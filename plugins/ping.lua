local triggers = {
	'^/(ping)$',
	'^/(ping)@'..bot.username..'$',
	'^/(ping redis)$'
}

local function on_each_msg(msg, ln)
	print('in')
	return msg
end

local action = function(msg, blocks, ln)
	
	if blocks[1] == 'ping redis' then
		if msg.from.id ~= config.admin then
			print('\27[31mNil: not admin\27[39m')
			return
		end
		local ris = client:ping()
		if ris == true then
			local text = make_text(lang[ln].ping)
			sendMessage(msg.from.id, text)
		end
	end
	
	if blocks[1] == 'ping' then
		local text = make_text(lang[ln].ping)
		sendMessage(msg.from.id, text)
	end
	
	mystat('ping') --save stats
end

return {
	action = action,
	triggers = triggers
}