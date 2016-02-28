groups = load_data('groups.json')


local commands = {
    ['^/disable[@'..bot.username..']*'] = function(msg)
        
        --ignore if via pm
        if msg.chat.type == 'private' then
            print('PV settings.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
            sendMessage(msg.from.id, 'This is a command available only in a group')
    	    return nil
        end
        
        print('\n/disable', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            sendReply(msg, 'You are *not* a moderator', true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            print('\27[31mNil: no text\27[39m')
            sendReply(msg, 'Disable what?', false)
            return nil
        end
        
        --check the command to lock
        if input == 'rules' then
            mystat('disablerules') --save stats
            now = groups[tostring(msg.chat.id)]['settings']['s_rules']
            if now == 'yes' then
                sendReply(msg, 'Rules command is already *locked*', true)
            elseif now == 'no' then
                groups[tostring(msg.chat.id)]['settings']['s_rules'] = 'yes'
                save_data('groups.json', groups)
                sendReply(msg, 'Rules command it\'s now available *only for moderators*', true)
            end
            
        elseif input == 'about' then
                mystat('disableabout') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_about']
                if now == 'yes' then
                    sendReply(msg, 'About command is already *locked*', true)
                elseif now == 'no' then
                    groups[tostring(msg.chat.id)]['settings']['s_about'] = 'yes'
                    save_data('groups.json', groups)
                    sendReply(msg, 'About command it\'s now available *only for moderators*', true)
                end
        
        elseif input == 'welcome' then
                mystat('disablewelcome') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_welcome']
                if now == 'yes' then
                    sendReply(msg, 'Welcome message is already *locked*', true)
                elseif now == 'no' then
                    groups[tostring(msg.chat.id)]['settings']['s_welcome'] = 'yes'
                    save_data('groups.json', groups)
                    sendReply(msg, 'The welcome message *won\'t be diplayed*', true)
                end
        
        elseif input == 'modlist' then
                mystat('disablemodlist') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_modlist']
                if now == 'yes' then
                    sendReply(msg, 'Modlist is already *locked*', true)
                elseif now == 'no' then
                    groups[tostring(msg.chat.id)]['settings']['s_modlist'] = 'yes'
                    save_data('groups.json', groups)
                    sendReply(msg, 'Modlist command it\'s now available *only for moderators*', true)
                end
        
        elseif input == 'flag' then
                mystat('disableflag') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_flag']
                if now == 'yes' then
                    sendReply(msg, 'Flag option is already *locked*', true)
                elseif now == 'no' then
                    groups[tostring(msg.chat.id)]['settings']['s_flag'] = 'yes'
                    save_data('groups.json', groups)
                    sendReply(msg, 'Moderators from now *won\'t receive* reports from users', true)
                end
        else
            print('\27[31mNil: argument not available\27[39m')
            sendReply(msg, 'Arguments unavailable.\nUse /disable [rules|about|welcome|modlist|flag] instead', true)
        end
        
    end,

    ['^/enable[@'..bot.username..']*'] = function(msg)
        
        --ignore if via pm
        if msg.chat.type == 'private' then
            print('PV settings.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
            sendMessage(msg.from.id, 'This is a command available only in a group')
    	    return nil
        end
        
        print('\n/enable', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            sendReply(msg, 'You are *not* a moderator', true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            print('\27[31mNil: no input text\27[39m')
            sendReply(msg, 'Enable what?', false)
            return nil
        end
        
        --check the command to enable
        if input == 'rules' then
            mystat('enablerules') --save stats
            now = groups[tostring(msg.chat.id)]['settings']['s_rules']
            if now == 'no' then
                sendReply(msg, 'Rules command is already *unlocked*', true)
            elseif now == 'yes' then
                groups[tostring(msg.chat.id)]['settings']['s_rules'] = 'no'
                save_data('groups.json', groups)
                sendReply(msg, 'Rules command it\'s now available *for all*', true)
            end
            
        elseif input == 'about' then
                mystat('enableabout') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_about']
                if now == 'no' then
                    sendReply(msg, 'About command is already *unlocked*', true)
                elseif now == 'yes' then
                    groups[tostring(msg.chat.id)]['settings']['s_about'] = 'no'
                    save_data('groups.json', groups)
                    sendReply(msg, 'About command it\'s now available *for all*', true)
                end
        
        elseif input == 'welcome' then
                mystat('enablewelcome') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_welcome']
                if now == 'no' then
                    sendReply(msg, 'Welcome message is already *unlocked*', true)
                elseif now == 'yes' then
                    groups[tostring(msg.chat.id)]['settings']['s_welcome'] = 'no'
                    save_data('groups.json', groups)
                    sendReply(msg, 'The welcome message *will be diplayed*', true)
                end
        
        elseif input == 'modlist' then
                mystat('enablemodlist') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_modlist']
                if now == 'no' then
                    sendReply(msg, 'Modlist command is already *unlocked*', true)
                elseif now == 'yes' then
                    groups[tostring(msg.chat.id)]['settings']['s_modlist'] = 'no'
                    save_data('groups.json', groups)
                    sendReply(msg, 'Modlist command it\'s now available *for all*', true)
                end
        
        elseif input == 'flag' then
                mystat('enableflag') --save stats
                now = groups[tostring(msg.chat.id)]['settings']['s_flag']
                if now == 'no' then
                    sendReply(msg, 'Flag option is already *unlocked*', true)
                elseif now == 'yes' then
                    groups[tostring(msg.chat.id)]['settings']['s_flag'] = 'no'
                    save_data('groups.json', groups)
                    sendReply(msg, 'Moderators from now *will receive* reports from users', true)
                end
        else
            print('\27[31mNil: argument not available\27[39m')
            sendReply(msg, 'Argument unavailable.\nUse /unlock [rules|about|welcome|modlist|flag] instead', true)
        end
        
    end,
    
    ['^/welcome[@'..bot.username..']*'] = function(msg)
        
        --ignore if via pm
        if msg.chat.type == 'private' then
            print('PV settings.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
            sendMessage(msg.from.id, 'This is a command available only in a group')
    	    return nil
        end
        
        print('\n/welcome', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            sendReply(msg, 'You are *not* a moderator', true)
            return nil
        end
        
        local input = msg.text:input()
        
        --ignore if not input text
        if not input then
            print('\27[31mNil: no input text\27[39m')
            sendReply(msg, 'Welcome and...?', false)
            return nil
        end
        
        now = groups[tostring(msg.chat.id)]['settings']['welcome']
        
        --change welcome settings
        if input == 'a' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'a'
            sendReply(msg, 'New settings for the welcome message:\nRules\n*About*\nModerators list', true)
        elseif input == 'r' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'r'
            sendReply(msg, 'New settings for the welcome message:\n*Rules*\nAbout\nModerators list', true)
        elseif input == 'm' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'm'
            sendReply(msg, 'New settings for the welcome message:\nRules\nAbout\n*Moderators list*', true)
        elseif input == 'ar' or input == 'ra' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'ra'
            sendReply(msg, 'New settings for the welcome message:\n*Rules*\n*About*\nModerators list', true)
        elseif input == 'mr' or input == 'rm' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'rm'
            sendReply(msg, 'New settings for the welcome message:\nRules\n*About*\n*Moderators list*', true)
        elseif input == 'am' or input == 'ma' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'am'
            sendReply(msg, 'New settings for the welcome message:\nRules\n*About*\n*Moderators list*', true)
        elseif input == 'ram' or input == 'rma' or input == 'arm' or input == 'amr' or input == 'mra' or input == 'mar' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'ram'
            sendReply(msg, 'New settings for the welcome message:\n*Rules*\n*About*\n*Moderators list*', true)
        elseif input == 'no' then
            groups[tostring(msg.chat.id)]['settings']['welcome'] = 'no'
            sendReply(msg, 'New settings for the welcome message:\nRules\nAbout\nModerators list', true)
        else sendReply(msg, 'Argument unavailable.\nUse _/welcome [no|r|a|ra|ar]_ instead', true)
        end
        
        mystat('welcome') --save stats
        save_data('groups.json', groups)
    end,

    ['^/settings[@'..bot.username..']*$'] = function(msg)
        
        --ignore if via pm
        if msg.chat.type == 'private' then
            print('PV settings.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
            sendMessage(msg.from.id, 'This is a command available only in a group')
    	    return nil
        end
        
        print('\n/settings', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --ignore if is not mod
        if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, 'You are *not* a moderator', true)
			return nil
		end
        
        settings = groups[tostring(msg.chat.id)]['settings']
        
        message = 'Current settings for *'..msg.chat.title..'*:\n\n'
        
        --build the message
        if settings.s_rules == 'yes' then
            message = message..'*Rules*: for moderators\n'
        else
            message = message..'*Rules*: for all\n'
        end
        if settings.s_about == 'yes' then
            message = message..'*About*: for moderators\n'
        else
            message = message..'*About*: for all\n'
        end
        if settings.s_modlist == 'yes' then
            message = message..'*Modlist*: for moderators\n'
        else
            message = message..'*Modlist*: for all\n'
        end
        if settings.s_flag == 'yes' then
            message = message..'*Flag*: off\n'
        else
            message = message..'*Flag*: on\n'
        end
        if settings.s_welcome == 'yes' then
            message = message..'*Welcome message*: off\n'
        else
            message = message..'*Welcome message*: on\n'
        end
        
        --build the "welcome" line
        if settings.welcome == 'a' then
            message = message..'*Welcome type*: welcome + about\n'
        elseif settings.welcome == 'r' then
            message = message..'*Welcome type*: welcome + rules\n'
        elseif settings.welcome == 'm' then
            message = message..'*Welcome type*: welcome + modlist\n'
        elseif settings.welcome == 'ra' then
            message = message..'*Welcome type*: welcome + rules + about\n'
        elseif settings.welcome == 'rm' then
            message = message..'*Welcome type*: welcome + rules + modlist\n'
        elseif settings.welcome == 'am' then
            message = message..'*Welcome type*: welcome + about + modlist\n'
        elseif settings.welcome == 'ram' then
            message = message..'*Welcome type*: welcome + rules + about + modlist\n'
        elseif settings.welcome == 'no' then
            message = message..'*Welcome type*: welcome only\n'
        end
        
        mystat('settings') --save stats
        sendReply(msg, message, true)
    end
}


local triggers = {}
for k,v in pairs(commands) do
	table.insert(triggers, k)
end

local action = function(msg)

	for k,v in pairs(commands) do
		if string.match(msg.text_lower, k) then
			local output = v(msg)
			if output == true then
				return true
			elseif output then
				sendReply(msg, output)
			end
			return
		end
	end

	return true

end

return {
	action = action,
	triggers = triggers
}