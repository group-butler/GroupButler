local triggers = {
	'^/(flood) (%d%d?)$',
	'^/(flood) (on)$',
	'^/(flood) (off)$',
	'^/(flood) (kick)$',
	'^/(flood) (ban)$',
}

local action = function(msg, blocks, ln)
	
	--ceck if admin here
	
	--if msg.chat.type == 'private' then
	    --sendMessage(msg.chat.id, lang[ln].pv)
	    --return
	--end
	
	if blocks[2] == '%d%d?' then
	    local new = tonumber(blocks[2])
	    local old = tonumber(client:hget('chat:'..msg.chat.id..':settings', 'MaxFlood')) or 5
	    print(old, new)
	    if new == old then
	        sendReply(msg.chat.id, make_text(lang[ln].floodmanager.not_changed, new))
	    else
	        client:hset('chat:'..msg.chat.id..':settings', 'MaxFlood', new)
	        sendReply(msg, make_text(lang[ln].floodmanager.changed, old, new))
	    end
    else
        if blocks[2] == 'on' then
            client:hset('chat:'..msg.chat.id..':settings', 'AntiFlood', 'yes')
            sendReply(msg, lang[ln].floodmanager.enabled)
        elseif blocks[2] == 'off' then
            client:hset('chat:'..msg.chat.id..':settings', 'AntiFlood', 'no')
            sendReply(msg, lang[ln].floodmanager.disabled)
        elseif blocks[2] == 'ban' then
            client:hset('chat:'..msg.chat.id..':settings', 'ActionFlood', 'ban')
            sendReply(msg, lang[ln].floodmanager.ban)
        elseif blocks[2] == 'kick' then
            client:hset('chat:'..msg.chat.id..':settings', 'ActionFlood', 'kick')
            sendReply(msg, lang[ln].floodmanager.kick)
        end
    end
    
	
	mystat('floodmanager') --save stats
end

return {
	action = action,
	triggers = triggers
}