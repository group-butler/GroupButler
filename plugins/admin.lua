local triggers = {
	'^/(reload)$',
	'^/(stop)$',
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
	'^/(admin)$',
	'^/(block) (%d+)$',
	'^/(block)$',
	'^/(unblock) (%d+)$',
	'^/(unblock)$',
	'^/(isblocked)$',
	'^/(ping redis)$',
	'^/(leave) (-%d+)$',
	'^/(leave)$',
	'^/(post) (.*)$',
	'^###(forward)',
	'^/(reset) (.*)$',
	'^/(reset)$',
	'^/(send) (%d+) (.*)$',
	'^/(send) (.*)$',
	'^/(adminmode) (%a%a%a?)$'
}

local logtxt = ''
local failed = 0

local function save_in_redis(hash, text)
    local redis_res = client:set(hash, text)
    if redis_res == true then
	    return 'Saved on redis (res: true)'
	else
	    failed = failed + 1
	    return 'Something went wrong with redis, res -> '..res
	end
end

local function bot_leave(chat_id, ln)
	local res = api.kickChatMember(chat_id, bot.id)
	if not res then
		return lang[ln].admin.leave_error
	else
		client:hincrby('bot:general', 'groups', -1)
		return lang[ln].admin.leave_chat_leaved
	end
end

