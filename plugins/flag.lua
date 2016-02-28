local triggers = {
	'^/(flag)$',
	'^/(flag) (.*)', --flag with motivation
	'^/(flag block)$',
	'^/(flag free)$',
	'^/(flag list)$'
}

local action = function(msg, blocks)
    
    if msg.chat.type == 'private' then--return nil if it's a private chat
        print('PV flag.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
		sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    if blocks[1] == 'flag' then
        
        print('\n/flag', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if 's_flag' is locked
        if is_locked(msg, 's_flag') then --or is_mod(msg) then
            print('\27[31mNil: /flagmsg locked for group\27[39m')
            return nil 
        end
        
        groups = load_data('groups.json')
        
        --ignore if who is flagging is a mod
        if is_mod(msg) then
	        print('\27[31mNil: a mod can\'t flag\27[39m')
	        return nil
	    end
        
        --check if /flagblocked
        if groups[tostring(msg.chat.id)]['flag_blocked'][tostring(msg.from.id)] then
            print('\27[31mNil: /flagmsg locked for user\27[39m')
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: not a reply\27[39m')
            sendReply(msg, 'Reply to a message to report it to admins')
		    return nil
	    end
	    
	    local replied = msg.reply_to_message --load the replied message
	    
	    --return nil if an user flag a mod
	    if is_mod(replied) then
	        print('\27[31mNil: mod flagged\27[39m')
	        return nil
	    end
	    
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot flagged\27[39m')
	        return nil
	    end
	    
	    local desc = blocks[2]
	    
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
	        print('Reported to ['..k..']')
            sendMessage(k, msg.from.first_name..titlefla..' reported '..replied.from.first_name..titlere..'\nDescription: '..desc..'\nMessage reported:\n\n'..replied.text)
        end
        
        mystat('flagmsg') --save stats
        sendMessage(msg.chat.id, '*Flagged* 🎯', true, false, true)
    end
    
    if blocks[1] == 'flag block' then
        
        print('\n/flag block', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            sendReply(msg, 'Reply to an user to block his /flag power')
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
	    --can't /flagblock a mod
	    if is_mod(replied) then --return nil if an user flag a mod
	        print('\27[31mNil: can\'t flagblock a mod\27[39m')
	        sendReply(msg, 'Moderators can\'t flag people')
	        return nil
	    end
	    
	    --can't /flagblock the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
	    
	    local groups = load_data('groups.json')
	    
	    --check if already unable to use /flag
	    if groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] then
	        print('\27[31mNil: already flagblocked\27[39m')
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
        
        mystat('flagblock') --save stats
        sendReply(msg, '*'..msg.from.first_name..'* is now *unable* to use /flag', true)
    end
    
    if blocks[1] == 'flag free' then
        
        print('\n/flag free', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            print('\27[31mNil: not a mod\27[39m')
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            sendReply(msg, 'Reply to an user to unblock his /flag power')
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
	    --an user can't /flagfree a mod
	    if is_mod(replied) then
	        print('\27[31mNil: a mod can\'t be flagblocked\27[39m')
	        sendReply(msg, 'Moderators can\'t flag people')
	        return nil
	    end
	    
	    --can't /flagfree the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
	    
	    local groups = load_data('groups.json')
	    
	    --check if already able to use /flag
	    if not groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] then
	        print('\27[31mNil: already flagfree\27[39m')
            sendReply(msg, '*'..replied.from.first_name..'* is already *able* to use /flag command', true)
            return nil
        end
        
        --able the user to use /flag and save datas
        groups[tostring(msg.chat.id)]['flag_blocked'][tostring(replied.from.id)] = nil
        save_data('groups.json', groups)
        
        mystat('flagfree') --save stats
        sendReply(msg, '*'..msg.from.first_name..'* is now *able* to use /flag', true)
    end
    
    if blocks[1] == 'flag list' then
        
        print('\n/flag list', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            print('\27[31mNil: not a mod\27[39m')
            return nil
        end
        
        --check if there are people unable to flag messages
        if next(groups[tostring(msg.chat.id)]['flag_blocked']) == nil then
            print('\27[31mNil: empty list\27[39m')
            sendReply(msg, 'There are zero people unable to use /flag command in this group.', true)
            return nil
        end
    
        local i = 1
        local message = '\nUsers unable to flag:\n'
        for k,v in pairs(groups[tostring(msg.chat.id)]['flag_blocked']) do
            message = message..'*'..i..'* - '..v..' (id: ' ..k.. ')\n'
            i = i + 1
        end
        
        mystat('flaglist') --save stats
        sendReply(msg, message, true)
    end
end

return {
	action = action,
	triggers = triggers
}
