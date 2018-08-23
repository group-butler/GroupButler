local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local locale = require "groupbutler.languages"
local i18n = locale.translate
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

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

local function list_to_kv(list)
	local copy = {}
	for i = 1, #list, 2 do
		copy[list[i]] = list[i + 1]
	end
	return copy
end

local function get_button_description(key)
	local button_description = {
		rules_on_join = i18n("When you join a group moderated by this bot, you will receive the group rules in private"),
		reports = i18n("If enabled, you will receive all the messages reported with the @admin command in the groups you are moderating"), -- luacheck: ignore 631
	} set_default(button_description, i18n("Description not available"))
	return button_description[key]
end

local function change_private_setting(self, user_id, key)
	local red = self.red
	local hash = 'user:'..user_id..':settings'
	local new_val = "off"
	local old_val = red:hget(hash, key)
	if old_val ~= "on" and old_val ~= "off" then
		old_val = config.private_settings[key]
	end

	if old_val ~= "on" then
		new_val = "on"
	end
	red:hset(hash, key, new_val)
end

local function get_user_settings(self, user_id)
	local red = self.red
	local hash = 'user:'..user_id..':settings'
	local user_settings = red:hgetall(hash)

	if user_settings == null then
		return config.private_settings
	end

	user_settings = list_to_kv(user_settings)

	for key, default_status in ipairs(config.private_settings) do
		if not user_settings[key] then
			user_settings[key] = default_status
		end
	end

	return user_settings
end

local function doKeyboard_privsett(self, user_id)
	local user_settings = get_user_settings(self, user_id)

	local keyboard = {inline_keyboard = {}}
	local button_names = {
		['rules_on_join'] = i18n('Rules on join'),
		['reports'] = i18n('Users reports')
	}
	for key, status in pairs(user_settings) do
		local icon = "☑️"
		if status == "on" then
			icon = "✅"
		end
		table.insert(keyboard.inline_keyboard,
			{
				{text = button_names[key], callback_data = 'myset:alert:'..key},
				{text = icon, callback_data = 'myset:switch:'..key}
			})
	end

	return keyboard
end

function _M:onTextMessage()
	local msg = self.message
	if msg.chat.type == 'private' then
		local reply_markup = doKeyboard_privsett(self, msg.from.id)
		api.send_message{
			chat_id = msg.from.id,
			text = i18n("Change your private settings"),
			reply_markup = reply_markup
	}
	end
end

function _M:onCallbackQuery(blocks)
	local msg = self.message
	if blocks[1] == 'alert' then
		api.answerCallbackQuery(msg.cb_id, get_button_description(blocks[2]), true)
		return
	end
	change_private_setting(self, msg.from.id, blocks[2])
	local reply_markup = doKeyboard_privsett(self, msg.from.id)
	api.edit_message_reply_markup{
		chat_id = msg.from.id,
		message_id = msg.message_id,
		reply_markup = reply_markup
	}
	api.answer_callback_query(msg.cb_id, i18n('⚙ Setting applied'))
end

_M.triggers = {
	onTextMessage = {config.cmd..'(mysettings)$'},
	onCallbackQuery = {
		'^###cb:myset:(alert):(.*)$',
		'^###cb:myset:(switch):(.*)$',
		}
}

return _M
