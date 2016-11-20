local plugin = {}

local function getAntispamWarns(chat_id, user_id)
    local max_allowed = (db:hget('chat:'..chat_id..':antispam', 'warns')) or config.chat_settings['antispam']['warns']
    max_allowed = tonumber(max_allowed)
    local warns_received = (db:hincrby('chat:'..chat_id..':spamwarns', user_id, 1))
    warns_received = tonumber(warns_received)
    
    return warns_received, max_allowed
end

function plugin.onEveryMessage(msg)
    if not msg.inline and msg.spam and msg.chat.id < 0 and not msg.cb then
        print('processing...', msg.spam)
        local status = db:hget('chat:'..msg.chat.id..':antispam', msg.spam)
        print(status)
        if status and status == 'notalwd' then
            if not roles.is_admin_cached(msg) then
                print('not admin')
                local name = misc.getname_final(msg.from)
                local warns_received, max_allowed = getAntispamWarns(msg.chat.id, msg.from.id)
                print(warns_received, max_allowed)
                if warns_received >= max_allowed then
                    local action = (db:hget('chat:'..msg.chat.id..':antispam', 'action')) or config.chat_settings['antispam']['action']
                    print(action)
                    
                    local hammer_funct, hammer_text
                    if action == 'ban' then
                        hammer_funct = api.banUser
                        hammer_text = _('banned')
                    elseif action == 'kick' then
                        hammer_funct = api.kickUser
                        hammer_text = _('kicked')
                    end
                    local res = hammer_funct(msg.chat.id, msg.from.id)
                    if res then
                        db:hdel('chat:'..msg.chat.id..':spamwarns', msg.from.id) --remove media warns
                        api.sendMessage(msg.chat.id, _('%s %s for *spam*! (%d/%d)'):format(name, hammer_text, warns_received, max_allowed), true)
                    end
                else
                    api.sendReply(msg, _('%s, this kind of spam is not allowed in this chat (*%d/%d*)'):format(name, warns_received, max_allowed), true)
                end
            end
        end
    end
    
    return true
end

local function toggleAntispamSetting(chat_id, key)
    local hash = 'chat:'..chat_id..':antispam'
    local current = (db:hget(hash, key)) or config.chat_settings['antispam'][key]
    local new
    if current == 'alwd' then new = 'notalwd' else new = 'alwd' end
    
    db:hset(hash, key, new)
    
    local text = _('allowed')
    if new == 'notalwd' then text = _('not allowed') end
    
    return _(key)..(': %s'):format(text)
end

local function changeWarnsNumber(chat_id, action)
    local hash = 'chat:'..chat_id..':antispam'
    local key = 'warns'
    local current = (db:hget(hash, key)) or config.chat_settings['antispam'][key]
    current = tonumber(current)
    if current < 1 then
        current = 1
        db:hset(hash, key, 1)
    end
    
    if current == 1 and action == 'dim' then
        return _("You can't go lower")
    elseif current == 7 and action == 'raise' then
        return _("You can't go higher")
    else
        local new
        if action == 'dim' then
            new = db:hincrby(hash, key, -1)
        elseif action == 'raise' then
            new = db:hincrby(hash, key, 1)
        end
        return _("New value: %d"):format(new)
    end
end

local function changeAction(chat_id)
    local hash = 'chat:'..chat_id..':antispam'
    local key = 'action'
    local current = (db:hget(hash, key)) or config.chat_settings['antispam'][key]
    
    local new_action = 'ban'
    if current == 'ban' then new_action = 'kick' end
    
    db:hset(hash, key, new_action)
    
    return '✅'
end

local function  get_alert_text(key)
    if key == 'links' then
        return _("Allow/forbid telegram.me links")
    elseif key == 'forwards' then
        return _("Allow/forbid forwarded messages from channels")
    elseif key == 'warns' then
        return _("Set how many times the bot should warn the user before kick/ban him")
    else
        return 'description'
    end
end

local function doKeyboard_antispam(chat_id)
    local keyboard = {inline_keyboard = {}}
    local humanizations = {
        ['links'] = _('telegram.me links'),
        ['forwards'] = _('Channels messages')
    }
    for field, value in pairs(config.chat_settings['antispam']) do
        if field == 'links' or field == 'forwards' then
            local icon = '✅'
            local status = (db:hget('chat:'..chat_id..':antispam', field)) or config.chat_settings['antispam'][field]
            if status == 'notalwd' then icon = '❌' end
            local line = {
                {text = _(humanizations[field] or field), callback_data = 'antispam:alert:'..field},
                {text = icon, callback_data = 'antispam:toggle:'..field..':'..chat_id}
            }
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    
    local warns = (db:hget('chat:'..chat_id..':antispam', 'warns')) or config.chat_settings['antispam']['warns']
    local action = (db:hget('chat:'..chat_id..':antispam', 'action')) or config.chat_settings['antispam']['action']
	
	if action == 'kick' then
		action = _("Kick")
	else
		action = _("Ban")
	end
    
    local line = {
        {text = 'Warns: '..warns, callback_data = 'antispam:alert:warns'},
        {text = '➖', callback_data = 'antispam:toggle:dim:'..chat_id},
        {text = '➕', callback_data = 'antispam:toggle:raise:'..chat_id},
        {text = _(action), callback_data = 'antispam:toggle:action:'..chat_id}
    }
    
    table.insert(keyboard.inline_keyboard, line)
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

function plugin.onCallbackQuery(msg, blocks)
    
	if blocks[1] == 'alert' then
	    local text = get_alert_text(blocks[2])
	    api.answerCallbackQuery(msg.cb_id, text, true)
	else
	    
	    local chat_id = msg.target_id
	    if not roles.is_admin_cached(chat_id, msg.from.id) then
	    	api.answerCallbackQuery(msg.cb_id, _("You're no longer an admin"))
	    else
	        local antispam_first = _([[*Anti-spam settings*
Choose which kind of spam you want to forbid
• ✅ = *Allowed*
• ❌ = *Not allowed*
]])
        
            local keyboard, text
            
            if blocks[1] == 'toggle' then
                if blocks[2] == 'forwards' or blocks[2] == 'links' then
                    text = toggleAntispamSetting(chat_id, blocks[2])
                else
                    if blocks[2] == 'raise' or blocks[2] == 'dim' then
                        text = changeWarnsNumber(chat_id, blocks[2])
                    elseif blocks[2] == 'action' then
                        text = changeAction(chat_id, blocks[2])
                    end
                end
            end
            
            keyboard = doKeyboard_antispam(chat_id)
            api.editMessageText(msg.chat.id, msg.message_id, antispam_first, true, keyboard)
            if text then api.answerCallbackQuery(msg.cb_id, text) end
        end
    end
end

plugin.triggers = {
    onCallbackQuery = {
        '^###cb:antispam:(toggle):(%w+):(-?%d+)$',
        '^###cb:antispam:(alert):(%w+)$',
        '^###cb:(config):antispam:(-?%d+)$'
    }
}

return plugin
