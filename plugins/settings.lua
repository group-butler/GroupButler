local triggers = {
	'^/(disable) (.*)$',
	'^/(enable) (.*)$',
	'^/(settings)$',
	'^/(welcome)'
}


local action = function(msg, blocks, ln)

--ignore if via pm
        if msg.chat.type == 'private' then
            print('PV settings.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
            sendMessage(msg.from.id, make_text(lang[ln].pv))
    	    return nil
        end

if blocks[1] == 'disable' then
        
        --ignore if via pm
        if msg.chat.type == 'private' then
            print('PV settings.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
            sendMessage(msg.from.id, make_text(lang[ln].pv))
    	    return nil
        end
        
        --ignore if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            sendReply(msg, make_text(lang[ln].not_mod), true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            print('\27[31mNil: no text\27[39m')
            sendReply(msg, make_text(lang[ln].settings.disable.no_input), false)
            return nil
        end
        
        local hash = 'chat:'..msg.chat.id..':settings'
        local now
        
        --check the command to lock
        if input == 'rules' then
            mystat('disablerules') --save stats
            now = client:hget(hash, 'Rules')
            if now == 'yes' then
                sendReply(msg, make_text(lang[ln].settings.disable.rules_already), true)
            else
                client:hset(hash, 'Rules', 'yes')
                sendReply(msg, make_text(lang[ln].settings.disable.rules_locked), true)
            end
            
        elseif input == 'about' then
            mystat('disableabout') --save stats
            now = client:hget(hash, 'About')
            if now == 'yes' then
                sendReply(msg, make_text(lang[ln].settings.disable.about_already), true)
            else
                client:hset(hash, 'About', 'yes')
                sendReply(msg, make_text(lang[ln].settings.disable.about_locked), true)
            end
        
        elseif input == 'welcome' then
            mystat('disablewelcome') --save stats
            now = client:hget(hash, 'Welcome')
            if now == 'yes' then
                sendReply(msg, make_text(lang[ln].settings.disable.welcome_already), true)
            else
                client:hset(hash, 'Welcome', 'yes')
                sendReply(msg, make_text(lang[ln].settings.disable.welcome_locked), true)
            end
        
        elseif input == 'modlist' then
            mystat('disablemodlist') --save stats
            now = client:hget(hash, 'Modlist')
            if now == 'yes' then
                sendReply(msg, make_text(lang[ln].settings.disable.modlist_already), true)
            else
                client:hset(hash, 'Modlist', 'yes')
                sendReply(msg, make_text(lang[ln].settings.disable.modlist_locked), true)
            end
        
        elseif input == 'flag' then
            mystat('disableflag') --save stats
            now = client:hget(hash, 'Flag')
            if now == 'yes' then
                sendReply(msg, make_text(lang[ln].settings.disable.flag_already), true)
            else
                client:hset(hash, 'Flag', 'yes')
                sendReply(msg, make_text(lang[ln].settings.disable.flag_locked), true)
            end
            
        elseif input == 'extra' then
            mystat('disableextras') --save stats
            now = client:hget(hash, 'Extra')
            if now == 'yes' then
                sendReply(msg, make_text(lang[ln].settings.disable.extra_already), true)
            else
                client:hset(hash, 'Extra', 'yes')
                sendReply(msg, make_text(lang[ln].settings.disable.extra_locked), true)
            end
        else
            print('\27[31mNil: argument not available\27[39m')
            sendReply(msg, make_text(lang[ln].settings.disable.wrong_input), true)
        end
        
end

if blocks[1] == 'enable' then
        
        print('\n/enable', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            sendReply(msg, make_text(lang[ln].not_mod), true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            print('\27[31mNil: no input text\27[39m')
            sendReply(msg, make_text(lang[ln].settings.enable.no_input), false)
            return nil
        end
        
        local hash = 'chat:'..msg.chat.id..':settings'
        local now
        
        --check the command to enable
        if input == 'rules' then
            mystat('enablerules') --save stats
            now = client:hget(hash, 'Rules')
            if now == 'no' then
                sendReply(msg, make_text(lang[ln].settings.enable.rules_already), true)
            else
                client:hset(hash, 'Rules', 'no')
                sendReply(msg, make_text(lang[ln].settings.enable.rules_unlocked), true)
            end
            
        elseif input == 'about' then
            mystat('enableabout') --save stats
            now = client:hget(hash, 'About')
            if now == 'no' then
                sendReply(msg, make_text(lang[ln].settings.enableabout._already), true)
            else
                client:hset(hash, 'About', 'no')
                sendReply(msg, make_text(lang[ln].settings.enable.about_unlocked), true)
            end
        
        elseif input == 'welcome' then
            mystat('enablewelcome') --save stats
            now = client:hget(hash, 'Welcome')
            if now == 'no' then
                sendReply(msg, make_text(lang[ln].settings.enable.welcome_already), true)
            else
                client:hset(hash, 'Welcome', 'no')
                sendReply(msg, make_text(lang[ln].settings.enable.welcome_unlocked), true)
            end
        
        elseif input == 'modlist' then
            mystat('enablemodlist') --save stats
            now = client:hget(hash, 'Modlist')
            if now == 'no' then
                sendReply(msg, make_text(lang[ln].settings.enable.modlist_already), true)
            else
                client:hset(hash, 'Modlist', 'no')
                sendReply(msg, make_text(lang[ln].settings.enable.modlist_unlocked), true)
            end
        
        elseif input == 'flag' then
            mystat('enableflag') --save stats
            now = client:hget(hash, 'Flag')
            if now == 'no' then
                sendReply(msg, make_text(lang[ln].settings.enable.flag_already), true)
            else
                client:hset(hash, 'Flag', 'no')
                sendReply(msg, make_text(lang[ln].settings.enable.flag_unlocked), true)
            end
            
        elseif input == 'extra' then
            mystat('enableextra') --save stats
            now = client:hget(hash, 'Extra')
            if now == 'no' then
                sendReply(msg, make_text(lang[ln].settings.enable.extra_already), true)
            else
                client:hset(hash, 'Extra', 'no')
                sendReply(msg, make_text(lang[ln].settings.enable.extra_unlocked), true)
            end
            
        else
            print('\27[31mNil: argument not available\27[39m')
            sendReply(msg, make_text(lang[ln].settings.enable.wrong_input), true)
        end
        
    end
    
if blocks[1] == 'welcome' then
        
        print('\n/welcome', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            sendReply(msg, make_text(lang[ln].not_mod), true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            print('\27[31mNil: no input text\27[39m')
            sendReply(msg, make_text(lang[ln].settings.welcome.no_input), false)
            return nil
        end
        
        local hash = 'chat:'..msg.chat.id..':welcome'
        local key = 'wel'
        
        --change welcome settings
        if input == 'a' then
            client:hset(hash, key, 'a')
            sendReply(msg, make_text(lang[ln].settings.welcome.a), true)
        elseif input == 'r' then
            client:hset(hash, key, 'r')
            sendReply(msg, make_text(lang[ln].settings.welcome.r), true)
        elseif input == 'm' then
            client:hset(hash, key, 'm')
            sendReply(msg, make_text(lang[ln].settings.welcome.m), true)
        elseif input == 'ar' or input == 'ra' then
            client:hset(hash, key, 'ra')
            sendReply(msg, make_text(lang[ln].settings.welcome.ra), true)
        elseif input == 'mr' or input == 'rm' then
            client:hset(hash, key, 'rm')
            sendReply(msg, make_text(lang[ln].settings.welcome.rm), true)
        elseif input == 'am' or input == 'ma' then
            client:hset(hash, key, 'am')
            sendReply(msg, make_text(lang[ln].settings.welcome.am), true)
        elseif input == 'ram' or input == 'rma' or input == 'arm' or input == 'amr' or input == 'mra' or input == 'mar' then
            client:hset(hash, key, 'ram')
            sendReply(msg, make_text(lang[ln].settings.welcome.ram), true)
        elseif input == 'no' then
            client:hset(hash, key, 'no')
            sendReply(msg, make_text(lang[ln].settings.welcome.no), true)
        else sendReply(msg, make_text(lang[ln].settings.welcome.wrong_input), true)
        end
        
        mystat('welcome') --save stats
    end

if blocks[1] == 'settings' then
        
        print('\n/settings', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if is not mod
        if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, make_text(lang[ln].not_mod), true)
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
            message = message..text
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
        
        mystat('settings') --save stats
        sendReply(msg, message, true)
    end

end

return {
	action = action,
	triggers = triggers
}