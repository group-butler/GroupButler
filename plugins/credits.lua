local action = function(msg, blocks, ln)
	mystat('/credits')
	api.sendMessage(msg.chat.id, lang[ln].credits, true, true)
end

return {
	action = action,
	triggers = {
		'^/(info)'
	}
}
