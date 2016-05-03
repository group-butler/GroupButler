local triggers = {
	'^/(init)$',
	'^/(init)@'..bot.username..'$',
	'^/(stop)$',
	'^/(backup)[@'..bot.username..']?',
	'^/(bc) (.*)$',
	'^/(bcg) (.*)$',
	'^/(save)$',
	'^/(commands)$',
	'^/(stats)$',
	'^/(lua)$',
	'^/(lua) (.*)$',
	'^/(run) (.*)$',
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
	'^/(adminmode) (%a%a%a?)$',
	'^/(delflag)$',
	'^/(usernames)$',
	'^/(api errors)$',
	'^/(rediscli) (.*)$',
	'^/(update)$',
	'^/(movechat) (-%d+)$',
	'^/(redis backup)$',
	'^/(group info) (-?%d+)$'
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

function change_redis_headers()
	print('Groups list:')
	local groups = client:smembers('bot:groupsid')
	local logtxt = 'CHANGING REDIS KEYS AND HASHES...\n\n'
	for k,id in pairs(groups) do
		logtxt = logtxt..'\n-----------------------------------------------------\nGROUP ID: '..id..'\n'
		print('Group:', id) --first: print this, once the for is done, print logtxt
		
		logtxt = logtxt..'---> PORTING MODS...\n'
		local mods = client:hgetall('bot:'..id..':mod')
		logtxt = logtxt..migrate_table(mods, 'chat:'..id..':mod')
		
		logtxt = logtxt..'---> PORTING OWNER...\n'
		local owner_id = client:hkeys('bot:'..id..':owner')
		local owner_name = client:hvals('bot:'..id..':owner')
		if not next(owner_id) or not next(owner_name) then
			logtxt = logtxt..'No owner!\n'
		else
			logtxt = logtxt..'Owner info: '..owner_id[1]..', '..owner_name[1]..' [migration:'
			local res = client:hset('chat:'..id..':owner', owner_id[1], owner_name[1])
			logtxt = logtxt..give_result(res)..'\n'
		end
		
		logtxt = logtxt..'---> PORTING MEDIA SETTINGS...\n'
		local media = client:hgetall('media:'..id)
		logtxt = logtxt..migrate_table(media, 'chat:'..id..':media')
		
		logtxt = logtxt..'---> PORTING ABOUT...\n'
		local about = client:get('bot:'..id..':about')
		if not about then
			logtxt = logtxt..'No about!\n'
		else
			logtxt = logtxt..'About found! [migration:'
			local res = client:set('chat:'..id..':about', about)
			logtxt = logtxt..give_result(res)..']\n'
		end
		
		logtxt = logtxt..'---> PORTING RULES...\n'
		local rules = client:get('bot:'..id..':rules')
		if not rules then
			logtxt = logtxt..'No rules!\n'
		else
			logtxt = logtxt..'Rules found!  [migration:'
			local res = client:set('chat:'..id..':rules', rules)
			logtxt = logtxt..give_result(res)..']\n'
		end
		
		logtxt = logtxt..'---> PORTING EXTRA...\n'
		local extra = client:hgetall('extra:'..id)
		logtxt = logtxt..migrate_table(media, 'chat:'..id..':extra')
	end
	print('\n\n\n')
	logtxt = 'Successful: '..voice_succ..'\nUpdated: '..voice_updated..'\n\n'..logtxt
	print(logtxt)
	local log_path = "./logs/changehashes.txt"
	file = io.open(log_path, "w")
	file:write(logtxt)
    file:close()
	api.sendDocument(config.admin, log_path)
end

local function load_lua(code)
	local output = loadstring(code)()
	if not output then
		output = 'Done! (no output)'
	else
		if type(output) == 'table' then
			output = vtext(output)
		end
		output = '```\n' .. output .. '\n```'
	end
	return output
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
	if blocks[1] == 'init' then
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
		local output = load_lua(blocks[2])
		api.sendMessage(msg.chat.id, output, true)
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
    			elseif blocks[2] == 'usernames' then
    				api.sendDocument(msg.from.id, './logs/usernames.txt')
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
    				elseif blocks[3] == 'usernames' then
    					cmd = io.popen('sudo rm -rf logs/usernames.txt')
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
			local reply = '*Available logs*:\n\n`msg`: errors during the delivery of messages\n`errors`: errors during the execution\n`starts`: when the bot have been started\n`usernames`: all the usernames seen by the bot\n`additions`: when the bot have been added to a group\n\nUsage:\n`/log [argument]`\n`/log del [argument]`\n`/log del` (whole folder)'
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
		if msg.chat.type == 'private' then
			if msg.forward_from then
				api.sendReply(msg, msg.forward_from.id)
			end
		end
		return msg.text:gsub('###forward:', '')
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
	if blocks[1] == 'delflag' then
		--with @admin command, flag is no longer needed
		local groups = client:smembers('bot:groupsid')
		local logtxt = ''
		local deleted = 0
		local not_deleted = 0
		logtxt = logtxt..'Number of groups:\t'..#groups..'\n\n'
		for i=1,#groups do
			logtxt = logtxt..i..' - Group id:\t'..groups[i]..'\n'
			local hash = 'chat:'..groups[i]..':settings'
			local res = client:hdel(hash, 'Flag')
			if res == 1 then
				deleted = deleted + 1
			elseif res == 0 then
				not_deleted = not_deleted + 1
			end
			logtxt = logtxt..'Result for the group:\t'..res..'\n\n'
		end
		logtxt = logtxt..'\nDeleted:\t'..deleted..'\nNot deleted:\t'..not_deleted
		print(logtxt)
		local file = io.open("./logs/delflag.txt", "w")
        file:write(logtxt)
        file:close()
        api.sendDocument(msg.from.id, './logs/delflag.txt')
        api.sendMessage(msg.chat.id, 'Instruction processed. Check the log file I\'ve sent you')
        mystat('/delflag')
	end
	if blocks[1] == 'usernames' then
		local hash = 'bot:usernames'
		local usernames = client:hkeys(hash)
		local file = io.open("./logs/usernames.txt", "w")
		file:write(vtext(usernames):gsub('"', ''))
        file:close()
        api.sendDocument(msg.from.id, './logs/usernames.txt')
        api.sendMessage(msg.chat.id, 'Instruction processed. Total number of usernames: '..#usernames)
        mystat('/usernames')
    end
    if blocks[1] == 'api errors' then
    	local errors = client:hkeys('bot:errors')
    	local times = client:hvals('bot:errors')
    	local text = 'Api errors:\n'
    	for i=1,#errors do
    		text = text..errors[i]..': '..times[i]..'\n'
    	end
    	mystat('/apierrors')
    	api.sendMessage(config.admin, text)
    end
    if blocks[1] == 'rediscli' then
    	local redis_f = blocks[2]:gsub(' ', '(\'', 1)
    	redis_f = redis_f:gsub(' ', '\',\'')
    	redis_f = 'return client:'..redis_f..'\')'
    	print(redis_f)
    	local output = load_lua(redis_f)
    	print(output)
    	mystat('/rediscli')
    	api.sendMessage(config.admin, output, true)
    end
    if blocks[1] == 'update' then
    	--change redis keys and hashes to replace my stupid fuckin headers that makes no sense
    	change_redis_headers()
    	api.sendMessage(config.admin, 'Processed. Check the log I\'ve sent you for further info')
    end
    if blocks[1] == 'movechat' then
    	if msg.chat.type == 'private' then
    		api.sendMessage(msg.chat.id, 'This command must be launched from the group you want to move')
    	else
    		if tonumber(blocks[2]) == tonumber(msg.chat.id) then
    			api.sendMessage(msg.chat.id, 'The id sent is the id of this chat!')
    		else
    			local new = blocks[2]
    			local old = msg.chat.id
    			migrate_chat_info(old, new, true)
    		end
    	end
	end
	if blocks[1] == 'redis backup' then
		local groups = client:smembers('bot:groupsid')
		vardump(groups)
		div()
		local all_groups = {}
		for k,v in pairs(groups) do
			local current = {}
			current = group_table(v)
			vardump(current)
			div()
			table.insert(all_groups, current)
		end
		div()
		vardump(all_groups)
		save_data("./logs/redisbackup.json", all_groups)
		if not (msg.chat.type == 'private') then
			api.sendMessage(msg.chat.id, 'I\'ve sent you the .json file in private')
		end
		api.sendDocument(config.admin, "./logs/redisbackup.json")
	end
	if blocks[1] == 'group info' then
		local id = blocks[2]
		if not (id:find('-')) then
			id = '-'..id
		end
		local group_info_table = group_table(id)
		local text = vtext(group_info_table)
		local path = "./logs/group["..id.."].txt"
		local res = write_file(path, text)
		if not res then
			api.sendMessage(msg.chat.id, 'Path invalid. Probably a folder is wrong/missing')
			return
		end
		if not (msg.chat.type == 'private') then
			api.sendMessage(msg.chat.id, 'I\'ve sent you the file in private')
		end
		api.sendDocument(config.admin, path)
	end
end

return {
	action = action,
	triggers = triggers
}