local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local utilities = require "groupbutler.utilities"
local redis = require "resty.redis"
local plugins = require "groupbutler.plugins"
local get_bot = require "groupbutler.bot"
local locale = require "groupbutler.languages"
local i18n = locale.translate

local _M = {}

local bot

_M.__index = _M

setmetatable(_M, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function _M.new(update)
	local self = setmetatable({}, _M)
	self.update = update
	self.db = redis:new()
	self.db:connect(config.redis.host, config.redis.port)
	self.db:select(config.redis.db)
	self.u = utilities.new(self)
	bot = get_bot.init()
	return self
end

local function extract_usernames(self, msg)
	local db = self.db
	if msg.from then
		if msg.from.username then
			db:hset('bot:usernames', '@'..msg.from.username:lower(), msg.from.id)
		end
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

local function collect_stats(self, msg)
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

local function match_triggers(triggers, text)
	if text and triggers then
		text = text:gsub('^(/[%w_]+)@'..bot.username, '%1')
		for _, trigger in pairs(triggers) do
			local matches = { string.match(text, trigger) }
			if next(matches) then
				return matches, trigger
			end
		end
	end
end

local function on_msg_receive(self, msg, callback) -- The fn run whenever a message is received.
	local u = self.u
	local db = self.db
	-- u:dump(msg)

	if not msg then
		return
	end

	-- Do not process old updates
	local now = os.time(os.date("*t"))
	if msg.date < now - config.bot_settings.old_update then
			print(os.date('[%H:%M:%S]', now), 'Old update skipped: ', os.date('%H:%M:%S', msg.date), now-msg.date)
			return
	end

	-- Set chat language
	locale.language = db:get('lang:'..msg.chat.id) or config.lang
	if not config.available_languages[locale.language] then
		locale.language = config.lang
	end

	-- Do not process messages from normal groups
	if msg.chat.type == 'group'
		and msg.group_chat_created or (msg.new_chat_member and msg.new_chat_member.id == bot.id) then
		api.sendMessage(msg.chat.id, i18n([[Hello everyone!
My name is %s, and I'm a bot made to help administrators in their hard work.
Unfortunately I can't work in normal groups. If you need me, please ask the creator to convert this group to a supergroup and then add me again.
]]):format(bot.first_name))
		api.leaveChat(msg.chat.id)
		if config.bot_settings.stream_commands then
			print('['..os.date('%X')..'] Bot was added to a normal group '..msg.from.first_name..
				' ['..msg.from.id..'] -> ['..msg.chat.id..']')
		end
		return
	end

	if not msg.text then msg.text = msg.caption or '' end

	locale.language = db:get('lang:'..msg.chat.id) --group language
	if not config.available_languages[locale.language] then
		locale.language = config.lang
	end

	collect_stats(self, msg)

	local continue, onm_success, plugin_obj
	for i=1, #plugins do
		if plugins[i].onEveryMessage then
			plugin_obj = plugins[i].new(self)
			onm_success, continue = pcall(plugin_obj.onEveryMessage, plugin_obj, msg)
			if not onm_success then
				print('An #error occurred (preprocess).\n'..tostring(continue)..'\n'..locale.language..'\n'..msg.text)
			end
			if not continue then
				return
			end
		end
	end

	for i=1, #plugins do
		if plugins[i].triggers then
			plugin_obj = plugins[i].new(self)
			local blocks, trigger = match_triggers(plugin_obj.triggers[callback], msg.text)
			if blocks then
				if msg.chat.id < 0 and msg.chat.type ~= 'inline'and db:exists('chat:'..msg.chat.id..':settings') == 0 and not msg.service then --init agroup if the bot wasn't aware to be in
				u:initGroup(msg.chat.id)
				end
				if config.bot_settings.stream_commands then --print some info in the terminal
					print(trigger..' '..msg.from.first_name..' ['..msg.from.id..'] -> ['..msg.chat.id..']')
				end
				--if not check_callback(msg, callback) then goto searchaction end
				local success, result = xpcall((function() return plugin_obj[callback](plugin_obj, msg, blocks) end), debug.traceback) --execute the main function of the plugin triggered
				if not success then --if a bug happens
					if config.bot_settings.notify_bug then
					u:sendReply(msg, i18n("🐞 Sorry, a *bug* occurred"), "Markdown")
					end
					print('An #error occurred.\n'..result..'\n'..locale.language..'\n'..msg.text)
					return
				end
				if not result then --if the action returns true, then don't stop the loop of the plugin's actions
					return
				end
			end
		end
	end
end

function _M:parseMessageFunction()
	local update = self.update
	local u = self.u
	local db = self.db

	u:metric_incr("messages_count")

	local msg, function_key
	local start_time = u:time_hires()

	if update.message or update.edited_message then

		function_key = 'onTextMessage'

		if update.edited_message then
			update.edited_message.edited = true
			update.edited_message.original_date = update.edited_message.date
			update.edited_message.date = update.edited_message.edit_date
			function_key = 'onEditedMessage'
		end

		msg = update.message or update.edited_message

		if msg.text then
			msg.text = msg.text -- Just so that luacheck stops complaining about empty if branch
		elseif msg.photo then
			msg.media = true
			msg.media_type = 'photo'
		elseif msg.audio then
			msg.media = true
			msg.media_type = 'audio'
		elseif msg.document then
			msg.media = true
			msg.media_type = 'document'
			if msg.document.mime_type == 'video/mp4' then
				msg.media_type = 'gif'
			end
		elseif msg.sticker then
			msg.media = true
			msg.media_type = 'sticker'
		elseif msg.video then
			msg.media = true
			msg.media_type = 'video'
		elseif msg.video_note then
			msg.media = true
			msg.media_type = 'video_note'
		elseif msg.voice then
			msg.media = true
			msg.media_type = 'voice'
		elseif msg.contact then
			msg.media = true
			msg.media_type = 'contact'
		elseif msg.venue then
			msg.media = true
			msg.media_type = 'venue'
		elseif msg.location then
			msg.media = true
			msg.media_type = 'location'
		elseif msg.game then
			msg.media = true
			msg.media_type = 'game'
		elseif msg.left_chat_member then
			msg.service = true
			if msg.left_chat_member.id == bot.id then
				msg.text = '###left_chat_member:bot'
			else
				msg.text = '###left_chat_member'
			end
		elseif msg.new_chat_member then
			msg.service = true
			if msg.new_chat_member.id == bot.id then
				msg.text = '###new_chat_member:bot'
			else
				msg.text = '###new_chat_member'
			end
		elseif msg.new_chat_photo then
			msg.service = true
			msg.text = '###new_chat_photo'
		elseif msg.delete_chat_photo then
			msg.service = true
			msg.text = '###delete_chat_photo'
		elseif msg.group_chat_created then
			msg.service = true
			msg.text = '###group_chat_created'
		elseif msg.supergroup_chat_created then
			msg.service = true
			msg.text = '###supergroup_chat_created'
		elseif msg.channel_chat_created then
			msg.service = true
			msg.text = '###channel_chat_created'
		elseif msg.migrate_to_chat_id then
			msg.service = true
			msg.text = '###migrate_to_chat_id'
		elseif msg.migrate_from_chat_id then
			msg.service = true
			msg.text = '###migrate_from_chat_id'
		elseif msg.new_chat_title then
			msg.service = true
			msg.text = '###new_chat_title'
		elseif msg.pinned_message then
			msg.service = true
			msg.text = '###pinned_message'
		else
			--callback = 'onUnknownType'
			print('Unknown update type') return
		end

		if msg.forward_from_chat then
			if msg.forward_from_chat.type == 'channel' then
				msg.spam = 'forwards'
			end
		end
		if msg.caption then
			local caption_lower = msg.caption:lower()
			if caption_lower:match('telegram%.me') or caption_lower:match('telegram%.dog') or caption_lower:match('t%.me') then
				msg.spam = 'links'
			end
		end
		if msg.entities then
			for _, entity in pairs(msg.entities) do
				if entity.type == 'text_mention' then
					msg.mention_id = entity.user.id
				end
				if entity.type == 'url' or entity.type == 'text_link' then
					local text_lower = msg.text or msg.caption
					text_lower = entity.url and text_lower..entity.url or text_lower
					text_lower = text_lower:lower()
					if text_lower:match('telegram%.me') or
						text_lower:match('telegram%.dog') or
						text_lower:match('t%.me') then
						msg.spam = 'links'
					else
						msg.media_type = 'link'
						msg.media = true
					end
				end
			end
		end
		if msg.reply_to_message then
			msg.reply = msg.reply_to_message
			if msg.reply.caption then
				msg.reply.text = msg.reply.caption
			end
		end
	elseif update.callback_query then
		msg = update.callback_query
		msg.cb = true
		msg.text = '###cb:'..msg.data
		if msg.message then
			msg.original_text = msg.message.text
			msg.original_date = msg.message.date
			msg.message_id = msg.message.message_id
			msg.chat = msg.message.chat
		else --when the inline keyboard is sent via the inline mode
			msg.chat = {type = 'inline', id = msg.from.id, title = msg.from.first_name}
			msg.message_id = msg.inline_message_id
		end
		msg.date = os.time()
		msg.cb_id = msg.id
		msg.message = nil
		msg.target_id = msg.data:match('(-%d+)$') --callback datas often ship IDs
		function_key = 'onCallbackQuery'
	else
		--function_key = 'onUnknownType'
		print('Unknown update type') return
	end

	if (msg.chat.id < 0 or msg.target_id) and msg.from then
		msg.from.admin = u:is_admin(msg.target_id or msg.chat.id, msg.from.id)
	end

	-- print('Admin:', msg.from.admin)
	local retval = on_msg_receive(self, msg, function_key)
	u:metric_set("msg_request_duration_sec", u:time_hires() - start_time)
	-- print(db:get_reused_times())
	db:set_keepalive()
	return retval
end

return _M
