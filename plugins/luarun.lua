local triggers = {
	'^/lua'
}

local action = function(msg)
	
	print('\n/lua', msg.from.first_name..' ['..msg.from.id..']')
	
	--ignore if not admin
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end
	
	--check if there is an input
	local input = msg.text:input()
	if not input then
		print('\27[31mNil: no input\27[39m')
		sendReply(msg, 'Please enter a string to load.')
		return
	end
	
	--execute
	local output = loadstring(input)()
	if not output then
		output = 'Done!'
	else
		output = '```\n' .. output .. '\n```'
	end
	
	mystat('lua')
	sendMessage(msg.chat.id, output, true, msg.message_id, true)
end

return {
	action = action,
	triggers = triggers
}

