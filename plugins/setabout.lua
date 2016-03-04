
local triggers = {
	'^/(setabout)$', --to warn if an user don't add a text
	'^/(setabout) (.*)',
	'^/(about)$',
	'^/(addabout)$', --to warn if an user don't add a text
	'^/(addabout) (.*)',
	
}

local action = function(msg, blocks)
	
	--ignore if via pm
	if msg.chat.type == 'private' then
		print('PV setabout.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
		sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    groups = load_data('groups.json')
    
    --/about
    if blocks[1] == 'about' then
    	
    	print('\n/about', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    	
    	--ignore if is locked and is not mod
    	if is_locked(msg, 'About') and not is_mod(msg) then
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
        
        mystat('about') --save stats
        return nil
    end
	
	--/ADDabout
	if blocks[1] == 'addabout' then
		
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
            sendReply(msg, '*No bio for this group*.\nUse /setabout [bio] to set-up a new description', true)
        else
            local input = blocks[2]
            if not input then
            	print('\27[31mNil: no text\27[39m')
		        sendReply(msg, 'Please write something next this poor "/addabout"', true)
		        return nil
	        end
	        
	        --check if breaks the markdown
	        if breaks_markdown(input) then
				print('\27[31mNil: about text breaks the markdown\27[39m')
				sendReply(msg, 'The text inserted breaks the markdown.\nCheck how many times you used * or _ or `')
				return nil
			end
			
			--add the new string to the about text
            about = about..'\n'..input
            groups[tostring(msg.chat.id)]['about'] = tostring(about)
            save_data('groups.json', groups)
            sendReply(msg, '*Description added:*\n"'..input..'"', true)
        end
        
        mystat('addabout') --save stats
        return nil
    end
	
	--/SETabout
	if blocks[1] == 'setabout' then
	
		print('\n/setabout', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
	
		local input = blocks[2]
		
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, 'You are *not* a moderator', true)
			return nil
		end
	
		--ignore if not text
		if not input then
			print('\27[31mNil: no input text\27[39m')
			sendReply(msg, 'Please write something next this poor "/setabout"', true)
			return true
		end
	
		--check if the mod want to clean the about text
		if input == 'clean$' then
			print('\27[31mNil: about text cleaned\27[39m')
			groups[tostring(msg.chat.id)]['about'] = nil
			sendReply(msg, 'The bio has been cleaned.')
			return nil
		end
		
		--check if the about text breaks the markdown
		if breaks_markdown(input) then
			print('\27[31mNil: about text breaks the markdown\27[39m')
			sendReply(msg, 'The text inserted breaks the markdown.\nCheck how many times you used * or _ or `')
			return nil
		end
		
		--set the new about
		groups[tostring(msg.chat.id)]['about'] = input
		sendReply(msg, '*New bio:*\n"'..input..'"', true)
	
		save_data('groups.json', groups)
	
		mystat('setabout') --save stats
		return true
	end

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}