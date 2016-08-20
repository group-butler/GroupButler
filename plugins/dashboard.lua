local function getWelcomeMessage(chat_id, ln)
    hash = 'chat:'..chat_id..':welcome'
    local type = db:hget(hash, 'type')
    local message = ''
    if type == 'no' then
    	message = message..lang[ln].settings.resume.w_default
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
            {text = lang[ln].all.dashboard.admins, callback_data = 'dashboard:adminlist:'..chat_id}
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

local function get_group_name(text)
    local name = text:match('.*%((.+)%)$')
    if not name then
        return ''
    end
    name = '\n('..name..')'
    return name:mEscape()
end

local action = function(msg, blocks)
    
    --get the interested chat id
    local chat_id = msg.target_id or msg.chat.id
    
    local keyboard = {}
    
    if not(msg.chat.type == 'private') and not msg.cb then
        keyboard = doKeyboard_dashboard(chat_id, msg.ln)
        --everyone can use this
        local res = api.sendKeyboard(msg.from.id, lang[msg.ln].all.dashboard.first, keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                api.sendMessage(msg.chat.id, lang[msg.ln].all.dashboard.private, true)
            else
                misc.sendStartMe(msg, msg.ln)
            end
        end
	    return
    end
    if msg.cb then
        local request = blocks[2]
        local text
        keyboard = doKeyboard_dashboard(chat_id, msg.ln)
        if request == 'settings' then
            text = misc.getSettings(chat_id, msg.ln)
        end
        if request == 'rules' then
            text = misc.getRules(chat_id, msg.ln)
        end
        if request == 'about' then
            text = misc.getAbout(chat_id, msg.ln)
        end
        if request == 'adminlist' then
            local creator, admins = misc.getAdminlist(chat_id)
            if not creator then
                text = lang[msg.ln].bonus.adminlist_admin_required --creator is false, admins is the error code
            else
                text = make_text(lang[msg.ln].mod.modlist, creator, admins)
            end
        end
        if request == 'extra' then
            text = misc.getExtraList(chat_id, msg.ln)
        end
        if request == 'welcome' then
            text = getWelcomeMessage(chat_id, msg.ln)
        end
        if request == 'flood' then
            text = getFloodSettings_text(chat_id, msg.ln)
        end
        if request == 'media' then
            text = lang[msg.ln].mediasettings.settings_header
            for media, default_status in pairs(config.chat_settings['media']) do
                local status = (db:hget('chat:'..chat_id..':media', media)) or default_status
                if status == 'ok' then
                    status = '✅'
                else
                    status = '🔐 '
                end
                text = text..'`'..media..'` ≡ '..status..'\n'
            end
        end
        api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
        api.answerCallbackQuery(msg.cb_id, 'ℹ️ Group ► '..request)
        return
    end
end

return {
	action = action,
	triggers = {
		config.cmd..'(dashboard)$',
		'^###cb:(dashboard):(%a+):(-%d+)',
	}
}