local function doKeyboard_lang()
	local keyboard = {
		inline_keyboard = {}
	}
	for i,lang in pairs(config.available_languages) do
		local line = {{text = lang, callback_data = 'langselected:'..lang}}
		table.insert(keyboard.inline_keyboard, line)
	end
	return keyboard
end

local action = function(msg, blocks, ln)
	if msg.chat.type ~= 'private' and not is_mod(msg) then
		if msg.cb then
			api.answerCallbackQuery(msg.cb_id, lang[ln].not_mod:mEscape_hard())
    	end
    	return
    end
	
	local keyboard
	
	if blocks[1] == 'lang' and not blocks[2] then
		keyboard = doKeyboard_lang()
		
		api.sendKeyboard(msg.chat.id, lang[ln].setlang.list, keyboard, true)
	end
	if blocks[1] == 'langselected' and msg.cb then
	    local selected = blocks[2]
	    db:set('lang:'..msg.chat.id, selected)
        api.editMessageText(msg.chat.id, msg.message_id, make_text(lang[selected].setlang.success, selected), false, true)
	end
end

return {
	action = action,
	triggers = {
		'^/(lang)$',
		'^###cb:(langselected):(%a%a)$'
	}
}