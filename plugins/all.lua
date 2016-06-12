local included_fields = {
    'settings',
    'about',
    'rules',
    'mod',
    'extra'
}

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

local function doKeyboard_media(chat_id)
    local keyboard = {}
    keyboard.inline_keyboard = {}
    local list = {'image', 'audio', 'video', 'sticker', 'gif', 'voice', 'contact', 'file', 'link'}
    local media_sett = db:hgetall('chat:'..chat_id..':media')
    for media,status in pairs(media_sett) do
        if status == 'allowed' then
            status = '✅'
        else
            status = '🔐 '..status
        end
        local line = {
            {text = media, callback_data = 'menualert//'},
            {text = status, callback_data = 'media'..media..'//'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, line)
    end
    
    return keyboard
end

local function doKeyboard_dashboard(chat_id)
    local keyboard = {}
    keyboard.inline_keyboard = {
	    {
            {text = "Settings", callback_data = 'dashboardsettings//'..chat_id},
            {text = "Admins", callback_data = 'dashboardmodlist//'..chat_id}
		},
	    {
		    {text = "Rules", callback_data = 'dashboardrules//'..chat_id},
		    {text = "About", callback_data = 'dashboardabout//'..chat_id}
        },
	   	{
	   	    {text = "Welcome", callback_data = 'dashboardwelcome//'..chat_id},
	   	    {text = "Extra commands", callback_data = 'dashboardextra//'..chat_id}
	    }
    }
    
    return keyboard
end

local function doKeyboard_menu(chat_id)
    local keyboard = {}
    
    --settings
    local settings = db:hgetall('chat:'..chat_id..':settings')
    keyboard.inline_keyboard = {}
    for key,val in pairs(settings) do
        if val == 'yes' then val = '🚫' end
        if val == 'no' then val = '☑️' end
        local current = {
            {text = key:gsub('_', ' '), callback_data = 'menualert//'},
            {text = val, callback_data = 'menu'..key..'//'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, current)
    end
    
    --flood
    local hash = 'chat:'..chat_id..':flood'
    local action = db:hget(hash, 'ActionFlood')
    local num = db:hget(hash, 'MaxFlood')
    local flood = {
        {text = '➖', callback_data = 'menuDimFlood//'..chat_id},
        {text = '📍'..num..' ⚡️'..action, callback_data = 'menuActionFlood//'..chat_id},
        {text = '➕', callback_data = 'menuRaiseFlood//'..chat_id},
    }
    table.insert(keyboard.inline_keyboard, flood)
    
    --warn
    
    return keyboard
end

local action = function(msg, blocks, ln)
    --get the interested chat id
    local chat_id, msg_id
    if msg.cb then
        chat_id = msg.data:gsub('[%a _]+//', '')
        msg_id = msg.message_id
    else
        chat_id = msg.chat.id
    end
    
    local keyboard = {}
    
    if blocks[1] == 'dashboard' then
        if not(msg.chat.type == 'private') and not msg.cb then
            keyboard = doKeyboard_dashboard(chat_id)
            --everyone can use this
            api.sendMessage(msg.chat.id, lang[ln].all.dashboard, true)
	        api.sendKeyboard(msg.from.id, lang[ln].all.dashboard_first, keyboard, true)
	        return
        end
        if msg.cb then
            local text
            keyboard = doKeyboard_dashboard(chat_id)
            if blocks[2] == 'settings' then
                text = cross.getSettings(chat_id, ln)
            end
            if blocks[2] == 'rules' then
                text = cross.getRules(chat_id, ln)
            end
            if blocks[2] == 'about' then
                text = cross.getAbout(chat_id, ln)
            end
            if blocks[2] == 'modlist' then
                local creator, admins = cross.getModlist(chat_id)
                if not creator then
                    text = lang[ln].bonus.adminlist_admin_required --creator is false, admins is the error code
                else
                    text = make_text(lang[ln].mod.modlist, creator, admins)
                end
            end
            if blocks[2] == 'extra' then
                text = cross.getExtraList(chat_id, ln)
            end
            if blocks[2] == 'welcome' then
                text = getWelcomeMessage(chat_id, ln)
            end
            api.editMessageText(msg.chat.id, msg_id, text, keyboard, true)
            api.answerCallbackQuery(msg.cb_id, 'ℹ️ Group ► '..blocks[2])
            return
        end
    end
    if blocks[1] == 'menu' then
        if not(msg.chat.type == 'private') and not msg.cb then
            if not is_mod(msg) then return end --only mods can use this
            keyboard = doKeyboard_menu(chat_id)
            api.sendMessage(msg.chat.id, lang[ln].all.menu, true)
	        api.sendKeyboard(msg.from.id, lang[ln].all.menu_first, keyboard, true)
	        return
	    end
	    if msg.cb then
	        if blocks[2] == 'alert' then
                api.answerCallbackQuery(msg.cb_id, '⚠️ Tap on an icon!')
                return
            end
            --keyboard = doKeyboard(blocks[1], chat_id)
            if blocks[2] == 'DimFlood' or blocks[2] == 'RaiseFlood' or blocks[2] == 'ActionFlood' then
                local action
                if blocks[2] == 'DimFlood' then
                    action = -1
                elseif blocks[2] == 'RaiseFlood' then
                    action = 1
                elseif blocks[2] == 'ActionFlood' then
                    action = (db:hget('chat:'..chat_id..':flood', 'ActionFlood')) or 'kick'
                end
                text = cross.changeFloodSettings(chat_id, action, ln)
            else
                text = cross.changeSettingStatus(chat_id, blocks[2], ln)
            end
            keyboard = doKeyboard_menu(chat_id)
            api.editMessageText(msg.chat.id, msg_id, lang[ln].all.menu_first, keyboard, true)
            api.answerCallbackQuery(msg.cb_id, '⚙ '..text:mEscape_hard())
        end
    end
    if blocks[1] == 'media' then
        if not(msg.chat.type == 'private') and not msg.cb then
            if not is_mod(msg) then return end --only mods can use this
            keyboard = doKeyboard_media(chat_id)
            api.sendMessage(msg.chat.id, lang[ln].bonus.general_pm, true)
	        api.sendKeyboard(msg.from.id, lang[ln].all.media_first, keyboard, true)
	        return
	    end
	    if msg.cb then
	        local media = blocks[2]
	        local text = cross.changeMediaStatus(chat_id, media, 'next', ln)
            keyboard = doKeyboard_media(chat_id)
            api.editMessageText(msg.chat.id, msg_id, lang[ln].all.media_first, keyboard, true)
            api.answerCallbackQuery(msg.cb_id, '⚡️ '..text:mEscape_hard())
        end
    end
end

return {
	action = action,
	triggers = {
		'^/(dashboard)$',
		'^/(menu)$',
		'^/(media)$',
		
		'^###cb:(dashboard)(settings)//',
    	'^###cb:(dashboard)(rules)//',
	    '^###cb:(dashboard)(about)//',
	    '^###cb:(dashboard)(modlist)//',
	    '^###cb:(dashboard)(extra)//',
	    '^###cb:(dashboard)(welcome)//',
    	
    	'^###cb:(menu)(alert)//',
    	'^###cb:(menu)(Rules)//',
    	'^###cb:(menu)(About)//',
    	'^###cb:(menu)(Modlist)//',
    	'^###cb:(menu)(Rtl)//',
    	'^###cb:(menu)(Arab)//',
    	'^###cb:(menu)(Report)//',
    	'^###cb:(menu)(Welcome)//',
    	'^###cb:(menu)(Extra)//',
    	'^###cb:(menu)(Admin_mode)//',
    	'^###cb:(menu)(Flood)//',
    	'^###cb:(menu)(DimFlood)//',
    	'^###cb:(menu)(RaiseFlood)//',
    	'^###cb:(menu)(ActionFlood)//',
    	
    	'^###cb:(media)(image)//',
    	'^###cb:(media)(audio)//',
    	'^###cb:(media)(video)//',
    	'^###cb:(media)(voice)//',
    	'^###cb:(media)(sticker)//',
    	'^###cb:(media)(contact)//',
    	'^###cb:(media)(file)//',
    	'^###cb:(media)(gif)//',
    	'^###cb:(media)(link)//',
	}
}