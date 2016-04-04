
local triggers = {
	'^/(tell)$'
}

local action = function(msg)
	
	print('\n/tell', msg.from.first_name..' ['..msg.from.id..']')
	
	--check if is a reply
	if msg.reply_to_message then
		msg = msg.reply_to_message
	end
	
	local text = ''
	text = text..'*First name*: '..msg.from.first_name..'\n'
	
	--check if the user has a last name
	if msg.from.last_name then
		text = text..'*Last name*: '..msg.from.last_name..'\n'
	end
	
	--check if the user has a username
	if msg.from.username then
		text = text..'*Username*: @'..msg.from.username..'\n'
	end
	
	--add the id
	text = text..'*ID*: '..msg.from.id..'\n'
	
	--if in a group, build group info
	if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
		text = text..'\n*Group name*: '..msg.chat.title..'\n'
		text = text..'*Group ID*: '..msg.chat.id
		sendReply(msg, text, true)
	else
		sendMessage(msg.from.id, text, true, false, true)
	end
	
	--if in private, return bot info too
	--if msg.chat.type == 'private' then
		--text = text..'\nI am '..bot.first_name..'\n'
		--text = text..'My username is '..bot.username..'\n'
		--text = text..'My ID is '..bot.id
		--sendMessage(msg.from.id, text, true, false, true)
	--end
		
	mystat('tell') --save stats
end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
