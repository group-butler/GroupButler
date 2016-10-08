local function getFloodSettings_text(chat_id)
    local status = db:hget('chat:'..chat_id..':settings', 'Flood') or 'yes' --check (default: disabled)
    if status == 'no' then
        status = _("✅ | ON")
    elseif status == 'yes' then
        status = _("❌ | OFF")
    end
    local hash = 'chat:'..chat_id..':flood'
    local action = (db:hget(hash, 'ActionFlood')) or 'kick'
    if action == 'kick' then
        action = _("⚡️ kick")
    else
        action = _("⛔ ️ban")
    end
    local num = (db:hget(hash, 'MaxFlood')) or 5
    local exceptions = {
        text = _("Texts"),
        sticker = _("Stickers"),
        image = _("Images"),
        gif = _("GIFs"),
        video = _("Videos"),
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
    return _("- *Status*: `%s`\n"):format(status)
			.. _("- *Action* to perform when an user floods: `%s`\n"):format(action)
			.. _("- Number of messages allowed *every 5 seconds*: `%d`\n"):format(num)
			.. _("- *Ignored media*:\n%s"):format(list_exc)
end

local function doKeyboard_dashboard(chat_id)
    local keyboard = {}
    keyboard.inline_keyboard = {
	    {
            {text = _("Settings"), callback_data = 'dashboard:settings:'..chat_id},
            {text = _("Admins"), callback_data = 'dashboard:adminlist:'..chat_id}
		},
	    {
		    {text = _("Rules"), callback_data = 'dashboard:rules:'..chat_id},
		    {text = _("Extra commands"), callback_data = 'dashboard:extra:'..chat_id}
        },
	    {
	   	    {text = _("Flood settings"), callback_data = 'dashboard:flood:'..chat_id},
	   	    {text = _("Media settings"), callback_data = 'dashboard:media:'..chat_id}
	    },
    }
    
    return keyboard
end

local action = function(msg, blocks)
    
	       if msg.chat.type == 'private' then
    	if blocks[1] == 'start' then
     msg.chat.id = tonumber(blocks[2])
    local chat_id = msg.target_id or msg.chat.id
    local hash = 'chat:'..msg.chat.id..':info'
    if blocks[1] == 'dashboard' or blocks[1] == 'start' then
         keyboard = doKeyboard_dashboard(chat_id)
    	if msg.chat.type == 'private' or (not roles.is_admin_cached(msg) and not send_in_group(msg.chat.id)) then
   	api.sendKeyboard(msg.from.id, _("Navigate this message to see *all the info* about this group!"), keyboard, true)
    	else
        	api.sendKeyboard(msg.from.id, _("Navigate this message to see *all the info* about this group!"), keyboard, true)
        end
     end 
  end
end
	
    --get the interested chat id
    local chat_id = msg.target_id or msg.chat.id
    
    local keyboard = {}
    
    if not(msg.chat.type == 'private') and not msg.cb then
        keyboard = doKeyboard_dashboard(chat_id)
        --everyone can use this
        local res = api.sendKeyboard(msg.from.id, _("Navigate this message to see *all the info* about this group!"), keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                api.sendKeyboard(msg.chat.id, _("_I've sent you the group dashboard via private message_"), true)
            else
                misc.sendStartMe(msg)
            end
        end
	    return
    end
    if msg.cb then
        local request = blocks[2]
        local text, notification

		local res = api.getChat(chat_id)
		if not res then
			api.answerCallbackQuery(msg.cb_id, _("🚫 This group was deleted"))
			return
		end
		-- Private chats have no an username
		local private = not res.result.username

		local res = api.getChatMember(chat_id, msg.from.id)
		if not res or (res.result.status == 'left' or res.result.status == 'kicked') and private then
			api.editMessageText(msg.from.id, msg.message_id, _("🚷 You aren't member chat. " ..
				"You can't watch settings of the private group."))
			return
		end

        keyboard = doKeyboard_dashboard(chat_id)
        if request == 'settings' then
            text = misc.getSettings(chat_id)
            notification = _("ℹ️ Group ► Settings")
        end
        if request == 'rules' then
            text = misc.getRules(chat_id)
            notification = _("ℹ️ Group ► Rules")
        end
        if request == 'adminlist' then
            local creator, admins = misc.getAdminlist(chat_id)
            if not creator then
                -- creator is false, admins is the error code
                text = _("I got kicked out of this group 😓")
            else
                text = _("*Creator*:\n%s\n\n*Admins*:\n%s"):format(creator, admins)
            end
            notification = _("ℹ️ Group ► Admin list")
        end
        if request == 'extra' then
            text = misc.getExtraList(chat_id)
            notification = _("ℹ️ Group ► Extra")
        end
        if request == 'flood' then
            text = getFloodSettings_text(chat_id)
            notification = _("ℹ️ Group ► Flood")
        end
        if request == 'media' then
            text = _("*Current media settings*:\n\n")
            for media, default_status in pairs(config.chat_settings['media']) do
                local status = (db:hget('chat:'..chat_id..':media', media)) or default_status
                if status == 'ok' then
                    status = '✅'
                else
                    status = '🔐 '
                end
                text = text..'`'..media..'` ≡ '..status..'\n'
            end
            notification = _("ℹ️ Group ► Media")
        end
        api.editMessageText(msg.from.id, msg.message_id, text, keyboard, true)
        api.answerCallbackQuery(msg.cb_id, notification)
        return
    end
end

return {
	action = action,
	triggers = {
		config.cmd..'(dashboard)$',
		'^###cb:(dashboard):(%a+):(-%d+)',
		'^/(start) (-?%d+):dashboard$'
	}
}
