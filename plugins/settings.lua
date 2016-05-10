local function disable_set(field, msg, ln)
    local hash = 'chat:'..msg.chat.id..':settings'
    local field_lower = field:lower()
    print(already, locked)
    local now = db:hget(hash, field)
    if now == 'yes' then
        api.sendReply(msg, make_text(lang[ln].settings.disable[field_lower..'_already']), true)
    else
        db:hset(hash, field, 'yes')
        api.sendReply(msg, make_text(lang[ln].settings.disable[field_lower..'_locked']), true)
    end
end

local function enable_set(field, msg, ln)
    local hash = 'chat:'..msg.chat.id..':settings'
    local field_lower = field:lower()
    print(field_lower)
    local now = db:hget(hash, field)
    if now == 'no' then
        api.sendReply(msg, make_text(lang[ln].settings.enable[field_lower..'_already']), true)
    else
        db:hset(hash, field, 'no')
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
        
        db:hdel(hash, 'custom') --will be hsetted again if the text is a custom welcome
        --change welcome settings
        if input == 'a' then
            db:hset(hash, key, 'a')
            api.sendReply(msg, lang[ln].settings.welcome.a, true)
        elseif input == 'r' then
            db:hset(hash, key, 'r')
            api.sendReply(msg, lang[ln].settings.welcome.r, true)
        elseif input == 'm' then
            db:hset(hash, key, 'm')
            api.sendReply(msg, lang[ln].settings.welcome.m, true)
        elseif input == 'ar' or input == 'ra' then
            db:hset(hash, key, 'ra')
            api.sendReply(msg, lang[ln].settings.welcome.ra, true)
        elseif input == 'mr' or input == 'rm' then
            db:hset(hash, key, 'rm')
            api.sendReply(msg, lang[ln].settings.welcome.rm, true)
        elseif input == 'am' or input == 'ma' then
            db:hset(hash, key, 'am')
            api.sendReply(msg, lang[ln].settings.welcome.am, true)
        elseif input == 'ram' or input == 'rma' or input == 'arm' or input == 'amr' or input == 'mra' or input == 'mar' then
            db:hset(hash, key, 'ram')
            api.sendReply(msg, lang[ln].settings.welcome.ram, true)
        elseif input == 'no' then
            db:hset(hash, key, 'no')
            api.sendReply(msg, lang[ln].settings.welcome.no, true)
        else
            db:hset(hash, 'custom', input)
            local res = api.sendReply(msg, make_text(lang[ln].settings.welcome.custom, input), true)
            if not res then
                db:hdel(hash, 'custom')
                api.sendReply(msg, lang[ln].settings.welcome.wrong_markdown, true)
            end
        end
        
        mystat('/welcome') --save stats
    end

if blocks[1] == 'settings' then
        --ignore if is not mod
        if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
        
        --get settings
        local message = cross.getSettings(msg.chat.id, ln)
        
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