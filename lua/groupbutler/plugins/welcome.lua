local config = require "groupbutler.config"
local null = require "groupbutler.null"
local api_u = require "telegram-bot-api.utilities"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function ban_bots(self, msg)
	local db = self.db
	local u = self.u

	-- ignore if added by an admin or new member joined by link or the setting is disabled
	if msg.from.user.id == msg.new_chat_member.id
	or msg.from:isAdmin()
	or not db:get_chat_setting(msg.from.chat.id, 'Antibot') then
		return
	end

	local users = msg.new_chat_members
	local n = 0 --bots banned
	for i = 1, #users do
		if users[i].is_bot == true then
			u:banUser(msg.from.chat.id, users[i].id)
			n = n + 1
		end
	end
	if n == #users then
		--if all the new members added are bots then don't send a welcome message
		return true
	end
end

-- local permissions =
-- {'can_send_messages', 'can_send_media_messages', 'can_send_other_messages', 'can_add_web_page_previews'}

local function apply_default_permissions(self, chat_id, users)
	local api = self.api
	local red = self.red

	local hash = ('chat:%d:defpermissions'):format(chat_id)
	local def_permissions = red:array_to_hash(red:hgetall(hash))

	if next(def_permissions) then
		--for i=1, #permissions do
			--if not def_permissions[permissions[i]] then
				--def_permissions[permissions[i]] = config.chat_settings.defpermissions[permissions[i]]
			--end
		--end

		for i=1, #users do
			local res = api:getChatMember(chat_id, users[i].id)
			if res.status ~= 'restricted' then
				def_permissions.chat_id = chat_id
				def_permissions.user_id = users[i].id
				api:restrictChatMember(def_permissions)
			end
		end
	end
end

local function get_reply_markup(self, msg, text)
	local u = self.u
	local i18n = self.i18n
	local db = self.db

	local new_text, reply_markup
	if text then
		reply_markup, new_text = u:reply_markup_from_text(u:replaceholders(text, msg))
	end

	if db:get_chat_setting(msg.from.chat.id, "Welbut") then
		if not reply_markup then
			reply_markup = api_u.InlineKeyboardMarkup:new()
		end
		reply_markup:row({text = i18n("Read the rules"), url = u:deeplink_constructor(msg.from.chat.id, "rules")})
	end

	return reply_markup, new_text
end

local function send_welcome(self, msg)
	local api = self.api
	local red = self.red
	local i18n = self.i18n
	local u = self.u
	local db = self.db

	if not db:get_chat_setting(msg.from.chat.id, 'Welcome') then
		return
	end

	local hash = 'chat:'..msg.from.chat.id..':welcome'
	local welcome_type = red:hget(hash, "type")
	local content = red:hget(hash, 'content')
	if welcome_type == "no" or content == "no" -- TODO: database migration no -> null
	or welcome_type == null or content == null then
		welcome_type = "text"
		content = i18n("Hi $name!")
	end

	local ok, err
	if welcome_type == "custom" -- TODO: database migration custom -> text
	or welcome_type == "text" then
		local reply_markup, text = get_reply_markup(self, msg, content)
		local link_preview = text:find('telegra%.ph/') == nil
		ok, err = api:sendMessage(msg.from.chat.id, text, "Markdown", link_preview, nil, nil, reply_markup)
	end
	if welcome_type == "media" then
		local caption = red:hget(hash, "caption")
		if caption == null then
			caption = nil
		end
		local reply_markup, text = get_reply_markup(self, msg, caption)
		ok, err = api:sendDocument(msg.from.chat.id, content, text, nil, nil, reply_markup)
	end

	if not ok and err.description:match("have no rights to send a message") then
		u:remGroup(msg.from.chat.id)
		api:leaveChat(msg.from.chat.id)
		return
	end

	if ok and db:get_chat_setting(msg.from.chat.id, "Weldelchain") then
		local key = ('chat:%d:lastwelcome'):format(msg.from.chat.id) -- get the id of the last sent welcome message
		local message_id = red:get(key)
		if message_id ~= null then
			api:deleteMessage(msg.from.chat.id, message_id)
		end
		red:setex(key, 259200, ok.message_id) --set the new message id to delete
	end
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local db = self.db
	local i18n = self.i18n
	local api_err = self.api_err
	local u = self.u

	if blocks[1] == 'welcome' then
		if msg.from.chat.type == 'private' or not u:is_allowed('texts', msg.from.chat.id, msg.from.user) then return end

		local input = blocks[2]
		if not input and not msg.reply then
			msg:send_reply(i18n("Welcome and...?"))
			return
		end

		local hash = 'chat:'..msg.from.chat.id..':welcome'

		if not input and msg.reply then
			local replied_to = msg.reply:type()
			if replied_to == 'sticker' or replied_to == 'gif' then
				local file_id
				if replied_to == 'sticker' then
					file_id = msg.reply.sticker.file_id
				else
					file_id = msg.reply.document.file_id
				end
				red:hset(hash, 'type', 'media')
				red:hset(hash, 'content', file_id)
				if msg.reply.caption then
					red:hset(hash, 'caption', msg.reply.caption)
				else
					red:hdel(hash, 'caption') --remove the caption key if the new media doesn't have a caption
				end
				-- turn on the welcome message in the group settings
				db:set_chat_setting(msg.from.chat.id, "Welcome", true)
				msg:send_reply(i18n("A form of media has been set as the welcome message: `%s`"):format(replied_to), "Markdown")
			else
				msg:send_reply(i18n("Reply to a `sticker` or a `gif` to set them as the *welcome message*"), "Markdown")
			end
		else
			local reply_markup, new_text = u:reply_markup_from_text(input)

			new_text = new_text:gsub('$rules', u:deeplink_constructor(msg.from.chat.id, 'rules'))

			red:hset(hash, 'type', 'custom')
			red:hset(hash, 'content', input)

			local ok, err = msg:send_reply(new_text, "Markdown", reply_markup)
			if not ok then
				red:hset(hash, 'type', 'no') --if wrong markdown, remove 'custom' again
				red:hset(hash, 'content', 'no')
				api:sendMessage(msg.from.chat.id, api_err:trans(err), "Markdown")
			else
				-- turn on the welcome message in the group settings
				db:set_chat_setting(msg.from.chat.id, "Welcome", true)
				local id = ok.message_id
				api:editMessageText(msg.from.chat.id, id, nil, i18n("*Custom welcome message saved!*"), "Markdown")
			end
		end
	end
	if blocks[1] == 'new_chat_member' then
		if not msg.service then return end

		local extra
		if msg.from.user.id ~= msg.new_chat_member.id then extra = msg.from.user end
		u:logEvent(blocks[1], msg, extra)

		local stop = ban_bots(self, msg)
		if stop then return end

		apply_default_permissions(self, msg.from.chat.id, msg.new_chat_members)

		send_welcome(self, msg)

		if db:get_user_setting(msg.new_chat_member.id, 'rules_on_join') then
			local rules = red:hget('chat:'..msg.from.chat.id..':info', 'rules')
			if rules ~= null then
				api:sendMessage(msg.new_chat_member.id, rules, "Markdown")
			end
		end
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(welcome) (.*)$',
		config.cmd..'set(welcome) (.*)$',
		config.cmd..'(welcome)$',
		config.cmd..'set(welcome)$',
		config.cmd..'(goodbye) (.*)$',
		config.cmd..'set(goodbye) (.*)$',

		'^###(new_chat_member)$'
	}
}

return _M
