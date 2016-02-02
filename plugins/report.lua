local triggers = {
	'^/c[@'..bot.username..']*',
	'^/reply[@'..bot.username..']*',
}

local action = function(msg)
    if msg.chat.type ~= 'private' then
        return nil
    end
    if string.match(msg.text, '^/c') then
        mystat('con')
        local receiver = config.admin
        local input = msg.text:input()
        if not input then
            sendMessage(msg.from.id, 'Write your suggestions/bugs/douts near "/contact"')
            return nil
        end
        local last_name = ''
        --if msg.from.last_name then
            --last_name = '\n*Last*: '..msg.from.last_name
        --end
        --local text = '*First*: '..msg.from.first_name..last_name..'\n*Username*: @'..msg.from.username..' ('..msg.from.id..')\n\n'..input
	    --sendMessage(receiver, text, true, false, true)
	    local target = msg.message_id
	    forwardMessage (receiver, msg.from.id, target)
	    sendMessage(msg.from.id, '*Feedback sent*:\n\n'..input, true, false, true)
	end
	if string.match(msg.text, '^/reply') then
	    if msg.from.id ~= config.admin then
	        return nil
	    end
	    if not msg.reply_to_message then
            sendReply(msg, 'Reply to a feedback to reply to the user', false)
			return nil
		end
		local input = msg.text:input()
		if not input then
            sendMessage(msg.from.id, 'Write your reply next to "/reply"')
            return nil
        end
		msg = msg.reply_to_message
		local name = msg.forward_from.first_name
		local receiver = msg.forward_from.id
		local feed = msg.text:sub(4, 14)
		local text = 'Hi *'..name..'*, this is a reply to your feedback:\n"'..feed..'..."\n\n*Reply*:\n'..input
		sendMessage(receiver, text, true, false, true)
		sendMessage(config.admin, '*Reply sent*:\n\n'..input, true, false, true)
	end
end

return {
	action = action,
	triggers = triggers
}