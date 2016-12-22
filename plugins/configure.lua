local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function do_keyboard_config(chat_id, user_id, is_admin)
    local keyboard = {
        inline_keyboard = {
            {{text = _("🛠 Menu"), callback_data = 'config:menu:'..chat_id}},
            {{text = _("⚡️ Antiflood"), callback_data = 'config:antiflood:'..chat_id}},
            {{text = _("🌈 Media"), callback_data = 'config:media:'..chat_id}},
            {{text = _("🚫 Antispam"), callback_data = 'config:antispam:'..chat_id}},
            {{text = _("📥 Log channel"), callback_data = 'config:logchannel:'..chat_id}}
        }
    }
    
    local show_mod_button = db:hget('chat:'..chat_id..':modsettings', 'promdem') or config.chat_settings['modsettings']['promdem']
    if u.is_owner(chat_id, user_id) or (show_mod_button == 'yes' and is_admin) then
        table.insert(keyboard.inline_keyboard, {{text = _("👔 Moderators"), callback_data = 'config:mods:'..chat_id}})
    end
    
    return keyboard
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type ~= 'private' then
        if u.is_allowed('config', msg.chat.id, msg.from) then
            local chat_id = msg.chat.id
            local keyboard = do_keyboard_config(chat_id, msg.from.id)
            local res = api.sendMessage(msg.from.id, _("_Manage your group_"), true, keyboard)
            if not u.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
                if res then
                    api.sendMessage(msg.chat.id, _("_I've sent you the keyboard via private message_"), true)
                else
                    u.sendStartMe(msg)
                end
            end
        end
    end
end

function plugin.onCallbackQuery(msg, blocks)
    local chat_id = msg.target_id
    local keyboard = do_keyboard_config(chat_id, msg.from.id, msg.from.admin)
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