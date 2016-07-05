local triggers2 = {
	'^/a(init)$',
	'^/a(stop)$',
	'^/a(backup)$',
	'^/a(bc) (.*)$',
	'^/a(bcg) (.*)$',
	'^/a(save)$',
	'^/a(commands)$',
	'^/a(stats)$',
	'^/a(lua)$',
	'^/a(lua) (.*)$',
	'^/a(run) (.*)$',
	'^/a(log) (del) (.*)',
	'^/a(log) (del)',
	'^/a(log) (.*)$',
	'^/a(log)$',
	'^/a(admin)$',
	'^/a(block) (%d+)$',
	'^/a(block)$',
	'^/a(unblock) (%d+)$',
	'^/a(unblock)$',
	'^/a(isblocked)$',
	'^/a(ping redis)$',
	'^/a(leave) (-%d+)$',
	'^/a(leave)$',
	'^/a(post) (.*)$',
	'^###(forward)',
	'^/a(reset) (.*)$',
	'^/a(reset)$',
	'^/a(send) (-?%d+) (.*)$',
	'^/a(send) (.*)$',
	'^/a(adminmode) (%a%a%a?)$',
	'^/a(usernames)$',
	'^/a(api errors)$',
	'^/a(rediscli) (.*)$',
	'^/a(genlang)$',
	'^/a(genlang) (%a%a)$',
	'^/a(trfile) (%a%a)$',
	'^/a(trfile)$',
	'^/a(fixaction) (-%d+)$',
	'^/a(sendplug) (.*)$',
	'^/a(sendfile) (.*)$',
	'^/a(r)$',
	'^/a(r) (.*)',
	'^/a(download)$',
	'^/a(migrate) (%d+)%s(%d+)',
	'^/a(resid) (%d+)$',
	'^/a(checkgroups)$',
	'^/a(update)$',
	'^/a(subadmin) (yes)$',
	'^/a(subadmin) (no)$',
	'^/a(tban) (get)$',
	'^/a(tban) (flush)$',
	'^/a(db) (.*)$',
	'^a(aa)$',
	'^/a(remban) (@[%w_]+)$',
	'^/a(info) (%d+)$',
	'^/a(prevban) (.*)$',
	'^/a(rawinfo) (.*)$',
	'^/a(editpost) (%d%d%d?) (.*)$',
	'^/a(cleandeadgroups)$',
	'^/a(initgroup) (-%d+)$',
	'^/a(remgroup) (-%d+)$',
	'^/a(remgroup) (true) (-%d+)$',
}

local logtxt = ''
local failed = 0

local function cron()
	db:bgsave()
end

local function save_in_redis(hash, text)
    local redis_res = db:set(hash, text)
    if redis_res == true then
	    return 'Saved on redis (res: true)'
	else
	    failed = failed + 1
	    return 'Something went wrong with redis, res -> '..res
	end
end

local function bot_leave(chat_id, ln)
	local res = api.leaveChat(chat_id)
	if not res then
		return 'Check the id, it could be wrong'
	else
		db:hincrby('bot:general', 'groups', -1)
		return 'Chat leaved!'
	end
end

local function load_lua(code)
	local output = loadstring(code)()
	if not output then
		output = '`Done! (no output)`'
	else
		if type(output) == 'table' then
			output = vtext(output)
		end
		output = '```\n' .. output .. '\n```'
	end
	return output
end	

local function match_pattern(pattern, text)
  if text then
  	text = text:gsub('@'..bot.username, '')
    local matches = {}
    matches = { string.match(text, pattern) }
    if next(matches) then
    	return matches
    end
  end
end

