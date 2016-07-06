local included_fields = {
    'settings',
    'about',
    'rules',
    'mod',
    'extra'
}

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

local function getWelcomeMessage(chat_id, ln)
    hash = 'chat:'..chat_id..':welcome'
    local type = db:hget(hash, 'type')
    local message = ''
    if type == 'composed' then
    	local wel = db:hget(hash, 'content')
    	if wel == 'a' then
    	    message = message..lang[ln].settings.resume.w_a
    	elseif wel == 'r' then
    	    message = message..lang[ln].settings.resume.w_r
    	elseif wel == 'm' then
    	    message = message..lang[ln].settings.resume.w_m
    	elseif wel == 'ra' then
    	    message = message..lang[ln].settings.resume.w_ra
    	elseif wel == 'rm' then
    	    message = message..lang[ln].settings.resume.w_rm
    	elseif wel == 'am' then
    	    message = message..lang[ln].settings.resume.w_am
    	elseif wel == 'ram' then
    	    message = message..lang[ln].settings.resume.w_ram
    	elseif wel == 'no' then
    	    message = message..lang[ln].settings.resume.w_no
    	end
	elseif type == 'media' then
		message = message..lang[ln].settings.resume.w_media
	elseif type == 'custom' then
		message = db:hget(hash, 'content')
	end
    return message
end

local function getFloodSettings_text(chat_id, ln)
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
    local exceptions = {
        ['text'] = lang[ln].floodmanager.text,
        ['sticker'] = lang[ln].floodmanager.sticker,
        ['image'] = lang[ln].floodmanager.image,
        ['gif'] = lang[ln].floodmanager.gif,
        ['video'] = lang[ln].floodmanager.video
    }
    hash = 'chat:'..chat_id..':floodexceptions'
    local list_exc = ''
    for media, translation in pairs(exceptions) do
        --ignored by the antiflood-> yes, no
        local exc_status = (db:hget(hash, media)) or 'no'
        if exc_status == 'yes' then
            exc_status = '✅'
        else
            exc_status = '❌'
        end
        list_exc = list_exc..'• `'..translation..'`: '..exc_status..'\n'
    end
    return make_text(lang[ln].all.dashboard.antiflood, status, action, num, list_exc)
end

local function doKeyboard_dashboard(chat_id, ln)
    local keyboard = {}
    keyboard.inline_keyboard = {
	    {
            {text = lang[ln].all.dashboard.settings, callback_data = 'dashboard:settings:'..chat_id},
            {text = lang[ln].all.dashboard.admins, callback_data = 'dashboard:modlist:'..chat_id}
		},
	    {
		    {text = lang[ln].all.dashboard.rules, callback_data = 'dashboard:rules:'..chat_id},
		    {text = lang[ln].all.dashboard.about, callback_data = 'dashboard:about:'..chat_id}
        },
	   	{
	   	    {text = lang[ln].all.dashboard.welcome, callback_data = 'dashboard:welcome:'..chat_id},
	   	    {text = lang[ln].all.dashboard.extra, callback_data = 'dashboard:extra:'..chat_id}
	    },
	    {
	   	    {text = lang[ln].all.dashboard.flood, callback_data = 'dashboard:flood:'..chat_id},
	   	    {text = lang[ln].all.dashboard.media, callback_data = 'dashboard:media:'..chat_id}
	    },
    }
    
    return keyboard
end

local function usersettings_table(settings)
    local return_table = {}
    local icon_yes, icon_no = '👤', '👥'
    for field, status in pairs(settings) do
        if field == 'Modlist' or field == 'About' or field == 'Rules' or field == 'Extra' then
            if status == 'yes' then
                return_table[field] = icon_yes
            elseif status == 'no' then
                return_table[field] = icon_no
            end
        end
    end
    
    return return_table
end

local function adminsettings_table(settings)
    local return_table = {}
    local icon_yes, icon_no = '🚫', '✅'
    for field, status in pairs(settings) do
        if field == 'Flood' or field == 'Report' or field == 'Welcome' or field == 'Admin_mode' then
            if status == 'yes' then
                return_table[field] = icon_yes
            elseif status == 'no' then
                return_table[field] = icon_no
            end
        end
    end
    
    return return_table
end

local function charsettings_table(chat_id)
    local settings = db:hgetall('chat:'..chat_id..':char')
    local return_table = {}
    local icon_allow, icon_not_allow = '✅', '🔐'
    for field, status in pairs(settings) do
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
            {text = lang[ln].settings[key], callback_data = 'menu:alert:settings'},
            {text = icon, callback_data = 'menu:'..key..':'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, current)
    end
    
    return keyboard
end

local function doKeyboard_menu(chat_id, ln)
    local keyboard = {inline_keyboard = {}}
    
    --settings
    local settings = db:hgetall('chat:'..chat_id..':settings')
    
    local settings_section = adminsettings_table(settings)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id, ln)
    
    settings_section = usersettings_table(settings)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id, ln)
    
    settings_section = charsettings_table(chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id, ln)
    
    --warn
    local max = (db:hget('chat:'..chat_id..':warnsettings', 'max')) or 3
    action = (db:hget('chat:'..chat_id..':warnsettings', 'type')) or 'kick'
    local warn = {
        {text = '➖', callback_data = 'menu:DimWarn:'..chat_id},
        {text = '📍'..max..' 🔨️'..action, callback_data = 'menu:ActionWarn:'..chat_id},
        {text = '➕', callback_data = 'menu:RaiseWarn:'..chat_id},
    }
    table.insert(keyboard.inline_keyboard, {{text = 'Warns 👇🏼', callback_data = 'menu:alert:warns:'}})
    table.insert(keyboard.inline_keyboard, warn)
    
    return keyboard
