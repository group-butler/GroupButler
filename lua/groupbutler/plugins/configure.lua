local config = require "groupbutler.config"
local api_u = require "telegram-bot-api.utilities"
local Chat = require("groupbutler.chat")
local ChatMember = require("groupbutler.chatmember")

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function doKeyboardConfig(self, member)
	local i18n = self.i18n
	local reply_markup = api_u.InlineKeyboardMarkup:new()
	reply_markup:row({text = i18n("🛠 Menu"), callback_data = "config:menu:"..member.chat.id})
	reply_markup:row({text = i18n("⚡️ Antiflood"), callback_data = "config:antiflood:"..member.chat.id})
	reply_markup:row({text = i18n("🌈 Media"), callback_data = "config:media:"..member.chat.id})
	reply_markup:row({text = i18n("🚫 Antispam"), callback_data = "config:antispam:"..member.chat.id})
	reply_markup:row({text = i18n("📥 Log channel"), callback_data = "config:logchannel:"..member.chat.id})
	if member:can("can_restrict_members") then
		reply_markup:row({text = i18n("⛔️ Default permissions"), callback_data = "config:defpermissions:"..member.chat.id}) -- luacheck: ignore 631
	end
	return reply_markup
end

local function messageConstructor(self, member)
	local i18n = self.i18n
	local text = i18n("<i>Change the settings of your group</i>")
	if member.chat.title then
		text = ("<b>%s</b>\n"):format(member.chat.title:escape_html())..text
	end
	return {
		chat_id = member.user.id,
		text = text,
		parse_mode = "html",
		reply_markup = doKeyboardConfig(self, member)
	}
end

function _M:onTextMessage()
	local api = self.api
	local msg = self.message
	local u = self.u
	local i18n = self.i18n

	if msg.from.chat.type ~= "supergroup"
	or not msg.from:isAdmin() then
		return
	end

	local res = api:sendMessage(messageConstructor(self, msg.from))

	if u:is_silentmode_on(msg.from.chat.id) then -- send the response in the group only if the silent mode is off
		return
	end

	if not res then
		u:sendStartMe(msg)
		return
	end
	api:sendMessage(msg.from.chat.id, i18n("_I've sent you the keyboard via private message_"), "Markdown")
end

function _M:onCallbackQuery()
	local api = self.api
	local msg = self.message

	local member = ChatMember:new({
		chat = Chat:new({id=msg.target_id}, self),
		user = msg.from.user,
	}, self)

	local body = messageConstructor(self, member)
	body.message_id = msg.message_id
	api:editMessageText(body)
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'config$',
		config.cmd..'settings$',
	},
	onCallbackQuery = {
		'^###cb:config:back:'
	}
}

return _M
