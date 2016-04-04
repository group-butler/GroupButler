local triggers = {
	'^/(warn)$',
	'^/(warnmax) (%d%d?)$',
	'^/(getwarns)$',
	'^/(nowarns)$',
}

local action = function(msg, blocks)
    
    if msg.chat.type == 'private' then--return nil if it's a private chat
        print('PV flag.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
		sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
    
    if blocks[1] == 'warn' then
        
        print('\n/warn', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            return nil 
        end
        
		--warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: not a reply\27[39m')
            sendReply(msg, 'Reply to a message to warn the user')
		    return nil
	    end
		
		local replied = msg.reply_to_message --load the replied message
		
	    --return nil if an user flag a mod
	    if is_mod(replied) then
	        print('\27[31mNil: mod flagged\27[39m')
			sendReply(msg, 'An admin can\'t be warned')
	        return nil
	    end
		
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot flagged\27[39m')
	        return nil
	    end
	    
	    --check if there is an username of flagged user
	    local name = replied.from.first_name
        if replied.from.username then
            name = '@'..replied.from.username
        end
	    name = name:gsub('_', ''):gsub('*', '')
		
		local hash = 'warns:'..msg.chat.id
		local hash_set = 'warns:'..msg.chat.id..':max'
		local num = client:hincrby(hash, replied.from.id, 1)
		local nmax = client:get(hash_set)
		local text
		
		if tonumber(num) >= tonumber(nmax) then
			text = '❌*User* '..name..' *reached the max number of warns*❌'
		else
			local diff = tonumber(nmax)-tonumber(num)
			text ='⚠*️User* '..name..' *have been warned.*\n🔰_Number of warnings_   *'..num..'*\n⛔️_Max allowed_   *'..nmax..'* (*-'..diff..'*)'
		end
        
        mystat('warn') --save stats
        sendMessage(msg.chat.id, text, true, false, true)
    end
    
    if blocks[1] == 'warnmax' then
        
        print('\n/warnmax', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            return nil
        end
        
	    local hash = 'warns:'..msg.chat.id..':max'
		local old = client:get(hash)
		client:set(hash, blocks[2])
        local text = '🔄 Max number of warnings changed.\n🔹*Old* value: '..old..'\n🔺*New* max: '..blocks[2]
        mystat('warnmax') --save stats
        sendReply(msg, text, true)
    end
    
    if blocks[1] == 'getwarns' then
        
        print('\n/getwarns', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            print('\27[31mNil: not a mod\27[39m')
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            sendReply(msg, 'Reply to an user to check his numebr of warns')
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
		--return nil if an user flag a mod
	    if is_mod(replied) then
	        print('\27[31mNil: mod flagged\27[39m')
			sendReply(msg, 'An admin can\'t be warned')
	        return nil
	    end
		
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot flagged\27[39m')
	        return nil
	    end
	    
	    --check if there is an username of flagged user
	    local name = replied.from.first_name
        if replied.from.username then
            name = '@'..replied.from.username
        end
	    name = name:gsub('_', ''):gsub('*', '')
		
		local hash = 'warns:'..msg.chat.id
		local hash_set = 'warns:'..msg.chat.id..':max'
		local num = client:hget(hash, replied.from.id)
		local nmax = client:get(hash_set)
		local text
		
		--if there isn't the hash
		if not num then num = 0 end
		
		--check if over or under
		if tonumber(num) >= tonumber(nmax) then
			text = '⛔️This usern has already reached the max number of warnings (*'..num..'/'..nmax..'*)'
		else
			local diff = tonumber(nmax)-tonumber(num)
			text ='✅ This user is under the max number of warnings.\n🔰 *'..diff..'* warnings missing on a total of *'..nmax..'* (*'..num..'/'..nmax..'*)'
		end
        
        mystat('getwarns') --save stats
        sendReply(msg, text, true)
    end
    
    if blocks[1] == 'nowarns' then
        
        print('\n/noworns', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
        
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
	    
		--return nil if an user flag a mod
	    if is_mod(replied) then
	        print('\27[31mNil: mod flagged\27[39m')
			sendReply(msg, 'An admin can\'t be flagged')
	        return nil
	    end
		
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot flagged\27[39m')
	        return nil
	    end
		
		local hash = 'warns:'..msg.chat.id
		client:hdel(hash, replied.from.id)
		
		local text = '🔰 The number of warns received by this user have been *resetted*'
        
        mystat('noworns') --save stats
        sendReply(msg, text, true)
    end
end

return {
	action = action,
	triggers = triggers
}