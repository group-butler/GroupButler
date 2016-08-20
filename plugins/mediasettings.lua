local function doKeyboard_media(chat_id, ln)
	if not ln then ln = 'en' end
    local keyboard = {}
    keyboard.inline_keyboard = {}
    for media, default_status in pairs(config.chat_settings['media']) do
    	local status = (db:hget('chat:'..chat_id..':media', media)) or default_status
        if status == 'ok' then
            status = '✅'
        else
            status = '❌'
        end
        local media_text = lang[ln].mediasettings.media_texts[media] or media
        local line = {
            {text = media_text, callback_data = 'mediallert'},
            {text = status, callback_data = 'media:'..media..':'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, line)
    end
    
    --MEDIA WARN
    --action line
    local max = (db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or config.chat_settings['warnsettings']['mediamax']
    local action = (db:hget('chat:'..chat_id..':warnsettings', 'mediatype')) or config.chat_settings['warnsettings']['mediatype']
    table.insert(keyboard.inline_keyboard, {{text = 'Warns (media) 📍 '..max..' | '..action, callback_data = 'mediatype:'..chat_id}})
    --buttons line
    local warn = {
        {text = '➖', callback_data = 'mediawarn:dim:'..chat_id},
        {text = '➕', callback_data = 'mediawarn:raise:'..chat_id},
    }
    table.insert(keyboard.inline_keyboard, warn)
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

local action = function(msg, blocks)
	
	local chat_id = msg.target_id
	
	if  blocks[1] == 'config' then
		local keyboard = doKeyboard_media(chat_id, msg.ln)
		local text = lang[msg.ln].all.media_first
	    api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
	else
		if blocks[1] == 'mediallert' then
			api.answerCallbackQuery(msg.cb_id, lang[msg.ln].mediasettings.cb_alert) return
		end
		local cb_text
		if blocks[1] == 'mediawarn' then
			local current = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or 2
			if blocks[2] == 'dim' then
				if current < 2 then
					cb_text = lang[msg.ln].warn.inline_low
				else
					local new = db:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', -1)
					cb_text = make_text(lang[msg.ln].floodmanager.changed_cross, current, new)
				end
			elseif blocks[2] == 'raise' then
				if current > 11 then
					cb_text = lang[msg.ln].warn.inline_high
				else
					local new = db:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', 1)
					cb_text = make_text(lang[msg.ln].floodmanager.changed_cross, current, new)
				end
			end
			cb_text = '⚙ '..cb_text
		end
		if blocks[1] == 'mediatype' then
			local hash = 'chat:'..chat_id..':warnsettings'
			local current = (db:hget(hash, 'mediatype')) or config.chat_settings['warnsettings']['mediatype']
			if current == 'ban' then
				db:hset(hash, 'mediatype', 'kick')
				cb_text = '🔨 '..lang[msg.ln].mediasettings.changed:compose('kick')
			else
				db:hset(hash, 'mediatype', 'ban')
				cb_text = '🔨 '..lang[msg.ln].mediasettings.changed:compose('ban')
			end
		end
		if blocks[1] == 'media' then
			local media = blocks[2]
	    	cb_text = '⚡️ '..misc.changeMediaStatus(chat_id, media, 'next', msg.ln)
        end
        keyboard = doKeyboard_media(chat_id, msg.ln)
    	api.editMessageText(msg.chat.id, msg.message_id, lang[msg.ln].all.media_first, keyboard, true)
        api.answerCallbackQuery(msg.cb_id, cb_text)
    end
end

return {
	action = action,
	triggers = {
		'^###cb:(media):(%a+):(-%d+)',
		'^###cb:(mediatype):(-%d+)',
		'^###cb:(mediawarn):(%a+):(-%d+)',
		'^###cb:(mediallert)',
		
		'^###cb:(config):media:(-%d+)$'
	}
}