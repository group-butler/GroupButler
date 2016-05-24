local action = function(msg, blocks, ln)
	if msg.chat.type == 'private' then
	    api.sendMessage(msg.chat.id, lang[ln].pv)
	    return
	end
	if not is_mod(msg) then
		return
	end
	local list = {'image', 'audio', 'video', 'sticker', 'gif', 'voice', 'contact', 'file'}
	if blocks[1] == 'media list' then
	    local text = lang[ln].mediasettings.list_header
	    for i=1,#list do
	        text = text..i..' ▸ `'..list[i]..'`\n'
	    end
	    api.sendReply(msg, text, true)
	    mystat('/media list')
	elseif blocks[1] == 'media' then
		local media_sett = db:hgetall('chat:'..msg.chat.id..':media')
		local text = lang[ln].mediasettings.settings_header
		for k,v in pairs(media_sett) do
			text = text..'`'..k..'`'..' ≡ '..v..'\n'
		end
		api.sendReply(msg, text, true)
		mystat('/media')
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
	    local text
	    if valid then
	        text = cross.changeMediaStatus(msg.chat.id, media, status, ln)
        else
            text = lang[ln].mediasettings.wrong_input
        end
        api.sendReply(msg, text, true)
        mystat('/kickbanallow media')
    end
end

return {
	action = action,
	triggers = {
		'^/media (kick) (.*)$',
		'^/media (ban) (.*)$',
		'^/media (allow) (.*)$',
		'^/(media list)$',
		--'^/(media)$'
	}
}