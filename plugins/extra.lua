local action = function(msg, blocks, ln)
	if msg.chat.type == 'private' then
		return
	end
	
	if blocks[1] == 'extra' then
		if not blocks[2] then
			api.sendReply(msg, make_text(lang[ln].extra.usage), true)
	        return nil
		end
	    if not is_mod(msg) then
	        return nil
	    end
	    local hash = 'chat:'..msg.chat.id..':extra'
	    local text = make_text(lang[ln].extra.new_command, blocks[2], blocks[3])
	    local res = api.sendReply(msg, text, true)
	    if not res then
	    	api.sendReply(msg, lang[ln].breaks_markdown, true)
	    else
	    	db:hset(hash, blocks[2], blocks[3])
	    end
	    mystat('/extra')
	elseif blocks[1] == 'extra list' then
	    if not is_mod(msg) then
	        return nil
	    end
	    local hash = 'chat:'..msg.chat.id..':extra'
	    local commands = db:hkeys(hash)
	    local text = ''
	    if commands[1] == nil then
	    	local out = make_text(lang[ln].extra.no_commands)
	        api.sendReply(msg, out)
	    else
	        for k,v in pairs(commands) do
	            text = text..v..'\n'
	        end
	        local out = make_text(lang[ln].extra.commands_list, text)
	        api.sendReply(msg, out, true)
	    end
	    mystat('/extra list')
    elseif blocks[1] == 'extra del' then
        if not is_mod(msg) then
	        return nil
	    end
	    local hash = 'chat:'..msg.chat.id..':extra'
	    local success = db:hdel(hash, blocks[2])
	    print(success)
	    if success == 1 then
	    	local out = make_text(lang[ln].extra.command_deleted, blocks[2])
	        api.sendReply(msg, out)
	    else
	        local out = make_text(lang[ln].extra.command_empty, blocks[2])
	        api.sendReply(msg, out)
	    end
	    mystat('/extra del')
    else
    	local hash = 'chat:'..msg.chat.id..':extra'
    	local text = db:hget(hash, blocks[1])
        if not text then return end
        if is_locked(msg, 'Extra') and not is_mod(msg) then
            api.sendMessage(msg.from.id, text, true)
        else
        	api.sendReply(msg, text, true)
        end
		mystat('/extra command')
    end
end

return {
	action = action,
	triggers = {
		'^/(extra)$',
		'^/(extra) (#[%w_]*)%s(.*)$',
		'^/(extra del) (#[%w_]*)$',
		'^/(extra list)$',
		'^(#[%w_]*)$'
	}
}