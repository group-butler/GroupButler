local function disable_set(field, msg, ln)
    local hash = 'chat:'..msg.chat.id..':settings'
    local field_lower = field:lower()
    print(already, locked)
    local now = client:hget(hash, field)
    if now == 'yes' then
        api.sendReply(msg, make_text(lang[ln].settings.disable[field_lower..'_already']), true)
    else
        client:hset(hash, field, 'yes')
        api.sendReply(msg, make_text(lang[ln].settings.disable[field_lower..'_locked']), true)
    end
end

local function enable_set(field, msg, ln)
    local hash = 'chat:'..msg.chat.id..':settings'
    local field_lower = field:lower()
    print(field_lower)
    local now = client:hget(hash, field)
    if now == 'no' then
        api.sendReply(msg, make_text(lang[ln].settings.enable[field_lower..'_already']), true)
    else
        client:hset(hash, field, 'no')
        api.sendReply(msg, make_text(lang[ln].settings.enable[field_lower..'_unlocked']), true)
    end
end

local action = function(msg, blocks, ln)

--ignore if via pm
if msg.chat.type == 'private' then
    api.sendMessage(msg.from.id, make_text(lang[ln].pv))
    return nil
end

if blocks[1] == 'disable' then
        
        --ignore if via pm
        if msg.chat.type == 'private' then
            api.sendMessage(msg.from.id, make_text(lang[ln].pv))
    	    return nil
        end
        
        --ignore if not mod
        if not is_mod(msg) then
            api.sendReply(msg, make_text(lang[ln].not_mod), true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            api.sendReply(msg, make_text(lang[ln].settings.disable.no_input), false)
            return nil
        end
        
        local hash = 'chat:'..msg.chat.id..':settings'
        local now
        
        --check the command to lock
        if input == 'rules' then
            mystat('/disable rules') --save stats
            disable_set('Rules', msg, ln)  
        elseif input == 'about' then
            mystat('/disable about') --save stats
            disable_set('About', msg, ln)
        elseif input == 'welcome' then
            mystat('/disable welcome') --save stats
            disable_set('Welcome', msg, ln)
        elseif input == 'modlist' then
            mystat('/disable modlist') --save stats
            disable_set('Modlist', msg, ln)
        elseif input == 'extra' then
            mystat('/disable extra') --save stats
            disable_set('Extra', msg, ln)
        elseif input == 'rtl' then
            mystat('/disable rtl') --save stats
            disable_set('Rtl', msg, ln)
        elseif input == 'arab' then
            mystat('/disable arab') --save stats
            disable_set('Arab', msg, ln)
        elseif input == 'report' then
            mystat('/disable report') --save stats
            disable_set('Report', msg, ln)
        else
            api.sendReply(msg, make_text(lang[ln].settings.disable.wrong_input), true)
        end
        
end

if blocks[1] == 'enable' then
        --ignore if not mod
        if not is_mod(msg) then
            api.sendReply(msg, make_text(lang[ln].not_mod), true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            api.sendReply(msg, make_text(lang[ln].settings.enable.no_input), false)
            return nil
        end
        
        local hash = 'chat:'..msg.chat.id..':settings'
        local now
        
        --check the command to enable
        if input == 'rules' then
            mystat('/enable rules') --save stats
            enable_set('Rules', msg, ln)
        elseif input == 'about' then
            mystat('/enable about') --save stats
            enable_set('About', msg, ln)
        elseif input == 'welcome' then
            mystat('/enable welcome') --save stats
            enable_set('Welcome', msg, ln)
        elseif input == 'modlist' then
            mystat('/enable modlist') --save stats
            enable_set('Modlist', msg, ln)
        elseif input == 'extra' then
            mystat('/enable extra') --save stats
            enable_set('Extra', msg, ln)
        elseif input == 'rtl' then
            mystat('/enable rtl') --save stats
            enable_set('Rtl', msg, ln)
        elseif input == 'arab' then
            mystat('/enable arab') --save stats
            enable_set('Arab', msg, ln)
        elseif input == 'report' then
            mystat('/enable report') --save stats
            enable_set('Report', msg, ln)
        else
            api.sendReply(msg, make_text(lang[ln].settings.enable.wrong_input), true)
        end
        
    end
    
if blocks[1] == 'welcome' then
        --ignore if not mod
        if not is_mod(msg) then
            api.sendReply(msg, make_text(lang[ln].not_mod), true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            api.sendReply(msg, make_text(lang[ln].settings.welcome.no_input), false)
            return nil
        end
        
        local hash = 'chat:'..msg.chat.id..':welcome'
        local key = 'wel'
        
        --change welcome settings
        if input == 'a' then
            client:hset(hash, key, 'a')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.a), true)
        elseif input == 'r' then
            client:hset(hash, key, 'r')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.r), true)
        elseif input == 'm' then
            client:hset(hash, key, 'm')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.m), true)
        elseif input == 'ar' or input == 'ra' then
            client:hset(hash, key, 'ra')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.ra), true)
        elseif input == 'mr' or input == 'rm' then
            client:hset(hash, key, 'rm')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.rm), true)
        elseif input == 'am' or input == 'ma' then
            client:hset(hash, key, 'am')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.am), true)
        elseif input == 'ram' or input == 'rma' or input == 'arm' or input == 'amr' or input == 'mra' or input == 'mar' then
            client:hset(hash, key, 'ram')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.ram), true)
        elseif input == 'no' then
            client:hset(hash, key, 'no')
            api.sendReply(msg, make_text(lang[ln].settings.welcome.no), true)
        else 
            api.sendReply(msg, make_text(lang[ln].settings.welcome.wrong_input), true)
        end
        
        mystat('/welcome') --save stats
    end

