 -- Actually the simplest plugin ever!

local triggers = {
	'^/ping[@'..bot.username..']*'
}

local action = function(msg)
	
	print('\n/ping', msg.from.first_name..' ['..msg.from.id..']')
	
	sendMessage(msg.chat.id, 'Pong!')
end

return {
	action = action,
	triggers = triggers
}
