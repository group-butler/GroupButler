pre_process = function(msg, ln)
    --MaxFlood, AntiFlood, ActionFlood
    --check if admin here
    local spamhash = 'spam:'..msg.chat.id..':'..msg.from.id
    local msgs = tonumber(client:get(spamhash)) or 0
    if msgs == 0 then msgs = 1 end
    local max_msgs = tonumber(client:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
    local max_time = 5
    if msgs > max_msgs then
        local status = client:hget('chat:'..msg.chat.id..':settings', 'Flood') or 'yes'
        --how flood on/off works: yes->yes, antiflood is diabled. no->no, anti flood is not disbaled
        if status == 'no' then
            local action = client:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
            local name = msg.from.first_name
            if msg.from.username then name = name..' (@'..msg.from.username..')' end
            if action == 'ban' then
                kickChatMember(msg.chat.id, msg.from.id) --kick
		        unbanChatMember(msg.chat.id, msg.from.id) --unblock
		        client:hset('kicked:'..msg.chat.id, msg.from.id, name) --add in kicked list
		        print('Banned', msgs)
		        sendMessage(msg.chat.id, make_text(lang[ln].preprocess.flood_ban, name)) --send message
		    else
		        kickChatMember(msg.chat.id, msg.from.id) --kick
		        print('Kicked', msgs)
		        sendMessage(msg.chat.id, make_text(lang[ln].preprocess.flood_kick, name)) --send message
		    end
		end
    end
    client:setex(spamhash, max_time, msgs+1)
    
    if msg.media then
        local name = msg.from.first_name
        if msg.from.username then name = name..' (@'..msg.from.username..')' end
        local media = msg.text:gsub('###', '')
        local hash = 'media:'..msg.chat.id
        local status = client:hget(hash, media)
        if status == 'kick' then
            kickChatMember(msg.chat.id, msg.from.id) --kick
		    unbanChatMember(msg.chat.id, msg.from.id) --unblock
		    client:hset('kicked:'..msg.chat.id, msg.from.id, name) --add in kicked list
		    print('Kicked', media)
		    sendReply(msg, make_text(lang[ln].preprocess.media_kick, name), true)
	    elseif status == 'ban' then
	        kickChatMember(msg.chat.id, msg.from.id) --kick
		    print('Banned', media)
		    sendReply(msg, make_text(lang[ln].preprocess.media_ban, name), true)
		end
    end
    
    if client:hget('chat:'..msg.chat.id..':settings', 'Rtl') == 'yes' then --no = not disabled
        local name = msg.from.first_name
        if msg.from.username then name = name..' (@'..msg.from.username..')' end
        local rtl = '‮'
	    local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+')
	    if check ~= nil then 
	        print('RTL found')
	        kickChatMember(msg.chat.id, msg.from.id) --kick
		    unbanChatMember(msg.chat.id, msg.from.id) --unblock
		    sendReply(msg, make_text(lang[ln].preprocess.rtl, name), true)
	    end
    end
    
    if msg.text and msg.text:find('([\216-\219][\128-\191])') and client:hget('chat:'..msg.chat.id..':settings', 'Arab') == 'yes' then
        local name = msg.from.first_name
        if msg.from.username then name = name..' (@'..msg.from.username..')' end
        kickChatMember(msg.chat.id, msg.from.id) --kick
		unbanChatMember(msg.chat.id, msg.from.id) --unblock
		sendReply(msg, make_text(lang[ln].preprocess.arab, name), true)
    end
end


return pre_process