
local triggers = {
	'^/(setrules)$',
	'^/(setrules) (.*)',
	'^/(rules)$',
	'^/(rules)@GroupButler_bot',
	'^/(addrules)$',
	'^/(addrules) (.*)'
	
}

local action = function(msg, blocks, ln)
    --ignore if via pm
    if msg.chat.type == 'private' then
    	sendMessage(msg.from.id, lang[ln].pv)
    	return nil
    end
    local hash = 'bot:'..msg.chat.id..':rules'
    if blocks[1] == 'rules' then
        --ignore if rules are locked and not is a mod
    	if is_locked(msg, 'Rules') and not is_mod(msg) then
    		return nil
    	end
        local rules = client:get(hash)
        --cehck if rules are empty
        if not rules then
            api.sendReply(msg, make_text(lang[ln].setrules.no_rules), true)
        else
            api.sendReply(msg, make_text(lang[ln].setrules.rules, msg.chat.title, rules), true)
        end
        mystat('rules') --save stats
        return nil
    end
	if blocks[1] == 'addrules' then
	    --ignore if not mod
		if not is_mod(msg) then
			api.sendReply(msg, make_text(lang[ln].not_mod), true)
			return nil
		end
	    local rules = client:get(hash)
        --check if rules are empty
        if not rules then
            api.sendReply(msg, make_text(lang[ln].setrules.no_rules_add), true)
        else
            local input = blocks[2]
            if not input then
		        api.sendReply(msg, make_text(lang[ln].setrules.no_input_add), true)
		        return nil
	        end
	        --check if breaks the markdown
	        if breaks_markdown(input) then
				api.sendReply(msg, make_text(lang[ln].breaks_markdown))
				return nil
			end
			--add the new string to the rules
            rules = rules..'\n'..input
            client:set(hash, rules)
            api.sendReply(msg, make_text(lang[ln].setrules.added, input), true)
        end
        mystat('addrules') --save stats
        return nil
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
			client:del(hash)
			api.sendReply(msg, make_text(lang[ln].setrules.clean))
			return nil
		end
		--check if new rules text breaks the markdown
		if breaks_markdown(input) then
			api.sendReply(msg, make_text(lang[ln].breaks_markdown))
			return nil
		end
		--set the new rules	
		client:set(hash, input)
		api.sendReply(msg, make_text(lang[ln].setrules.new, input), true)
		mystat('setrules') --save stats
		return true
	end

end

return {
	action = action,
	triggers = triggers
}