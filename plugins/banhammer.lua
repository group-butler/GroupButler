local triggers = {
	'^/(kick)$',
	'^/(ban)$',
	'^/(kicked list)$'
}

local action = function(msg, blocks, ln)
	if msg.chat.type ~= 'private' then
	    if blocks[1] == 'kicked list' then
	        --check if setting is unlocked here
	        local hash = 'kicked:'..msg.chat.id
	        local kicked_list = client:hvals(hash)
	        local text = make_text(lang[ln].banhammer.kicked_header)
	        for i=1,#kicked_list do
	            text = text..i..' - '..kicked_list[i]
	        end
	        if text == lang[ln].banhammer.kicked_header then
	            text = lang[ln].banhammer.kicked_empty
	        end
	        sendReply(msg, text)
	    end
	    --admin check here
	    if not msg.reply_to_message then
	        sendReply(msg, lang[ln].banhammer.reply)
	        return nil
	    end
	    local name = msg.reply_to_message.first_name
	    if msg.reply_to_message.username then
	        name = name..' [@'..msg.reply_to_message.username..']'
	    end
    	if blocks[1] == 'kick' then
	        local hash = 'kicked:'..msg.chat.id
	        --add time of kick
	        client:hset(hash, msg.reply_to_message.id, name)
		    kickChatMember(msg.chat.id, msg.reply_to_message.id)
		    unbanChatMember(msg.chat.id, msg.reply_to_message.id)
		    sendMessage(msg.chat.id, make_text(lang[ln].banhammer.kicked, name))
	    end
	    if blocks[1] == 'ban' then
		    kickChatMember(msg.chat.id, msg.reply_to_message.id)
		    sendMessage(msg.chat.id, make_text(lang[ln].banhammer.banned, name))
	    end
	
	    mystat('banhammer') --save stats
	else
	    sendMessage(msg.chat.id, lang[ln].pv)
	end
end

return {
	action = action,
	triggers = triggers
}