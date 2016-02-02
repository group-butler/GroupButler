local command = 'setabout <about>'
local doc = [[```
/nick <nickname>
Set your nickname. Use "/whoami" to check your nickname and "/nick -" to delete it.
```]]

local triggers = {
	'^/setabout[@'..bot.username..']*',
	'^/about[@'..bot.username..']*',
	'^/addabout[@'..bot.username..']*',
	
}

local action = function(msg)
	if msg.chat.type == 'private' then
		sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    groups = load_data('groups.json')
    --/about
    if string.match(msg.text, '^/about') then
    	if is_locked(msg, 's_about') and not is_mod(msg) then
    		return nil
    	end
    	mystat('abt')
        about = groups[tostring(msg.chat.id)]['about']
        if not about then
            sendReply(msg, '*NO BIO* for this group.', true)
        else
            sendReply(msg, '*Bio of '..msg.chat.title..':*\n'..about..'', true)
        end
        return nil
    end
	--/ADDabout
	if string.match(msg.text, '^/addabout') then
		if not is_mod(msg) then
			sendReply(msg, 'You are *not* a moderator', true)
			return nil
		end
		mystat('aabt')
	    about = groups[tostring(msg.chat.id)]['about']
        if not about then
            sendReply(msg, '*No bio for this group.\nUse /setabout [bio] to set-up a new description', true)
        else
            local input = msg.text:input()
            if not input then
		        sendReply(msg, 'Please write something next this poor "/addabout" or *gtfo*', true)
		        return nil
	        end
            about = about..'\n'..input
            groups[tostring(msg.chat.id)]['about'] = tostring(about)
            save_data('groups.json', groups)
            sendReply(msg, '*Description added:*\n"'..input..'"', true)
        end
        return nil
    end
	--/SETabout
	local input = msg.text:input()
	if not is_mod(msg) then
		sendReply(msg, 'You are *not* a moderator', true)
		return nil
	end
	mystat('sabt')
	if not input then
		sendReply(msg, 'Please write something next this poor "/setabout" or *gtfo*', true)
		return true
	end

	if input == 'clean' then
		groups[tostring(msg.chat.id)]['about'] = nil
		sendReply(msg, 'The bio has been cleaned.')
	else
		groups[tostring(msg.chat.id)]['about'] = input
		sendReply(msg, '*New bio:*\n"'..input..'"', true)
	end

	save_data('groups.json', groups)
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}