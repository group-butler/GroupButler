local action = function(msg, blocks)
	--ignore if via pm
	if msg.chat.type == 'private' then
    	return
    end
    
    local hash = 'chat:'..msg.chat.id..':info'
    if blocks[1] == 'about' then
    	local out = misc.getAbout(msg.chat.id, msg.ln)
    	if not roles.is_admin_cached(msg) then
    		api.sendMessage(msg.from.id, out, true)
    	else
        	api.sendReply(msg, out, true)
        end
    end
    
    if not roles.is_admin_cached(msg) then return end
	
	if blocks[1] == 'addabout' then
		if not blocks[2] then
			api.sendReply(msg, lang[msg.ln].setabout.no_input_add)
			return
		end
	    --load about
	    about = db:hget(hash, 'about')
        --check if there is an about text
        if not about then
            api.sendReply(msg, lang[msg.ln].setabout.no_bio_add, true)
        else
            local input = blocks[2]
			--add the new string to the about text
            local res = api.sendReply(msg, lang[msg.ln].setabout.added:compose(input), true)
            if not res then
            	api.sendReply(msg, lang[msg.ln].breaks_markdown, true)
            else
            	about = about..'\n'..input
            	db:hset(hash, 'about', about)
            end
        end
    end
	if blocks[1] == 'setabout' then
		local input = blocks[2]
		--ignore if not mod
		
		--ignore if not text
		if not input then
			api.sendReply(msg, lang[msg.ln].setabout.no_input_set, true)
			return
		end
		--check if the mod want to clean the about text
		if input == '-' then
			db:hdel(hash, 'about')
			api.sendReply(msg, lang[msg.ln].setabout.clean)
			return
		end
		
		--set the new about
		local res, code = api.sendReply(msg, input, true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, lang[msg.ln].bonus.too_long)
			else
				api.sendMessage(msg.chat.id, lang[msg.ln].breaks_markdown, true)
			end
		else
			db:hset(hash, 'about', input)
			local id = res.result.message_id
			api.editMessageText(msg.chat.id, id, lang[msg.ln].setabout.about_setted, false, true)
		end
	end

end

return {
	action = action,
	triggers = {
		config.cmd..'(setabout)$', --to warn if an user don't add a text
		config.cmd..'(setabout) (.*)',
		config.cmd..'(about)$',
		config.cmd..'(addabout)$', --to warn if an user don't add a text
		config.cmd..'(addabout) (.*)',
	}
}