local function do_keyboard_flood(chat_id)
    --no: enabled, yes: disabled
    local status = db:hget('chat:'..chat_id..':settings', 'Flood') or config.chat_settings['settings']['Flood'] --check (default: disabled)
    if status == 'on' then
        status = _("✅ | ON")
    elseif status == 'off' then
        status = _("❌ | OFF")
    end
    
    local hash = 'chat:'..chat_id..':flood'
    local action = (db:hget(hash, 'ActionFlood')) or config.chat_settings['flood']['ActionFlood']
    if action == 'kick' then
        action = _("⚡️ kick")
    else
        action = _("⛔ ️ban")
    end
    local num = (db:hget(hash, 'MaxFlood')) or config.chat_settings['flood']['MaxFlood']
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
        text = _("Texts"),
        sticker = _("Stickers"),
        image = _("Images"),
        gif = _("GIFs"),
        video = _("Videos"),
    }
    local hash = 'chat:'..chat_id..':floodexceptions'
    for media, translation in pairs(exceptions) do
        --ignored by the antiflood-> yes, no
        local exc_status = (db:hget(hash, media)) or config.chat_settings['floodexceptions'][media]
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
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

local function action(msg, blocks)
	local header = _([[
You can manage the group flood settings from here.

*1st row*
• *ON/OFF*: the current status of the anti-flood
• *Kick/Ban*: what to do when someone is flooding

*2nd row*
• you can use *+/-* to change the current sensitivity of the antiflood system
• the number it's the max number of messages that can be sent in _5 seconds_
• max value: _25_, min value: _4_

*3rd row* and below
You can set some exceptions for the antiflood:
• ✅: the media will be ignored by the anti-flood
• ❌: the media won\'t be ignored by the anti-flood
• *Note*: in "_texts_" are included all the other types of media (file, audio...)
]])

    
    if not msg.cb and msg.chat.type == 'private' then return end
    
    local chat_id = msg.target_id or msg.chat.id
    
    local text, keyboard
    
    if blocks[1] == 'antiflood' then
        if not roles.is_admin_cached(msg) then return end
        if blocks[2]:match('%d%d?') then
            if tonumber(blocks[2]) < 4 or tonumber(blocks[2]) > 25 then
				local text = _("`%s` is not a valid value!\nThe value should be *higher* than `3` and *lower* then `26`")
				api.sendReply(msg, text:format(blocks[1]), true)
			else
	    	    local new = tonumber(blocks[2])
	    	    local old = tonumber(db:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or config.chat_settings['flood']['MaxFlood']
	    	    if new == old then
	            	api.sendReply(msg, _("The max number of messages is already %d"):format(new), true)
	    	    else
	            	db:hset('chat:'..msg.chat.id..':flood', 'MaxFlood', new)
					local text = _("The *max number* of messages (in *5 seconds*) changed _from_  %d _to_  %d")
	            	api.sendReply(msg, text:format(old, new), true)
	    	    end
            end
            return
        end
    else
        if not msg.cb then return end --avaoid trolls
        
        if blocks[1] == 'config' then
            keyboard = do_keyboard_flood(chat_id)
            api.editMessageText(msg.chat.id, msg.message_id, header, keyboard, true)
            return
        end
        
        if blocks[1] == 'alert' then
            if blocks[2] == 'num' then
                text = _("⚖ Current sensitivity. Tap on the + or the -")
            elseif blocks[2] == 'voice' then
                text = _("⚠️ Tap on an icon!")
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
                text = _("❎ [%s] will be ignored by the anti-flood"):format(media)
            else
                db:hset(hash, media, 'no')
                text = _("🚫 [%s] won't be ignored by the anti-flood"):format(media)
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
            text = misc.changeFloodSettings(chat_id, action):mEscape_hard()
        end
        
        if blocks[1] == 'status' then
            local status = db:hget('chat:'..chat_id..':settings', 'Flood') or config.chat_settings['settings']['Flood']
            text = misc.changeSettingStatus(chat_id, 'Flood'):mEscape_hard()
        end
        
        keyboard = do_keyboard_flood(chat_id)
        api.editMessageText(msg.chat.id, msg.message_id, header, keyboard, true)
        api.answerCallbackQuery(msg.cb_id, text)
    end
end

return {
    action = action,
    triggers = {
        config.cmd..'(antiflood) (%d%d?)$',
        
        '^###cb:flood:(alert):(%w+)$',
        '^###cb:flood:(status):(-%d+)$',
        '^###cb:flood:(action):(-%d+)$',
        '^###cb:flood:(dim):(-%d+)$',
        '^###cb:flood:(raise):(-%d+)$',
        '^###cb:flood:(exc):(%a+):(-%d+)$',
        
        '^###cb:(config):antiflood:'
    }
}
