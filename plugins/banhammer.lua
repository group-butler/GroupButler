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
		        api.sendReply(msg, text)
		        mystat('/kicked list')
		        return
		    end
		    if not msg.reply_to_message then
		        api.sendReply(msg, lang[ln].banhammer.reply)
		        return nil
		    end
		    if msg.reply.from.id == bot.id then
		    	return
		    end
		    local name = msg.reply.from.first_name
		    if msg.reply.from.username then
		        name = name..' [@'..msg.reply.from.username..']'
		    end
		 	local res
		 	if blocks[1] == 'kick' then
		 		if not is_mod(msg.reply) then
		    		api.kickUser(msg.chat.id, msg.reply.from.id, ln, name)
		    	end
	    	end
	   		if blocks[1] == 'ban' then
	    		if not is_mod(msg.reply_to_message) then
	    			api.banUser(msg.chat.id, msg.reply.from.id, ln, name)
		   			mystat('/ban')
		   		end
    		end
   			if blocks[1] == 'unban' then
   				if msg.chat.type == 'group' then
   					api.sendReply(msg, lang[ln].banhammer.no_unbanned)
   				else
   					api.unbanChatMember(msg.chat.id, msg.reply.from.id)
   					api.sendReply(msg, make_text(lang[ln].banhammer.unbanned, name))
   				end
   				mystat('/unban')
   			end
   			if blocks[1] == 'gban' then
   				print('in')
	   			if is_admin(msg) then
	   				local groups = client:smembers('bot:groupsid')
    				local succ = 0
    				local not_succ = 0
	    			for k,v in pairs(groups) do
	    				local res = api.banUser(v, msg.reply.from.id, ln, false, true)
	    				if res then
	    					print('Global banned', v)
	   						succ = succ + 1
	   					else
	   						print('Not banned', v)
	   						not_succ = not_succ + 1
    					end
    				end
    				api.sendMessage(msg.chat.id, make_text(lang[ln].banhammer.globally_banned, name)..'\nDone: '..succ..'\nErrors: '..not_succ)
    				mystat('/gban')
    			end
    		end
		end
	else
    	api.sendMessage(msg.chat.id, lang[ln].pv)
	end
end

return {
	action = action,
	triggers = {
		'^/(kick)$',
		'^/(ban)$',
		'^/(kicked list)$',
		'^/(unban)$',
		'^/(gban)$'
	}
}