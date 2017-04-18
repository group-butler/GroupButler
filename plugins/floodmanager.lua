local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function get_button_description(key)
    if key == 'num' then
        return ("⚖ Current sensitivity. Tap on the + or the - to change it")
    elseif key == 'voice' then
        return ([[Choose which media must be ignored by the antiflood (the bot won't consider them).
✅: ignored
❌: not ignored]])
    else
        return ("Description not available")
    end
end

local function do_keyboard_flood(chat_id)
    --no: enabled, yes: disabled
    local status = db:hget('chat:'..chat_id..':settings', 'Flood') or config.chat_settings['settings']['Flood'] --check (default: disabled)
    if status == 'on' then
        status = ("✅ | ON")
    else
        status = ("❌ | OFF")
    end

    local hash = 'chat:'..chat_id..':flood'
    local action = (db:hget(hash, 'ActionFlood')) or config.chat_settings['flood']['ActionFlood']
    if action == 'kick' then
        action = ("👞️ kick")
    else
        action = ("🔨 ️ban")
    end
    local num = (db:hget(hash, 'MaxFlood')) or config.chat_settings['flood']['MaxFlood']
    local keyboard = {
        inline_keyboard = {
            {
                {text = status, callback_data = 'flood:status:'..chat_id},
                {text = action, callback_data = 'flood:action:'..chat_id},
            },
            {
                {text = '➖', callback_data = 'flood:dim:'..chat_id},
                {text = tostring(num), callback_data = 'flood:alert:num:'..locale.language},
                {text = '➕', callback_data = 'flood:raise:'..chat_id},
            }
        }
    }

    local exceptions = {
        text = ("Texts"),
		forward = ("Forwards"),
        sticker = ("Stickers"),
        photo = ("Images"),
        gif = ("GIFs"),
        video = ("Videos"),
    }
    local hash = 'chat:'..chat_id..':floodexceptions'
    for media, translation in pairs(exceptions) do
        --ignored by the antiflood-> yes, no
        local exc_status = db:hget(hash, media) or config.chat_settings['floodexceptions'][media]
        if exc_status == 'yes' then
            exc_status = '✅'
        else
            exc_status = '❌'
        end
        local line = {
            {text = translation, callback_data = 'flood:alert:voice:'..locale.language},
            {text = exc_status, callback_data = 'flood:exc:'..media..':'..chat_id},
        }
        table.insert(keyboard.inline_keyboard, line)
    end

    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})

    return keyboard
end

local function changeFloodSettings(chat_id, screm)
    local hash = 'chat:'..chat_id..':flood'
    if type(screm) == 'string' then
        if screm == 'kick' then
            db:hset(hash, 'ActionFlood', 'ban')
            return ("Flooders will be banned")
        else
            db:hset(hash, 'ActionFlood', 'kick')
            return ("Flooders will be kicked")
        end
    elseif type(screm) == 'number' then
        local old = tonumber(db:hget(hash, 'MaxFlood')) or 5
        local new
        if screm > 0 then
            new = db:hincrby(hash, 'MaxFlood', 1)
            if new > 25 then
                db:hincrby(hash, 'MaxFlood', -1)
                return ("%d is not a valid value!\n"):format(new)
                    .. ("The value should be higher than 3 and lower then 26")
            end
        elseif screm < 0 then
            new = db:hincrby(hash, 'MaxFlood', -1)
            if new < 3 then
                db:hincrby(hash, 'MaxFlood', 1)
                return ("%d is not a valid value!\n"):format(new)
                    .. ("The value should be higher than 2 and lower then 26")
            end
        end
        return string.format('%d → %d', old, new)
    end
end

function plugin.onCallbackQuery(msg, blocks)
    local chat_id = msg.target_id
	if chat_id and not u.is_allowed('config', chat_id, msg.from) then
		api.answerCallbackQuery(msg.cb_id, ("You're no longer an admin"))
	else
	    local header = ("You can manage the antiflood settings from here")

        local text

        if blocks[1] == 'config' then
            text = ("Antiflood settings")
        end

        if blocks[1] == 'alert' then
			if config.available_languages[blocks[3]] then
				locale.language = blocks[3]
			end
            text = get_button_description(blocks[2])
            api.answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
			return
        end

        if blocks[1] == 'exc' then
            local media = blocks[2]
            local hash = 'chat:'..chat_id..':floodexceptions'
            local status = (db:hget(hash, media)) or 'no'
            if status == 'no' then
                db:hset(hash, media, 'yes')
                text = ("❎ [%s] will be ignored by the anti-flood"):format(media)
            else
                db:hset(hash, media, 'no')
                text = ("🚫 [%s] won't be ignored by the anti-flood"):format(media)
            end
        end

        local action
        if blocks[1] == 'action' or blocks[1] == 'dim' or blocks[1] == 'raise' then
            if blocks[1] == 'action' then
                action = db:hget('chat:'..chat_id..':flood', 'ActionFlood') or 'kick'
            elseif blocks[1] == 'dim' then
                action = -1
            elseif blocks[1] == 'raise' then
                action = 1
            end
            text = changeFloodSettings(chat_id, action)
        end

        if blocks[1] == 'status' then
            text = u.changeSettingStatus(chat_id, 'Flood')
        end

        local keyboard = do_keyboard_flood(chat_id)
        api.editMessageText(msg.chat.id, msg.message_id, header, true, keyboard)
        api.answerCallbackQuery(msg.cb_id, text)
    end
end

plugin.triggers = {
    onCallbackQuery = {
        '^###cb:flood:(alert):([%w_]+):([%w_]+)$',
        '^###cb:flood:(status):(-?%d+)$',
        '^###cb:flood:(action):(-?%d+)$',
        '^###cb:flood:(dim):(-?%d+)$',
        '^###cb:flood:(raise):(-?%d+)$',
        '^###cb:flood:(exc):(%a+):(-?%d+)$',

        '^###cb:(config):antiflood:'
    }
}

return plugin
