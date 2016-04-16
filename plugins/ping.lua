local triggers = {
	'^/(ping)$',
	'^/(ping)@'..bot.username..'$'
}

local action = function(msg, blocks, ln)
	if blocks[1] == 'ping' then
		api.sendMessage(msg.chat.id, lang[ln].ping)
	end
	mystat('ping') --save stats
end

return {
	action = action,
	triggers = triggers
}