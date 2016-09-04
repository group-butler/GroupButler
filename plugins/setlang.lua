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

local action = function(msg, blocks)
	if msg.chat.type ~= 'private' and not roles.is_admin_cached(msg) then
		if msg.cb then
			api.answerCallbackQuery(msg.cb_id, _("You are not an admin"))
    	end
    	return
    end
	
	local keyboard
	
	if blocks[1] == 'lang' and not blocks[2] then
		keyboard = doKeyboard_lang()
		
		api.sendKeyboard(msg.chat.id, _("*List of available languages*:"), keyboard, true)
	end
	if blocks[1] == 'langselected' and msg.cb then
		locale.language = blocks[2]
	    db:set('lang:'..msg.chat.id, locale.language)
		-- TRANSLATORS: replace word 'English' with name of your language
        api.editMessageText(msg.chat.id, msg.message_id, _("English language is *set*"), false, true)
	end
end

return {
	action = action,
	triggers = {
		config.cmd..'(lang)$',
		'^###cb:(langselected):(%l%l)$',
		'^###cb:(langselected):(%l%l_%u%u)$',
	}
}
