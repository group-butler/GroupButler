local config = require "groupbutler.config"
local null = require "groupbutler.null"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local bot = self.bot
	local u = self.u
	local red = self.red
	local i18n = self.i18n

	if not msg.service then return end

	if blocks[1] == "new_chat_member" then
		red:sadd(string.format("chat:%d:members", msg.from.chat.id), msg.new_chat_member.id)
	end
	if blocks[1] == "left_chat_member" then
		red:srem(string.format("chat:%d:members", msg.from.chat.id), msg.left_chat_member.id)
	end
	if blocks[1] == 'new_chat_member'
	or blocks[1] == 'left_chat_member' then
		local status = red:hget(('chat:%d:settings'):format(msg.from.chat.id), 'Clean_service_msg')
		if status == null then status = config.chat_settings.settings.Clean_service_msg end

		if status == 'on' then
			api:deleteMessage(msg.from.chat.id, msg.message_id)
		end
		return true
	end

	if blocks[1] == 'new_chat_member:bot' or blocks[1] == 'migrate_from_chat_id' then
		if u:is_blocked_global(msg.from.user.id) then
			api:sendMessage(msg.from.chat.id, i18n("_You (user ID: %d) are in the blocked list_"):format(msg.from.user.id),
				"Markdown")
			api:leaveChat(msg.from.chat.id)
			return
		end
		if config.bot_settings.admin_mode and not u:is_superadmin(msg.from.user.id) then
			api:sendMessage(msg.from.chat.id, i18n("_Admin mode is on: only the bot admin can add me to a new group_"),
				"Markdown")
			api:leaveChat(msg.from.chat.id)
			return
		end
		u:initGroup(msg.from.chat)
		-- send manuals
		local text
		if blocks[1] == 'new_chat_member:bot' then
			text = i18n("Hello everyone!\n"
				.. "My name is %s, and I'm a bot made to help administrators in their hard work.\n")
				:format(bot.first_name:escape())
		else
			text = i18n("Yay! This group has been upgraded. You are great! Now I can work properly :)\n")
		end
		api:sendMessage(msg.from.chat.id, text, "Markdown")
	elseif blocks[1] == 'left_chat_member:bot' then
		u:remGroup(msg.from.chat.id)
	end

	u:logEvent(blocks[1], msg)
end

_M.triggers = {
	onTextMessage = {
		'^###(new_chat_member)$',
		'^###(left_chat_member)$',
		'^###(new_chat_member:bot)',
		'^###(migrate_from_chat_id)',
		'^###(left_chat_member:bot)',
		'^###(pinned_message)$',
		'^###(new_chat_title)$',
		'^###(new_chat_photo)$',
		'^###(delete_chat_photo)$'
	}
}

return _M
