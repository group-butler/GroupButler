local triggers = {
	'^/(ping)$',
	'^/(ping)@'..bot.username..'$'
}

local action = function(msg, blocks, ln)
	if blocks[1] == 'ping' then
		local text = make_text(lang[ln].ping)
		api.sendMessage(msg.chat.id, text)
	end
	mystat('ping') --save stats
end

return {
	action = action,
	triggers = triggers
}