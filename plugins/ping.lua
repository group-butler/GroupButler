local action = function(msg, blocks, ln)
	if blocks[1] == 'ping' then
		api.sendMessage(msg.from.id, lang[ln].ping)
		mystat('/ping') --save stats
	end
	if blocks[1] == 'helpme' then
		if not is_owner(msg) or msg.chat.type == 'private' then
			return
		end
		client:sadd('bot:tofix', msg.chat.id)
		change_one_header(msg.chat.id)
		api.sendReply(msg, 'All should be ok now.\nIf not, contact the bot owner! (with _/c_ command)', true)
	end
	if blocks[1] == 'fixextra' then
		if not is_owner(msg) or msg.chat.type == 'private' then
			return
		end
		client:sadd('bot:tofixextra', msg.chat.id)
		change_extra_header(msg.chat.id)
		api.sendReply(msg, 'All should be ok now.\nIf not, contact the bot owner! (with _/c_ command)', true)
	end
end

return {
	action = action,
	triggers = {
		'^/(ping)$',
		'^/(ping)@'..bot.username..'$',
		'^/(helpme)$',
		'^/(fixextra)$'
	}
}