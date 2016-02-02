local triggers = {
	'^/flagmsg[@'..bot.username..']*',
	'^/flagblock[@'..bot.username..']*',
	'^/flagfree[@'..bot.username..']*',
	'^/flaglist[@'..bot.username..']*'
}

local action = function(msg)
    
    if msg.chat.type == 'private' then--return nil if it's a private chat
		sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    if string.match(msg.text, '^/flagmsg') then
        
        --return nil if 's_flag' is locked
        if is_locked(msg, 's_flag') then --or is_mod(msg) then
            return nil 
        end
        
        groups = load_data('groups.json')
        
        --check if /flagblocked
        if groups[tostring(msg.chat.id)]['flag_blocked'][tostring(msg.from.id)] then
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            sendReply(msg, 'Reply to a message to report it to admins')
		    return nil
	    end
	    mystat('flmsg')
	    local replied = msg.reply_to_message --load the replied message
	    
	    --return nil if an user flag a mod
	    if is_mod(replied) then
	        return nil
	    end
	    
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        return nil
	    end
	    
	    local desc = msg.text:input()
	    
	    --check if there is a description for the flag
	    if not desc then
	        desc = 'no description given'
	    end
	    
	    --check if there is an username of flagging user
	    local titlefla = ''
        if msg.from.username then
            titlefla = ' (@'..msg.from.username..')'
        end
	    
	    --check if there is an username of flagged user
	    local titlere = ''
        if replied.from.username then
            titlere = ' (@'..replied.from.username..')'
        end
	    
	    for k,v in pairs(groups[tostring(msg.chat.id)]['mods']) do
            sendMessage(k, msg.from.first_name..titlefla..' reported '..replied.from.first_name..titlere..'\nDescription: '..desc..'\nMessage reported:\n\n'..replied.text)
        end
        sendMessage(msg.chat.id, '*Flagged* 🎯', true, false, true)
    end
    
    if string.match(msg.text, '^/flagblock') then
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            sendReply(msg, 'Reply to an user to block his /flag power')
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
	    --can't /flagblock a mod
	    if is_mod(replied) then --return nil if an user flag a mod
	        sendReply(msg, 'Moderators can\'t flag people')
	        return nil
	    end
	    
	    --can't /flagblock the bot
	    if replied.from.id == bot.id then
	        return nil
	    end
	    mystat('flb')
	    groups = load_data('groups.json')
	    
	    --check if already unable to use /flag
	    if groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] then
            sendReply(msg, '*'..replied.from.first_name..'* is already unable to use /flag command', true)
            return nil
        end
        
        --unable the user to use /flag and save datas
        
        --check if there is an username
        local title = replied.from.first_name
        if replied.from.username then
            title = '@'..replied.from.username
        end
        groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] = tostring(title)
        save_data('groups.json', groups)
        sendReply(msg, '*'..msg.from.first_name..'* is now *unable* to use /flag', true)
    end
    
    if string.match(msg.text, '^/flagfree') then
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            sendReply(msg, 'Reply to an user to unblock his /flag power')
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
	    --can't /flagfree a mod
	    if is_mod(replied) then --return nil if an user flag a mod
	        sendReply(msg, 'Moderators can\'t flag people')
	        return nil
	    end
	    
	    --can't /flagfree the bot
	    if replied.from.id == bot.id then
	        return nil
	    end
	    mystat('flfre')
	    groups = load_data('groups.json')
	    
	    --check if already able to use /flag
	    if not groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] then
            sendReply(msg, '*'..replied.from.first_name..'* is already *able* to use /flag command', true)
            return nil
        end
        
        --able the user to use /flag and save datas
        groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] = nil
        save_data('groups.json', groups)
        sendReply(msg, '*'..msg.from.first_name..'* is now *able* to use /flag', true)
    end
    
    if string.match(msg.text, '^/flaglist') then
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        mystat('fllist')
        if next(groups[tostring(msg.chat.id)]['flag_blocked']) == nil then
            sendReply(msg, 'There are zero people unable to use /flag command in this group.', true)
            return nil
        end
    
        local i = 1
        local message = '\nUsers unable to flag:\n'
        for k,v in pairs(groups[tostring(msg.chat.id)]['flag_blocked']) do
            message = message..'*'..i..'* - '..v..' (id: ' ..k.. ')\n'
            i = i + 1
        end
        sendReply(msg, message, true)
    end
end

return {
	action = action,
	triggers = triggers
}
