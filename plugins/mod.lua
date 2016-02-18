groups = load_data('groups.json')


local commands = {
 
 
['^/promote[@'..bot.username..']*$'] = function(msg)
    
    --return nil if wrote in private
    if msg.chat.type == 'private' then
        print('PV mod.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    print('\n/promote', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --only the owner can promote
    if not is_owner(msg) then
        print('\27[31mNil: the user is not the owner\27[39m')
        sendReply(msg, 'You are *not* the owner of this group.', true)
    else
        --allert if is not a reply
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            sendReply(msg, 'Reply to someone to promote him', false)
			return nil
		end
	
		msg = msg.reply_to_message
        
        --ignore if replied to the bot
        if msg.from.id == bot.id then
            print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
	    
	    --ignore if is promoting itself
	    if is_owner(msg) then
	        print('\27[31mNil: an owner can\'t promote itself\27[39m')
	        return nil
	    end
	    
	    --ignore if already moderator
        if groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
            print('\27[31mNil: already a mod\27[39m')
            sendReply(msg, '*'..msg.from.first_name..'* is already a moderator of *'..msg.chat.title..'*', true)
            return nil
        end
        
        --check if it has a username. if not, save the name
        local jsoname = tostring(msg.from.first_name)
        if msg.from.username then
            jsoname = '@'..tostring(msg.from.username)
        end
        
        --save the moderator
        groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
        save_data('groups.json', groups)
        
        mystat('prom') --save stats
        sendReply(msg, '*'..msg.from.first_name..'* has been promoted as moderator of *'..msg.chat.title..'*', true)
    end
end,

['^/demote[@'..bot.username..']*$'] = function(msg)
    
    --ignore if via pm
    if msg.chat.type == 'private' then
        print('PV mod.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    print('\n/demote', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --only the owner can promote or demote
    if not is_owner(msg) then
        print('\27[31mNil: the user is not the owner\27[39m')
        sendReply(msg, 'You are *not* the owner of this group.', true)
    else
        --allert if is not a reply
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            sendReply(msg, 'Reply to someone to demote him', false)
			return nil
		end
	    
		msg = msg.reply_to_message
		
	    --ignore if is demoting itself
	    if is_owner(msg) then
	        print('\27[31mNil: an owner can\'t demote itself\27[39m')
	        return nil
	    end
	    
		--ignored if demoted the bot
        if msg.from.id == bot.id then
            print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
	    
	    --allert if the replied users was not a moderator, and then ignore
        if not groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
            print('\27[31mNil: user was not a moderator\27[39m')
            sendReply(msg, '*'..msg.from.first_name..'* is not a moderator of *'..msg.chat.title..'*', true)
            return nil
        end
        
        --remove the moderator
        groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = nil
        save_data('groups.json', groups)
        
        mystat('dem') --save stats
        sendReply(msg, '*'..msg.from.first_name..'* has been demoted', true)
    end
end,

['^/owner[@'..bot.username..']*$'] = function(msg)
    
    --ignore if private chat
    if msg.chat.type == 'private' then
        print('PV mod.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    print('\n/owner', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --only the owner can change the owner
    if not is_owner(msg) then
        sendReply(msg, 'You are *not* the owner of this group.', true)
    else
        --allert if it's not a reply to someone and return nil
        if not msg.reply_to_message then
            print('\27[31mNil: not the owner\27[39m')
            sendReply(msg, 'Reply to someone to set him as owner', false)
			return nil
		end
		
	    local old = msg.from.id
		local msg = msg.reply_to_message
        
        --ignore if replied to the bot
        if msg.from.id == bot.id then
            print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
        
        --allert if the owner is promoting as owner itself
        if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
            print('\27[31mNil: promoting as owner itself\27[39m')
            sendReply(msg, '*'..msg.from.first_name..'* is already the owner of *'..msg.chat.title..'*', true)
            return nil
        end
        
        --check if the new owner has a username. if not, save the name
        local jsoname = tostring(msg.from.first_name)
        if msg.from.username then
            jsoname = '@'..tostring(msg.from.username)
        end
        
        --remove old owner from mods
        groups[tostring(msg.chat.id)]['mods'][tostring(old)] = nil
        --add the new one to moderators list
        groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
        
        --save the owner id
        groups[tostring(msg.chat.id)]['owner'] = tostring(msg.from.id)
        save_data('groups.json', groups)
        
        mystat('own') --save stats
        sendReply(msg, '*'..msg.from.first_name..'* is the new owner of *'..msg.chat.title..'*', true)
    end
end,

['^/modlist[@'..bot.username..']*$'] = function(msg)
    
    --ignore if via pm
    if msg.chat.type == 'private' then
        print('PV mod.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    print('\n/modlist', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --ignore if the command is locked and the user is not a moderator
    if is_locked(msg, 's_modlist') and not is_mod(msg) then
        print('\27[31mNil: action locked\27[39m')
    	return nil
    end
    
    --check if the moderator list is empty. If it is, return a mesage
    if next(groups[tostring(msg.chat.id)]['mods']) == nil then
        print('\27[31mNil: no moderators\27[39m')
        sendReply(msg, '*No moderators* in this group.', true)
        return nil
    end
    
    --build the moderator list
    local i = 1
    local message = '\nModerators list of *'..msg.chat.title..'*:\n'
    for k,v in pairs(groups[tostring(msg.chat.id)]['mods']) do
        message = message..'*'..i..'* - '..v..' (id: ' ..k.. ')\n'
        i = i + 1
    end
    
    mystat('modl') --save stats
    --send the list
    sendReply(msg, message, true)
end
    
}


local triggers = {}
for k,v in pairs(commands) do
    --put the first string value of "commands" table in the triggers table
	table.insert(triggers, k)
end

local action = function(msg)
    --build the action function for each trigger
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