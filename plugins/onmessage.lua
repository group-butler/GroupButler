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

local function is_blocked(id)
	if db:sismember('bot:blocked', id) then
		return true
	else
		return false
	end
end

local pre_process = function(msg)
    
    local msg_type = 'text'
    if msg.media then msg_type = msg.media_type end
    if not is_ignored(msg.chat.id, msg_type) then
        local spamhash = 'spam:'..msg.chat.id..':'..msg.from.id
        local msgs = tonumber(db:get(spamhash)) or 0
        if msgs == 0 then msgs = 1 end
        local default_spam_value = 5
        if msg.chat.type == 'private' then default_spam_value = 12 end
        local max_msgs = tonumber(db:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or default_spam_value
        if msg.cb then max_msgs = 15 end
        local max_time = 5
        db:setex(spamhash, max_time, msgs+1)
        if msgs > max_msgs then
            local status = db:hget('chat:'..msg.chat.id..':settings', 'Flood') or 'yes'
            --how flood on/off works: yes->yes, antiflood is diabled. no->no, anti flood is not disbaled
            if status == 'on' and not msg.cb and not roles.is_admin_cached(msg) then --if the status is on, and the user is not an admin, and the message is not a callback, then:
                local action = db:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
                local name = misc.getname_link(msg.from.first_name, msg.from.username) or misc.getname_id(msg):mEscape()
                local res, message
                --try to kick or ban
                if action == 'ban' then
                    if msg.chat.type == 'group' then is_normal_group = true end
        	        res = api.banUser(msg.chat.id, msg.from.id, msg.normal_group)
        	    else
        	        res = api.kickUser(msg.chat.id, msg.from.id)
        	    end
        	    --if kicked/banned, send a message
        	    if res then
        	        misc.saveBan(msg.from.id, 'flood') --save ban
        	        if action == 'ban' then
        	            message = _("%s *banned* for flood!"):format(name)
        	        else
        	            message = _("%s *kicked* for flood!"):format(name)
        	        end
        	        if msgs == (max_msgs + 1) or msgs == max_msgs + 5 then --send the message only if it's the message after the first message flood. Repeat after 5
        	            api.sendMessage(msg.chat.id, message, true)
        	        end
        	    end
        	end
            
            if msg.cb then
                api.answerCallbackQuery(msg.cb_id, '‼️ Please don\'t abuse the keyboard, requests will be ignored')
            end
            return msg, true --if an user is spamming, don't go through plugins
        end
    end
    
    if msg.media and not(msg.chat.type == 'private') and not msg.cb then
        local media = msg.media_type
        local hash = 'chat:'..msg.chat.id..':media'
        local media_status = (db:hget(hash, media)) or 'ok'
        local out
        if not(media_status == 'ok') then
            if roles.is_admin_cached(msg) then return msg end --ignore admins
            local name = misc.getname_link(msg.from.first_name, msg.from.username) or misc.getname_id(msg):mEscape()
            local max_reached_var, n, max = max_reached(msg.chat.id, msg.from.id)
    	    if max_reached_var then --max num reached. Kick/ban the user
    	        local status = (db:hget('chat:'..msg.chat.id..':warnsettings', 'mediatype')) or config.chat_settings['warnsettings']['mediatype']
    	        --try to kick/ban
    	        if status == 'kick' then
                    res = api.kickUser(msg.chat.id, msg.from.id)
                elseif status == 'ban' then
                    if msg.chat.type == 'group' then is_normal_group = true end
                    res = api.banUser(msg.chat.id, msg.from.id, is_normal_group)
    	        end
    	        if res then --kick worked
    	            misc.saveBan(msg.from.id, 'media') --save ban
    	            db:hdel('chat:'..msg.chat.id..':mediawarn', msg.from.id) --remove media warns
    	            local message
    	            if status == 'ban' then
						message = _("%s *banned*: media sent not allowed!\n❗️ `%d` / `%d`"):format(name, n, max)
    	            else
						message = _("%s *kicked*: media sent not allowed!\n❗️ `%d` / `%d`"):format(name, n, max)
    	            end
    	            api.sendMessage(msg.chat.id, message, true)
    	        end
	        else --max num not reached -> warn
				local message = _("%s, this type of media is *not allowed* in this chat.\n(%d / %d)"):format(name, n, max)
	            api.sendReply(msg, message, true)
	        end
    	end
    end
    
    local rtl_status = (db:hget('chat:'..msg.chat.id..':char', 'Rtl')) or 'allowed'
    if rtl_status == 'kick' or rtl_status == 'ban' then
        local rtl = '‮'
        local last_name = 'x'
        if msg.from.last_name then last_name = msg.from.last_name end
        local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+') or last_name:find(rtl..'+')
        if check ~= nil and not roles.is_admin_cached(msg) then
            local name = misc.getname_link(msg.from.first_name, msg.from.username) or misc.getname_id(msg):mEscape()
            local res
            if rtl_status == 'kick' then
                res = api.kickUser(msg.chat.id, msg.from.id)
            elseif status == 'ban' then
                res = api.banUser(msg.chat.id, msg.from.id, msg.normal_group)
            end
    	    if res then
    	        misc.saveBan(msg.from.id, 'rtl') --save ban
    	        local message = _("%s *kicked*: RTL character in names / messages not allowed!"):format(name)
    	        if rtl_status == 'ban' then
					message = _("%s *banned*: RTL character in names / messages not allowed!"):format(name)
    	        end
    	        api.sendMessage(msg.chat.id, message, true)
    	    end
        end
    end
    
    if msg.text and msg.text:find('([\216-\219][\128-\191])') then
        local arab_status = (db:hget('chat:'..msg.chat.id..':char', 'Arab')) or 'allowed'
        if arab_status == 'kick' or arab_status == 'ban' then
    	    if not roles.is_admin_cached(msg) then
    	        local name = misc.getname_link(msg.from.first_name, msg.from.username) or misc.getname_id(msg):mEscape()
    	        local res
    	        if arab_status == 'kick' then
    	            res = api.kickUser(msg.chat.id, msg.from.id)
    	        elseif arab_status == 'ban' then
    	            res = api.banUser(msg.chat.id, msg.from.id, msg.normal_group)
    	        end
    	        if res then
    	            misc.saveBan(msg.from.id, 'arab') --save ban
    	            local message = _("%s *kicked*: arab message detected!"):format(name)
    	            if arab_status == 'ban' then
						message = _("%s *banned*: arab message detected!"):format(name)
    	            end
    	            api.sendMessage(msg.chat.id, message, true)
    	        end
            end
        end
    end
    
    if is_blocked(msg.from.id) then --ignore blocked users
        return msg, true --if an user is blocked, don't go through plugins
    end
    
    return msg
end

return {
    on_each_msg = pre_process
}
