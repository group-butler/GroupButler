local action = function(msg, blocks, ln)
	api.sendMessage(msg.from.id, lang[ln].ping)
	mystat('/ping') --save stats
end

return {
	action = action,
	triggers = {
		'^/(ping)$',
		'^/(ping)@'..bot.username..'$'
	}
}