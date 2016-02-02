local triggers = {
	'^/run[@'..bot.username..']*'
}

local action = function(msg)

	if msg.from.id ~= config.admin then
		return
	end

	local input = msg.text:input()
	if not input then
		sendReply(msg, 'Please specify a command to run.')
		return
	end

	local output = io.popen(input):read('*all')
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
