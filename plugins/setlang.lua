local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

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
	if not (msg.chat.type ~= 'private' and not roles.is_admin_cached(msg)) then
		local keyboard = doKeyboard_lang()
		api.sendMessage(msg.chat.id, _("*List of available languages*:"), true, keyboard)
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if msg.chat.type ~= 'private' and not roles.is_admin_cached(msg) then
		api.answerCallbackQuery(msg.cb_id, _("You are not an admin"))
	else
		if blocks[1] == 'selectlang' then
			local keyboard = doKeyboard_lang()
			api.editMessageText(msg.chat.id, msg.message_id, _("*List of available languages*:"), true, keyboard)
		else
			locale.language = blocks[1]
	    	db:set('lang:'..msg.chat.id, locale.language)
	    	if (blocks[1] == 'ar' or blocks[1] == 'fa') and msg.chat.type ~= 'private' then
	    		db:hset('chat:'..msg.chat.id..':char', 'Arab', 'allowed')
	    		db:hset('chat:'..msg.chat.id..':char', 'Rtl', 'allowed')
	    	end
			-- TRANSLATORS: replace 'English' with the name of your language
        	api.editMessageText(msg.chat.id, msg.message_id, _("English language is *set*").._(".\nPlease note that translators are volunteers, and some strings of the translation you selected _could not have been translated yet_"), true)
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
