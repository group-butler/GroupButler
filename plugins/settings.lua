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
            now = client:hget(hash, 'Rules')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.rules_already), true)
            else
                client:hset(hash, 'Rules', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.rules_locked), true)
            end
            
        elseif input == 'about' then
            mystat('/disable about') --save stats
            now = client:hget(hash, 'About')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.about_already), true)
            else
                client:hset(hash, 'About', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.about_locked), true)
            end
        
        elseif input == 'welcome' then
            mystat('/disable welcome') --save stats
            now = client:hget(hash, 'Welcome')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.welcome_already), true)
            else
                client:hset(hash, 'Welcome', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.welcome_locked), true)
            end
        
        elseif input == 'modlist' then
            mystat('/disable modlist') --save stats
            now = client:hget(hash, 'Modlist')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.modlist_already), true)
            else
                client:hset(hash, 'Modlist', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.modlist_locked), true)
            end
        
        elseif input == 'flag' then
            mystat('/disable flag') --save stats
            now = client:hget(hash, 'Flag')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.flag_already), true)
            else
                client:hset(hash, 'Flag', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.flag_locked), true)
            end
            
        elseif input == 'extra' then
            mystat('/disable extra') --save stats
            now = client:hget(hash, 'Extra')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.extra_already), true)
            else
                client:hset(hash, 'Extra', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.extra_locked), true)
            end
        elseif input == 'rtl' then
            mystat('/disable rtl') --save stats
            now = client:hget(hash, 'Rtl')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.rtl_already), true)
            else
                client:hset(hash, 'Rtl', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.rtl_locked), true)
            end
        elseif input == 'arab' then
            mystat('/disable arab') --save stats
            now = client:hget(hash, 'Arab')
            if now == 'yes' then
                api.sendReply(msg, make_text(lang[ln].settings.disable.rtl_already), true)
            else
                client:hset(hash, 'Arab', 'yes')
                api.sendReply(msg, make_text(lang[ln].settings.disable.rtl_locked), true)
            end
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
            now = client:hget(hash, 'Rules')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.rules_already), true)
            else
                client:hset(hash, 'Rules', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.rules_unlocked), true)
            end
            
        elseif input == 'about' then
            mystat('/enable about') --save stats
            now = client:hget(hash, 'About')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enableabout._already), true)
            else
                client:hset(hash, 'About', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.about_unlocked), true)
            end
        
        elseif input == 'welcome' then
            mystat('/enable welcome') --save stats
            now = client:hget(hash, 'Welcome')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.welcome_already), true)
            else
                client:hset(hash, 'Welcome', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.welcome_unlocked), true)
            end
        
        elseif input == 'modlist' then
            mystat('/enable modlist') --save stats
            now = client:hget(hash, 'Modlist')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.modlist_already), true)
            else
                client:hset(hash, 'Modlist', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.modlist_unlocked), true)
            end
        
        elseif input == 'flag' then
            mystat('/enable flag') --save stats
            now = client:hget(hash, 'Flag')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.flag_already), true)
            else
                client:hset(hash, 'Flag', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.flag_unlocked), true)
            end
            
        elseif input == 'extra' then
            mystat('/enable extra') --save stats
            now = client:hget(hash, 'Extra')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.extra_already), true)
            else
                client:hset(hash, 'Extra', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.extra_unlocked), true)
            end
        elseif input == 'rtl' then
            mystat('/enable rtl') --save stats
            now = client:hget(hash, 'Rtl')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.rtl_already), true)
            else
                client:hset(hash, 'Rtl', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.rtl_unlocked), true)
            end
        elseif input == 'arab' then
            mystat('/enable arab') --save stats
            now = client:hget(hash, 'Arab')
            if now == 'no' then
                api.sendReply(msg, make_text(lang[ln].settings.enable.arab_already), true)
            else
                client:hset(hash, 'Arab', 'no')
                api.sendReply(msg, make_text(lang[ln].settings.enable.arab_unlocked), true)
            end
            
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