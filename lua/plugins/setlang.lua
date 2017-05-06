local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local db = require 'database'

local plugin = {}

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

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type == 'private' or (msg.chat.id < 0 and u.is_allowed('config', msg.chat.id, msg.from)) then
		local keyboard = doKeyboard_lang()
		api.sendMessage(msg.chat.id, ("*List of available languages*:"), true, keyboard)
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if msg.chat.type ~= 'private' and not msg.from.admin then
		api.answerCallbackQuery(msg.cb_id, ("You are not an admin"))
	else
		if blocks[1] == 'selectlang' then
			local keyboard = doKeyboard_lang()
			api.editMessageText(msg.chat.id, msg.message_id, ("*List of available languages*:"), true, keyboard)
		else
			i18n.setLocale(blocks[1])
			db.setvchat(msg.chat.id, 'lang', "'"..blocks[1].."'")
			if (blocks[1] == 'ar' or blocks[1] == 'fa') and msg.chat.type ~= 'private' then
				-- Here null means allowed. Other possible values are ban and kick
				db.setvchat(msg.chat.id, 'arab', 'null')
				db.setvchat(msg.chat.id, 'rtl', 'null')
			end
			-- TRANSLATORS: replace 'English' with the name of your language
			api.editMessageText(msg.chat.id, msg.message_id, ("English language is *set*")..(".\nPlease note that translators are volunteers, and some strings of the translation you selected _could not have been translated yet_"), true)
		end
	end
end

plugin.triggers = {
	onTextMessage = {config.cmd..'(lang)$'},
	onCallbackQuery = {
		'^###cb:(selectlang)',
		'^###cb:langselected:(%l%l)$',
		'^###cb:langselected:(%l%l_%u%u)$'
	}
}

return plugin
