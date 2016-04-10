local triggers = {
	'^/(commands)$',
	'^/(commands)@groupbutler_bot',
	'^/(stats)$',
	'^/(stats)@groupbutler_bot',
	'^/(redis save)$'
	
}

local action = function(msg, blocks, ln)
    
    print('\n/getstats', msg.from.first_name..' ['..msg.from.id..']')
    
    --ignore if not admin
    if msg.from.id ~= config.admin then
        print('\27[31mNil: not admin\27[39m')
		return nil
	end
	
	local text = 'Stats:\n'
	
	--save redis datas and end the function
	if blocks[1] == 'redis save' then
		client:bgsave()
		local out = make_text(lang[ln].getstats.redis)
		sendMessage(msg.chat.id, out, true, false, true)
		return nil
	end
	
	if blocks[1] == 'commands' then
	    local hash = 'commands:stats'
	    local names = client:hkeys(hash)
	    local num = client:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: '..num[i]..'\n'
	    end
    end

    if blocks[1] == 'stats' then
        local hash = 'bot:general'
	    local names = client:hkeys(hash)
	    local num = client:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: '..num[i]..'\n'
	    end
    end
    
    local out = make_text(lang[ln].getstats.stats, text)
	sendMessage(msg.chat.id, out, true, false, true)
end

return {
	action = action,
	triggers = triggers
}