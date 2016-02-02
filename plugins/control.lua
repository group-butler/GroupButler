local triggers = {
	'^/reload[@'..bot.username..']*',
	'^/halt[@'..bot.username..']*'
}

local action = function(msg)

	if msg.from.id ~= config.admin then
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

