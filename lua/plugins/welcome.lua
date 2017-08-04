local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function ban_bots(msg)
	if msg.from.admin or msg.from.id == msg.new_chat_member.id then
		--ignore if added by an admin or new member joined by link
		return
	else
		local status = db:hget(('chat:%d:settings'):format(msg.chat.id), 'Antibot') or config.chat_settings.settings.Antibot
		if status == 'on' then
			local users = msg.new_chat_members
			local n = 0 --bots banned
			for i=1, #users do
				if not users[i].last_name and users[i].username and users[i].username:lower():find('bot', -3) then
					if db:sismember('bot:bots', users[i].id) then
						local res, code, description = api.banUser(msg.chat.id, users[i].id)
						n = n + 1
					else
						local res, code = api.sendChatAction(users[i].id, 'typing')
						if not res and code == 161 then
							db:sadd('bot:bots', users[i].id)
							api.banUser(msg.chat.id, users[i].id)
							n = n + 1
						end
					end
				end
			end
			if n == #users then
				--if all the new members added are bots then don't send a welcome message
				return true
			end
		end
	end
end

local function is_on(chat_id, setting)
	local hash = 'chat:'..chat_id..':settings'
	local current = db:hget(hash, setting) or config.chat_settings.settings[setting]
	if current == 'on' then
		return true
	else
		return false
	end
end

local permissions = {'can_send_messages', 'can_send_media_messages', 'can_send_other_messages', 'can_add_web_page_previews'}

local function apply_default_permissions(chat_id, users)
	local hash = ('chat:%d:defpermissions'):format(chat_id)
	local def_permissions = db:hgetall(hash)
	
	if next(def_permissions) then
		for i=1, #permissions do
			if not def_permissions[permissions[i]] then
			def_permissions[permissions[i]] = config.chat_settings.defpermissions[permissions[i]]
			end
		end
		
		for i=1, #users do
			api.restrictChatMember(chat_id, users[i].id, def_permissions)
		end
	end
end

local function get_welcome(msg)
	if not is_on(msg.chat.id, 'Welcome') then
		return false
	end

	local hash = 'chat:'..msg.chat.id..':welcome'
	local type = (db:hget(hash, 'type')) or config.chat_settings['welcome']['type']
	local content = (db:hget(hash, 'content')) or config.chat_settings['welcome']['content']
	if type == 'media' then
		local file_id = content
		local caption = db:hget(hash, 'caption')
		if caption then caption = caption:replaceholders(msg, true) end
		local rules_button = db:hget('chat:'..msg.chat.id..':settings', 'Welbut') or config.chat_settings['settings']['Welbut']
		local reply_markup
		if rules_button == 'on' then
			reply_markup = {inline_keyboard={{{text = _('Read the rules'), url = u.deeplink_constructor(msg.chat.id, 'rules')}}}}
		end

		local res = api.sendDocumentId(msg.chat.id, file_id, nil, caption, reply_markup)
		if res and is_on(msg.chat.id, 'Weldelchain') then
			local key = ('chat:%d:lastwelcome'):format(msg.chat.id) -- get the id of the last sent welcome message
			local message_id = db:get(key)
			if message_id then
				api.deleteMessage(msg.chat.id, message_id)
			end
			db:setex(key, 259200, res.result.message_id) --set the new message id to delete
		end
		return false
	elseif type == 'custom' then
		local reply_markup, new_text = u.reply_markup_from_text(content)
		return new_text:replaceholders(msg), reply_markup
	else
		return _("Hi %s!"):format(msg.new_chat_member.first_name:escape())
	end
end

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'welcome' then

		if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end

		local input = blocks[2]

		if not input and not msg.reply then
			api.sendReply(msg, _("Welcome and...?")) return
		end

		local hash = 'chat:'..msg.chat.id..':welcome'

		if not input and msg.reply then
			local replied_to = u.get_media_type(msg.reply)
			if replied_to == 'sticker' or replied_to == 'gif' then
				local file_id
				if replied_to == 'sticker' then
					file_id = msg.reply.sticker.file_id
				else
					file_id = msg.reply.document.file_id
				end
				db:hset(hash, 'type', 'media')
				db:hset(hash, 'content', file_id)
				if msg.reply.caption then
					db:hset(hash, 'caption', msg.reply.caption)
				else
					db:hdel(hash, 'caption') --remove the caption key if the new media doesn't have a caption
				end
				-- turn on the welcome message in the group settings
				db:hset(('chat:%d:settings'):format(msg.chat.id), 'Welcome', 'on')
				api.sendReply(msg, _("A form of media has been set as the welcome message: `%s`"):format(replied_to), true)
			else
				api.sendReply(msg, _("Reply to a `sticker` or a `gif` to set them as the *welcome message*"), true)
			end
		else
			db:hset(hash, 'type', 'custom')
			db:hset(hash, 'content', input)

			local reply_markup, new_text = u.reply_markup_from_text(input)

			local res, code = api.sendReply(msg, new_text:gsub('$rules', u.deeplink_constructor(msg.chat.id, 'rules')), true, reply_markup)
			if not res then
				db:hset(hash, 'type', 'no') --if wrong markdown, remove 'custom' again
				db:hset(hash, 'content', 'no')
				api.sendMessage(msg.chat.id, u.get_sm_error_string(code), true)
			else
				-- turn on the welcome message in the group settings
				db:hset(('chat:%d:settings'):format(msg.chat.id), 'Welcome', 'on')
				local id = res.result.message_id
				api.editMessageText(msg.chat.id, id, _("*Custom welcome message saved!*"), true)
			end
		end
	end
	if blocks[1] == 'new_chat_member' then
		if not msg.service then return end

		local extra
		if msg.from.id ~= msg.new_chat_member.id then extra = msg.from end
		u.logEvent(blocks[1], msg, extra)
		
		local stop = ban_bots(msg)
		if stop then return end
		
		apply_default_permissions(msg.chat.id, msg.new_chat_members)
		
		local text, reply_markup = get_welcome(msg)
		if text then --if not text: welcome is locked or is a gif/sticker
			local attach_button = (db:hget('chat:'..msg.chat.id..':settings', 'Welbut')) or config.chat_settings['settings']['Welbut']
			if attach_button == 'on' then
				if not reply_markup then reply_markup = {inline_keyboard={}} end
				local line = {{text = _('Read the rules'), url = u.deeplink_constructor(msg.chat.id, 'rules')}}
				table.insert(reply_markup.inline_keyboard, line)
			end
			local link_preview = text:find('telegra%.ph/') ~= nil
			local res = api.sendMessage(msg.chat.id, text, true, reply_markup, nil, link_preview)
			if res and is_on(msg.chat.id, 'Weldelchain') then
				local key = ('chat:%d:lastwelcome'):format(msg.chat.id) -- get the id of the last sent welcome message
				local message_id = db:get(key)
				if message_id then
					api.deleteMessage(msg.chat.id, message_id)
				end
				db:setex(key, 259200, res.result.message_id) --set the new message id to delete
			end
		end

		local send_rules_private = db:hget('user:'..msg.new_chat_member.id..':settings', 'rules_on_join')
		if send_rules_private and send_rules_private == 'on' then
			local rules = db:hget('chat:'..msg.chat.id..':info', 'rules')
			if rules then
				api.sendMessage(msg.new_chat_member.id, rules, true)
			end
		end
	end
end

plugin.triggers = {
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

return plugin
