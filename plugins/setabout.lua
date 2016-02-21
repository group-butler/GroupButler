
local triggers = {
	'^/setabout[@'..bot.username..']*',
	'^/about[@'..bot.username..']*',
	'^/addabout[@'..bot.username..']*',
	
}

local action = function(msg)
	
	--ignore if via pm
	if msg.chat.type == 'private' then
		print('PV setabout.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
		sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    groups = load_data('groups.json')
    
    --/about
    if string.match(msg.text, '^/about') then
    	
    	print('\n/about', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    	
    	--ignore if is locked and is not mod
    	if is_locked(msg, 's_about') and not is_mod(msg) then
    		print('\27[31mNil: locked and not mod\27[39m')
    		return nil
    	end
    	
    	--load the about
        local about = groups[tostring(msg.chat.id)]['about']
        
        if not about then
        	print('\27[31mNil: no about text\27[39m')
            sendReply(msg, '*NO BIO* for this group.', true)
        else
            sendReply(msg, '*Bio of '..msg.chat.title..':*\n'..about..'', true)
        end
        
        mystat('abt') --save stats
        return nil
    end
	
	--/ADDabout
	if string.match(msg.text, '^/addabout') then
		
		print('\n/addabout', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
		
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, 'You are *not* a moderator', true)
			return nil
		end
		
	    --load about
	    about = groups[tostring(msg.chat.id)]['about']
        
        --check if there is an about text
        if not about then
        	print('\27[31mNil: no about text\27[39m')
            sendReply(msg, '*No bio for this group.\nUse /setabout [bio] to set-up a new description', true)
        else
            local input = msg.text:input()
            if not input then
            	print('\27[31mNil: no text\27[39m')
		        sendReply(msg, 'Please write something next this poor "/addabout" or *gtfo*', true)
		        return nil
	        end
            about = about..'\n'..input
            groups[tostring(msg.chat.id)]['about'] = tostring(about)
            save_data('groups.json', groups)
            sendReply(msg, '*Description added:*\n"'..input..'"', true)
        end
        
        mystat('aabt') --save stats
        return nil
    end
	
	--/SETabout
	
	print('\n/setabout', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
	
	local input = msg.text:input()
	
	--ignore if not mod
	if not is_mod(msg) then
		print('\27[31mNil: not mod\27[39m')
		sendReply(msg, 'You are *not* a moderator', true)
		return nil
	end
	
	--ignore if not text
	if not input then
		print('\27[31mNil: no input text\27[39m')
		sendReply(msg, 'Please write something next this poor "/setabout" or *gtfo*', true)
		return true
	end
	
	--check if the mod want to clean the about text
	if input == 'clean$' then
		print('\27[31mNil: about text cleaned\27[39m')
		groups[tostring(msg.chat.id)]['about'] = nil
		sendReply(msg, 'The bio has been cleaned.')
	else
		groups[tostring(msg.chat.id)]['about'] = input
		sendReply(msg, '*New bio:*\n"'..input..'"', true)
	end
	
	save_data('groups.json', groups)
	
	mystat('sabt') --save stats
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}