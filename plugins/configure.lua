local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function cache_chat_title(chat_id, title)
    print('caching title...')
    local key = 'chat:'..chat_id..':title'
    db:set(key, title)
    db:expire(key, config.bot_settings.cache_time.chat_titles)
    
    return title
end

local function get_chat_title(chat_id)
    local cached_title = db:get('chat:'..chat_id..':title')
    if not cached_title then
        local chat_object = api.getChat(chat_id)
        if chat_object then
            return cache_chat_title(chat_id, chat_object.result.title)
        end
    else
        return cached_title 
    end
end

local function do_keyboard_config(chat_id, user_id, is_admin)
    local keyboard = {
        inline_keyboard = {
            {{text = ("🛠 Menu"), callback_data = 'config:menu:'..chat_id}},
            {{text = ("⚡️ Antiflood"), callback_data = 'config:antiflood:'..chat_id}},
            {{text = ("🌈 Media"), callback_data = 'config:media:'..chat_id}},
            {{text = ("🚫 Antispam"), callback_data = 'config:antispam:'..chat_id}},
            {{text = ("📥 Log channel"), callback_data = 'config:logchannel:'..chat_id}}
        }
    }
    
    local show_mod_button = db:hget('chat:'..chat_id..':modsettings', 'promdem') or config.chat_settings['modsettings']['promdem']
    if u.is_owner(chat_id, user_id) or (show_mod_button == 'yes' and is_admin) then
        table.insert(keyboard.inline_keyboard, {{text = ("👔 Moderators"), callback_data = 'config:mods:'..chat_id}})
    end
    
    return keyboard
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type ~= 'private' then
        if u.is_allowed('config', msg.chat.id, msg.from) then
            local chat_id = msg.chat.id
            local keyboard = do_keyboard_config(chat_id, msg.from.id)
            if not db:get('chat:'..chat_id..':title') then cache_chat_title(chat_id, msg.chat.title) end
            local res = api.sendMessage(msg.from.id, ("<b>%s</b>\n<i>Change the settings of your group</i>"):format(msg.chat.title:escape_html()), 'html', keyboard)
            if not u.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
                if res then
                    api.sendMessage(msg.chat.id, ("_I've sent you the keyboard via private message_"), true)
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
    local text = ("<i>Change the settings of your group</i>")
    local chat_title = get_chat_title(chat_id)
    if chat_title then
        text = ("<b>%s</b>\n"):format(chat_title:escape_html())..text
    end
    api.editMessageText(msg.chat.id, msg.message_id, text, 'html', keyboard)
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