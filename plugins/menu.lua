local function changeWarnSettings(chat_id, action, ln)
    local current = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'max')) or 3
    local new_val
    if action == 1 then
        if current > 12 then
            return lang[ln].warn.inline_high
        else
            new_val = db:hincrby('chat:'..chat_id..':warnsettings', 'max', 1)
            return current..'->'..new_val
        end
    elseif action == -1 then
        if current < 2 then
            return lang[ln].warn.inline_low
        else
            new_val = db:hincrby('chat:'..chat_id..':warnsettings', 'max', -1)
            return current..'->'..new_val
        end
    elseif action == 'status' then
        local status = (db:hget('chat:'..chat_id..':warnsettings', 'type')) or 'kick'
        if status == 'kick' then
            db:hset('chat:'..chat_id..':warnsettings', 'type', 'ban')
            return make_text(lang[ln].warn.changed_type, 'ban')
        elseif status == 'ban' then
            db:hset('chat:'..chat_id..':warnsettings', 'type', 'kick')
            return make_text(lang[ln].warn.changed_type, 'kick')
        end
    end
end

local function changeCharSettings(chat_id, field, ln)
    local hash = 'chat:'..chat_id..':char'
    local status = db:hget(hash, field)
    local text
    if status == 'allowed' then
        db:hset(hash, field, 'kick')
        text = lang[ln].settings.char[field:lower()..'_kick']
    elseif status == 'kick' then
        db:hset(hash, field, 'ban')
        text = lang[ln].settings.char[field:lower()..'_ban']
    elseif status == 'ban' then
        db:hset(hash, field, 'allowed')
        text = lang[ln].settings.char[field:lower()..'_allow']
    else
        db:hset(hash, field, 'allowed')
        text = lang[ln].settings.char[field:lower()..'_allow']
    end
    
    return text
end

local function usersettings_table(settings, chat_id)
    local return_table = {}
    local icon_off, icon_on = '👤', '👥'
    for field, default in pairs(settings) do
        if field == 'Extra' or field == 'Rules' then
            local status = (db:hget('chat:'..chat_id..':settings', field)) or default
            if status == 'off' then
                return_table[field] = icon_off
            elseif status == 'on' then
                return_table[field] = icon_on
            end
        end
    end
    
    return return_table
end

local function adminsettings_table(settings, chat_id)
    local return_table = {}
    local icon_off, icon_on = '🚫', '✅'
    for field, default in pairs(settings) do
        if field ~= 'Extra' and field ~= 'Rules' then
            local status = (db:hget('chat:'..chat_id..':settings', field)) or default
            if status == 'off' then
                return_table[field] = icon_off
            elseif status == 'on' then
                return_table[field] = icon_on
            end
        end
    end
    
    return return_table
end

local function charsettings_table(settings, chat_id)
    local return_table = {}
    local icon_allow, icon_not_allow = '✅', '🔐'
    for field, default in pairs(settings) do
        local status = (db:hget('chat:'..chat_id..':char', field)) or default
        if status == 'kick' or status == 'ban' then
            return_table[field] = icon_not_allow..' '..status
        elseif status == 'allowed' then
            return_table[field] = icon_allow
        end
    end
    
    return return_table
end

local function insert_settings_section(keyboard, settings_section, chat_id, ln)
    for key, icon in pairs(settings_section) do
        local current = {
            {text = lang[ln].settings[key] or key, callback_data = 'menu:alert:settings'},
            {text = icon, callback_data = 'menu:'..key..':'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, current)
    end
    
    return keyboard
end

local function doKeyboard_menu(chat_id, ln)
    local keyboard = {inline_keyboard = {}}
    
    local settings_section = adminsettings_table(config.chat_settings['settings'], chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id, ln)
    
    settings_section = usersettings_table(config.chat_settings['settings'], chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id, ln)
    
    settings_section = charsettings_table(config.chat_settings['char'], chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id, ln)
    
    --warn
    local max = (db:hget('chat:'..chat_id..':warnsettings', 'max')) or config.chat_settings['warnsettings']['max']
    local action = (db:hget('chat:'..chat_id..':warnsettings', 'type')) or config.chat_settings['warnsettings']['type']
    local warn = {
        {text = '➖', callback_data = 'menu:DimWarn:'..chat_id},
        {text = '📍'..max..' 🔨️'..action, callback_data = 'menu:ActionWarn:'..chat_id},
        {text = '➕', callback_data = 'menu:RaiseWarn:'..chat_id},
    }
    table.insert(keyboard.inline_keyboard, {{text = 'Warns 👇🏼', callback_data = 'menu:alert:warns:'}})
    table.insert(keyboard.inline_keyboard, warn)
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

local action = function(msg, blocks)
    --get the interested chat id
    local chat_id = msg.target_id
    
    local keyboard, text
    
    if blocks[1] == 'config' then
        local text = lang[msg.ln].all.menu_first
        keyboard = doKeyboard_menu(chat_id, msg.ln)
        api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
    else
	    if blocks[2] == 'alert' then
	        if blocks[3] == 'settings' then
                text = '⚠️ '..lang[msg.ln].bonus.menu_cb_settings
            elseif blocks[3] == 'warns' then
                text = '⚠️ '..lang[msg.ln].bonus.menu_cb_warns
            end
            api.answerCallbackQuery(msg.cb_id, text)
            return
        end
        if blocks[2] == 'DimWarn' or blocks[2] == 'RaiseWarn' or blocks[2] == 'ActionWarn' then
            if blocks[2] == 'DimWarn' then
                text = changeWarnSettings(chat_id, -1, msg.ln)
            elseif blocks[2] == 'RaiseWarn' then
                text = changeWarnSettings(chat_id, 1, msg.ln)
            elseif blocks[2] == 'ActionWarn' then
                text = changeWarnSettings(chat_id, 'status', msg.ln)
            end
        elseif blocks[2] == 'Rtl' or blocks[2] == 'Arab' then
            text = changeCharSettings(chat_id, blocks[2], msg.ln)
        else
            text = misc.changeSettingStatus(chat_id, blocks[2], msg.ln)
        end
        keyboard = doKeyboard_menu(chat_id, msg.ln)
        api.editMessageText(msg.chat.id, msg.message_id, lang[msg.ln].all.menu_first, keyboard, true)
        if text then api.answerCallbackQuery(msg.cb_id, '⚙ '..text) end --workaround to avoid to send an error to users who are using an old inline keyboard
    end
end

return {
	action = action,
	triggers = {
	    '^###cb:(menu):(alert):(settings)',
    	'^###cb:(menu):(alert):(warns)',
    	
    	'^###cb:(menu):(.*):',
    	
    	'^###cb:(config):menu:(-%d+)$'
	}
}