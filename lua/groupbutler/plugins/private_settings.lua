local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local locale = require "groupbutler.languages"
local i18n = locale.translate
local null = require "groupbutler.null"

local _M = {}

_M.__index = _M

setmetatable(_M, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function _M.new(main)
	local self = setmetatable({}, _M)
	self.update = main.update
	self.db = main.db
	return self
end

local function get_button_description(key)
	if key == 'rules_on_join' then
		return i18n("When you join a group moderated by this bot, you will receive the group rules in private")
	elseif key == 'reports' then
		return i18n(
			'If enabled, you will receive all the messages reported with the @admin command in the groups you are moderating'
			)
	else
		return i18n("Description not available")
	end
end

local function change_private_setting(self, user_id, key)
	local db = self.db
	local hash = 'user:'..user_id..':settings'
	local val = 'off'
	local current_status = db:hget(hash, key)
	if current_status == null then current_status = config.private_settings[key] end

	if current_status == 'off' then
		val = 'on'
	end
	db:hset(hash, key, val)
end

local function doKeyboard_privsett(self, user_id)
	local db = self.db
	local hash = 'user:'..user_id..':settings'
	local user_settings = db:hgetall(hash)
	if not next(user_settings) then
		user_settings = config.private_settings
	else
		for key, default_status in pairs(config.private_settings) do
			if not user_settings[key] then
				user_settings[key] = default_status
			end
		end
	end

	local keyboard = {inline_keyboard = {}}
	local button_names = {
		['rules_on_join'] = i18n('Rules on join'),
		['reports'] = i18n('Users reports')
	}
	for key, status in pairs(user_settings) do
		local icon
		if status == 'on' then icon = '✅' else icon = '☑️'end
		table.insert(keyboard.inline_keyboard,
			{
				{text = button_names[key], callback_data = 'myset:alert:'..key},
				{text = icon, callback_data = 'myset:switch:'..key}
			})
	end

	return keyboard
end

function _M:onTextMessage(msg)
	if msg.chat.type == 'private' then
		local keyboard = doKeyboard_privsett(self, msg.from.id)
		api.sendMessage(msg.from.id, i18n('Change your private settings'), "Markdown", nil, nil, nil, keyboard)
	end
end

function _M:onCallbackQuery(msg, blocks)
	if blocks[1] == 'alert' then
		api.answerCallbackQuery(msg.cb_id, get_button_description(blocks[2]), true)
	else
		change_private_setting(self, msg.from.id, blocks[2])
		local keyboard = doKeyboard_privsett(self, msg.from.id)
		api.editMessageReplyMarkup(msg.from.id, msg.message_id, nil, keyboard)
		api.answerCallbackQuery(msg.cb_id, i18n('⚙ Setting applied'))
	end
end

_M.triggers = {
	onTextMessage = {config.cmd..'(mysettings)$'},
	onCallbackQuery = {
		'^###cb:myset:(alert):(.*)$',
		'^###cb:myset:(switch):(.*)$',
		}
}

return _M
