local action = function(msg, blocks, ln)
	
	if not is_mod(msg) then
		return
	end
	
	if msg.chat.type == 'private' then
	    api.sendMessage(msg.chat.id, lang[ln].pv)
	    return
	end
	if not blocks[2] then
		--show flood settings
	else
		if blocks[2]:match('(%d%d?)') then
			if tonumber(blocks[2]) < 4 or tonumber(blocks[2]) > 25 then
				api.sendReply(msg, make_text(lang[ln].floodmanager.number_invalid, blocks[2]), true)
				return
			end
	    	local new = tonumber(blocks[2])
	    	local old = tonumber(client:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
	    	if new == old then
	        	api.sendReply(msg, make_text(lang[ln].floodmanager.not_changed, new))
	    	else
	        	client:hset('chat:'..msg.chat.id..':flood', 'MaxFlood', new)
	        	api.sendReply(msg, make_text(lang[ln].floodmanager.changed, old, new))
	    	end
	    	mystat('/flood num')
		else
			--yes/no = antiflood disabled, so: yes->yes, disabled, no->no, not diabled
        	if blocks[2] == 'on' then
            	client:hset('chat:'..msg.chat.id..':settings', 'Flood', 'no')
            	api.sendReply(msg, lang[ln].floodmanager.enabled)
            	mystat('/flood on')
        	elseif blocks[2] == 'off' then
            	client:hset('chat:'..msg.chat.id..':settings', 'Flood', 'yes')
            	api.sendReply(msg, lang[ln].floodmanager.disabled)
            	mystat('/flood off')
        	elseif blocks[2] == 'ban' then
            	client:hset('chat:'..msg.chat.id..':flood', 'ActionFlood', 'ban')
            	api.sendReply(msg, lang[ln].floodmanager.ban)
            	mystat('/flood ban')
        	elseif blocks[2] == 'kick' then
            	client:hset('chat:'..msg.chat.id..':flood', 'ActionFlood', 'kick')
            	api.sendReply(msg, lang[ln].floodmanager.kick)
            	mystat('/flood kick')
        	end
        end
    end
end

return {
	action = action,
	triggers = {
		'^/(flood) (%d%d?)$',
		'^/(flood) (on)$',
		'^/(flood) (off)$',
		'^/(flood) (kick)$',
		'^/(flood) (ban)$',
		'^(flood)$'
	}
}