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

local function max_reached(chat_id, user_id)
    local max = tonumber(db:get('chat:'..chat_id..':mediamax')) or 2
    local n = tonumber(db:hincrby('chat:'..chat_id..':mediawarn', user_id, 1))
    if n >= max then
        return true, n, max
    else
        return false, n, max
    end
end

pre_process = function(msg, ln)
    
    --[[if msg.cb then --ignore callbacks
        return msg
    end]]
    
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
    
    if msg.media and not(msg.chat.type == 'private') then
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
    	            db:hdel('chat:'..msg.chat.id..':mediawarn', msg.from.id)
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
    
    if db:hget('chat:'..msg.chat.id..':settings', 'Rtl') == 'yes' then --no = not disabled
        local name = msg.from.first_name
        if msg.from.username then name = name..' (@'..msg.from.username..')' end
        local rtl = '‮'
        local last_name = 'x'
        if msg.from.last_name then last_name = msg.from.last_name end
        local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+') or last_name:find(rtl..'+')
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
    	if res then
    	    api.sendMessage(msg.chat.id, make_text(lang[ln].preprocess.arab, name:mEscape()), true)
    	end
    end
    
    if is_blocked(msg.from.id) then --ignore blocked users
        print('Blocked:', msg.from.id)
        return msg, true --if an user is blocked, don't go through plugins
    end
    
    return msg
end

return {
    on_each_msg = pre_process
    }