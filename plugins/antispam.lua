local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function is_whitelisted(chat_id, text)
    local set = ('chat:%d:whitelist'):format(chat_id)
    local links = db:smembers(set)
    if links and next(links) then
        for i=1, #links do
            if text:find(links[i]:lower():gsub('%-', '%%-')) then
                return true
            end
        end
    end
end

local function is_whitelisted_channel(chat_id, channel_id)
    local set = ('chat:%d:chanwhitelist'):format(chat_id)
    return db:sismember(set, channel_id)
end

local function getAntispamWarns(chat_id, user_id)
    local max_allowed = (db:hget('chat:'..chat_id..':antispam', 'warns')) or config.chat_settings['antispam']['warns']
    max_allowed = tonumber(max_allowed)
    local warns_received = (db:hincrby('chat:'..chat_id..':spamwarns', user_id, 1))
    warns_received = tonumber(warns_received)
    
    return warns_received, max_allowed
end

function plugin.onEveryMessage(msg)
    if not msg.inline and msg.spam and msg.chat.id < 0 and not msg.cb then
        local status = db:hget('chat:'..msg.chat.id..':antispam', msg.spam)
        if status and status == 'notalwd' then
            if not msg.from.mod then
                local whitelisted
                if msg.spam == 'links' then
                    whitelisted = is_whitelisted(msg.chat.id, msg.text:lower())
                [[elseif msg.forward_from_chat then 
                    if msg.forward_from_chat.type == 'channel' then
                        whitelisted = is_whitelisted_channel(msg.chat.id, msg.forward_from_chat.id)
                    end]]
                end
                
                if not whitelisted then
                    local hammer_text = nil
                    local name = u.getname_final(msg.from)
                    local warns_received, max_allowed = getAntispamWarns(msg.chat.id, msg.from.id)
                    
                    if warns_received >= max_allowed then
                        local action = (db:hget('chat:'..msg.chat.id..':antispam', 'action')) or config.chat_settings['antispam']['action']
                        
                        local hammer_funct
                        if action == 'ban' then
                            hammer_funct = api.banUser
                        elseif action == 'kick' then
                            hammer_funct = api.kickUser
                        end
                        local res = hammer_funct(msg.chat.id, msg.from.id)
                        if res then
                            hammer_text = action
                            db:hdel('chat:'..msg.chat.id..':spamwarns', msg.from.id) --remove media warns
                            api.sendMessage(msg.chat.id, ('%s %s for <b>spam</b>! (%d/%d)'):format(name, hammer_text, warns_received, max_allowed), 'html')
                        end
                    else
                        api.sendReply(msg, ('%s, this kind of spam is not allowed in this chat (<b>%d/%d</b>)'):format(name, warns_received, max_allowed), 'html')
                    end
                    local name_pretty = {links = ("telegram.me link"), forwards = ("message from a channel")}
                    u.logEvent('spamwarn', msg, {hammered = hammer_text, warns = warns_received, warnmax = max_allowed, spam_type = name_pretty[msg.spam]})
                end
            end
        end
    end
    
    if msg.edited then return false end
    return true
end

local function toggleAntispamSetting(chat_id, key)
    local hash = 'chat:'..chat_id..':antispam'
    local current = (db:hget(hash, key)) or config.chat_settings['antispam'][key]
    local new
    if current == 'alwd' then new = 'notalwd' else new = 'alwd' end
    
    db:hset(hash, key, new)
    
    
    local text = ('allowed')
    if new == 'notalwd' then text = ('not allowed') end
    return (key)..(': %s'):format(text)
end

local function changeWarnsNumber(chat_id, action)
    local hash = 'chat:'..chat_id..':antispam'
    local key = 'warns'
    local current = (db:hget(hash, key)) or config.chat_settings['antispam'][key]
    current = tonumber(current)
    if current < 1 then
        current = 1
        db:hset(hash, key, 1)
    end
    
    if current == 1 and action == 'dim' then
        return ("You can't go lower")
    elseif current == 7 and action == 'raise' then
        return ("You can't go higher")
    else
        local new
        if action == 'dim' then
            new = db:hincrby(hash, key, -1)
        elseif action == 'raise' then
            new = db:hincrby(hash, key, 1)
        end
        return ("New value: %d"):format(new)
    end
end

local function changeAction(chat_id)
    local hash = 'chat:'..chat_id..':antispam'
    local key = 'action'
    local current = (db:hget(hash, key)) or config.chat_settings['antispam'][key]
    
    local new_action = 'ban'
    if current == 'ban' then new_action = 'kick' end
    
    db:hset(hash, key, new_action)
    
    return '✅'
end

