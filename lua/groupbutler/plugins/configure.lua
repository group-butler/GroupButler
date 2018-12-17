local config = require "groupbutler.config"
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

local function doKeyboardConfig(self, chat_id, user_id)
	local u = self.u
	local i18n = self.i18n
	local reply_markup = api_u.InlineKeyboardMarkup:new()
	reply_markup:row({text = i18n("🛠 Menu"), callback_data = 'config:menu:'..chat_id})
	reply_markup:row({text = i18n("⚡️ Antiflood"), callback_data = 'config:antiflood:'..chat_id})
	reply_markup:row({text = i18n("🌈 Media"), callback_data = 'config:media:'..chat_id})
	reply_markup:row({text = i18n("🚫 Antispam"), callback_data = 'config:antispam:'..chat_id})
	reply_markup:row({text = i18n("📥 Log channel"), callback_data = 'config:logchannel:'..chat_id})

	if u:can(chat_id, user_id, "can_restrict_members") then
		reply_markup:row({text = i18n("⛔️ Default permissions"), callback_data = 'config:defpermissions:'..chat_id})
	end
	return reply_markup
end

function _M:onTextMessage()
	local api = self.api
	local msg = self.message
	local u = self.u
	local i18n = self.i18n

	if msg.chat.type ~= "supergroup"
	or not msg:is_from_admin() then
		return
	end

	msg.chat:cache()
	local res = api:sendMessage({
		chat_id = msg.from.id,
		text = ("<b>%s</b>\n"):format(msg.chat.title:escape_html())..i18n("<i>Change the settings of your group</i>"),
		parse_mode = "html",
		reply_markup = doKeyboardConfig(self, msg.chat.id, msg.from.id),
	})

	if u:is_silentmode_on(msg.chat.id) then -- send the response in the group only if the silent mode is off
		return
	end

	if not res then
		u:sendStartMe(msg)
		return
	end
	api:sendMessage(msg.chat.id, i18n("_I've sent you the keyboard via private message_"), "Markdown")
end

function _M:onCallbackQuery()
	local api = self.api
	local msg = self.message
	local i18n = self.i18n
	local db = self.db

	local chat_id = msg.target_id
	local text = i18n("<i>Change the settings of your group</i>")
	local chat_title = db:getChatTitle({id=chat_id})
	if chat_title then
		text = ("<b>%s</b>\n"):format(chat_title:escape_html())..text
	end

	api:editMessageText({
		chat_id = msg.chat.id,
		message_id = msg.message_id,
		text = text,
		parse_mode = "html",
		reply_markup = doKeyboardConfig(self, chat_id, msg.from.id)
	})
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
