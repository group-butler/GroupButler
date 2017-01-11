local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function max_reached(chat_id, user_id)
    local max = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or 2
    local n = tonumber(db:hincrby('chat:'..chat_id..':mediawarn', user_id, 1))
    if n >= max then
        return true, n, max
    else
        return false, n, max
    end
end

local function is_ignored(chat_id, msg_type)
    local hash = 'chat:'..chat_id..':floodexceptions'
    local status = (db:hget(hash, msg_type)) or 'no'
    if status == 'yes' then
        return true
    elseif status == 'no' then
        return false
    end
end

local function is_flooding_funct(msg)
    local spamhash = 'spam:'..msg.chat.id..':'..msg.from.id
    
    local msgs = tonumber(db:get(spamhash)) or 1
    
    local max_msgs = tonumber(db:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
    if msg.cb then max_msgs = 15 end
    
    local max_time = 5
    db:setex(spamhash, max_time, msgs+1)
    
    if msgs > max_msgs then
        return true, msgs, max_msgs
    else
        return false
    end
end

local function is_blocked(id)
	if db:sismember('bot:blocked', id) then
		return true
	else
		return false
	end
end

local function is_whitelisted(chat_id, text)
    local set = ('chat:%d:whitelist'):format(chat_id)
    local links = db:smembers(set)
    if links and next(links) then
        for i=1, #links do
            if text:match(links[i]:gsub('%-', '%%-')) then
                --print('Whitelist:', links[i])
                return true
            end
        end
    end
end

function plugin.onEveryMessage(msg)
    
    if not msg.inline then
    
    local msg_type = 'text'
	if msg.forward_from or msg.forward_from_chat then msg_type = 'forward' end
	if msg.media_type then msg_type = msg.media_type end
	if not is_ignored(msg.chat.id, msg_type) and not msg.edited then
        local is_flooding, msgs_sent, msgs_max = is_flooding_funct(msg)
        if is_flooding then
            local status = (db:hget('chat:'..msg.chat.id..':settings', 'Flood')) or config.chat_settings['settings']['Flood']
            if status == 'on' and not msg.cb and not msg.from.mod then --if the status is on, and the user is not an admin, and the message is not a callback, then:
                local action = db:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
                local name = u.getname_final(msg.from)
                local res, message
                --try to kick or ban
                if action == 'ban' then
        	        res = api.banUser(msg.chat.id, msg.from.id)
        	    else
        	        res = api.kickUser(msg.chat.id, msg.from.id)
        	    end
        	    --if kicked/banned, send a message
        	    if res then
        	        local log_hammered = action
        	        if msgs_sent == (msgs_max + 1) then --send the message only if it's the message after the first message flood. Repeat after 5
        	            if action == 'ban' then
        	                message = _("%s <b>banned</b> for flood!"):format(name)
        	            else
        	                message = _("%s <b>kicked</b> for flood!"):format(name)
        	            end
        	            api.sendMessage(msg.chat.id, message, 'html')
        	            u.logEvent('flood', msg, {hammered = log_hammered})
        	        end
        	    end
        	end
            
            if msg.cb then
                --api.answerCallbackQuery(msg.cb_id, _("‼️ Please don't abuse the keyboard, requests will be ignored")) --avoid to hit the limits with answerCallbackQuery
            end
            return false --if an user is spamming, don't go through plugins
        end
    end
    
    if msg.media and msg.chat.type ~= 'private' and not msg.cb and not msg.edited then
        local media = msg.media_type
        local hash = 'chat:'..msg.chat.id..':media'
        local media_status = (db:hget(hash, media)) or 'ok'
        local out
        if media_status ~= 'ok' then
            if not msg.from.mod then --ignore mods and above
                local whitelisted
                if media == 'link' then
                    whitelisted = is_whitelisted(msg.chat.id, msg.text)
                end
                
                if not whitelisted then
                    local status
                    local name = u.getname_final(msg.from)
                    local max_reached_var, n, max = max_reached(msg.chat.id, msg.from.id)
    	            if max_reached_var then --max num reached. Kick/ban the user
    	                status = (db:hget('chat:'..msg.chat.id..':warnsettings', 'mediatype')) or config.chat_settings['warnsettings']['mediatype']
    	                --try to kick/ban
    	                if status == 'kick' then
                            res = api.kickUser(msg.chat.id, msg.from.id)
                        elseif status == 'ban' then
                            res = api.banUser(msg.chat.id, msg.from.id)
    	                end
    	                if res then --kick worked
    	                    db:hdel('chat:'..msg.chat.id..':mediawarn', msg.from.id) --remove media warns
    	                    local message
    	                    if status == 'ban' then
			        			message = _("%s <b>banned</b>: media sent not allowed!\n❗️ <code>%d/%d</code>"):format(name, n, max)
    	                    else
			        			message = _("%s <b>kicked</b>: media sent not allowed!\n❗️ <code>%d/%d</code>"):format(name, n, max)
    	                    end
    	                    api.sendMessage(msg.chat.id, message, 'html')
    	                end
	                else --max num not reached -> warn
			        	local message = _("%s, this type of media is <b>not allowed</b> in this chat.\n(<code>%d/%d</code>)"):format(name, n, max)
	                    api.sendReply(msg, message, 'html')
	                end
	                u.logEvent('mediawarn', msg, {warns = n, warnmax = max, media = _(media), hammered = status})
                end
    	    end
    	end
    end
    
    local rtl_status = (db:hget('chat:'..msg.chat.id..':char', 'Rtl')) or 'allowed'
    if rtl_status == 'kick' or rtl_status == 'ban' then
        local rtl = '‮'
        local last_name = 'x'
        if msg.from.last_name then last_name = msg.from.last_name end
        local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+') or last_name:find(rtl..'+')
        if check ~= nil and not msg.from.mod then
            local name = u.getname_final(msg.from)
            local res
            if rtl_status == 'kick' then
                res = api.kickUser(msg.chat.id, msg.from.id)
            elseif status == 'ban' then
                res = api.banUser(msg.chat.id, msg.from.id)
            end
    	    if res then
    	        local message = _("%s <b>kicked</b>: RTL character in names / messages not allowed!"):format(name)
    	        if rtl_status == 'ban' then
					message = _("%s <b>banned</b>: RTL character in names / messages not allowed!"):format(name)
    	        end
    	        api.sendMessage(msg.chat.id, message, 'html')
				return false -- not execute command already kicked out and not welcome him
    	    end
        end
    end
    
    if msg.text and msg.text:find('([\216-\219][\128-\191])') then
        local arab_status = (db:hget('chat:'..msg.chat.id..':char', 'Arab')) or 'allowed'
        if arab_status == 'kick' or arab_status == 'ban' then
    	    if not msg.from.mod then
    	        local name = u.getname_final(msg.from)
    	        local res
    	        if arab_status == 'kick' then
    	            res = api.kickUser(msg.chat.id, msg.from.id)
    	        elseif arab_status == 'ban' then
    	            res = api.banUser(msg.chat.id, msg.from.id)
    	        end
    	        if res then
    	            local message = _("%s <b>kicked</b>: arab/persian message detected!"):format(name)
    	            if arab_status == 'ban' then
						message = _("%s <b>banned</b>: arab/persian message detected!"):format(name)
    	            end
    	            api.sendMessage(msg.chat.id, message, 'html')
					return false
    	        end
            end
        end
    end
    
    end --if not msg.inline then [if statement closed]
    
    if is_blocked(msg.from.id) then --ignore blocked users
        return false --if an user is blocked, don't go through plugins
    end
    
    --don't return false for edited messages: the antispam need to process them
    
    return true
end

return plugin
