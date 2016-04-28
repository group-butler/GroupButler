local action = function(msg, blocks, ln)
    
    -- ignore if the chat is a group or a supergroup
    if msg.chat.type ~= 'private' then
        return nil
    end
    
    if blocks[1] == 'c' then
        local receiver = config.admin
        local input = blocks[2]
        
        --allert if not feedback
        if not input then
        	local out = make_text(lang[ln].report.no_input)
            api.sendMessage(msg.from.id, out)
            return nil
        end
	    
	    api.forwardMessage (receiver, msg.from.id, msg.message_id)
	    local out = make_text(lang[ln].report.sent, input)
	    api.sendMessage(msg.from.id, out)
	    mystat('/c')
	end
	
	if blocks[1] == 'reply' then
	    --ignore if not admin
	    if msg.from.id ~= config.admin then
	        return nil
	    end
	    
	    --ignore if no reply
	    if not msg.reply_to_message then
	    	local out = make_text(lang[ln].report.reply)
            api.sendReply(msg, out, false)
			return nil
		end
		
		local input = blocks[2]
		
		--ignore if not imput
		if not input then
			local out = make_text(lang[ln].report.reply_no_input)
            api.sendMessage(msg.from.id, out)
            return nil
        end
		
		msg = msg.reply_to_message
		local receiver = msg.forward_from.id
		local out = make_text(lang[ln].report.feedback_reply, input)
		
		api.sendMessage(receiver, out, true)
		api.sendMessage(config.admin, make_text(lang[ln].report.reply_sent, input), true)
		mystat('/reply')
	end
end

return {
	action = action,
	triggers = {
		'^/(c)$', --warn if not input
		'^/(c) (.*)',
		'^/(reply)$', --warn if not input
		'^/(reply) (.*)'
	}
}