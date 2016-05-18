local action = function(msg, blocks, ln)
	--ignore if via pm
	if msg.chat.type == 'private' then
		api.sendMessage(msg.from.id, lang[ln].pv)
    	return nil
    end
    local hash = 'chat:'..msg.chat.id..':about'
    if blocks[1] == 'about' then
    	local out = cross.getAbout(msg.chat.id, ln)
    	if is_locked(msg, 'About') and not is_mod(msg) then
    		api.sendMessage(msg.from.id, out, true)
    	else
        	api.sendReply(msg, out, true)
        end
        mystat('/about')
    end
	if blocks[1] == 'addabout' then
		--ignore if not mod
		if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
	    --load about
	    about = db:get(hash)
        --check if there is an about text
        if not about then
            api.sendReply(msg, make_text(lang[ln].setabout.no_bio_add), true)
        else
            local input = blocks[2]
			--add the new string to the about text
            local res = api.sendReply(msg, make_text(lang[ln].setabout.added, input), true)
            if not res then
            	api.sendReply(msg. lang[ln].breaks_markdown, true)
            else
            	about = about..'\n'..input
            	db:set(hash, about)
            end
        end
        mystat('/addabout')
    end
	if blocks[1] == 'setabout' then
		local input = blocks[2]
		print(input)
		--ignore if not mod
		if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
		--ignore if not text
		if not input then
			api.sendReply(msg, make_text(lang[ln].setabout.no_input_set), true)
			return true
		end
		--check if the mod want to clean the about text
		if input == 'clean' then
			db:del(hash)
			api.sendReply(msg, make_text(lang[ln].setabout.clean))
			return nil
		end
		
		--set the new about
		local res = api.sendReply(msg, make_text(lang[ln].setabout.new, input), true)
		if not res then
			api.sendReply(msg, lang[ln].breaks_markdown, true)
		else
			db:set(hash, input)
		end
		mystat('/setabout')
	end

end

return {
	action = action,
	get_about = get_about,
	triggers = {
		'^/(setabout)$', --to warn if an user don't add a text
		'^/(setabout) (.*)',
		'^/(about)$',
		'^/(addabout)$', --to warn if an user don't add a text
		'^/(addabout) (.*)',
	}
}