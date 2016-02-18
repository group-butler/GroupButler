local command = 'setrules <rules>'
local doc = [[```
/nick <nickname>
Set your nickname. Use "/whoami" to check your nickname and "/nick -" to delete it.
```]]

local triggers = {
	'^/setrules[@'..bot.username..']*',
	'^/rules[@'..bot.username..']*',
	'^/addrules[@'..bot.username..']*',
	
}

local action = function(msg)
    
    --ignore if via pm
    if msg.chat.type == 'private' then
    	print('PV setrules.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
    	sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    groups = load_data('groups.json')
    
    --/RULES
    if string.match(msg.text, '^/rules') then
    	
    	print('\n/rules', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    	
    	--ignore if rules are locked and not is a mod
    	if is_locked(msg, 's_rules') and not is_mod(msg) then
    		print('\27[31mNil: locked and not mod\27[39m')
    		return nil
    	end
    	
        rules = groups[tostring(msg.chat.id)]['rules']
        
        --cehck if rules are empty
        if not rules then
        	print('\27[31mNil: no rules\27[39m')
            sendReply(msg, '*TOTAL ANARCHY* for this group.', true)
        else
            sendReply(msg, '*Rules for '..msg.chat.title..':*\n'..rules..'', true)
        end
        
        mystat('rls') --save stats
        return nil
    end
	
	--/ADDRULES
	if string.match(msg.text, '^/addrules') then
		
		print('\n/addrules', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
		
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, 'You are *not* a moderator', true)
			return nil
		end
		
	    rules = groups[tostring(msg.chat.id)]['rules']
        
        --check if rules are empty
        if not rules then
        	print('\27[31mNil: no rules\27[39m')
            sendReply(msg, '*No rules* for this group.\nUse /setrules [rules] to set-up a new constitution', true)
        else
            local input = msg.text:input()
            if not input then
            	print('\27[31mNil: no text\27[39m')
		        sendReply(msg, 'Please write something next this poor "/addrules" or *gtfo*', true)
		        return nil
	        end
            rules = rules..'\n'..input
            groups[tostring(msg.chat.id)]['rules'] = tostring(rules)
            save_data('groups.json', groups)
            sendReply(msg, '*Rules added:*\n"'..input..'"', true)
        end
        
        mystat('arls') --save stats
        return nil
    end
	
	--/SETRULES
	
	print('\n/setrules', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
	
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
		sendReply(msg, 'Please write something next this poor "/setrules" or *gtfo*', true)
		return true
	end
	
	--check if a mod want to clean the rules
	if input == 'clean' then
		print('\27[31mNil: rules cleaned\27[39m')
		groups[tostring(msg.chat.id)]['rules'] = nil
		sendReply(msg, 'Rules has been cleaned.')
	else
		groups[tostring(msg.chat.id)]['rules'] = input
		sendReply(msg, '*New rules:*\n"'..input..'"', true)
	end

	save_data('groups.json', groups)
	
	mystat('srls') --save stats
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}