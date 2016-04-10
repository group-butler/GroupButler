local triggers = {
	'^/(run) (.*)'
}

local action = function(msg, blocks, ln)

	print('\n/run', msg.from.first_name..' ['..msg.from.id..']')

	--ignore if not admin
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end

	local input = blocks[2]
	
	--ignore if not input text
	if not input then
		print('\27[31mNil: no input text\27[39m')
		sendReply(msg, make_text(lang[ln].shell.no_input))
		return
	end
	
	--read the output
	local output = io.popen(input):read('*all')
	
	--check if the output has a text
	if output:len() == 0 then
		output = make_text(lang[ln].shell.done)
	else
		output = make_text(lang[ln].shell.output, output)
	end
	
	mystat('run') --save stats
	sendMessage(msg.chat.id, output, true, msg.message_id, true)
end

return {
	action = action,
	triggers = triggers
}