end

local function get_group_name(text)
    local name = text:match('.*%((.+)%)$')
    if not name then
        return ''
    end
    name = '\n('..name..')'
    return name:mEscape()
end

local action = function(msg, blocks, ln)
    
    --get the interested chat id
    local chat_id, msg_id
    if msg.cb then
        chat_id = msg.data:gsub('[%a _]+:', '')
        msg_id = msg.message_id
    else
        chat_id = msg.chat.id
    end
    
    local keyboard = {}
    
    if blocks[1] == 'dashboard' then
        if not(msg.chat.type == 'private') and not msg.cb then
            keyboard = doKeyboard_dashboard(chat_id, ln)
            --everyone can use this
            local res = api.sendKeyboard(msg.from.id, lang[ln].all.dashboard.first, keyboard, true)
            if res then
                api.sendMessage(msg.chat.id, lang[ln].all.dashboard.private, true)
            else
                cross.sendStartMe(msg, ln)
            end
	        return
        end
        if msg.cb then
            local request = blocks[2]
            local text
            keyboard = doKeyboard_dashboard(chat_id, ln)
            if request == 'settings' then
                text = cross.getSettings(chat_id, ln)
            end
            if request == 'rules' then
                text = cross.getRules(chat_id, ln)
            end
            if request == 'about' then
                text = cross.getAbout(chat_id, ln)
            end
            if request == 'modlist' then
                local creator, admins = cross.getModlist(chat_id)
                if not creator then
                    text = lang[ln].bonus.adminlist_admin_required --creator is false, admins is the error code
                else
                    text = make_text(lang[ln].mod.modlist, creator, admins)
                end
            end
            if request == 'extra' then
                text = cross.getExtraList(chat_id, ln)
            end
            if request == 'welcome' then
                text = getWelcomeMessage(chat_id, ln)
            end
            if request == 'flood' then
                text = getFloodSettings_text(chat_id, ln)
            end
            if request == 'media' then
                text = lang[ln].mediasettings.settings_header
                for i, media in pairs(config.media_list) do
                    local status = (db:hget('chat:'..chat_id..':media', media)) or 'allowed'
                    if status == 'allowed' then
                        status = '✅'
                    else
                        status = '🔐 '..status
                    end
                    text = text..'`'..media..'` ≡ '..status..'\n'
                end
            end
            api.editMessageText(msg.chat.id, msg_id, text, keyboard, true)
            api.answerCallbackQuery(msg.cb_id, 'ℹ️ Group ► '..request)
            return
        end
    end
    if blocks[1] == 'menu' then
        if not(msg.chat.type == 'private') and not msg.cb then
            if not is_mod(msg) then return end --only mods can use this
            keyboard = doKeyboard_menu(chat_id, ln)
            api.sendMessage(msg.chat.id, lang[ln].all.menu, true)
	        api.sendKeyboard(msg.from.id, lang[ln].all.menu_first..'\n('..msg.chat.title:mEscape()..')', keyboard, true)
	        return
	    end
	    if msg.cb then
	        local text
	        if blocks[2] == 'alert' then
	            if blocks[3] == 'settings' then
                    text = '⚠️ '..lang[ln].bonus.menu_cb_settings
                elseif blocks[3] == 'warns' then
                    text = '⚠️ '..lang[ln].bonus.menu_cb_warns
                end
                api.answerCallbackQuery(msg.cb_id, text)
                return
            end
            if blocks[2] == 'DimWarn' or blocks[2] == 'RaiseWarn' or blocks[2] == 'ActionWarn' then
                if blocks[2] == 'DimWarn' then
                    text = changeWarnSettings(chat_id, -1, ln)
                elseif blocks[2] == 'RaiseWarn' then
                    text = changeWarnSettings(chat_id, 1, ln)
                elseif blocks[2] == 'ActionWarn' then
                    text = changeWarnSettings(chat_id, 'status', ln)
                end
            elseif blocks[2] == 'Rtl' or blocks[2] == 'Arab' then
                text = changeCharSettings(chat_id, blocks[2], ln)
            else
                text = cross.changeSettingStatus(chat_id, blocks[2], ln)
            end
            keyboard = doKeyboard_menu(chat_id, ln)
            local group_name = get_group_name(msg.old_text)
            api.editMessageText(msg.chat.id, msg_id, lang[ln].all.menu_first..group_name, keyboard, true)
            if text then api.answerCallbackQuery(msg.cb_id, '⚙ '..text) end --workaround to avoid to send an error to users who are using an old inline keyboard
        end
    end
end

return {
	action = action,
	triggers = {
		'^/(dashboard)$',
		'^/(menu)$',
		
		'^###cb:(dashboard):(%a+):(-%d+)',
    	
    	'^###cb:(menu):(alert):(settings)',
    	'^###cb:(menu):(alert):(warns)',
    	
    	'^###cb:(menu):(.*):',
	}
}