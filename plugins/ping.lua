local triggers = {
	'^/(ping)$',
	'^/(ping)@groupbutler_bot$',
	'^/(ping redis)$'
}

local action = function(msg, blocks, ln)
	
	print('\n/ping', msg.from.first_name..' ['..msg.from.id..']')
	
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