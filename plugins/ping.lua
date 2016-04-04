local triggers = {
	'^/(ping)$',
	'^/(ping redis)$'
}

local action = function(msg, blocks)
	
	print('\n/ping', msg.from.first_name..' ['..msg.from.id..']')
	
	if blocks[1] == 'ping redis' then
		if msg.from.id ~= config.admin then
			print('\27[31mNil: not admin\27[39m')
			return
		end
		local ris = client:ping()
		if ris == true then
			sendMessage(msg.from.id, 'Pong')
		end
	end
	
	if blocks[1] == 'ping' then
		sendMessage(msg.from.id, 'Pong')
	end
	
	mystat('ping') --save stats
end

return {
	action = action,
	triggers = triggers
}