 -- Actually the simplest plugin ever!

local triggers = {
	'^/(info)'
}

local action = function(msg)
	
	print('\n/info', msg.from.first_name..' ['..msg.from.id..']')
	
	local text = 'This bot is based on [GroupButler bot](https://github.com/RememberTheAir/GroupButler), an *opensource* bot available on [Github](https://github.com/). Follow the link to know how the bot works or which data are stored.\n'
	text = text..'\nRemember you can always use /r command to ask something.'
	
	mystat('info')
	sendMessage(msg.from.id, text, true, false, true)
end

return {
	action = action,
	triggers = triggers
}
