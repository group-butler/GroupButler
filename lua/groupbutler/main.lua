local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local utilities = require "groupbutler.utilities"
local log = require "groupbutler.logging"
local redis = require "resty.redis"
local plugins = require "groupbutler.plugins"
local locale = require "groupbutler.languages"
local i18n = locale.translate

local _M = {}

local get_me = {}

function _M:new(update_obj)
	setmetatable(update_obj, {__index = self})

	if not get_me[config.telegram.token] then
		get_me[config.telegram.token] = api.get_me()
	end
	update_obj.bot = get_me[config.telegram.token]

	update_obj.db = redis:new()
	local ok, err = update_obj.db:connect(config.redis.host, config.redis.port)
	if not ok then
		log.error("Redis connection failed: {err}", {err=err})
		return nil, err
	end
	update_obj.db:select(config.redis.db)

	update_obj.u = utilities:new(update_obj)

	return update_obj
end

local function extract_usernames(self, msg)
	local db = self.db
	if msg.from and msg.from.username then
			db:hset('bot:usernames', '@'..msg.from.username:lower(), msg.from.id)
	end
	if msg.forward_from and msg.forward_from.username then
		db:hset('bot:usernames', '@'..msg.forward_from.username:lower(), msg.forward_from.id)
	end
	if msg.new_chat_member then
		if msg.new_chat_member.username then
			db:hset('bot:usernames', '@'..msg.new_chat_member.username:lower(), msg.new_chat_member.id)
		end
		db:sadd(string.format('chat:%d:members', msg.chat.id), msg.new_chat_member.id)
	end
	if msg.left_chat_member then
		if msg.left_chat_member.username then
			db:hset('bot:usernames', '@'..msg.left_chat_member.username:lower(), msg.left_chat_member.id)
		end
		db:srem(string.format('chat:%d:members', msg.chat.id), msg.left_chat_member.id)
	end
	if msg.reply_to_message then
		extract_usernames(self, msg.reply_to_message)
	end
	if msg.pinned_message then
		extract_usernames(self, msg.pinned_message)
	end
end

local function collect_stats(self)
	local msg = self.message
	local db = self.db
	local u = self.u
	extract_usernames(self, msg)
	local now = os.time(os.date("*t"))
	if msg.chat.type ~= 'private' and msg.chat.type ~= 'inline' and msg.from then
		db:hset('chat:'..msg.chat.id..':userlast', msg.from.id, now) --last message for each user
		db:hset('bot:chats:latsmsg', msg.chat.id, now) --last message in the group
	end
	u:metric_incr("messages_processed_count")
	u:metric_set("message_timestamp_distance_sec", now - msg.date)
end

local function match_triggers(self, triggers)
	local bot = self.bot
	local text = self.message.text

	if not text or not triggers then return nil end
		text = text:gsub('^(/[%w_]+)@'..bot.username, '%1')
		for _, trigger in pairs(triggers) do
			local matches = { string.match(text, trigger) }
			if next(matches) then
				return matches, trigger
			end
		end
	return nil
end

local function on_msg_receive(self, callback) -- The fn run whenever a message is received.
	local msg = self.message
	local bot = self.bot
	local u = self.u
	local db = self.db
	-- u:dump(msg)

	if not msg then
		return
	end

	-- Do not process old updates
	local now = os.time(os.date("*t"))
	if msg.date < now - config.bot_settings.old_update then
			log.warn('Old update skipped: {time} {diff}', {time=os.date('%H:%M:%S', msg.date), diff=now-msg.date})
			u:metric_incr("messages_skipped")
			return
	end

	-- Set chat language
	locale.language = db:get('lang:'..msg.chat.id) or config.lang
	if not config.available_languages[locale.language] then
		locale.language = config.lang
	end

	-- Do not process messages from normal groups
	if msg.chat.type == 'group' then
		api.sendMessage(msg.chat.id, i18n([[Hello everyone!
My name is %s, and I'm a bot made to help administrators in their hard work.
Unfortunately I can't work in normal groups. If you need me, please ask the creator to convert this group to a supergroup and then add me again.
]]):format(bot.first_name))
		api.leaveChat(msg.chat.id)
		if config.bot_settings.stream_commands then
			log.info('Bot was added to a normal group {by_name} [{from_id}] -> [{chat_id}]',
					{
						by_name=msg.from.first_name,
						from_id=msg.from.id,
						chat_id=msg.chat.id,
					})
		end
		return
	end

	collect_stats(self)

	for i=1, #plugins do
		if plugins[i].on_message then
			local plugin_obj = plugins[i]:new(self)
			local onm_success, continue = pcall(plugin_obj.on_message, plugin_obj)
			if not onm_success then
				log.error('An #error occurred (preprocess).\n{err}\n{lang}\n{text}', {
					cont=tostring(continue),
					lang=locale.language,
					text=msg.text})
			end
			if not continue then
				return
			end
		end
	end

	for i=1, #plugins do
		if plugins[i].triggers then
			local blocks, trigger = match_triggers(self, plugins[i].triggers[callback])
			local plugin_obj = plugins[i]:new(self)

			if blocks then
				-- init agroup if the bot wasn't aware to be in
				if  msg.chat.id < 0
				and msg.chat.type ~= 'inline'
				and db:exists('chat:'..msg.chat.id..':settings') == 0
				and not msg.service then
				u:initGroup(msg.chat.id)
				end

				-- print some info in the terminal
				if config.bot_settings.stream_commands then
					log.info('{trigger} {from_name} [{from_id}] -> [{chat_id}]',
						{
							trigger=trigger,
							from_name=msg.from.first_name,
							from_id=msg.from.id,
							chat_id=msg.chat.id,
						})
				end

				-- execute the main function of the plugin triggered
				local success, result = xpcall(
					(function()
						return plugin_obj[callback](plugin_obj, blocks)
					end), debug.traceback)

				if not success then --if a bug happens
					if config.bot_settings.notify_bug then
					u:sendReply(msg, i18n("🐞 Sorry, a *bug* occurred"), "Markdown")
					end
					log.error('An #error occurred.\n{result}\n{lang}\n{text}', {
						cont=tostring(result),
						lang=locale.language,
						text=msg.text})
					return
				end
				if not result then -- Stop processing plugins when a triggered plugin does not return true
					return
				end
			end
		end
	end
