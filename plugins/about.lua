local action = function(msg, blocks)
	--ignore if via pm
	if msg.chat.type == 'private' then
    	return
    end
    
    local hash = 'chat:'..msg.chat.id..':info'
    if blocks[1] == 'about' then
    	local out = misc.getAbout(msg.chat.id)
    	if not roles.is_admin_cached(msg) then
    		api.sendMessage(msg.from.id, out, true)
    	else
        	api.sendReply(msg, out, true)
        end
    end
    
    if not roles.is_admin_cached(msg) then return end
	
	if blocks[1] == 'addabout' then
		if not blocks[2] then
			api.sendReply(msg, _("Please write something next this poor `/addabout`"), true)
			return
		end
	    --load about
	    about = db:hget(hash, 'about')
        --check if there is an about text
        if not about then
			local text = _("*No description for this group*.\n"
					.. "Use `/setabout [bio]` to set-up a new description")
            api.sendReply(msg, text, true)
        else
            local input = blocks[2]
			--add the new string to the about text
			local text = _("*Description added:*\n\"%s\""):format(input)
            local res = api.sendReply(msg, text, true)
            if not res then
				local text = _("This text breaks the markdown.\n"
						.. "More info about a proper use of markdown [here]"
						.. "(https://telegram.me/GroupButler_ch/46).")
            	api.sendReply(msg, text, true)
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
			api.sendReply(msg, _("Please write something next this poor `/setabout`"), true)
			return
		end
		--check if the mod want to clean the about text
		if input == '-' then
			db:hdel(hash, 'about')
			api.sendReply(msg, _("The bio has been cleaned."))
			return
		end
		
		--set the new about
		local res, code = api.sendReply(msg, input, true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, _("This text is too long, I can't send it"))
			else
				local text = _("This text breaks the markdown.\n"
						.. "More info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).")
				api.sendMessage(msg.chat.id, text, true)
			end
		else
			db:hset(hash, 'about', input)
			local id = res.result.message_id
			api.editMessageText(msg.chat.id, id, _("New description *saved successfully*!"), false, true)
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
