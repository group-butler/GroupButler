local triggers = {
	'^/(warn)$',
	'^/(warn) (kick)$',
	'^/(warn) (ban)$',
	'^/(warnmax) (%d%d?)$',
	'^/(getwarns)$',
	'^/(nowarns)$',
}

local action = function(msg, blocks, ln)
    
    if msg.chat.type == 'private' then--return nil if it's a private chat
        print('PV flag.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
		api.sendMessage(msg.from.id, make_text(lang[ln].pv))
    	return nil
    end
    
    if blocks[1] == 'warn' then
        
        --return nil if not mod
        if not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            return nil 
        end
        
        --action do do when max number of warns change:
		if blocks[2] then
			local hash = 'warns:'..msg.chat.id..':type'
			client:set(hash, blocks[2])
			api.sendReply(msg, make_text(lang[ln].warn.changed_type, blocks[2]), true)
			return
		end	
        
		--warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: not a reply\27[39m')
            api.sendReply(msg, make_text(lang[ln].warn.warn_reply))
		    return nil
	    end
		
		local replied = msg.reply_to_message --load the replied message
		
	    --return nil if a mod is warned
	    if is_mod(replied) then
	        print('\27[31mNil: mod warned\27[39m')
			api.sendReply(msg, make_text(lang[ln].warn.mod))
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
			text = make_text(lang[ln].warn.warned_max_kick, name)
			local type = client:get('warns:'..msg.chat.id..':type')
			if type == 'ban' then
				text = make_text(lang[ln].warn.warned_max_ban, name)
				api.kickChatMember(msg.chat.id, replied.from.id)
				print('banned')
		    else
		    	api.kickChatMember(msg.chat.id, replied.from.id)
		    	api.unbanChatMember(msg.chat.id, replied.from.id)
		    	print('Kicked')
		    	text = make_text(lang[ln].warn.warned_max_kick, name)
		    end
		else
			local diff = tonumber(nmax)-tonumber(num)
			text = make_text(lang[ln].warn.warned, name, num, nmax, diff)
		end
        
        mystat('warn') --save stats
        api.sendReply(msg.chat.id, text, true)
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
        local text = make_text(lang[ln].warn.warnmax, old, blocks[2])
        mystat('warnmax') --save stats
        api.sendReply(msg, text, true)
    end
    
    if blocks[1] == 'getwarns' then
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            print('\27[31mNil: not a mod\27[39m')
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            api.sendReply(msg, make_text(lang[ln].warn.getwarns_reply))
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
		--return nil if an user flag a mod
	    if is_mod(replied) then
	        print('\27[31mNil: mod flagged\27[39m')
			api.sendReply(msg, make_text(lang[ln].warn.mod))
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
			text = make_text(lang[ln].warn.limit_reached, num, nmax)
		else
			local diff = tonumber(nmax)-tonumber(num)
			text = make_text(lang[ln].warn.limit_lower, diff, nmax, num, nmax)
		end
        
        mystat('getwarns') --save stats
        api.sendReply(msg, text, true)
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
            api.sendReply(msg, make_text(lang[ln].warn.nowarn_reply))
		    return nil
	    end
	    
	    local replied = msg.reply_to_message
	    
		--return nil if an user flag a mod
	    if is_mod(replied) then
	        print('\27[31mNil: mod flagged\27[39m')
			api.sendReply(msg, make_text(lang[ln].warn.mod))
	        return nil
	    end
		
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        print('\27[31mNil: bot flagged\27[39m')
	        return nil
	    end
		
		local hash = 'warns:'..msg.chat.id
		client:hdel(hash, replied.from.id)
		
		local text = make_text(lang[ln].warn.nowarn)
        
        mystat('noworns') --save stats
        api.sendReply(msg, text, true)
    end
end

return {
	action = action,
	triggers = triggers
}