local action = function(msg, blocks, ln)
	
	if msg.from.id ~= config.admin then
		return
	end
	
	if blocks[1] == 'admin' then
		local text = ''
		for k,v in pairs(triggers) do
			text = text..v..'\n'
		end
		api.sendMessage(config.admin, text)
		mystat('/admin')
	end
	if blocks[1] == 'reload' then
		--client:bgsave()
		bot_init(true)
		
		local out = make_text(lang[ln].control.reload)
		api.sendReply(msg, out, true)
		mystat('/reload')
	end
	if blocks[1] == 'stop' then
		client:bgsave()
		is_started = false
		local out = make_text(lang[ln].control.stop)
		api.sendReply(msg, out, true)
		mystat('/stop')
	end
	if blocks[1] == 'backup' then
		local cmd = io.popen('sudo tar -cpf '..bot.first_name:gsub(' ', '_')..'.tar *')
    	cmd:read('*all')
    	cmd:close()
    	api.sendDocument(msg.from.id, './'..bot.first_name:gsub(' ', '_')..'.tar')
    	mystat('/backup')
    end
    if blocks[1] == 'bc' then
	        if breaks_markdown(blocks[2]) then
	            api.sendMessage(config.admin, lang[ln].breaks_markdown)
	            return
	        end
	        local hash = 'bot:users'
	        local ids = client:hkeys(hash)
	        if ids then
	            for i=1,#ids do
	                api.sendMessage(ids[i], blocks[2], true)
	                print('Sent', ids[i])
	            end
	            api.sendMessage(config.admin, lang[ln].broadcast.delivered)
	        else
	            api.sendMessage(config.admin, lang[ln].broadcast.no_user)
	        end
	        mystat('/bc')
	    end
	if blocks[1] == 'bcg' then
		if breaks_markdown(blocks[2]) then
	    	api.sendMessage(config.admin, lang[ln].breaks_markdown)
	        return
	    end
	    local groups = client:smembers('bot:groupsid')
	    if not groups then
	    	api.sendMessage(config.admin, lang[ln].admin.bcg_no_groups)
	    else
	    	for i=1,#groups do
	    		api.sendMessage(groups[i], blocks[2], true)
	        	print('Sent', groups[i])
	    	end
	    	api.sendMessage(config.admin, lang[ln].broadcast.delivered)
	    end
	    mystat('/bcg')
	end
	if blocks[1] == 'save' then
		client:bgsave()
		local out = make_text(lang[ln].getstats.redis)
		api.sendMessage(msg.chat.id, out, true)
		mystat('/save')
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
		api.sendMessage(msg.chat.id, out, true)
		mystat('/commands')
    end
    if blocks[1] == 'stats' then
    	local text = '#stats:\n'
        local hash = 'bot:general'
	    local names = client:hkeys(hash)
	    local num = client:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: '..num[i]..'\n'
	    end
	    local out = make_text(lang[ln].getstats.stats, text)
		api.sendMessage(msg.chat.id, out, true)
		mystat('/stats')
	end
	if blocks[1] == 'lua' then
		if not blocks[2] then
			api.sendReply(msg, make_text(lang[ln].luarun.enter_string))
			return
		end
		--execute
		local output = loadstring(blocks[2])()
		if not output then
			output = make_text(lang[ln].luarun.done)
		else
			output = '```\n' .. output .. '\n```'
		end
		api.sendMessage(msg.chat.id, output, true, msg.message_id, true)
		mystat('/lua')
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
		api.sendMessage(msg.chat.id, output, true, msg.message_id, true)
		mystat('/run')
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
	        client:sadd('bot:groupsid', k)
	        local rules = data[k]['rules']
	        local about = data[k]['about']
	        if rules then
	            local hash = 'bot:'..k..':rules'
	            logtxt = logtxt..'\nSaving rules...\t'..save_in_redis(hash, rules)
	        else
	            logtxt = logtxt..'\nSaving rules...\tno rules found'
	            client:del('bot:'..k..':rules')
	            no_rules = no_rules + 1
	        end
	        if about then
	            local hash = 'bot:'..k..':about'
	            logtxt = logtxt..'\nSaving about...\t'..save_in_redis(hash, about)
	        else
	            logtxt = logtxt..'\nSaving about...\tno about found'
	            client:del('bot:'..k..':about')
	            no_about = no_about + 1
	        end
	        total_items = total_items + 1
        end
        logtxt = logtxt..'\n\nItems (groups) checked:\t'..total_items..'\nItems with no rules:\t'..no_rules..'\nItems with no about\t'..no_about..'\nRedis saves failed:\t'..failed
        print(logtxt)
        local file = io.open("./logs/dbswitch.txt", "w")
        file:write(logtxt)
        file:close()
        api.sendDocument(msg.from.id, './logs/dbswitch.txt')
        api.sendMessage(msg.chat.id, 'Instruction processed. Check the log file I\'ve sent you')
        mystat('/changedb')
    end
    if blocks[1] == 'log' then
    	if blocks[2] then
    		if blocks[2] ~= 'del' then
    			local reply = 'I\' sent it in private'
    			if blocks[2] == 'msg' then
    				api.sendDocument(msg.from.id, './logs/msgs_errors.txt')
    			elseif blocks[2] == 'dbswitch' then
    				api.sendDocument(msg.from.id, './logs/dbswitch.txt')
    			elseif blocks[2] == 'errors' then
    				api.sendDocument(msg.from.id, './logs/errors.txt')
    			elseif blocks[2] == 'starts' then
    				api.sendDocument(msg.from.id, './logs/starts.txt')
    			elseif blocks[2] == 'additions' then
    				api.sendDocument(msg.from.id, './logs/additions.txt')
    			else
    				reply = 'Invalid parameter: '..blocks[2]
    			end
    			if msg.chat.type ~= 'private' then
    				api.sendReply(msg, reply)
    			else
    				if string.match(reply, '^Invalid parameter: .*') then
    					api.sendMessage(msg.chat.id, reply)
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
    				elseif blocks[3] == 'starts' then
    					cmd = io.popen('sudo rm -rf logs/additions.txt')
    				else
    					reply = 'Invalid parameter: '..blocks[3]
    				end
    				if msg.chat.type ~= 'private' then
    					if not string.match(reply, '^Invalid parameter: .*') then
    						cmd:read('*all')
        					cmd:close()
        					api.sendReply(msg, reply)
    					else
    						api.sendReply(msg, reply)
    					end
    				else
    					if string.match(reply, '^Invalid parameter: .*') then
    						api.sendMessage(msg.chat.id, reply)
    					else
    						cmd:read('*all')
        					cmd:close()
        					api.sendMessage(msg.chat.id, reply)
        				end
					end
				else
					local cmd = io.popen('sudo rm -rf logs')
        			cmd:read('*all')
        			cmd:close()
					if msg.chat.type == 'private' then
						api.sendMessage(msg.chat.id, 'Logs folder deleted', true)
					else
						api.sendReply(msg, 'Logs folder deleted', true)
					end
				end
			end
		else
			local reply = '*Available logs*:\n\n`msg`: errors during the delivery of messages\n`errors`: errors during the execution\n`starts`: when the bot have been started\n`additions`: when the bot have been added to a group\n\nUsage:\n`/log [argument]`\n`/log del [argument]`\n`/log del` (whole folder)'
			if msg.chat.type == 'private' then
				api.sendMessage(msg.chat.id, reply, true)
			else
				api.sendReply(msg, reply, true)
			end
		end
		mystat('/log')
    end
	if blocks[1] == 'block' then
		local id
		if not blocks[2] then
			if not msg.reply then
				api.sendReply(msg, lang[ln].admin.no_reply)
				return
			else
				id = msg.reply.from.id
			end
		else
			id = blocks[2]
		end
		local response = client:sadd('bot:blocked', id)
		local text
		if response == 1 then
			text = make_text(lang[ln].admin.blocked, id)
		else
			text = make_text(lang[ln].admin.already_blocked, id)
		end
		api.sendReply(msg, text)
		mystat('/block')
	end
	if blocks[1] == 'unblock' then
		local id
		local response
		if not blocks[2] then
			if not msg.reply then
				api.sendReply(msg, lang[ln].admin.no_reply)
				return
			else
				id = msg.reply.from.id
			end
		else
			id = blocks[2]
		end
		local response = client:srem('bot:blocked', id)
		local text
		if response == 1 then
			text = make_text(lang[ln].admin.unblocked, id)
		else
			text = make_text(lang[ln].admin.already_unblocked, id)
		end
		api.sendReply(msg, text)
		mystat('/unblock')
	end
	if blocks[1] == 'isblocked' then
		if not msg.reply then
			api.sendReply(msg, lang[ln].admin.no_reply)
			return
		else
			if is_blocked(msg.reply.from.id) then
				api.sendReply(msg, 'yes')
			else
				api.sendReply(msg, 'no')
			end
		end
		mystat('/isblocked')
	end
	if blocks[1] == 'ping redis' then
		local ris = client:ping()
		if ris == true then
			api.sendMessage(msg.from.id, lang[ln].ping)
		end
		mystat('/ping redis')
	end
	if blocks[1] == 'leave' then
		local text
		if not blocks[2] then
			if msg.chat.type == 'private' then
				text = lang[ln].admin.leave_id_missing
			else
				text = bot_leave(msg.chat.id, ln) 
			end
		else
			text = bot_leave(blocks[2], ln)
		end
		api.sendMessage(config.admin, text)
		mystat('/leave')
	end
	if blocks[1] == 'post' then
		if config.channel == '' then
			api.sendMessage(config.admin, 'Enter your channel username in config.lua')
		else
			local res = api.sendMessage(config.channel, blocks[2], true)
			local text
			if res then
				text = 'Message posted in '..config.channel
			else
				text = 'Delivery failed. Check the markdown used or the channel username setted'
			end
			api.sendMessage(config.admin, text)
			mystat('/post')
		end
	end
	if blocks[1] == 'forward' then
		if msg.forward_from then
			api.sendReply(msg, msg.forward_from.id)
		end
	end
	if blocks[1] == 'reset' then
		if not blocks[2] then
			api.sendMessage(config.admin, 'Missing key')
			return
		end
		local key = blocks[2]
		local hash = 'bot:general'
		local res = client:hdel(hash, key)
		if res == 1 then
			api.sendMessage(config.admin, 'Resetted!')
		else
			api.sendMessage(config.admin, 'Field empty or invalid')
		end
	end
	if blocks[1] == 'send' then
		if not blocks[2] then
			api.sendMessage(config.admin, 'Specify an id or reply with the message')
			return
		end
		local id
		if blocks[2]:match('(%d+)') then
			if not blocks[3] then
				api.sendMessage(config.admin, 'Text is missing')
				return
			end
			id = blocks[2]
		else
			if not msg.reply then
				api.sendMessage(config.admin, 'Reply to a user to send him a message')
				return
			end
			id = msg.reply.from.id
		end
		local res = api.sendMessage(id, blocks[2])
		if res then
			api.sendMessage(config.admin, 'Successful delivery')
		end
	end
	if blocks[1] == 'adminmode' then
		if blocks[2]:match('^(on)$') and blocks[2]:match('^(off)$') then
			api.sendMessage(config.admin, 'Available status: on/off')
			return
		end
		local status = blocks[2]
		local current = client:hget('bot:general', 'adminmode')
		if current == status then
			api.sendMessage(config.admin, 'Admin mode *already '..status..'*', true)
		else
			client:hset('bot:general', 'adminmode', status)
			api.sendMessage(config.admin, 'Admin mode: *'..status..'*', true)
		end
	end
end

return {
	action = action,
	triggers = triggers
}

