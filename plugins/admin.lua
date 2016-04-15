local triggers = {
	'^/(reload)$',
	'^/(halt)$',
	'^/(backup)$',
	'^/(bc) (.*)$',
	'^/(bcg) (.*)$',
	'^/(save)$',
	'^/(commands)$',
	'^/(stats)$',
	'^/(lua)$',
	'^/(lua) (.*)$',
	'^/(run) (.*)$',
	'^/(changedb)$',
	'^/(log) (del) (.*)',
	'^/(log) (del)',
	'^/(log) (.*)$',
	'^/(log)$',
}

local function save_in_redis(hash, text)
    local redis_res = client:set(hash, text)
    if redis_res == true then
	    return 'Saved on redis (res: true)'
	else
	    failed = failed + 1
	    return 'Something went wrong with redis, res -> '..res
	end
end

local action = function(msg, blocks, ln)
	
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end
	
	if blocks[1] == 'reload' then
		--client:bgsave()
		bot_init(true)
		
		local out = make_text(lang[ln].control.reload)
		sendReply(msg, out, true)
		mystat('reload') --save stat
	end
	if blocks[1] == 'halt' then
		client:bgsave()
		is_started = false
		
		local out = make_text(lang[ln].control.stop)
		sendReply(msg, out, true)
		mystat('halt') --save stat
	end
	if blocks[1] == 'backup' then
		local cmd = io.popen('sudo tar -cpf GroupButler.tar *')
    	cmd:read('*all')
    	cmd:close()
    	sendDocument(msg.from.id, './GroupButler.tar')
    end
    if blocks[1] == 'bc' then
	        if breaks_markdown(blocks[2]) then
	            sendMessage(config.admin, lang[ln].breaks_markdown)
	            return
	        end
	        local hash = 'bot:users'
	        local ids = client:hkeys(hash)
	        if ids then
	            for i=1,#ids do
	                sendMessage(ids[i], blocks[2], true, false, true)
	                print('Sent', ids[i])
	            end
	            sendMessage(config.admin, lang[ln].broadcast.delivered)
	        else
	            sendMessage(config.admin, lang[ln].broadcast.no_user)
	        end
	    end
	if blocks[1] == 'bcg' then
		if breaks_markdown(blocks[2]) then
	    	sendMessage(config.admin, lang[ln].breaks_markdown)
	        return
	    end
	    local groups= load_data('groups.json')
	    for k,v in pairs(json) do
	    	sendMessage(k, blocks[2], true, false, true)
	        print('Sent', ids[i])
	    end
	    sendMessage(config.admin, lang[ln].broadcast.delivered)
	end
	if blocks[1] == 'save' then
		client:bgsave()
		local out = make_text(lang[ln].getstats.redis)
		sendMessage(msg.chat.id, out, true, false, true)
		return nil
	end
	if blocks[1] == 'commands' then
		local text = 'Stats:\n'
	    local hash = 'commands:stats'
	    local names = client:hkeys(hash)
	    local num = client:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: '..num[i]..'\n'
	    end
	    local out = make_text(lang[ln].getstats.stats, text)
		sendMessage(msg.chat.id, out, true, false, true)
    end
    if blocks[1] == 'stats' then
    	local text = 'Stats:\n'
        local hash = 'bot:general'
	    local names = client:hkeys(hash)
	    local num = client:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: '..num[i]..'\n'
	    end
	    local out = make_text(lang[ln].getstats.stats, text)
		sendMessage(msg.chat.id, out, true, false, true)
	end
	if blocks[1] == 'lua' then
		if not blocks[2] then
			print('\27[31mNil: no input\27[39m')
			sendReply(msg, make_text(lang[ln].luarun.enter_string))
			return
		end
		--execute
		local output = loadstring(blocks[2])()
		if not output then
			output = make_text(lang[ln].luarun.done)
		else
			output = '```\n' .. output .. '\n```'
		end
		sendMessage(msg.chat.id, output, true, msg.message_id, true)
	end
	if blocks[1] == 'run' then
		--read the output
		local output = io.popen(blocks[2]):read('*all')
		--check if the output has a text
		if output:len() == 0 then
			output = make_text(lang[ln].shell.done)
		else
			output = make_text(lang[ln].shell.output, output)
		end
		mystat('run') --save stats
		sendMessage(msg.chat.id, output, true, msg.message_id, true)
	end
	if blocks[1] == 'changedb' then
	    local data = load_data('groups.json')
	    local total_items = 0
	    local no_rules = 0
	    local no_about = 0
	    for k,v in pairs(data) do
	        if total_items == 0 then
	            logtxt = logtxt..'Id:\t'..k
	        else
	            logtxt = logtxt..'\n\nId:\t'..k
	        end
	        local rules = data[k]['rules']
	        local about = data[k]['about']
	        if rules then
	            local hash = 'bot:'..k..':rules'
	            logtxt = logtxt..'\nSaving rules...\t'..save_in_redis(hash, rules)
	        else
	            logtxt = logtxt..'\nSaving rules...\tno rules found'
	            no_rules = no_rules + 1
	        end
	        if about then
	            local hash = 'bot:'..k..':about'
	            logtxt = logtxt..'\nSaving about...\t'..save_in_redis(hash, about)
	        else
	            logtxt = logtxt..'\nSaving about...\tno about found'
	            no_about = no_about + 1
	        end
	        total_items = total_items + 1
        end
        logtxt = logtxt..'\n\nItems (groups) checked:\t'..total_items..'\nItems with no rules:\t'..no_rules..'\nItems with no about\t'..no_about..'\nRedis saves failed:\t'..failed
        print(logtxt)
        local file = io.open("./logs/dbswitch.txt", "w")
        file:write(logtxt)
        file:close()
        sendDocument(msg.from.id, './logs/dbswitch.txt')
        sendMessage(msg.chat.id, 'Instruction processed. Check the log file I\'ve sent you')
    end
    if blocks[1] == 'log' then
    	if blocks[2] then
    		if blocks[2] ~= 'del' then
    			local reply = 'I\' sent it in private'
    			if blocks[2] == 'msg' then
    				sendDocument(msg.from.id, './logs/msgs_errors.txt')
    			elseif blocks[2] == 'dbswitch' then
    				sendDocument(msg.from.id, './logs/dbswitch.txt')
    			elseif blocks[2] == 'errors' then
    				sendDocument(msg.from.id, './logs/errors.txt')
    			elseif blocks[2] == 'starts' then
    				sendDocument(msg.from.id, './logs/starts.txt')
    			else
    				reply = 'Invalid parameter: '..blocks[2]
    			end
    			if msg.chat.type ~= 'private' then
    				sendReply(msg, reply)
    			else
    				if string.match(reply, '^Invalid parameter: .*') then
    					sendMessage(msg.chat.id, reply)
    				end
				end
			else
				if blocks[3] then
					local reply = 'Log deleted'
					local cmd
    				if blocks[3] == 'msg' then
    					cmd = io.popen('sudo rm -rf logs/msgs_errors.txt')
    				elseif blocks[3] == 'dbswitch' then
    					cmd = io.popen('sudo rm -rf logs/dbswitch.txt')
    				elseif blocks[3] == 'errors' then
    					cmd = io.popen('sudo rm -rf logs/errors.txt')
    				elseif blocks[3] == 'starts' then
    					cmd = io.popen('sudo rm -rf logs/starts.txt')
    				else
    					reply = 'Invalid parameter: '..blocks[3]
    				end
    				if msg.chat.type ~= 'private' then
    					if not string.match(reply, '^Invalid parameter: .*') then
    						cmd:read('*all')
        					cmd:close()
        					sendReply(msg, reply)
    					else
    						sendReply(msg, reply)
    					end
    				else
    					if string.match(reply, '^Invalid parameter: .*') then
    						sendMessage(msg.chat.id, reply)
    					else
    						cmd:read('*all')
        					cmd:close()
        					sendMessage(msg.chat.id, reply)
        				end
					end
				else
					local cmd = io.popen('sudo rm -rf logs')
        			cmd:read('*all')
        			cmd:close()
					if msg.chat.type == 'private' then
						sendMessage(msg.chat.id, 'Logs folder deleted', true, false, true)
					else
						sendReply(msg, 'Logs folder deleted', true)
					end
				end
			end
		else
			local reply = '*Available logs*:\n\n`msg`: errors during the delivery of messages\n`errors`: errors during the execution\n`starts`: when the bot have been started\n\nUsage:\n`/log [argument]`\n`/log del [argument]`\n`/log del` (whole folder)'
			if msg.chat.type == 'private' then
				sendMessage(msg.chat.id, reply, true, false, true)
			else
				sendReply(msg, reply, true)
			end
		end
    end
end

return {
	action = action,
	triggers = triggers
}

