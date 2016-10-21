local plugin = {}

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

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type ~= 'private' then
        if roles.is_admin_cached(msg) then
            local chat_id = msg.chat.id
            local keyboard = do_keyboard_config(chat_id)
            local res = api.sendMessage(msg.from.id, _("_Change the settings by navigating the keyboard_"), true, keyboard)
            if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
                if res then
                    api.sendMessage(msg.chat.id, _("_I've sent you the keyboard via private message_"), true)
                else
                    misc.sendStartMe(msg)
                end
            end
        end
    end
end

function plugin.onCallbackQuery(msg, blocks)
    local chat_id = msg.target_id
    local keyboard = do_keyboard_config(chat_id)
    api.editMessageText(msg.chat.id, msg.message_id, _("_Change the settings by navigating the keyboard_"), true, keyboard)
end

plugin.triggers = {
    onTextMessage = {
        config.cmd..'config$',
        config.cmd..'settings$',
    },
    onCallbackQuery = {
        '^###cb:config:back:'
    }
}

return plugin