local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local locale = require "groupbutler.languages"
local i18n = locale.translate

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function doKeyboard_lang()
	local keyboard = {
		inline_keyboard = {}
	}
	for lang, flag in pairs(config.available_languages) do
		local line = {{text = flag, callback_data = 'langselected:'..lang}}
		table.insert(keyboard.inline_keyboard, line)
	end
	return keyboard
end

function _M:onTextMessage()
	local msg = self.message
	local u = self.u

	if msg.chat.type == 'private' or (msg.chat.id < 0 and u:is_allowed('config', msg.chat.id, msg.from)) then
		local keyboard = doKeyboard_lang()
		api.sendMessage(msg.chat.id, i18n("*List of available languages*:"), "Markdown", nil, nil, nil, keyboard)
	end
end

function _M:onCallbackQuery(blocks)
	local msg = self.message
	local db = self.db

	if msg.chat.type ~= 'private' and not msg:is_from_admin() then
		api.answerCallbackQuery(msg.cb_id, i18n("You are not an admin"))
	else
		if blocks[1] == 'selectlang' then
			local keyboard = doKeyboard_lang()
			api.editMessageText(msg.chat.id, msg.message_id, nil, i18n("*List of available languages*:"), "Markdown", nil,
				keyboard)
		else
			locale.language = blocks[1]
			db:set('lang:'..msg.chat.id, locale.language)
			if (blocks[1] == 'ar_SA' or blocks[1] == 'fa_IR') and msg.chat.type ~= 'private' then
				db:hset('chat:'..msg.chat.id..':char', 'Arab', 'allowed')
				db:hset('chat:'..msg.chat.id..':char', 'Rtl', 'allowed')
			end
			-- TRANSLATORS: replace 'English' with the name of your language
			api.editMessageText(msg.chat.id, msg.message_id, nil, i18n("English language is *set*") ..
i18n([[.
Please note that translators are volunteers, and this localization _may be incomplete_. You can help improve translations on our [Crowdin Project](https://crowdin.com/project/group-butler).
]]), "Markdown")
		end
	end
end

_M.triggers = {
	onTextMessage = {config.cmd..'(lang)$'},
	onCallbackQuery = {
		'^###cb:(selectlang)',
		'^###cb:langselected:(%l%l)$',
		'^###cb:langselected:(%l%l_%u%u)$'
	}
}

return _M
