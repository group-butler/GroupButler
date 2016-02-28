local triggers = {
	'^/(c)$', --warn if not input
	'^/(c) (.*)',
	'^/(reply)$', --warn if not input
	'^/(reply) (.*)'
}

local action = function(msg, blocks)
    
    -- ignore if the chat is a group or a supergroup
    if msg.chat.type ~= 'private' then
    	print('NO PV report.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        return nil
    end
    
    if blocks[1] == 'c' then
    	
    	print('\n/c', msg.from.first_name..' ['..msg.from.id..']')
        
        local receiver = config.admin
        local input = blocks[2]
        
        --allert if not feedback
        if not input then
        	print('\27[31mNil: no text\27[39m')
            sendMessage(msg.from.id, 'Write your suggestions/bugs/doubt near "/contact"')
            return nil
        end
        
        local last_name = ''
        --if msg.from.last_name then
            --last_name = '\n*Last*: '..msg.from.last_name
        --end
        --local text = '*First*: '..msg.from.first_name..last_name..'\n*Username*: @'..msg.from.username..' ('..msg.from.id..')\n\n'..input
	    --sendMessage(receiver, text, true, false, true)
	    local target = msg.message_id
	    
	    mystat('c') --save stats
	    forwardMessage (receiver, msg.from.id, target)
	    sendMessage(msg.from.id, '*Feedback sent*:\n\n'..input, true, false, true)
	end
	
	if blocks[1] == 'reply' then
		
		print('\n/reply', msg.from.first_name..' ['..msg.from.id..']')
		
	    --ignore if not admin
	    if msg.from.id ~= config.admin then
	    	print('\27[31mNil: not admin\27[39m')
	        return nil
	    end
	    
	    --ignore if no reply
	    if not msg.reply_to_message then
	    	print('\27[31mNil: no reply\27[39m')
            sendReply(msg, 'Reply to a feedback to reply to the user', false)
			return nil
		end
		
		local input = blocks[2]
		
		--ignore if not imput
		if not input then
			print('\27[31mNil: no input text\27[39m')
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