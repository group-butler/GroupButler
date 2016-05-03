local function user_neverWarned(chat, user)
    local hash = 'chat:'..chat..':'..user..':mediawarn'
    local res = client:get(hash)
    if res then return false else return true end
end

local function saveFirstWarn(chat, user, media, ln)
    local hash = 'chat:'..chat..':'..user..':mediawarn'
    client:set(hash, true)
    local status = client:hget('chat:'..chat..':media', media)
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
        local msgs = tonumber(client:get(spamhash)) or 0
        if msgs == 0 then msgs = 1 end
        local max_msgs = tonumber(client:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
        local max_time = 5
        if msgs > max_msgs then
            local status = client:hget('chat:'..msg.chat.id..':settings', 'Flood') or 'yes'
            --how flood on/off works: yes->yes, antiflood is diabled. no->no, anti flood is not disbaled
            if status == 'no' then
                local action = client:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
                local name = msg.from.first_name
                if msg.from.username then name = name..' (@'..msg.from.username..')' end
                name = name.. ' (flood)'
                if action == 'ban' then
    		        api.banUser(msg, false, true)
    		    else
    		        api.kickUser(msg, false, true)
    		    end
    		end
            return msg, true --if an user is spamming, don't go through plugins
        end

        client:setex(spamhash, max_time, msgs+1)
    
        if msg.media then
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
            local media = msg.text:gsub('###', '')
            local hash = 'chat:'..msg.chat.id..':media'
            local status = client:hget(hash, media)
            local out
            if user_neverWarned(msg.chat.id, msg.from.id) and status and not(status == 'allowed') then
                local message = saveFirstWarn(msg.chat.id, msg.from.id, media, ln)
                api.sendReply(msg, message, true)
            elseif not user_neverWarned(msg.chat.id, msg.from.id) and status and not(status == 'allowed') then
                if status == 'kick' then
                    api.kickUser(msg, false, true)
    	        elseif status == 'ban' then
    	            api.banUser(msg, false, true)
    		    end
    		end
        end
    
        if client:hget('chat:'..msg.chat.id..':settings', 'Rtl') == 'yes' then --no = not disabled
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
            local rtl = '‮'
    	    local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+')
    	    if check ~= nil then
    		    name = name.. ' (RTL char)'
    		    api.kickUser(msg, false, true)
    	    end
        end
    
        if msg.text and msg.text:find('([\216-\219][\128-\191])') and client:hget('chat:'..msg.chat.id..':settings', 'Arab') == 'yes' then
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
    		name = name.. ' (arab)'
    		api.kickUser(msg, false, true)
        end
    end
    
    return msg
end

return {
    on_each_msg = pre_process
    }