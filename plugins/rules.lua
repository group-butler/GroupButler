local function send_in_group(chat_id)
	local res = db:hget('chat:'..chat_id..':settings', 'Rules')
	if res == 'on' then
		return true
	else
		return false
	end
end

local action = function(msg, blocks)
    
    if msg.chat.type == 'private' then return end
    
    local hash = 'chat:'..msg.chat.id..':info'
    if blocks[1] == 'rules' then
        local out = misc.getRules(msg.chat.id)
    	if not roles.is_admin_cached(msg) and not send_in_group(msg.chat.id) then
    		api.sendMessage(msg.from.id, out, true)
    	else
        	api.sendReply(msg, out, true)
        end
    end
	
	if not roles.is_admin_cached(msg) then return end
	
	if blocks[1] == 'addrules' then
		if not blocks[2] then
			api.sendReply(msg, _("Please write something next this poor `/addabout`"), true)
			return
		end
	    local rules = db:hget(hash, 'rules')
        --check if rules are empty
        if not rules then
            api.sendReply(msg, _("*No rules* for this group.\n"
				.. "Use `/setrules [rules]` to set them"), true)
        else
            local input = blocks[2]
			if not input then
				api.sendReply(msg, _("Please write something next this poor `/addabout`"), true)
				return
			end
			
			--add the new string to the rules
			local message = _("*Rules added:*\n\n") ..  input
            local res = api.sendReply(msg, message, true)
            if not res then
            	api.sendReply(msg, _("This text breaks the markdown.\n"
					.. "More info about a proper use of markdown "
					.. "[here](https://telegram.me/GroupButler_ch/46)."), true)
            else
            	rules = rules..'\n'..input
            	db:hset(hash, 'rules', rules)
            end
        end
    end
	if blocks[1] == 'setrules' then
		local input = blocks[2]
		--ignore if not input text
		if not input then
			api.sendReply(msg, _("Please write something next this poor `/setrules`"), true)
			return
		end
    	--check if a mod want to clean the rules
		if input == '-' then
			db:hdel(hash, 'rules')
			api.sendReply(msg, _("Rules has been wiped."))
			return
		end
		
		--set the new rules	
		local res, code = api.sendReply(msg, input, true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, _("This text is too long, I can't send it"))
			else
				api.sendMessage(msg.chat.id, _("This text breaks the markdown.\n"
					.. "More info about a proper use of markdown "
					.. "[here](https://telegram.me/GroupButler_ch/46)."), true)
			end
		else
			db:hset(hash, 'rules', input)
			local id = res.result.message_id
			api.editMessageText(msg.chat.id, id, _("New rules *saved successfully*!"), false, true)
		end
	end

end

return {
	action = action,
	triggers = {
		config.cmd..'(setrules)$',
		config.cmd..'(setrules) (.*)',
		config.cmd..'(rules)$',
		config.cmd..'(addrules)$',
		config.cmd..'(addrules) (.*)'	
	}
}
