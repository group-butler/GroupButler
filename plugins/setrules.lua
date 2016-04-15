
local triggers = {
	'^/(setrules)$',
	'^/(setrules) (.*)',
	'^/(rules)$',
	'^/(rules)@GroupButler_bot',
	'^/(addrules)$',
	'^/(addrules) (.*)'
	
}

local action = function(msg, blocks, ln)
    
    --ignore if via pm
    if msg.chat.type == 'private' then
    	print('PV setrules.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
    	sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    groups = load_data('groups.json')
    
    --/RULES
    if blocks[1] == 'rules' then
    	
    	print('\n/rules', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    	
    	--ignore if rules are locked and not is a mod
    	if is_locked(msg, 'Rules') and not is_mod(msg) then
    		print('\27[31mNil: locked and not mod\27[39m')
    		return nil
    	end
    	
        rules = groups[tostring(msg.cat.id)]['rules']
        
        --cehck if rules are empty
        if not rules then
        	print('\27[31mNil: no rules\27[39m')
            sendReply(msg, make_text(lang[ln].setrules.no_rules), true)
        else
            sendReply(msg, make_text(lang[ln].setrules.rules, msg.chat.title, rules), true)
        end
        
        mystat('rules') --save stats
        return nil
    end
	
	--/ADDRULES
	if blocks[1] == 'addrules' then
		
		print('\n/addrules', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
		
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
		
	    rules = groups[tostring(msg.chat.id)]['rules']
        
        --check if rules are empty
        if not rules then
        	print('\27[31mNil: no rules\27[39m')
            sendReply(msg, make_text(lang[ln].setrules.no_rules_add), true)
        else
            local input = blocks[2]
            if not input then
            	print('\27[31mNil: no text\27[39m')
		        sendReply(msg, make_text(lang[ln].setrules.no_input_add), true)
		        return nil
	        end
	        
	        --check if breaks the markdown
	        if breaks_markdown(input) then
				print('\27[31mNil: rules break the markdown\27[39m')
				sendReply(msg, make_text(lang[ln].breaks_markdown))
				return nil
			end
			
			--add the new string to the rules
            rules = rules..'\n'..input
            groups[tostring(msg.chat.id)]['rules'] = tostring(rules)
            save_data('groups.json', groups)
            sendReply(msg, make_text(lang[ln].setrules.added, input), true)
        end
        
        mystat('addrules') --save stats
        return nil
    end
	
	--/SETRULES
	if blocks[1] == 'setrules' then
	
		print('\n/setrules', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
	
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
	
		local input = blocks[2]
	
		--ignore if not input text
		if not input then
			print('\27[31mNil: no input text\27[39m')
			sendReply(msg, make_text(lang[ln].setrules.no_input_set), true)
			return true
		end
	
		--check if a mod want to clean the rules
		if input == 'clean' then
			print('\27[31mNil: rules cleaned\27[39m')
			groups[tostring(msg.chat.id)]['rules'] = nil
			sendReply(msg, make_text(lang[ln].setrules.clean))
			return nil
		end
		
		--check if new rules text breaks the markdown
		if breaks_markdown(input) then
			print('\27[31mNil: rulest break the markdown\27[39m')
			sendReply(msg, make_text(lang[ln].breaks_markdown))
			return nil
		end
		
		--set the new rules	
		groups[tostring(msg.chat.id)]['rules'] = input
		sendReply(msg, make_text(lang[ln].setrules.new, input), true)

		save_data('groups.json', groups)
	
		mystat('setrules') --save stats
		return true
	end

end

return {
	action = action,
	triggers = triggers
}