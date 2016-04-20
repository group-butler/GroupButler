 -- Actually the simplest plugin ever!

local triggers = {
	'^/(info)@groupbutler_bot',
	'^/(info)'
}

local action = function(msg, blocks, ln)
	mystat('/credits')
	api.sendMessage(msg.from.id, lang[ln].credits, true, true)
end

return {
	action = action,
	triggers = triggers
}
