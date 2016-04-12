local triggers = {
	'^/(bc) (.*)$',
	'^/(bcg) (.*)$'
}

local action = function(msg, blocks, ln)
	
	if tonumber(msg.from.id) == config.admin then
	    if blocks[1] == 'bc' then
	        if breaks_markdown(blocks[2]) then
	            sendMessage(config.admin, lang[ln].breaks_markdown)
	            return
	        end
	        local hash = 'bot:users'
	        local ids = client:hkeys(hash)
	        if ids then
	            for i=1,#ids do
	                sendMessage(ids[i], blocks[2], true, false, true)
	                print('Sent', ids[i])
	            end
	            sendMessage(config.admin, lang[ln].broadcast.delivered)
	        else
	            sendMessage(config.admin, lang[ln].broadcast.no_user)
	        end
	    end
	    if blocks[1] == 'bcg' then
	        if breaks_markdown(blocks[2]) then
	            sendMessage(config.admin, lang[ln].breaks_markdown)
	            return
	        end
	        local groups= load_data('groups.json')
	        for k,v in pairs(json) do
	            sendMessage(k, blocks[2], true, false, true)
	            print('Sent', ids[i])
	        end
	        sendMessage(config.admin, lang[ln].broadcast.delivered)
	    end
	end
	
	
	mystat('broadcast') --save stats
end

return {
	action = action,
	triggers = triggers
}