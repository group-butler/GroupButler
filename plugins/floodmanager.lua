local function do_keyboard_flood(chat_id, ln)
    --no: enabled, yes: disabled
    local status = db:hget('chat:'..chat_id..':settings', 'Flood') or 'yes' --check (default: disabled)
    if status == 'no' then
        status = '✅ | ON'
    elseif status == 'yes' then
        status = '❌ | OFF'
    end
    
    local hash = 'chat:'..chat_id..':flood'
    local action = (db:hget(hash, 'ActionFlood')) or 'kick'
    if action == 'kick' then
        action = '⚡️ '..action
    else
        action = '⛔ ️'..action
    end
    local num = (db:hget(hash, 'MaxFlood')) or 5
    local keyboard = {
        inline_keyboard = {
            {
                {text = status, callback_data = 'flood:status:'..chat_id},
                {text = action, callback_data = 'flood:action:'..chat_id},
            },
            {
                {text = '➖', callback_data = 'flood:dim:'..chat_id},
                {text = num, callback_data = 'flood:alert:num'},
                {text = '➕', callback_data = 'flood:raise:'..chat_id},
            }
        }
    }
    
    local exceptions = {
        ['text'] = lang[ln].floodmanager.text,
        ['sticker'] = lang[ln].floodmanager.sticker,
        ['image'] = lang[ln].floodmanager.image,
        ['gif'] = lang[ln].floodmanager.gif,
        ['video'] = lang[ln].floodmanager.video
    }
    hash = 'chat:'..chat_id..':floodexceptions'
    for media, translation in pairs(exceptions) do
        --ignored by the antiflood-> yes, no
        local exc_status = (db:hget(hash, media)) or 'no'
        if exc_status == 'yes' then
            exc_status = '✅'
        else
            exc_status = '❌'
        end
        local line = {
            {text = translation, callback_data = 'flood:alert:voice'},
            {text = exc_status, callback_data = 'flood:exc:'..media..':'..chat_id},
        }
        table.insert(keyboard.inline_keyboard, line)
    end
    
    return keyboard
end

local function action(msg, blocks, ln)
    
    if not msg.cb and msg.chat.type == 'private' then return end
    
    local chat_id
    if msg.cb then
        chat_id = msg.target_id
    else
        chat_id = msg.chat.id
    end
    
    local text, keyboard
    
    if not msg.cb then
        if not is_mod(msg) then return end
        if blocks[1]:match('%d%d?') then
            if tonumber(blocks[1]) < 4 or tonumber(blocks[1]) > 25 then
				api.sendReply(msg, make_text(lang[ln].floodmanager.number_invalid, blocks[1]), true)
			else
	    	    local new = tonumber(blocks[1])
	    	    local old = tonumber(db:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
	    	    if new == old then
	            	api.sendReply(msg, make_text(lang[ln].floodmanager.not_changed, new), true)
	    	    else
	            	db:hset('chat:'..msg.chat.id..':flood', 'MaxFlood', new)
	            	api.sendReply(msg, make_text(lang[ln].floodmanager.changed_plug, old, new), true)
	    	    end
            end
            return
        end
        text = lang[ln].floodmanager.header
        keyboard = do_keyboard_flood(chat_id, ln)
        local res = api.sendKeyboard(msg.from.id, text, keyboard, true)
        if not res then
            cross.sendStartMe(msg, ln)
        else
            api.sendReply(msg, lang[ln].floodmanager.sent, true)
        end
    else
        if blocks[1] == 'alert' then
            if blocks[2] == 'num' then
                text = '⚖'..lang[ln].floodmanager.number_cb
            elseif blocks[2] == 'voice' then
                text = '⚠️ '..lang[ln].bonus.menu_cb_media
            end
            api.answerCallbackQuery(msg.cb_id, text)
            return
        end
        
        if blocks[1] == 'exc' then
            local media = blocks[2]
            local hash = 'chat:'..chat_id..':floodexceptions'
            local status = (db:hget(hash, media)) or 'no'
            if status == 'no' then
                db:hset(hash, media, 'yes')
                text = '❎ '..make_text(lang[ln].floodmanager.ignored, media)
            else
                db:hset(hash, media, 'no')
                text = '🚫 '..make_text(lang[ln].floodmanager.not_ignored, media)
            end
        end
        
        local action
        if blocks[1] == 'action' or blocks[1] == 'dim' or blocks[1] == 'raise' then
            if blocks[1] == 'action' then
                action = (db:hget('chat:'..chat_id..':flood', 'ActionFlood')) or 'kick'
            elseif blocks[1] == 'dim' then
                action = -1
            elseif blocks[1] == 'raise' then
                action = 1
            end
            text = cross.changeFloodSettings(chat_id, action, ln):mEscape_hard()
        end
        
        if blocks[1] == 'status' then
            local status = db:hget('chat:'..chat_id..':settings', 'Flood') or 'yes'
            text = cross.changeSettingStatus(chat_id, 'Flood', ln):mEscape_hard()
        end
        
        keyboard = do_keyboard_flood(chat_id, ln)
        api.editMessageText(msg.chat.id, msg.message_id, lang[ln].floodmanager.header, keyboard, true)
        api.answerCallbackQuery(msg.cb_id, text)
    end
end

return {
    action = action,
    triggers = {
        '^/antiflood$',
        '^/antiflood (%d%d?)$',
        '^###cb:flood:(alert):(%w+)$',
        '^###cb:flood:(status):(-%d+)$',
        '^###cb:flood:(action):(-%d+)$',
        '^###cb:flood:(dim):(-%d+)$',
        '^###cb:flood:(raise):(-%d+)$',
        '^###cb:flood:(exc):(%a+):(-%d+)$',
    }
}