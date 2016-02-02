local command = 'whoami'
local doc = [[```
Returns user and chat info for you or the replied-to message.
Alias: /who
```]]

local triggers = {
	'^/tell*[@'..bot.username..']*$'
}

local action = function(msg)
	mystat('tell')
	if msg.reply_to_message then
		msg = msg.reply_to_message
	end
	local text = ''
	text = text..'*First name*: '..msg.from.first_name..'\n'
	if msg.from.last_name then
		text = text..'*Last name*: '..msg.from.last_name..'\n'
	end
	if msg.from.username then
		text = text..'*Username*: @'..msg.from.username..'\n'
	end
	text = text..'*ID*: '..msg.from.id..'\n'

	if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
		text = text..'\n*Group name*: '..msg.chat.title..'\n'
		text = text..'*Group ID*: '..msg.chat.id
		sendReply(msg, text, true)
	end
	
	if msg.chat.type == 'private' then
		text = text..'\nI am '..bot.first_name..'\n'
		text = text..'My username is '..bot.username..'\n'
		text = text..'My ID is '..bot.id
		sendMessage(msg.from.id, text, true, false, true)
	end

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
