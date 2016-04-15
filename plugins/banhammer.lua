local triggers = {
	'^/(kick)$',
	'^/(ban)$',
	'^/(kicked list)$',
	'^/(gban)$'
}

local action = function(msg, blocks, ln)
	if msg.chat.type ~= 'private' then
		if is_mod(msg) then
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
		        return
		    else
		    	if not msg.reply_to_message then
		        	sendReply(msg, lang[ln].banhammer.reply)
		        	return nil
		    	end
		    	local name = msg.reply_to_message.from.first_name
		    	if msg.reply_to_message.from.username then
		        	name = name..' [@'..msg.reply_to_message.from.username..']'
		    	end
		 		if blocks[1] == 'kick' then
		 			if not is_mod(msg.reply_to_message) then
			     		local hash = 'kicked:'..msg.chat.id
	        			client:hset(hash, msg.reply_to_message.from.id, name)
		    			kickChatMember(msg.chat.id, msg.reply_to_message.from.id)
		    			unbanChatMember(msg.chat.id, msg.reply_to_message.from.id)
		    			sendMessage(msg.chat.id, make_text(lang[ln].banhammer.kicked, name))
		    		end
	    		end
	    		if blocks[1] == 'ban' then
	    			if not is_mod(msg.reply_to_message) then
		    			kickChatMember(msg.chat.id, msg.reply_to_message.id)
		    			sendMessage(msg.chat.id, make_text(lang[ln].banhammer.banned, name))
		    		end
	    		end
	    		if blocks[1] == 'gban' then
	    			if tonumber(msg.from.id) ~= config.admin then
	    				local groups = load_data('groups.json')
	    				for k,v in pairs(groups) do
	    					kickChatMember(k, msg.reply_to_message.from.id)
	    					print('Global banned', k)
	    				end
	    				sendMessage(msg.chat.id, make_text(lang[ln].banhammer.globally_banned, name))
	    			end
	    		end
	
	    		mystat('banhammer') --save stats
			end
		end
	else
	    sendMessage(msg.chat.id, lang[ln].pv)
	end
end

return {
	action = action,
	triggers = triggers
}