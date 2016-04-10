local triggers = {
	'^/lua'
}

local action = function(msg, blocks, ln)
	
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
		sendReply(msg, make_text(lang[ln].luarun.enter_string))
		return
	end
	
	--execute
	local output = loadstring(input)()
	if not output then
		output = make_text(lang[ln].luarun.done)
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

