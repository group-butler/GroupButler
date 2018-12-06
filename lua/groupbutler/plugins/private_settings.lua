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

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

local function get_button_description(self, key)
	local i18n = self.i18n
	local button_description = {
		rules_on_join = i18n("When you join a group moderated by this bot, you will receive the group rules in private"),
		reports = i18n("If enabled, you will receive all the messages reported with the @admin command in the groups you are moderating"), -- luacheck: ignore 631
	} set_default(button_description, i18n("Description not available"))
	return button_description[key]
end

local function doKeyboard_privsett(self, user_id)
	local i18n = self.i18n
	local user_settings = self.db:get_all_user_settings(user_id)

	local keyboard = api_u.InlineKeyboardMarkup:new()
	local button_names = {
		['rules_on_join'] = i18n('Rules on join'),
		['reports'] = i18n('Users reports')
	} set_default(button_names, i18n("Name not available"))

	for key, status in pairs(user_settings) do
		local icon = "☑️"
		if status then
			icon = "✅"
		end
		keyboard:row(
			{text = button_names[key], callback_data = 'myset:alert:'..key},
			{text = icon, callback_data = 'myset:switch:'..key}
		)
	end

	return keyboard
end

function _M:onTextMessage()
	local api = self.api
	local msg = self.message
	local i18n = self.i18n
	if msg.chat.type == 'private' then
		local reply_markup = doKeyboard_privsett(self, msg.from.id)
		api:send_message{
			chat_id = msg.from.id,
			text = i18n("Change your private settings"),
			reply_markup = reply_markup
	}
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local i18n = self.i18n
	if blocks[1] == 'alert' then
		api:answerCallbackQuery(msg.cb_id, get_button_description(self, blocks[2]), true)
		return
	end
	self.db:toggle_user_setting(msg.from.id, blocks[2])
	local reply_markup = doKeyboard_privsett(self, msg.from.id)
	api:edit_message_reply_markup{
		chat_id = msg.from.id,
		message_id = msg.message_id,
		reply_markup = reply_markup
	}
	api:answer_callback_query(msg.cb_id, i18n('⚙ Setting applied'))
end

_M.triggers = {
	onTextMessage = {config.cmd..'(mysettings)$'},
	onCallbackQuery = {
		'^###cb:myset:(alert):(.*)$',
		'^###cb:myset:(switch):(.*)$',
		}
}

return _M