local action = function(msg, blocks, ln)
	
	if not config.admin.admins[msg.from.id] then return end
	
	blocks = {}
	
	for k,v in pairs(triggers2) do
		blocks = match_pattern(v, msg.text)
		if blocks then break end
	end
	
	if not blocks or not next(blocks) then return true end --continue to match plugins
	
	if blocks[1] == 'admin' then
		local text = ''
		for k,v in pairs(triggers2) do
			text = text..v..'\n'
		end
		api.sendMessage(msg.from.id, text)
		mystat('/admin')
	end
	if blocks[1] == 'init' then
		db:bgsave()
		bot_init(true)
		api.sendReply(msg, '*Bot reloaded!*', true)
		mystat('/reload')
	end
	if blocks[1] == 'stop' then
		db:bgsave()
		is_started = false
		api.sendReply(msg, '*Stopping bot*', true)
		mystat('/stop')
	end
	if blocks[1] == 'backup' then
		db:bgsave()
		local cmd = io.popen('sudo tar -cpf '..bot.first_name:gsub(' ', '_')..'.tar *')
    	cmd:read('*all')
    	cmd:close()
    	api.sendDocument(msg.from.id, './'..bot.first_name:gsub(' ', '_')..'.tar')
    	mystat('/backup')
    end
    if blocks[1] == 'bc' then
    	local res = api.sendAdmin(blocks[2], true)
    	if not res then
    		api.sendAdmin('Can\'t broadcast: wrong markdown')
    	else
	        local hash = 'bot:users'
	        local ids = db:hkeys(hash)
	        local sent, not_sent, err_429, err_403 = 0, 0, 0, 0
	        if next(ids) then
	            for i=1,#ids do
	                local res, code = api.sendMessage(ids[i], blocks[2], true)
	                if not res then
	                	if code == 429 then
	                		err_429 = err_429 + 1
	                		db:sadd('bc:err429', ids[i])
	                	elseif code == 403 then
	                		err_403 = err_403 + 1
	                	else
	                		not_sent = not_sent + 1
	                	end
	                else
	                	sent = sent + 1
	                end
	            end
	            api.sendMessage(msg.from.id, 'Broadcast delivered\n\n*Sent: '..sent..'\nNot sent: '..not_sent + err_429 + err_403..'*\n- Requests rejected for flood (hash: _bc:err429_ ): '..err_429..'\n- Users that blocked the bot: '..err_403, true)
	        else
	            api.sendMessage(msg.from.id, 'No users saved, no broadcast')
	        end
	        mystat('/bc')
	    end
	end
	if blocks[1] == 'bcg' then
		local res = api.sendAdmin(blocks[2], true)
    	if not res then
    		api.sendAdmin('Can\'t broadcast: wrong markdown')
    		return
    	end
	    local groups = db:smembers('bot:groupsid')
	    if not groups then
	    	api.sendMessage(msg.from.id, 'No (groups) id saved')
	    else
	    	for i=1,#groups do
	    		api.sendMessage(groups[i], blocks[2], true)
	        	print('Sent', groups[i])
	    	end
	    	api.sendMessage(msg.from.id, 'Broadcast delivered')
	    end
	    mystat('/bcg')
	end
	if blocks[1] == 'save' then
		db:bgsave()
		api.sendMessage(msg.chat.id, 'Redis updated', true)
		mystat('/save')
	end
	if blocks[1] == 'commands' then
		local text = 'Stats:\n'
	    local hash = 'commands:stats'
	    local names = db:hkeys(hash)
	    local num = db:hvals(hash)
	    for i=1, #names do
	        text = text..'- `'..names[i]..': '..num[i]..'`\n'
	    end
		api.sendMessage(msg.chat.id, text, true)
		mystat('/commands')
    end
    if blocks[1] == 'stats' then
    	local text = '#stats `['..get_date()..']`:\n'
        local hash = 'bot:general'
	    local names = db:hkeys(hash)
	    local num = db:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: `'..num[i]..'`\n'
	    end
	    text = text..'- *last minute msgs*: `'..last_m..'`\n'
	    
	    --[[local uptime = bash('uptime')
	    local ut_d, ut_h = uptime:match('.* up (%d%d) days?, (%d+:%d%d?)')
	    local la_1, la_2, la_3 = uptime:match('.*(%d%d?%.%d%d), (%d%d?%.%d%d), (%d%d?%.%d%d)')
	    local n_core = bash('grep processor /proc/cpuinfo | wc -l')
	    text = text..'\n- *uptime*: `'..ut_d..'d, '..ut_h..'h`\n'..'- *load average* ('..n_core:gsub('\n', '')..'): `'..la_1..', '..la_2..', '..la_3..'`']]
	    
	    --other info
	    if config.channel and config.channel ~= '' then
	    	local channel_members = api.getChatMembersCount(config.channel).result
	    	text = text..'- *channel members*: `'..channel_members..'`\n'
	    end
	    local usernames = db:hkeys('bot:usernames')
	    text = text..'- *usernames cache*: `'..#usernames..'`\n'
	    
	    --db info
	    text = text.. '\n*DB stats*\n'
		local dbinfo = db:info()
	    text = text..'- *redis version*: `'..dbinfo.server.redis_version..'`\n'
	    text = text..'- *uptime days*: `'..dbinfo.server.uptime_in_days..'('..dbinfo.server.uptime_in_seconds..' seconds)`\n'
	    text = text..'- *commands processed*: `'..dbinfo.stats.total_commands_processed..'`\n'
	    text = text..'- *keyspace*:\n'
	    for dbase,info in pairs(dbinfo.keyspace) do
	    	for real,num in pairs(info) do
	    		local keys = real:match('keys=(%d+),.*')
	    		if keys then
	    			text = text..'  '..dbase..': `'..keys..'`\n'
	    		end
	    	end
    	end
    	text = text..'- *expired keys*: `'..dbinfo.stats.expired_keys..'`\n'
    	text = text..'- *ops/sec*: `'..dbinfo.stats.instantaneous_ops_per_sec..'`\n'
    	if dbinfo.stats.total_net_input_bytes then
    		text = text..'- *input bytes*: `'..dbinfo.stats.total_net_input_bytes..'`\n'
    	end
    	if dbinfo.stats.total_net_output_bytes then
    		text = text..'- *outputput bytes*: `'..dbinfo.stats.total_net_output_bytes..'`\n'
    	end
	    
		api.sendMessage(msg.chat.id, text, true)
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
			output = 'Done!'
		else
			output = '```\n'..output..'\n```'
		end
		api.sendMessage(msg.chat.id, output, true, msg.message_id, true)
		mystat('/run')
	end
    if blocks[1] == 'log' then
    	if blocks[2] then
    		if blocks[2] ~= 'del' then
    			local reply = 'I\' sent it in private'
    			if blocks[2] == 'msg' then
    				api.sendDocument(msg.chat.id, './logs/msgs_errors.txt')
    			elseif blocks[2] == 'dbswitch' then
    				api.sendDocument(msg.chat.id, './logs/dbswitch.txt')
    			elseif blocks[2] == 'errors' then
    				api.sendDocument(msg.chat.id, './logs/errors.txt')
    			elseif blocks[2] == 'starts' then
    				api.sendDocument(msg.chat.id, './logs/starts.txt')
    			elseif blocks[2] == 'additions' then
    				api.sendDocument(msg.chat.id, './logs/additions.txt')
    			elseif blocks[2] == 'usernames' then
    				api.sendDocument(msg.chat.id, './logs/usernames.txt')
    			else
    				reply = 'Invalid parameter: '..blocks[2]
    			end
    			if reply:match('^Invalid parameter: .*') then
    				api.sendMessage(msg.chat.id, reply)
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
				api.sendReply(msg, 'This command need a reply or an username')
				return
			else
				id = msg.reply.from.id
			end
		else
			id = blocks[2]
		end
		local response = db:sadd('bot:blocked', id)
		local text
		if response == 1 then
			text = id..' have been blocked'
		else
			text = id..' was already blocked'
		end
		api.sendReply(msg, text)
		mystat('/block')
	end
	if blocks[1] == 'unblock' then
		local id
		local response
		if not blocks[2] then
			if not msg.reply then
				api.sendReply(msg, 'This command need a reply')
				return
			else
				id = msg.reply.from.id
			end
		else
			id = blocks[2]
		end
		local response = db:srem('bot:blocked', id)
		local text
		if response == 1 then
			text = id..' have been unblocked'
		else
			text = id..' was already unblocked'
		end
		api.sendReply(msg, text)
		mystat('/unblock')
	end
	if blocks[1] == 'isblocked' then
		if not msg.reply then
			api.sendReply(msg, 'This command need a reply')
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
		local ris = db:ping()
		if ris == true then
			api.sendMessage(msg.from.id, lang[ln].ping)
		end
		mystat('/ping redis')
	end
	if blocks[1] == 'leave' then
		local text
		if not blocks[2] then
			if msg.chat.type == 'private' then
				text = 'ID missing'
			else
				text = bot_leave(msg.chat.id, ln) 
			end
		else
			text = bot_leave(blocks[2], ln)
		end
		api.sendMessage(msg.from.id, text)
		mystat('/leave')
	end
	if blocks[1] == 'post' then
		if config.channel == '' then
			api.sendMessage(msg.from.id, 'Enter your channel username in config.lua')
		else
			local res = api.sendMessage(config.channel, blocks[2], true)
			local text
			if res then
				text = 'Message posted in '..config.channel
			else
				text = 'Delivery failed. Check the markdown used or the channel username setted'
			end
			api.sendMessage(msg.from.id, text)
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
			api.sendMessage(msg.from.id, 'Missing key')
			return
		end
		local key = blocks[2]
		local hash, res
		if key == 'commands' then
			res = db:del('commands:stats')
		else
			res = db:hdel('bot:general', key)
		end
		if res > 0 then
			api.sendReply(msg.chat.id, 'Resetted!')
		else
			api.sendReply(msg.chat.id, 'Field empty or invalid')
		end
	end
	if blocks[1] == 'send' then
		if not blocks[2] then
			api.sendMessage(msg.from.id, 'Specify an id or reply with the message')
			return
		end
		local id, text
		if blocks[2]:match('(-?%d+)') then
			if not blocks[3] then
				api.sendMessage(msg.from.id, 'Text is missing')
				return
			end
			id = blocks[2]
			text = blocks[3]
		else
			if not msg.reply then
				api.sendMessage(msg.from.id, 'Reply to a user to send him a message')
				return
			end
			id = msg.reply.from.id
			text = blocks[2]
		end
		local res = api.sendMessage(id, text)
		if res then
			api.sendMessage(msg.chat.id, 'Successful delivery')
		end
	end
	if blocks[1] == 'adminmode' then
		if blocks[2]:match('^(on)$') and blocks[2]:match('^(off)$') then
			api.sendMessage(msg.from.id, 'Available status: on/off')
			return
		end
		local status = blocks[2]
		local current = db:hget('bot:general', 'adminmode')
		if current == status then
			api.sendMessage(msg.from.id, 'Admin mode *already '..status..'*', true)
		else
			db:hset('bot:general', 'adminmode', status)
			api.sendMessage(msg.from.id, 'Admin mode: *'..status..'*', true)
		end
	end
	if blocks[1] == 'usernames' then
		local usernames = db:hkeys('bot:usernames')
		local file = io.open("./logs/usernames.txt", "w")
		file:write(vtext(usernames):gsub('"', ''))
        file:close()
        api.sendDocument(msg.from.id, './logs/usernames.txt')
        api.sendMessage(msg.chat.id, 'Instruction processed. Total number of usernames: '..#usernames)
        mystat('/usernames')
    end
    if blocks[1] == 'api errors' then
    	local errors = db:hkeys('bot:errors')
    	local times = db:hvals('bot:errors')
    	local text = 'Api errors:\n'
    	for i=1,#errors do
    		text = text..errors[i]..': '..times[i]..'\n'
    	end
    	mystat('/apierrors')
    	api.sendMessage(msg.from.id, text)
    end
    if blocks[1] == 'rediscli' then
    	local redis_f = blocks[2]:gsub(' ', '(\'', 1)
    	redis_f = redis_f:gsub(' ', '\',\'')
    	redis_f = 'return db:'..redis_f..'\')'
    	redis_f = redis_f:gsub('$chat', msg.chat.id)
    	redis_f = redis_f:gsub('$from', msg.from.id)
    	local output = load_lua(redis_f)
    	mystat('/rediscli')
    	api.sendReply(msg, output, true)
    end
	if blocks[1] == 'trfile' then
		if not msg.reply then
			api.sendReply(msg, 'Reply to a file')
		else
			if not msg.reply.document then
				api.sendReply(msg, 'This is not a file')
				return
			end
			if not blocks[2] then
				local hash = 'trfile:EN'
				db:set(hash, msg.reply.document.file_id)
				api.sendReply(msg, 'Translation file setted!\n*Lang*: '..code:upper()..'\n*ID*: '..msg.reply.document.file_id:mEscape()..'\n*Path*: ln'..code:upper()..'.lua', true)
				return
			end
			local code = blocks[2]
			local exists = is_lang_supported(code)
			if not exists then
				api.sendReply(msg, 'Language not supported')
			else
				local hash = 'trfile:'..code:upper()
				db:set(hash, msg.reply.document.file_id)
				api.sendReply(msg, 'Translation file setted!\n*Lang*: '..code:upper()..'\n*ID*: '..msg.reply.document.file_id:mEscape()..'\n*Path*: ln'..code:upper()..'.lua', true)
			end
			mystat('/trfile')
		end
	end
	if blocks[1] == 'genlang' then
		mystat('/genlang')
		if not blocks[2] then
			local instructions = dofile('instructions.lua')
			for i,ln in pairs(config.available_languages) do
				local path = 'ln'..ln:upper()..'.lua'
				local text = instructions..'\n\n\n\n\n\n\n\n\n\n\n'..vtext(lang[ln])
				write_file(path, text)
				api.sendDocument(msg.chat.id, path)
			end
			return
		end
		local code = blocks[2]
		local exists = is_lang_supported(code)
		if not exists then
			api.sendReply(msg, 'Language not supported')
		else
			local path = 'ln'..code:upper()..'.lua'
			local instructions = dofile('instructions.lua')
			local text = instructions..'\n\n\n\n\n\n\n\n\n\n\n'..vtext(lang[code])
			write_file(path, text)
			api.sendDocument(msg.chat.id, path)
		end
	end
	if blocks[1] == 'fixaction' then
		local id = blocks[2]
		local hash = 'chat:'..id..':flood'
		local key = 'ActionFlood'
		db:hset(hash, key, 'kick')
		key = 'MaxFlood'
		db:hset(hash, key, 5)
		api.sendAdmin('Should be fixed')
	end
	if blocks[1] == 'sendplug' then
		local path = './plugins/'..blocks[2]..'.lua'
		api.sendDocument(msg.from.id, path)
		mystat('/sendplug')
	end
	if blocks[1] == 'sendfile' then
		local path = './'..blocks[2]
		api.sendDocument(msg.from.id, path)
		mystat('/sendfile')
	end
	if blocks[1] == 'r' then
	    --ignore if no reply
	    if not msg.reply then
            api.sendReply(msg, 'Reply to a message')
			return nil
		end
		
		local input = blocks[2]
		
		--ignore if not imput
		if not input then
            api.sendMessage(msg.from.id, 'Write something to reply')
            return
        end
		
		msg = msg.reply_to_message
		local receiver = msg.forward_from.id
		
		local res = api.sendAdmin('*Reply sent:*\n\n'..input, true)
		if res then
			api.sendMessage(receiver, input, true)
		else
			api.sendAdmin('Wrong markdown')
		end
		mystat('/reply')
	end
	if blocks[1] == 'download' then
		if not msg.reply then
			api.sendMessage(msg.chat.id, 'Reply to a message')
		else
			local type
			local file_id
			local file_name
			local text
			msg = msg.reply
			if msg.document then
				type = 'document'
				file_id = msg.document.file_id
				file_name = msg.document.file_name
			elseif msg.sticker then
				type = 'sticker'
				file_id = msg.sticker.file_id
				file_name = 'sticker.png'
			elseif msg.audio then
				type = 'audio'
				file_id = msg.audio.file_id
				file_name = msg.audio.title or msg.audio.performer or 'audio.mp3'
			end
			local res = api.getFile(file_id)
			local download_link = telegram_file_link(res)
			path, code = download_to_file(download_link, file_name)
			if path then
				text = 'Saved to:\n'..path
			else
				text = 'Download failed\nCode: '..code
			end
			api.sendMessage(msg.chat.id, text)
		end
	end
	if blocks[1] == 'migrate' then
		local old = '-'..blocks[2]
		local new = '-'..blocks[3]
		migrate_chat_info(old, new, true)
	end
	if blocks[1] == 'resid' then
		mystat('/resid')
		local user_id = blocks[2]
		local all = db:hgetall('bot:usernames')
		for username,id in pairs(all) do
			if tostring(id) == user_id then
				api.sendReply(msg, username)
				return
			end
		end
		api.sendReply(msg, 'Not found')
	end
	if blocks[1] == 'checkgroups' then
		--could take several minutes
		--ask for the stats before use this command
		local ids = db:smembers('bot:groupsid')
		local txt = ''
		local gin = 0
		local gout = 0
		for i,chat_id in pairs(ids) do
			local res = api.getChatMember(chat_id, bot.id)
			txt = txt..chat_id..'\t'
			if not res then
				txt = txt..'OUT\n'
				gout = gout + 1
			else
				if res.result.status ~= 'member' and res.result.status ~= 'administrator' then
					txt = txt..'OUT ('..res.result.status..')\n'
					gout = gout + 1
				else
					txt = txt..'IN\n'
					gin = gin + 1
				end
			end
		end
		db:hdel('bot:general', 'groups')
    	db:hincrby('bot:general', 'groups', gin)
		txt = txt..'\n\nIn = '..gin..'\nOut = '..gout
		print(txt)
		write_file('logs/groupcount.txt', txt)
		api.sendDocument(config.admin, './logs/groupcount.txt')
	end
	if blocks[1] == 'update' then
		db:del('pin:id', 'pin:type')
		local ids = db:smembers('bot:groupsid')
		--TO DELETE
		--chat:chat_id:warntype
		--chat:chat_id:max
		--chat:chat_id:mediamax
		for i,chat_id in pairs(ids) do
			--moving media settings
			local new = 'chat:'..chat_id..':warnsettings'
			local max = (db:get('chat:'..chat_id..':max')) or 3
			local type = (db:get('chat:'..chat_id..':type')) or 'kick'
			local mediamax = (db:get('chat:'..chat_id..':mediamax')) or 2
			db:hset(new, 'max', max)
			db:hset(new, 'type', type)
			db:hset(new, 'mediamax', mediamax)
			--cleaning up old stuffs
			db:del('bot:'..chat_id..':mod')
			db:del('bot:'..chat_id..':owner')
			db:hdel('chat:'..chat_id..'links', 'poll')
			db:del('bot:'..chat_id..':rules')
			db:del('bot:'..chat_id..':about')
			db:del('media:'..chat_id)
			db:del('extra:'..chat_id)
			db:del('warns:'..chat_id..':type')
			db:del('warns:'..chat_id..':max')
		end
		api.sendMessage(msg.chat.id, '*Updated!*', true)
	end
	if blocks[1] == 'subadmin' then
		--the status will be resetted at the next stop
		if not msg.reply then
			api.sendAdmin('Reply to someone')
			return
		end
		local user_id = msg.reply.from.id
		if blocks[2] == 'yes' then
			config.admin.admins[user_id] = true
		else
			config.admin.admins[user_id] = false
		end
		api.sendAdmin('Changed')
	end
	if blocks[1] == 'tban' then
		if blocks[2] == 'flush' then
			db:del('tempbanned')
			api.sendReply(msg, 'Flushed!')
		end
		if blocks[2] == 'get' then
			api.sendMessage(msg.chat.id, vtext(db:hgetall('tempbanned')))
		end
	end
	if blocks[1] == 'db' then
		if blocks[2] == '00' then
			local output = io.popen('redis-cli config get databases'):read('*all')
			if output then
				api.sendReply(msg, output)
			else
				api.sendReply(msg, 'No output')
			end
			return
		end
		local db_number = tonumber(blocks[2])
		db:select(db_number)
		api.sendReply(msg, 'Current database: *'..db_number..'*\n(Main: *0*)', true)
	end
	if blocks[1] == 'aa' then
		api.sendAdmin(msg.chat.id)
	end
	if blocks[1] == 'remban' then
		local user_id = res_user(blocks[2])
		local text
		if user_id then
			db:del('ban:'..user_id)
			text = 'Done'
		else
			text = 'Username not stored'
		end
		api.sendReply(msg, text)
	end
	if blocks[1] == 'prevban' then
		local id = blocks[2]
		if blocks[2] == '$chat' then id = msg.chat.id end
		local text = (db:smembers('chat:'..id..':prevban')) or 'empty'
		if type(text) == 'table' then text = vtext(text) end
		api.sendMessage(msg.chat.id, text)
	end
	if blocks[1] == 'rawinfo' then
		local chat_id = blocks[2]
		if blocks[2] == '$chat' then
			chat_id = msg.chat.id
		end
		local text = '`'..chat_id..'\n'
		for set, info in pairs(config.chat_settings) do
			text = text..vtext(db:hgetall('chat:'..chat_id..':'..set))
		end
		text = text..'`'
		api.sendMessage(msg.chat.id, text, true)
	end
	if blocks[1] == 'editpost' then
		local msg_id = blocks[2]
		local text = blocks[3]
		local res = api.sendMessage(msg.from.id, text, true)
		if res then
			api.editMessageText(config.channel, msg_id, text, false, true)
			api.sendReply(msg, 'Edited in '..config.channel)
		else
			api.sendReply(msg, 'Breaks the markdown')
		end
	end
	if blocks[1] == 'cleandeadgroups' then
		--not tested
		local dead_groups = db:smembers('bot:groupsid:removed')
		for _, chat_id in pairs(dead_groups) do
			cross.remGroup(chat_id, true)
		end
		api.sendReply(msg, 'Done. Groups passed: '..#dead_groups)
	end
	if blocks[1] == 'initgroup' then
		cross.initGroup(blocks[2])
		api.sendMessage(msg.chat.id, 'Done')
	end
	if blocks[1] == 'remgroup' then
		local full = false
		local chat_id = blocks[2]
		if blocks[2] == 'true' then
			full = true
			chat_id = blocks[3]
		end
		cross.remGroup(chat_id, full)
		api.sendMessage(msg.chat.id, 'Removed (heavy: '..tostring(full)..')')
	end
end

return {
	action = action,
	cron = false,
	triggers = {'^/a', '^###(forward)'}
}