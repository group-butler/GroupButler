local action = function(msg, blocks, ln)
    
    if msg.chat.type == 'private' then--return nil if it's a private chat
		api.sendMessage(msg.from.id, make_text(lang[ln].pv))
    	return nil
    end
    
    if blocks[1] == 'warn' then
        
        --return nil if not mod
        if not is_mod(msg) then
            return nil 
        end
        
        --action do do when max number of warns change:
		if blocks[2] then
			local hash = 'chat:'..msg.chat.id..':warntype'
			db:set(hash, blocks[2])
			api.sendReply(msg, make_text(lang[ln].warn.changed_type, blocks[2]), true)
			return
		end	
        
		--warning to reply to a message
        if not msg.reply then
            api.sendReply(msg, make_text(lang[ln].warn.warn_reply))
		    return nil
	    end
		
	    --return nil if a mod is warned
	    if is_mod(msg.reply) then
			api.sendReply(msg, make_text(lang[ln].warn.mod))
	        return nil
	    end
				
	    --return nil if an user flag the bot
	    if msg.reply.from.id == bot.id then
	        return nil
	    end
	    
	    --check if there is an username of flagged user
	    local name = msg.reply.from.first_name
        if msg.reply.from.username then
            name = '@'..msg.reply.from.username
        end
	    name = name:gsub('_', ''):gsub('*', '')
		
		local hash = 'chat:'..msg.chat.id..':warns'
		local hash_set = 'chat:'..msg.chat.id..':max'
		local num = db:hincrby(hash, msg.reply.from.id, 1)
		local nmax = (db:get(hash_set)) or 5
		local text, res, motivation
		
		if tonumber(num) >= tonumber(nmax) then
			text = make_text(lang[ln].warn.warned_max_ban, name:mEscape())
			local type = db:get('chat:'..msg.chat.id..':warntype')
			name = name..' (->'..num..'/'..nmax..')'
			if type == 'ban' then
				res, motivation = api.banUser(msg.chat.id, msg.reply.from.id, ln)
				if not res then text = motivation end
	    	else
	    		text = make_text(lang[ln].warn.warned_max_kick, name:mEscape())
	    		local is_normal_group = false
	    		if msg.chat.type == 'group' then is_normal_group = true end
		    	res, motivation = api.kickUser(msg.chat.id, msg.reply.from.id, is_normal_group, ln)
		    	if not res then text = motivation end
		    end
		    return --avoid to send another reply 6 lines below
		else
			local diff = tonumber(nmax)-tonumber(num)
			text = make_text(lang[ln].warn.warned, name, num, nmax, diff)
		end
        
        mystat('/warn') --save stats
        api.sendReply(msg, text, true)
    end
    
    if blocks[1] == 'warnmax' then--return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        
	    local hash = 'chat:'..msg.chat.id..':max'
		local old = (db:get(hash)) or 5
		db:set(hash, blocks[2])
        local text = make_text(lang[ln].warn.warnmax, old, blocks[2])
        mystat('/warnmax') --save stats
        api.sendReply(msg, text, true)
    end
    
    if blocks[1] == 'getwarns' then
        
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply_to_message then
            api.sendReply(msg, make_text(lang[ln].warn.getwarns_reply))
		    return nil
	    end
	    
		--return nil if an user flag a mod
	    if is_mod(msg.reply) then
			api.sendReply(msg, make_text(lang[ln].warn.mod))
	        return nil
	    end
		
	    --return nil if an user flag the bot
	    if msg.reply.from.id == bot.id then
	        return nil
	    end
	    
	    --check if there is an username of flagged user
	    local name = msg.reply.from.first_name
        if msg.reply.from.username then
            name = '@'..msg.reply.from.username
        end
	    name = name:gsub('_', ''):gsub('*', '')
		
		local hash = 'chat:'..msg.chat.id..':warns'
		local hash_set = 'chat:'..msg.chat.id..':max'
		local num = db:hget(hash, msg.reply.from.id)
		local nmax = (db:get(hash_set)) or 5
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
        
        mystat('/getwarns') --save stats
        api.sendReply(msg, text, true)
    end
    
    if blocks[1] == 'nowarns' then
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        
        --warning to reply to a message
        if not msg.reply then
            api.sendReply(msg, make_text(lang[ln].warn.nowarn_reply))
		    return nil
	    end
	    
		--return nil if an user flag a mod
	    if is_mod(msg.reply) then
			api.sendReply(msg, make_text(lang[ln].warn.mod))
	        return nil
	    end
		
	    --return nil if an user flag the bot
	    if msg.reply.from.id == bot.id then
	        return nil
	    end
		
		local hash = 'chat:'..msg.chat.id..':warns'
		db:hdel(hash, msg.reply.from.id)
		
		local text = make_text(lang[ln].warn.nowarn)
        
        mystat('/nowarns') --save stats
        api.sendReply(msg, text, true)
    end
end

return {
	action = action,
	triggers = {
		'^/(warn)$',
		'^/(warn) (kick)$',
		'^/(warn) (ban)$',
		'^/(warnmax) (%d%d?)$',
		'^/(getwarns)$',
		'^/(nowarns)$',
	}
}