local function get_alert_text(key)
    if key == 'links' then
        return ("Allow/forbid telegram.me links")
    elseif key == 'forwards' then
        return ("Allow/forbid forwarded messages from channels")
    elseif key == 'warns' then
        return ("Set how many times the bot should warn the user before kick/ban him")
    else
        return ("Description not available")
    end
end

local function doKeyboard_antispam(chat_id)
    local keyboard = {inline_keyboard = {}}
    local humanizations = {
        ['links'] = ('telegram.me links'),
        ['forwards'] = ('Channels messages')
    }
    for field, value in pairs(config.chat_settings['antispam']) do
        if field == 'links' or field == 'forwards' then
            local icon = '✅'
            local status = (db:hget('chat:'..chat_id..':antispam', field)) or config.chat_settings['antispam'][field]
            if status == 'notalwd' then icon = '❌' end
            local line = {
                {text = (humanizations[field] or field), callback_data = 'antispam:alert:'..field..':'..locale.language},
                {text = icon, callback_data = 'antispam:toggle:'..field..':'..chat_id}
            }
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    
    local warns = (db:hget('chat:'..chat_id..':antispam', 'warns')) or config.chat_settings['antispam']['warns']
    local action = (db:hget('chat:'..chat_id..':antispam', 'action')) or config.chat_settings['antispam']['action']

		if action == 'kick' then
			kick = ("Kick 👞")
		else
			kick = ("Ban 🔨")
		end
    
    local line = {
        {text = 'Warns: '..warns, callback_data = 'antispam:alert:warns:'..locale.language},
        {text = '➖', callback_data = 'antispam:toggle:dim:'..chat_id},
        {text = '➕', callback_data = 'antispam:toggle:raise:'..chat_id},
        {text = (action), callback_data = 'antispam:toggle:action:'..chat_id}
    }
    
    table.insert(keyboard.inline_keyboard, line)
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

local function get_url(text, entity)
    return text:sub(entity.offset + 1, entity.offset + entity.length)
end

local function urls_table(entities, text)
    local links = {}
    for _, entity in pairs(entities) do
        if entity.type == 'url' then
            local url = get_url(text, entity):gsub(' ', ''):gsub('https?://', ''):gsub('www.', '')
            table.insert(links, url)
        end
    end
    
    return links
end

function plugin.onCallbackQuery(msg, blocks)
    
	if blocks[1] == 'alert' then
		if config.available_languages[blocks[3]] then
			locale.language = blocks[3]
		end
	    local text = get_alert_text(blocks[2])
	    api.answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
	else
	    
	    local chat_id = msg.target_id
	    if not u.is_allowed('config', chat_id, msg.from) then
	    	api.answerCallbackQuery(msg.cb_id, ("You're no longer an admin"))
	    else
	        local antispam_first = ([[*Anti-spam settings*
Choose which kind of spam you want to forbid
• ✅ = *Allowed*
• ❌ = *Not allowed*
]])
        
            local keyboard, text
            
            if blocks[1] == 'toggle' then
                if blocks[2] == 'forwards' or blocks[2] == 'links' then
                    text = toggleAntispamSetting(chat_id, blocks[2])
                else
                    if blocks[2] == 'raise' or blocks[2] == 'dim' then
                        text = changeWarnsNumber(chat_id, blocks[2])
                    elseif blocks[2] == 'action' then
                        text = changeAction(chat_id, blocks[2])
                    end
                end
            end
            
            keyboard = doKeyboard_antispam(chat_id)
            api.editMessageText(msg.chat.id, msg.message_id, antispam_first, true, keyboard)
            if text then api.answerCallbackQuery(msg.cb_id, text) end
        end
    end
end

local function edit_channels_whitelist(chat_id, list, action)
    
    local channels = {valid = {}, not_valid ={}}
    local for_entered
    local set = ('chat:%d:chanwhitelist'):format(chat_id)
    local res
    for channel_id in list:gmatch('-%d+') do
        if action == 'add' then
            res = db:sadd(set, channel_id)
        elseif action == 'rem' then
            res = db:srem(set, channel_id)
        end
        
        if res == 1 then
            table.insert(channels.valid, channel_id)
        elseif res == 0 then
            table.insert(channels.not_valid, channel_id)
        end
        
        for_entered = true
    end
    
    return for_entered, channels
end

