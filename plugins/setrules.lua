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
    if msg.chat.type == 'private' then
    	sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    groups = load_data('groups.json')
    --sendMessage(msg.chat.id, 'Chat id: '..msg.chat.id..'\n'..check, true, false, false)
    --/RULES
    if string.match(msg.text, '^/rules') then
    	if is_locked(msg, 's_rules') and not is_mod(msg) then
    		return nil
    	end
    	mystat('rls')
        rules = groups[tostring(msg.chat.id)]['rules']
        if not rules then
            sendReply(msg, '*TOTAL ANARCHY* for this group.', true)
        else
            sendReply(msg, '*Rules for '..msg.chat.title..':*\n'..rules..'', true)
        end
        return nil
    end
	--/ADDRULES
	if string.match(msg.text, '^/addrules') then
		if not is_mod(msg) then
			sendReply(msg, 'You are *not* a moderator', true)
			return nil
		end
		mystat('arls')
	    rules = groups[tostring(msg.chat.id)]['rules']
        if not rules then
            sendReply(msg, '*No for this group.\nUse /setrules [rules] to set-up a new constitution', true)
        else
            local input = msg.text:input()
            if not input then
		        sendReply(msg, 'Please write something next this poor "/addrules" or *gtfo*', true)
		        return nil
	        end
            rules = rules..'\n'..input
            groups[tostring(msg.chat.id)]['rules'] = tostring(rules)
            save_data('groups.json', groups)
            sendReply(msg, '*Rules added:*\n"'..input..'"', true)
        end
        return nil
    end
	--/SETRULES
	if not is_mod(msg) then
		sendReply(msg, 'You are *not* a moderator', true)
		return nil
	end
	mystat('srls')
	local input = msg.text:input()
	if not input then
		sendReply(msg, 'Please write something next this poor "/setrules" or *gtfo*', true)
		return true
	end

	if input == 'clean' then
		groups[tostring(msg.chat.id)]['rules'] = nil
		sendReply(msg, 'Rules has been cleaned.')
	else
		groups[tostring(msg.chat.id)]['rules'] = input
		sendReply(msg, '*New rules:*\n"'..input..'"', true)
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