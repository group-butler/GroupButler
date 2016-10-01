local function do_keyboard_config(chat_id)
    local keyboard = {
        inline_keyboard = {
            {{text = _("🛠 Menu"), callback_data = 'config:menu:'..chat_id}},
            {{text = _("⚡️ Antiflood"), callback_data = 'config:antiflood:'..chat_id}},
            {{text = _("🌈 Media"), callback_data = 'config:media:'..chat_id}},
        }
    }
    
    return keyboard
end
    

local function action(msg, blocks)
    if msg.chat.type == 'private' and not msg.cb then return end
    local chat_id = msg.target_id or msg.chat.id
    local keyboard = do_keyboard_config(chat_id)
    if msg.cb then
        chat_id = msg.target_id
        api.editMessageText(msg.chat.id, msg.message_id, _("_Change the settings by navigating the keyboard_"), keyboard, true)
    else
        if not roles.is_admin_cached(msg) then return end
        local res = api.sendKeyboard(msg.from.id, _("_Change the settings by navigating the keyboard_"), keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                api.sendMessage(msg.chat.id, _("_I've sent you the keyboard via private message_"), true)
            else
                misc.sendStartMe(msg, msg.ln)
            end
        end
    end
end

return {
    action = action,
    triggers = {
        config.cmd..'config$',
        config.cmd..'settings$',
        '^###cb:config:back:'
    }
}
