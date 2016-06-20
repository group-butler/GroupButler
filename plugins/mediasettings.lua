local function get_group_name(text)
    local name = text:match('.*%((.+)%)$')
    if not name then
        return ''
    end
    name = '\n('..name..')'
    return name:mEscape()
end

local function doKeyboard_media(chat_id)
    local keyboard = {}
    keyboard.inline_keyboard = {}
    for i,media in pairs(config.media_list) do
    	local status = (db:hget('chat:'..chat_id..':media', media)) or 'allowed'
        if status == 'allowed' then
            status = '✅'
        else
            status = '🔐 '..status
        end
        local line = {
            {text = media, callback_data = 'mediallert'},
            {text = status, callback_data = 'media:'..media..':'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, line)
    end
    
    return keyboard
end

local action = function(msg, blocks, ln)
	
	if not msg.cb  and msg.chat.type ~= 'private' then
		
		if not is_mod(msg) then return end
		
		if blocks[1] == 'media list' then
			local media_sett = db:hgetall('chat:'..msg.chat.id..':media')
			local text = lang[ln].mediasettings.settings_header
			for k,v in pairs(media_sett) do
				text = text..'`'..k..'`'..' ≡ '..v..'\n'
			end
			api.sendReply(msg, text, true)
			mystat('/media')
		end
		if blocks[1] == 'media' then
            keyboard = doKeyboard_media(msg.chat.id)
            local res = api.sendKeyboard(msg.from.id, lang[ln].all.media_first..'\n('..msg.chat.title:mEscape()..')', keyboard, true)
            if res then
            	api.sendMessage(msg.chat.id, lang[ln].bonus.general_pm, true)
            else
            	cross.sendStartMe(msg, ln)
            end
	        mystat('/media')
	    end
	end
	
	if msg.cb then
		if blocks[1] == 'mediallert' then
			api.answerCallbackQuery(msg.cb_id, '⚠️ '..lang[ln].bonus.menu_cb_media)
		end
		if blocks[1] == 'media' then
			local chat_id = msg.target_id
			local media = blocks[2]
	    	local text = cross.changeMediaStatus(chat_id, media, 'next', ln)
        	keyboard = doKeyboard_media(chat_id)
        	local group_name = get_group_name(msg.old_text)
        	api.editMessageText(msg.chat.id, msg.message_id, lang[ln].all.media_first..group_name, keyboard, true)
        	api.answerCallbackQuery(msg.cb_id, '⚡️ '..text)
        end
    end
end

return {
	action = action,
	triggers = {
		'^/(media list)$',
		'^/(media)$',
		'^###cb:(media):(%a+):(-%d+)',
		'^###cb:(mediallert)',
	}
}