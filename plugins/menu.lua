local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

local function get_button_description(key)
    if key == 'Reports' then
		-- TRANSLATORS: these strings should be shorter than 200 characters
        return _("When enabled, users will be able to report messages with the @admin command")
    elseif key == 'Goodbye' then
        return _("Enable or disable the goodbye message. Can't be sent in large groups")
    elseif key == 'Welcome' then
        return _("Enable or disable the welcome message")
    elseif key == 'Silent' then
        return _("When enabled, the bot doesn't answer in the group to /dashboard, /config and /help commands (it will just answer in private)")
    elseif key == 'Flood' then
        return _("Enable and disable the anti-flood system (more info in the /help message)")
    elseif key == 'Welbut' then
        return _("If the welcome message is enabled, it will include an inline button that will send to the user the rules in private")
    elseif key == 'Preview' then
        return _("Show or hide the preview for links. Affects the rules, welcome and goodbye messages and every custom command set with /extra")
    elseif key == 'Rules' then
        return _([[When someone uses /rules
👥: the bot will answer in the group (always, with admins)
👤: the bot will answer in private]])
    elseif key == 'Extra' then
        return _([[When someone uses an #extra
👥: the bot will answer in the group (always, with admins)
👤: the bot will answer in private]])
    elseif key == 'Arab' then
        return _("Select what the bot should do when someone sends a message with arab characters")
    elseif key == 'Rtl' then
        return _("Select what the bot should do when someone sends a message with the RTL character, or has it in his name")
    elseif key == 'warnsnum' then
        return _("Change how many times an user has to be warned before being kicked/banned")
    elseif key == 'warnsact' then
        return _("Change the action to perform when an user reaches the max. number of warnings")
    else
        return _("Description not available")
    end
end 

local function changeWarnSettings(chat_id, action)
    local current = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'max')) or 3
    local new_val
    if action == 1 then
        if current > 12 then
            return _("The new value is too high ( > 12)")
        else
            new_val = db:hincrby('chat:'..chat_id..':warnsettings', 'max', 1)
            return current..'->'..new_val
        end
    elseif action == -1 then
        if current < 2 then
            return _("The new value is too low ( < 1)")
        else
            new_val = db:hincrby('chat:'..chat_id..':warnsettings', 'max', -1)
            return current..'->'..new_val
        end
    elseif action == 'status' then
        local status = (db:hget('chat:'..chat_id..':warnsettings', 'type')) or 'kick'
        if status == 'kick' then
            db:hset('chat:'..chat_id..':warnsettings', 'type', 'ban')
            return _("New action on max number of warns received: ban")
        elseif status == 'ban' then
            db:hset('chat:'..chat_id..':warnsettings', 'type', 'kick')
            return _("New action on max number of warns received: kick")
        end
    end
end

local function changeCharSettings(chat_id, field)
	local chars = {
		arab_kick = _("Senders of arab messages will be kicked"),
		arab_ban = _("Senders of arab messages will be banned"),
		arab_allow = _("Arab language allowed"),
		rtl_kick = _("The use of the RTL character will lead to a kick"),
		rtl_ban = _("The use of the RTL character will lead to a ban"),
		rtl_allow = _("RTL character allowed"),
	}

    local hash = 'chat:'..chat_id..':char'
    local status = db:hget(hash, field)
    local text
    if status == 'allowed' then
        db:hset(hash, field, 'kick')
        text = chars[field:lower()..'_kick']
    elseif status == 'kick' then
        db:hset(hash, field, 'ban')
        text = chars[field:lower()..'_ban']
    elseif status == 'ban' then
        db:hset(hash, field, 'allowed')
        text = chars[field:lower()..'_allow']
    else
        db:hset(hash, field, 'allowed')
        text = chars[field:lower()..'_allow']
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
    local icon_off, icon_on = '☑️', '✅'
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
    for field, default in pairs(settings) do
        local status = (db:hget('chat:'..chat_id..':char', field)) or default
        if status == 'kick' then
            return_table[field] = '👞 '..status
        elseif status == 'ban' then
            return_table[field] = '🔨 '..status
        elseif status == 'allowed' then
            return_table[field] = '✅'
        end
    end
    
    return return_table
end

