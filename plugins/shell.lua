local triggers = {
	'^/run[@'..bot.username..']*'
}

local action = function(msg)

	print('\n/run', msg.from.first_name..' ['..msg.from.id..']')

	--ignore if not admin
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end

	local input = msg.text:input()
	
	--ignore if not input text
	if not input then
		print('\27[31mNil: no input text\27[39m')
		sendReply(msg, 'Please specify a command to run.')
		return
	end
	
	--read the output
	local output = io.popen(input):read('*all')
	
	--check if the output has a text
	if output:len() == 0 then
		output = 'Done!'
	else
		output = '```\n' .. output .. '\n```'
	end
	
	sendMessage(msg.chat.id, output, true, msg.message_id, true)
end

return {
	action = action,
	triggers = triggers
}
