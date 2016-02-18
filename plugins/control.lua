local triggers = {
	'^/reload[@'..bot.username..']*',
	'^/halt[@'..bot.username..']*'
}

local action = function(msg)
	
	print('\n/reload or /halt', msg.from.first_name..' ['..msg.from.id..']')
	
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end
	mystat('rel')
	if msg.text:match('^/reload') then
		bot_init()
		sendReply(msg, 'Bot reloaded!')
	elseif msg.text:match('^/halt') then
		is_started = false
		sendReply(msg, 'Stopping bot!')
	end

end

return {
	action = action,
	triggers = triggers
}

