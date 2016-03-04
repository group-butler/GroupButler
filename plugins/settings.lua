
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
        
        local hash = 'chat:'..msg.chat.id..':settings'
        local now
        
        --check the command to lock
        if input == 'rules' then
            mystat('disablerules') --save stats
            now = client:hget(hash, 'Rules')
            if now == 'yes' then
                sendReply(msg, '`/rules` command is already *locked*', true)
            else
                client:hset(hash, 'Rules', 'yes')
                sendReply(msg, '`/rules` command is now available *only for moderators*', true)
            end
            
        elseif input == 'about' then
            mystat('disableabout') --save stats
            now = client:hget(hash, 'About')
            if now == 'yes' then
                sendReply(msg, '`/about` command is already *locked*', true)
            else
                client:hset(hash, 'About', 'yes')
                sendReply(msg, '`/about` command is now available *only for moderators*', true)
            end
        
        elseif input == 'welcome' then
            mystat('disablewelcome') --save stats
            now = client:hget(hash, 'Welcome')
            if now == 'yes' then
                sendReply(msg, 'Welcome message is already *locked*', true)
            else
                client:hset(hash, 'Welcome', 'yes')
                sendReply(msg, 'Welcome message *won\'t be displayed* from now', true)
            end
        
        elseif input == 'modlist' then
            mystat('disablemodlist') --save stats
            now = client:hget(hash, 'Modlist')
            if now == 'yes' then
                sendReply(msg, '`/modlist` command is already *locked*', true)
            else
                client:hset(hash, 'Modlist', 'yes')
                sendReply(msg, '`/modlist` command is now available *only for moderators*', true)
            end
        
        elseif input == 'flag' then
            mystat('disableflag') --save stats
            now = client:hget(hash, 'Flag')
            if now == 'yes' then
                sendReply(msg, '`/flag` command is already *not enabled*', true)
            else
                client:hset(hash, 'Flag', 'yes')
                sendReply(msg, '`/flag` command *won\'t be available* from now', true)
            end
        else
            print('\27[31mNil: argument not available\27[39m')
            sendReply(msg, 'Argument unavailable.\nUse `/disable [rules|about|welcome|modlist|flag]` instead', true)
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
        
        local hash = 'chat:'..msg.chat.id..':settings'
        local now
        
        --check the command to enable
        if input == 'rules' then
            mystat('enablerules') --save stats
            now = client:hget(hash, 'Rules')
            if now == 'no' then
                sendReply(msg, '`/rules` command is already *unlocked*', true)
            else
                client:hset(hash, 'Rules', 'no')
                sendReply(msg, '`/rules` command is now available *for all*', true)
            end
            
        elseif input == 'about' then
            mystat('enableabout') --save stats
            now = client:hget(hash, 'About')
            if now == 'no' then
                sendReply(msg, '`/about` command is already *unlocked*', true)
            else
                client:hset(hash, 'About', 'no')
                sendReply(msg, '`/about` command is now available *for all*', true)
            end
        
        elseif input == 'welcome' then
            mystat('enablewelcome') --save stats
            now = client:hget(hash, 'Welcome')
            if now == 'no' then
                sendReply(msg, 'Welcome message is already *unlocked*', true)
            else
                client:hset(hash, 'Welcome', 'no')
                sendReply(msg, 'Welcome message from now will be displayed', true)
            end
        
        elseif input == 'modlist' then
            mystat('enablemodlist') --save stats
            now = client:hget(hash, 'Modlist')
            if now == 'no' then
                sendReply(msg, '`/modlist` command is already *unlocked*', true)
            else
                client:hset(hash, 'Modlist', 'no')
                sendReply(msg, '`/modlist` command is now available *for all*', true)
            end
        
        elseif input == 'flag' then
            mystat('enableflag') --save stats
            now = client:hget(hash, 'Flag')
            if now == 'no' then
                sendReply(msg, '`/flag` command is already *available*', true)
            else
                client:hset(hash, 'Flag', 'no')
                sendReply(msg, '`/flag` command is now *available*', true)
            end
        else
            print('\27[31mNil: argument not available\27[39m')
            sendReply(msg, 'Argument unavailable.\nUse `/enable [rules|about|welcome|modlist|flag]` instead', true)
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
        
        local hash = 'chat:'..msg.chat.id..':welcome'
        local key = 'wel'
        
        --change welcome settings
        if input == 'a' then
            client:hset(hash, key, 'a')
            sendReply(msg, 'New settings for the welcome message:\n❌Rules\n✅*About*\n❌Moderators list', true)
        elseif input == 'r' then
            client:hset(hash, key, 'r')
            sendReply(msg, 'New settings for the welcome message:\n✅*Rules*\n❌About\n❌Moderators list', true)
        elseif input == 'm' then
            client:hset(hash, key, 'm')
            sendReply(msg, 'New settings for the welcome message:\n❌Rules\n❌About\n✅*Moderators list*', true)
        elseif input == 'ar' or input == 'ra' then
            client:hset(hash, key, 'ra')
            sendReply(msg, 'New settings for the welcome message:\n✅*Rules*\n✅*About*\n❌Moderators list', true)
        elseif input == 'mr' or input == 'rm' then
            client:hset(hash, key, 'rm')
            sendReply(msg, 'New settings for the welcome message:\n✅*Rules*\n❌About\n✅*Moderators list*', true)
        elseif input == 'am' or input == 'ma' then
            client:hset(hash, key, 'am')
            sendReply(msg, 'New settings for the welcome message:\n❌Rules\n✅*About*\n✅*Moderators list*', true)
        elseif input == 'ram' or input == 'rma' or input == 'arm' or input == 'amr' or input == 'mra' or input == 'mar' then
            client:hset(hash, key, 'ram')
            sendReply(msg, 'New settings for the welcome message:\n✅*Rules*\n✅*About*\n✅*Moderators list*', true)
        elseif input == 'no' then
            client:hset(hash, key, 'no')
            sendReply(msg, 'New settings for the welcome message:\n❌Rules\n❌About\n❌Moderators list', true)
        else sendReply(msg, 'Argument unavailable.\nUse _/welcome [no|r|a|ra|ar]_ instead', true)
        end
        
        mystat('welcome') --save stats
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
        
        --get settings from redis
        local hash = 'chat:'..msg.chat.id..':settings'
        local settings_key = client:hkeys(hash)
        local settings_val = client:hvals(hash)
        local key
        local val
        
        message = 'Current settings for *'..msg.chat.title..'*:\n\n'
        
        --build the message
        for i=1, #settings_key do
            key = settings_key[i]
            val = settings_val[i]
            
            local text
            if val == 'yes' then
                text = key..': 🔒\n'
            else
                text = '*'..key..'*: 🔓\n'
            end
            message = message..text
        end
        
        --build the "welcome" line
        hash = 'chat:'..msg.chat.id..':welcome'
        local wel = client:hget(hash, 'wel')
        if wel == 'a' then
            message = message..'*Welcome type*: `welcome + about`\n'
        elseif wel == 'r' then
            message = message..'*Welcome type*: `welcome + rules`\n'
        elseif wel == 'm' then
            message = message..'*Welcome type*: `welcome + modlist`\n'
        elseif wel == 'ra' then
            message = message..'*Welcome type*: `welcome + rules + about`\n'
        elseif wel == 'rm' then
            message = message..'*Welcome type*: `welcome + rules + modlist`\n'
        elseif wel == 'am' then
            message = message..'*Welcome type*: `welcome + about + modlist`\n'
        elseif wel == 'ram' then
            message = message..'*Welcome type*: `welcome + rules + about + modlist`\n'
        elseif wel == 'no' then
            message = message..'*Welcome type*: `welcome only`\n'
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