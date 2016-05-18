local action = function(msg, blocks, ln)
    --ignore if via pm
    if msg.chat.type == 'private' then
    	api.sendMessage(msg.from.id, lang[ln].pv)
    	return nil
    end
    local hash = 'chat:'..msg.chat.id..':rules'
    if blocks[1] == 'rules' then
        local out = cross.getRules(msg.chat.id, ln)
    	if is_locked(msg, 'Rules') and not is_mod(msg) then
    		api.sendMessage(msg.from.id, out, true)
    	else
        	api.sendReply(msg, out, true)
        end
        mystat('/rules') --save stats
    end
	if blocks[1] == 'addrules' then
	    --ignore if not mod
		if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
	    local rules = db:get(hash)
        --check if rules are empty
        if not rules then
            api.sendReply(msg, make_text(lang[ln].setrules.no_rules_add), true)
        else
            local input = blocks[2]
            if not input then
		        api.sendReply(msg, make_text(lang[ln].setrules.no_input_add), true)
		        return nil
	        end
			
			--add the new string to the rules
            local res = api.sendReply(msg, make_text(lang[ln].setrules.added, input), true)
            if not res then
            	api.sendReply(msg, lang[ln].breaks_markdown, true)
            else
            	rules = rules..'\n'..input
            	db:set(hash, rules)
            end
        end
        mystat('/addrules')
    end
	if blocks[1] == 'setrules' then
    	--ignore if not mod
		if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
		local input = blocks[2]
		--ignore if not input text
		if not input then
			api.sendReply(msg, make_text(lang[ln].setrules.no_input_set), true)
			return true
		end
    	--check if a mod want to clean the rules
		if input == '^clean' then
			db:del(hash)
			api.sendReply(msg, make_text(lang[ln].setrules.clean))
			return nil
		end
		
		--set the new rules	
		local res = api.sendReply(msg, make_text(lang[ln].setrules.new, input), true)
		if not res then
			api.sendReply(msg, lang[ln].breaks_markdown, true)
		else
			db:set(hash, input)
		end
		mystat('/setrules')
	end

end

return {
	action = action,
	triggers = {
		'^/(setrules)$',
		'^/(setrules) (.*)',
		'^/(rules)$',
		'^/(addrules)$',
		'^/(addrules) (.*)'	
	}
}