local function insert_settings_section(keyboard, settings_section, chat_id)
	local strings = {
		Welcome = _("Welcome"),
		Goodbye = _("Goodbye"),
		Extra = _("Extra"),
		Flood = _("Anti-flood"),
		Silent = _("Silent mode"),
		Rules = _("Rules"),
		Preview = _("Link preview"),
		Arab = _("Arab"),
		Rtl = _("RTL"),
		Antibot = _("Ban bots"),
		Reports = _("Reports"),
		Welbut = _("Welcome + rules button")
	}

    for key, icon in pairs(settings_section) do
        local current = {
            {text = strings[key] or key, callback_data = 'menu:alert:settings:'..key..':'..locale.language},
            {text = icon, callback_data = 'menu:'..key..':'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, current)
    end
    
    return keyboard
end

local function doKeyboard_menu(chat_id)
    local keyboard = {inline_keyboard = {}}
    
    local settings_section = adminsettings_table(config.chat_settings['settings'], chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id)
    
    settings_section = usersettings_table(config.chat_settings['settings'], chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id)
    
    settings_section = charsettings_table(config.chat_settings['char'], chat_id)
    keyboad = insert_settings_section(keyboard, settings_section, chat_id)
    
    --warn
    local max = (db:hget('chat:'..chat_id..':warnsettings', 'max')) or config.chat_settings['warnsettings']['max']
    local action = (db:hget('chat:'..chat_id..':warnsettings', 'type')) or config.chat_settings['warnsettings']['type']
	if action == 'kick' then
		action = _("👞 kick")
	else
		action = _("🔨️ ban")
	end
    local warn = {
        {
            {text = _('Warns: ')..max, callback_data = 'menu:alert:settings:warnsnum:'..locale.language},
		    {text = '➖', callback_data = 'menu:DimWarn:'..chat_id},
		    {text = '➕', callback_data = 'menu:RaiseWarn:'..chat_id},
        },
        {
            {text = _('Action:'), callback_data = 'menu:alert:settings:warnsact:'..locale.language},
            {text = action, callback_data = 'menu:ActionWarn:'..chat_id}
        }
    }
    for i, button in pairs(warn) do
        table.insert(keyboard.inline_keyboard, button)
    end
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

function plugin.onCallbackQuery(msg, blocks)
    local chat_id = msg.target_id
	if chat_id and not roles.is_admin_cached(chat_id, msg.from.id) then
		api.answerCallbackQuery(msg.cb_id, _("You're no longer an admin"))
	else
	    local menu_first = _("Manage the settings of the group. Click on the left column to get a small hint")
    
        local keyboard, text, show_alert
        
        if blocks[1] == 'config' then
            keyboard = doKeyboard_menu(chat_id)
            api.editMessageText(msg.chat.id, msg.message_id, menu_first, true, keyboard)
        else
	        if blocks[2] == 'alert' then
				if config.available_languages[blocks[4]] then
					locale.language = blocks[4]
				end
                text = get_button_description(blocks[3])
                api.answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
                return
            end
            if blocks[2] == 'DimWarn' or blocks[2] == 'RaiseWarn' or blocks[2] == 'ActionWarn' then
                if blocks[2] == 'DimWarn' then
                    text = changeWarnSettings(chat_id, -1)
                elseif blocks[2] == 'RaiseWarn' then
                    text = changeWarnSettings(chat_id, 1)
                elseif blocks[2] == 'ActionWarn' then
                    text = changeWarnSettings(chat_id, 'status')
                end
            elseif blocks[2] == 'Rtl' or blocks[2] == 'Arab' then
                text = changeCharSettings(chat_id, blocks[2])
            else
                text, show_alert = misc.changeSettingStatus(chat_id, blocks[2])
            end
            keyboard = doKeyboard_menu(chat_id)
            api.editMessageText(msg.chat.id, msg.message_id, menu_first, true, keyboard)
			if text then
				--workaround to avoid to send an error to users who are using an old inline keyboard
				api.answerCallbackQuery(msg.cb_id, '⚙ '..text, show_alert)
			end
        end
    end
end

plugin.triggers = {
    onCallbackQuery = {
        '^###cb:(menu):(alert):settings:([%w_]+):([%w_]+)$',
    	
    	'^###cb:(menu):(.*):',
    	
    	'^###cb:(config):menu:(-?%d+)$'
    }
}

return plugin