if blocks[1] == 'settings' then
        --ignore if is not mod
        if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
        
        --get settings from redis
        local hash = 'chat:'..msg.chat.id..':settings'
        local settings_key = client:hkeys(hash)
        local settings_val = client:hvals(hash)
        local key
        local val
        
        message = make_text(lang[ln].settings.resume.header, msg.chat.title, ln)
        
        --build the message
        for i=1, #settings_key do
            key = settings_key[i]
            val = settings_val[i]
            
            local text
            if val == 'yes' then
                text = make_text(lang[ln].settings[key])..': 🔒\n'
            else
                text = '*'..make_text(lang[ln].settings[key])..'*: 🔓\n'
            end
            message = message..text --concatenete the text
            if key == 'Flood' then
                local max_msgs = client:hget('chat:'..msg.chat.id..':flood', 'MaxFlood') or 5
                local action = client:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
                message = message..make_text(lang[ln].settings.resume.flood_info, max_msgs, action)
            end
        end
        
        --build the "welcome" line
        hash = 'chat:'..msg.chat.id..':welcome'
        local wel = client:hget(hash, 'wel')
        if wel == 'a' then
            message = message..make_text(lang[ln].settings.resume.w_a)
        elseif wel == 'r' then
            message = message..make_text(lang[ln].settings.resume.w_r)
        elseif wel == 'm' then
            message = message..make_text(lang[ln].settings.resume.w_m)
        elseif wel == 'ra' then
            message = message..make_text(lang[ln].settings.resume.w_ra)
        elseif wel == 'rm' then
            message = message..make_text(lang[ln].settings.resume.w_rm)
        elseif wel == 'am' then
            message = message..make_text(lang[ln].settings.resume.w_am)
        elseif wel == 'ram' then
            message = message..make_text(lang[ln].settings.resume.w_ram)
        elseif wel == 'no' then
            message = message..make_text(lang[ln].settings.resume.w_no)
        end
        
        mystat('/settings') --save stats
        api.sendReply(msg, message, true)
    end

end

return {
	action = action,
	triggers = {
    	'^/(disable) (.*)$',
    	'^/(enable) (.*)$',
    	'^/(settings)$',
    	'^/(welcome)'
    }
}