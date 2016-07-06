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
    
    --media warn
    local max = (db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or 2
    table.insert(keyboard.inline_keyboard, {{text = 'Warns (media) 📍 '..max, callback_data = 'mediallert'}})
    local warn = {
        {text = '➖', callback_data = 'mediawarn:dim:'..chat_id},
        {text = '➕', callback_data = 'mediawarn:raise:'..chat_id},
    }
    table.insert(keyboard.inline_keyboard, warn)
    return keyboard
end

local action = function(msg, blocks, ln)
	
	if not msg.cb and msg.chat.type ~= 'private' then
		
		if not is_mod(msg) then return end
		
		if blocks[1] == 'media list' then
			local media_sett = db:hgetall('chat:'..msg.chat.id..':media')
			local text = lang[ln].mediasettings.settings_header
			for k,v in pairs(media_sett) do
				text = text..'`'..k..'`'..' ≡ '..v..'\n'
			end
			api.sendReply(msg, text, true)
		end
		if blocks[1] == 'media' then
            keyboard = doKeyboard_media(msg.chat.id)
            local res = api.sendKeyboard(msg.from.id, lang[ln].all.media_first..'\n('..msg.chat.title:mEscape()..')', keyboard, true)
            if res then
            	api.sendMessage(msg.chat.id, lang[ln].bonus.general_pm, true)
            else
            	cross.sendStartMe(msg, ln)
            end
	    end
	end
	
	if msg.cb then
		if blocks[1] == 'mediallert' then
			api.answerCallbackQuery(msg.cb_id, '⚠️ '..lang[ln].bonus.menu_cb_media)
			return
		end
		local cb_text
		local group_name = get_group_name(msg.old_text)
		local chat_id = msg.target_id
		if blocks[1] == 'mediawarn' then
			local current = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or 2
			if blocks[2] == 'dim' then
				if current < 2 then
					cb_text = lang[ln].warn.inline_low
				else
					local new = db:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', -1)
					cb_text = make_text(lang[ln].floodmanager.changed_cross, current, new)
				end
			elseif blocks[2] == 'raise' then
				if current > 11 then
					cb_text = lang[ln].warn.inline_high
				else
					local new = db:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', 1)
					cb_text = make_text(lang[ln].floodmanager.changed_cross, current, new)
				end
			end
			cb_text = '⚙ '..cb_text
		end
		if blocks[1] == 'media' then
			local media = blocks[2]
	    	cb_text = '⚡️ '..cross.changeMediaStatus(chat_id, media, 'next', ln)
        end
        keyboard = doKeyboard_media(chat_id)
    	api.editMessageText(msg.chat.id, msg.message_id, lang[ln].all.media_first..group_name, keyboard, true)
        api.answerCallbackQuery(msg.cb_id, cb_text)
    end
end

return {
	action = action,
	triggers = {
		'^/(media list)$',
		'^/(media)$',
		'^###cb:(media):(%a+):(-%d+)',
		'^###cb:(mediawarn):(%a+):(-%d+)',
		'^###cb:(mediallert)',
	}
}