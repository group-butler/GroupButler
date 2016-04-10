local triggers = {
	'^/(extra) (#[%w_]*)%s(.*)$',
	'^/(extra del) (#[%w_]*)$',
	'^/(extra list)$',
	'^(#[%w_]*)$'
}

local action = function(msg, blocks, ln)
	
	print('\n/extra', msg.from.first_name..' ['..msg.from.id..']')
	
	if blocks[1] == 'extra' then
	    if not is_mod(msg) then
	        print('\27[31mNil: not mod\27[39m')
	        return nil
	    end
	    if breaks_markdown(blocks[2]) or breaks_markdown(blocks[3]) then
	    	local out = make_text(lang[ln].breaks_markdown)
	        sendReply(msg, out)
	        return nil
	    end
	    local hash = 'extra:'..msg.chat.id
	    client:hset(hash, blocks[2], blocks[3])
	    
	    mystat('extra')
	    local text = make_text(lang[ln].extra.new_command, blocks[2], blocks[3])
	    sendReply(msg, text, true)
	elseif blocks[1] == 'extra list' then
	    if not is_mod(msg) then
	        print('\27[31mNil: not mod\27[39m')
	        return nil
	    end
	    local hash = 'extra:'..msg.chat.id
	    local commands = client:hkeys(hash)
	    local text = ''
	    if commands[1] == nil then
	    	local out = make_text(lang[ln].extra.no_commands)
	        sendReply(msg, out)
	    else
	        for k,v in pairs(commands) do
	            text = text..v..'\n'
	        end
	        
	        mystat('extralist')
	        local out = make_text(lang[ln].extra.commands_list, text)
	        sendReply(msg, out, true)
	    end
    elseif blocks[1] == 'extra del' then
        if not is_mod(msg) then
	        print('\27[31mNil: not mod\27[39m')
	        return nil
	    end
	    local hash = 'extra:'..msg.chat.id
	    local success = client:hdel(hash, blocks[2])
	    print(success)
	    if success == 1 then
	    	local out = make_text(lang[ln].extra.command_deleted, blocks[2])
	        sendReply(msg, out)
	    else
	        local out = make_text(lang[ln].extra.command_empty, blocks[2])
	        sendReply(msg, out)
	    end
    else
        if is_locked(msg, 'Extra') and not is_mod(msg) then
            print('\27[31mNil: not mod\27[39m')
            --sendReply(msg, 'Custom commands are available *only for moderators*!\n(_you can change this setting_ )', true)
            return nil
        end
        local hash = 'extra:'..msg.chat.id
        local commands = client:hkeys(hash)
        local replies = client:hvals(hash)
        local text
        for k,v in pairs(commands) do
            if v == blocks[1] then
                text = replies[k]
                break
            end
        end
        sendReply(msg, text, true)
    end
    
	mystat('extra') --save stats
end

return {
	action = action,
	triggers = triggers
}