function plugin.onTextMessage(msg, blocks)
    if u.is_allowed('texts', msg.chat.id, msg.from) then
        if (blocks[1] == 'wl' or blocks[1] == 'whitelist') and blocks[2] then
            if blocks[2] == '-' then
                local set = ('chat:%d:whitelist'):format(msg.chat.id)
                local n = db:scard(set) or 0
                local text
                if n == 0 then
                    text = ("_The whitelist was already empty_")
                else
                    db:del(set)
                    text = ("*Whitelist cleaned*\n%d links have been removed"):format(n)
                end
                api.sendReply(msg, text, true)
            else
                local text
                if msg.entities then
                    local links = urls_table(msg.entities, msg.text)
                    if not next(links) then
                        text = ("_I can't find any url in this message_")
                    else
                        local new = db:sadd(('chat:%d:whitelist'):format(msg.chat.id), table.unpack(links))
                        text = ("%d link(s) will be whitelisted"):format(#links - (#links - new))
                        if new ~= #links then
                            text = text..("\n%d links were already in the list"):format(#links - new)
                        end
                    end
                else
                    text = ("_I can't find any url in this message_")
                end
                api.sendReply(msg, text, true)
            end
        end
        if (blocks[1] == 'wl' or blocks[1] == 'whitelist') and not blocks[2] then
            local links = db:smembers(('chat:%d:whitelist'):format(msg.chat.id))
            if not next(links) then
                api.sendReply(msg, ("_The whitelist is empty_.\nUse `/wl [links]` to add some links to the whitelist"), true)
            else
                local text = ("Whitelisted links:\n\n")
                for i=1, #links do
                    text = text..'• '..links[i]..'\n'
                end
                api.sendReply(msg, text)
            end
        end
        if blocks[1] == 'unwl' or blocks[1] == 'unwhitelist' then
            local text
            if msg.entities then
                local links = urls_table(msg.entities, msg.text)
                if not next(links) then
                    text = ("_I can't find any url in this message_")
                else
                    local removed = db:srem(('chat:%d:whitelist'):format(msg.chat.id), table.unpack(links))
                    text = ("%d link(s) removed from the whitelist"):format(removed)
                    if removed ~= #links then
                        text = text..("\n%d links were already in the list"):format(#links - removed)
                    end
                end
            else
                text = ("_I can't find any url in this message_")
            end
            api.sendReply(msg, text, true)
        end
        if blocks[1] == 'funwl' then --force the unwhitelist of a link
            db:srem(('chat:%d:whitelist'):format(msg.chat.id), blocks[2])
            api.sendReply(msg, 'Done')
        end
        if blocks[1] == 'wlchan' and not blocks[2] then
            local channels = db:smembers(('chat:%d:chanwhitelist'):format(msg.chat.id))
            if not next(channels) then
                api.sendReply(msg, ("_Whitelist of channels empty_"), true)
            else
                api.sendReply(msg, ("*Whitelisted channels:*\n%s"):format(table.concat(channels, '\n')), true)
            end
        end
        if blocks[1] == 'wlchan' and blocks[2] then
            local for_entered, channels = edit_channels_whitelist(msg.chat.id, blocks[2], 'add')
            
            if not for_entered then
                api.sendReply(msg, ("_I can't find a channel ID in your message_"), true)
            else
                local text = ''
                if next(channels.valid) then
                    text = text..("*Channels whitelisted*: `%s`\n"):format(table.concat(channels.valid, ', '))
                end
                if next(channels.not_valid) then
                    text = text..("*Channels already whitelisted*: `%s`\n"):format(table.concat(channels.not_valid, ', '))
                end
                
                api.sendReply(msg, text, true)
            end
        end
        if blocks[1] == 'unwlchan' then
            local for_entered, channels = edit_channels_whitelist(msg.chat.id, blocks[2], 'rem')
            
            if not for_entered then
                api.sendReply(msg, ("_I can't find a channel ID in your message_"), true)
            else
                local text = ''
                if next(channels.valid) then
                    text = text..("*Channels unwhitelisted*: `%s`\n"):format(table.concat(channels.valid, ', '))
                end
                if next(channels.not_valid) then
                    text = text..("*Channels not whitelisted*: `%s`\n"):format(table.concat(channels.not_valid, ', '))
                end
                
                api.sendReply(msg, text, true)
            end
        end
    end
end

plugin.triggers = {
    onCallbackQuery = {
        '^###cb:antispam:(toggle):(%w+):(-?%d+)$',
        '^###cb:antispam:(alert):(%w+):([%w_]+)$',
        '^###cb:(config):antispam:(-?%d+)$'
    },
    onTextMessage = {
        config.cmd..'(wl) (.+)$',
        config.cmd..'(whitelist) (.+)$',
        --config.cmd..'(wlchan) (.+)$',
        config.cmd..'(unwl) (.+)$',
        config.cmd..'(unwhitelist) (.+)$',
        --config.cmd..'(unwlchan) (.+)$',
        config.cmd..'(wl)$',
        config.cmd..'(whitelist)$',
        --config.cmd..'(wlchan)$',
        config.cmd..'(funwl) (.+)'
    }
}

return plugin
