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

pre_process = function(msg, ln)
    
    local msg_type = 'text'
    if msg.media then msg_type = msg.text:gsub('###', '') end
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
            if status == 'no' and not msg.cb then
                local action = db:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
                local name = msg.from.first_name
                if msg.from.username then name = name..' (@'..msg.from.username..')' end
                local is_normal_group = false
                local res, message
                --try to kick or ban
                if action == 'ban' then
                    if msg.chat.type == 'group' then is_normal_group = true end
        	        res = api.banUser(msg.chat.id, msg.from.id, is_normal_group, ln)
        	    else
        	        res = api.kickUser(msg.chat.id, msg.from.id, ln)
        	    end
        	    --if kicked/banned, send a message
        	    if res then
        	        cross.saveBan(msg.from.id, 'flood') --save ban
        	        if action == 'ban' then
        	            cross.addBanList(msg.chat.id, msg.from.id, name, lang[ln].preprocess.flood_motivation)
        	            message = make_text(lang[ln].preprocess.flood_ban, name:mEscape()) 
        	        else
        	            message = make_text(lang[ln].preprocess.flood_kick, name:mEscape())
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
        if is_mod(msg) then return msg end
        local name = msg.from.first_name
        if msg.from.username then name = name..' (@'..msg.from.username..')' end
        local media = msg.text:gsub('###', '')
        if msg.url then media = 'link' end
        local hash = 'chat:'..msg.chat.id..':media'
        local status = db:hget(hash, media)
        local out
        if not(status == 'allowed') then
            local max_reached_var, n, max = max_reached(msg.chat.id, msg.from.id)
    	    if max_reached_var then --max num reached. Kick/ban the user
    	        --try to kick/ban
    	        if status == 'kick' then
                    res = api.kickUser(msg.chat.id, msg.from.id, ln)
                elseif status == 'ban' then
                    if msg.chat.type == 'group' then is_normal_group = true end
                    res = api.banUser(msg.chat.id, msg.from.id, is_normal_group, ln)
    	        end
    	        if res then --kick worked
    	            cross.saveBan(msg.from.id, 'media') --save ban
    	            db:hdel('chat:'..msg.chat.id..':mediawarn', msg.from.id) --remove media warns
    	            local message
    	            if status == 'ban' then
    	                cross.addBanList(msg.chat.id, msg.from.id, name, lang[ln].preprocess.media_motivation)
    	                message = make_text(lang[ln].preprocess.media_ban, name:mEscape())..'\n`('..n..'/'..max..')`'
    	            else
    	                message = make_text(lang[ln].preprocess.media_kick, name:mEscape())..'\n`('..n..'/'..max..')`'
    	            end
    	            api.sendMessage(msg.chat.id, message, true)
    	        end
	        else --max num not reached -> warn
	            local message = lang[ln].preprocess.first_warn..'\n*('..n..'/'..max..')*'
	            api.sendReply(msg, message, true)
	        end
    	end
    end
    
    local rtl_status = (db:hget('chat:'..msg.chat.id..':char', 'Rtl')) or 'allowed'
    if rtl_status == 'kick' or rtl_status == 'ban' then
        local name = msg.from.first_name
        if msg.from.username then name = name..' (@'..msg.from.username..')' end
        local rtl = '‮'
        local last_name = 'x'
        if msg.from.last_name then last_name = msg.from.last_name end
        local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+') or last_name:find(rtl..'+')
        if check ~= nil then
            local res
            if rtl_status == 'kick' then
                res = api.kickUser(msg.chat.id, msg.from.id, ln)
            elseif status == 'ban' then
                res = api.banUser(msg.chat.id, msg.from.id, msg.normal_group, ln)
            end
    	    if res then
    	        cross.saveBan(msg.from.id, 'rtl') --save ban
    	        local message = make_text(lang[ln].preprocess.rtl_kicked, name:mEscape())
    	        if rtl_status == 'ban' then
    	            cross.addBanList(msg.chat.id, msg.from.id, name, 'Rtl')
    	            message = make_text(lang[ln].preprocess.rtl_banned, name:mEscape())
    	        end
    	        api.sendMessage(msg.chat.id, message, true)
    	    end
        end
    end
    
    if msg.text and msg.text:find('([\216-\219][\128-\191])') then
        local arab_status = (db:hget('chat:'..msg.chat.id..':char', 'Arab')) or 'allowed'
        if arab_status == 'kick' or arab_status == 'ban' then
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
    	    local res
    	    if arab_status == 'kick' then
    	        res = api.kickUser(msg.chat.id, msg.from.id, ln)
    	    elseif arab_status == 'ban' then
    	        res = api.banUser(msg.chat.id, msg.from.id, msg.normal_group, ln)
    	    end
    	    if res then
    	        cross.saveBan(msg.from.id, 'arab') --save ban
    	        local message = make_text(lang[ln].preprocess.arab_kicked, name:mEscape())
    	        if arab_status == 'ban' then
    	            cross.addBanList(msg.chat.id, msg.from.id, name, 'Arab')
    	            message = make_text(lang[ln].preprocess.arab_banned, name:mEscape())
    	        end
    	        api.sendMessage(msg.chat.id, message, true)
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