end

local message = {}

function message:is_from_admin()
	if self.chat.type == "private" then -- This should never happen but...
		return false
	end
	if not (self.chat.id < 0 or self.target_id) or not self.from then
		return false
	end
	return self.u:is_admin(self.target_id or self.chat.id, self.from.id)
end

function message:type()
	-- TODO: update database to use "animation" instead of "gif"
	if self.animation then
		return "gif"
	end
	local media_types = {
		"audio", --[["animation",]] "contact", "document", "game", "location", "photo", "sticker", "venue", "video",
		"video_note", "voice",
	}
	for _, v in pairs(media_types) do
		if self[v] then
			return v
		end
	end
	if self.entities then
		for _, entity in pairs(self.entities) do
			if entity.type == "url" or entity.type == "text_link" then
				return "link"
			end
		end
	end
	return "text"
end

function message:get_file_id()
	if self[self:type()] and self[self:type()].file_id then
		return self[self:type()].file_id
	end
	return false -- The message has no media file_id
end

function _M:process()
	local u = self.u
	local db = self.db
	local bot = self.bot

	local start_time = u:time_hires()
	u:metric_incr("messages_count")

	local function_key

	if self.message or self.edited_message then

		function_key = 'onTextMessage'

		if self.edited_message then
			self.edited_self.message.edited = true
			self.edited_self.message.original_date = self.edited_self.message.date
			self.edited_self.message.date = self.edited_self.message.edit_date
			function_key = 'onEditedMessage'
		end

		self.message = self.message or self.edited_message

		local service_messages = {
			"left_chat_member", "new_chat_member", "new_chat_photo", "delete_chat_photo", "group_chat_created",
			"supergroup_chat_created", "channel_chat_created", "migrate_to_chat_id", "migrate_from_chat_id",
			"new_chat_title", "pinned_message",
		}
		for _, v in pairs(service_messages) do
			if self.message[v] then
				self.message.service = true
				self.message.text = "###"..v
				if self.message[v].id == bot.id then
					self.message.text = self.message.text..":bot"
			end
			end
		end

		if self.message.forward_from_chat then
			if self.message.forward_from_chat.type == 'channel' then
				self.message.spam = 'forwards'
			end
		end
		if self.message.caption then
			local caption_lower = self.message.caption:lower()
			if caption_lower:match('telegram%.me') or caption_lower:match('telegram%.dog') or caption_lower:match('t%.me') then
				self.message.spam = 'links'
			end
		end
		if self.message.entities then
			for _, entity in pairs(self.message.entities) do
				if entity.type == 'text_mention' then
					self.message.mention_id = entity.user.id
				end
				if entity.type == 'url' or entity.type == 'text_link' then
					local text_lower = self.message.text or self.message.caption
					text_lower = entity.url and text_lower..entity.url or text_lower
					text_lower = text_lower:lower()
					if text_lower:match('telegram%.me')
					or text_lower:match('telegram%.dog')
					or text_lower:match('t%.me') then
						self.message.spam = 'links'
					end
				end
			end
		end
		if self.message.reply_to_message then
			-- Add message methods
			self.message.reply_to_message.u = self.u
			setmetatable(self.message.reply_to_message, {__index = message})

			self.message.reply = self.message.reply_to_message
			if self.message.reply.caption then
				self.message.reply.text = self.message.reply.caption
			end
		end
	elseif self.callback_query then
		self.message = self.callback_query
		self.message.cb = true
		self.message.text = '###cb:'..self.message.data
		if self.message.message then
			self.message.original_text = self.message.message.text
			self.message.original_date = self.message.message.date
			self.message.message_id = self.message.message.message_id
			self.message.chat = self.message.message.chat
		else --when the inline keyboard is sent via the inline mode
			self.message.chat = {type = 'inline', id = self.message.from.id, title = self.message.from.first_name}
			self.message.message_id = self.message.inline_message_id
		end
		self.message.date = os.time()
		self.message.cb_id = self.message.id
		self.message.message = nil
		self.message.target_id = self.message.data:match('(-%d+)$') --callback datas often ship IDs
		function_key = 'onCallbackQuery'
	else
		--function_key = 'onUnknownType'
		log.warn("Unknown update type")
		return
	end

	if not self.message.text then self.message.text = self.message.caption or '' end

	-- Add message methods
	self.message.u = self.u
	setmetatable(self.message, {__index = message})

	local retval = on_msg_receive(self, function_key)
	u:metric_set("msg_request_duration_sec", u:time_hires() - start_time)
	-- print(db:get_reused_times())
	db:set_keepalive()
	return retval
end

return _M
