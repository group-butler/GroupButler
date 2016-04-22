local action = function(msg, blocks, ln)
	--check if is a reply
	if msg.reply_to_message then
		msg = msg.reply_to_message
	end
	
	local text = ''
	text = text..make_text(lang[ln].tell.first_name, msg.from.first_name:neat())
	
	--check if the user has a last name
	if msg.from.last_name then
		text = text..make_text(lang[ln].tell.last_name, msg.from.last_name:neat())
	end
	
	--check if the user has a username
	if msg.from.username then
		text = text..'*Username*: @'..msg.from.username:neat()..'\n'
	end
	
	--add the id
	text = text..'*ID*: '..msg.from.id..'\n'
	
	--if in a group, build group info
	if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
		text = text..make_text(lang[ln].tell.group_name, msg.chat.title:neat())
		text = text..make_text(lang[ln].tell.group_id, msg.chat.id)
		api.sendReply(msg, text, true)
	else
		api.sendMessage(msg.from.id, text, true)
	end
		
	mystat('/tell') --save stats
end

return {
	action = action,
	triggers = {
		'^/(tell)$',
		'^/(tell@GroupButler_bot)$'
	}
}
