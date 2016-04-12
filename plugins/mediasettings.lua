local triggers = {
	'^/(kick) (.*)$',
	'^/(ban) (.*)$',
	'^/(allow) (.*)$',
	'^/(media list)$',
	'^/(media)$'
}

local action = function(msg, blocks, ln)
	--if msg.chat.type == 'private' then
	    --sendMessage(msg.chat.id, lang[ln].pv)
	    --return
	--end
	--admin assertion here
	local list = {'image', 'audio', 'video', 'sticker', 'voice', 'contact', 'file'}
	if blocks[1] == 'media list' then
	    local text = lang[ln].mediasettings.list_header
	    for i=1,#list do
	        text = text..i..' ▸ `'..list[i]..'`\n'
	    end
	    sendReply(msg, text, true)
	elseif blocks[1] == 'media' then
		local media_sett = client:hgetall('media:'..msg.chat.id)
		local text = lang[ln].mediasettings.settings_header
		for k,v in pairs(media_sett) do
			text = text..'`'..k..'`'..' ≡ '..v..'\n'
		end
		sendReply(msg, text, true)
	else
	    local media = blocks[2]
	    local status = blocks[1]
	    local valid = false
	    for i=1, #list do
	        if media == list[i] then
	            valid = true
	            break
	        end
	    end
	    if valid then
	        local old_status = client:hget('media:'..msg.chat.id, media)
	        if old_status == status then
	            sendReply(msg, make_text(lang[ln].mediasettings.already, media, status), true)
	        else
	            if status == 'allow' then status = 'allowed' end --change the text passed to make-text
	            client:hset('media:'..msg.chat.id, media, status)
	            sendReply(msg, make_text(lang[ln].mediasettings.changed, media, status), true)
	        end
        else
            sendReply(msg, lang[ln].mediasettings.wrong_input)
        end
    end
	    
	    
	
	mystat('media settings') --save stats
end

return {
	action = action,
	triggers = triggers
}