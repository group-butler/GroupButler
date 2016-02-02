groups = load_data('groups.json')


local commands = {
 
 
['^/promote[@'..bot.username..']*$'] = function(msg)
    
    if msg.chat.type == 'private' then
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    if not is_owner(msg) then
        sendReply(msg, 'You are *not* the owner of this group.', true)
    else
        mystat('prom')
        if not msg.reply_to_message then
            sendReply(msg, 'Reply to someone to promote him', false)
			return nil
		end
	
		msg = msg.reply_to_message
        if msg.from.id == bot.id then
	        return nil
	    end
        if groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
            sendReply(msg, '*'..msg.from.first_name..'* is already a moderator of *'..msg.chat.title..'*', true)
            return nil
        end
        local jsoname = tostring(msg.from.first_name)
        if msg.from.username then
            jsoname = '@'..tostring(msg.from.username)
        end
        groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
        save_data('groups.json', groups)
        sendReply(msg, '*'..msg.from.first_name..'* has been promoted as moderator of *'..msg.chat.title..'*', true)
    end
end,

['^/demote[@'..bot.username..']*$'] = function(msg)
    if msg.chat.type == 'private' then
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    if not is_owner(msg) then
        sendReply(msg, 'You are *not* the owner of this group.', true)
    else
        mystat('dem')
        if not msg.reply_to_message then
            --sendMessage(msg.chat.id, 'I don\'t see the replied message', true, false, false)
            sendReply(msg, 'Reply to someone to demote him', false)
			return nil
		end
	
		msg = msg.reply_to_message
        if msg.from.id == bot.id then
	        return nil
	    end
        if not groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
            sendReply(msg, '*'..msg.from.first_name..'* is not a moderator of *'..msg.chat.title..'*', true)
            return nil
        end
        
        groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = nil
        save_data('groups.json', groups)
        sendReply(msg, '*'..msg.from.first_name..'* has been demoted', true)
    end
end,

['^/owner[@'..bot.username..']*$'] = function(msg)
    if msg.chat.type == 'private' then
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    if not is_owner(msg) then
        sendReply(msg, 'You are *not* the owner of this group.', true)
    else
        mystat('own')
        if not msg.reply_to_message then
            --sendMessage(msg.chat.id, 'I don\'t see the replied message', true, false, false)
            sendReply(msg, 'Reply to someone to set him as owner', false)
			return nil
		end
	    old = msg.from.id
		msg = msg.reply_to_message
        if msg.from.id == bot.id then
	        return nil
	    end
        
        if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
            sendReply(msg, '*'..msg.from.first_name..'* is already the owner of *'..msg.chat.title..'*', true)
            return nil
        end
        
        --remove old owner from mods
        groups[tostring(msg.chat.id)]['mods'][tostring(old)] = nil
        --add the new one to moderators list
        groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = tostring(msg.from.username)
        
        groups[tostring(msg.chat.id)]['owner'] = tostring(msg.from.id)
        save_data('groups.json', groups)
        sendReply(msg, '*'..msg.from.first_name..'* is the new owner of *'..msg.chat.title..'*', true)
    end
end,

['^/modlist[@'..bot.username..']*$'] = function(msg)
    if msg.chat.type == 'private' then
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    if is_locked(msg, 's_modlist') and not is_mod(msg) then
    	return nil
    end
    mystat('modl')
    if next(groups[tostring(msg.chat.id)]['mods']) == nil then
        sendReply(msg, '*No moderators* in this group.', true)
        return nil
    end
    
    local i = 1
    local message = '\nModerators list of *'..msg.chat.title..'*:\n'
    for k,v in pairs(groups[tostring(msg.chat.id)]['mods']) do
        message = message..'*'..i..'* - '..v..' (id: ' ..k.. ')\n'
        i = i + 1
    end
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