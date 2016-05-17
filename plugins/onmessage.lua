local function user_neverWarned(chat, user)
    local hash = 'chat:'..chat..':'..user..':mediawarn'
    local res = db:get(hash)
    if res then return false else return true end
end

local function saveFirstWarn(chat, user, media, ln)
    local hash = 'chat:'..chat..':'..user..':mediawarn'
    db:set(hash, true)
    local status = db:hget('chat:'..chat..':media', media) --get the current status, to say in the reply if the next time the user will be kicked or banned
    return make_text(lang[ln].preprocess.first_warn, status)
end

pre_process = function(msg, ln)
    if msg.from.id and is_blocked(msg.from.id) then
        print('Blocked:', msg.from.id)
        return msg, true --if an user is blocked, don't go through plugins
    end
    if msg.cb then
        return msg
    end
    if msg.chat.type ~= 'private' and not is_mod(msg) then
        local spamhash = 'spam:'..msg.chat.id..':'..msg.from.id
        local msgs = tonumber(db:get(spamhash)) or 0
        if msgs == 0 then msgs = 1 end
        local max_msgs = tonumber(db:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
        local max_time = 5
        if msgs > max_msgs then
            local status = db:hget('chat:'..msg.chat.id..':settings', 'Flood') or 'yes'
            --how flood on/off works: yes->yes, antiflood is diabled. no->no, anti flood is not disbaled
            if status == 'no' then
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
    		        if action == 'ban' then message = make_text(lang[ln].preprocess.flood_ban, name:mEscape()) else message = make_text(lang[ln].preprocess.flood_kick, name:mEscape()) end
    		        api.sendMessage(msg.chat.id, message)
    		    end
    		end
            return msg, true --if an user is spamming, don't go through plugins
        end

        db:setex(spamhash, max_time, msgs+1)
    
        if msg.media then
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
            local media = msg.text:gsub('###', '')
            local hash = 'chat:'..msg.chat.id..':media'
            local status = db:hget(hash, media)
            local out
            if user_neverWarned(msg.chat.id, msg.from.id) and status and not(status == 'allowed') then
                local message = saveFirstWarn(msg.chat.id, msg.from.id, media, ln)
                api.sendReply(msg, message, true)
            elseif not user_neverWarned(msg.chat.id, msg.from.id) and status and not(status == 'allowed') then
                local is_normal_group = false
                local res
                if status == 'kick' then
                    res = api.kickUser(msg.chat.id, msg.from.id, ln)
    	        elseif status == 'ban' then
    	            if msg.chat.type == 'group' then is_normal_group = true end
    	            res = api.banUser(msg.chat.id, msg.from.id, is_normal_group, ln)
    		    end
    		    if res then
    		        local message
    		        if status == 'ban' then message = make_text(lang[ln].preprocess.media_ban, name:mEscape()) else message = make_text(lang[ln].preprocess.media_kick, name:mEscape()) end
    		        api.sendMessage(msg.chat.id, message, true)
    		    end
    		end
        end
    
        if db:hget('chat:'..msg.chat.id..':settings', 'Rtl') == 'yes' then --no = not disabled
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
            local rtl = '‮'
    	    local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+')
    	    if check ~= nil then
    		    local res = api.kickUser(msg.chat.id, msg.from.id, ln)
    		    if res then
    		        api.sendMessage(msg.chat.id, make_text(lang[ln].preprocess.rtl, name:mEscape()), true)
    		    end
    	    end
        end
    
        if msg.text and msg.text:find('([\216-\219][\128-\191])') and db:hget('chat:'..msg.chat.id..':settings', 'Arab') == 'yes' then
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
    		local res = api.kickUser(msg.chat.id, msg.from.id, ln)
    		vardump(res)
    		if res then
    		    api.sendMessage(msg.chat.id, make_text(lang[ln].preprocess.arab, name:mEscape()), true)
    		end
        end
    end
    
    return msg
end

return {
    on_each_msg = pre_process
    }