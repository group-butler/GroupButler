local plugin = {}

local triggers2 = {
	'^%$(init)$',
	'^%$(stop)$',
	'^%$(backup)$',
	'^%$(save)$',
	'^%$(stats)$',
	'^%$(lua) (.*)$',
	'^%$(run) (.*)$',
	'^%$(admin)$',
	'^%$(block) (%d+)$',
	'^%$(unblock) (%d+)$',
	'^%$(leave) (-%d+)$',
	'^%$(leave)$',
	'^%$(api errors)$',
	'^%$(rediscli) (.*)$',
	'^%$(sendfile) (.*)$',
	'^%$(download)$',
	'^%$(resid) (%d+)$',
	'^%$(update)$',
	'^%$(tban) (get)$',
	'^%$(tban) (flush)$',
	'^%$(selectdb) (.*)$',
	'^%$(aa)$',
	'^%$(remold)$',
	'^%$(remban) (@[%w_]+)$',
	'^%$(info) (%d+)$',
	'^%$(prevban) (.*)$',
	'^%$(rawinfo) (.*)$',
	'^%$(cleandeadgroups)$',
	'^%$(initgroup) (-%d+)$',
	'^%$(remgroup) (-%d+)$',
	'^%$(remgroup) (true) (-%d+)$',
	'^%$(cache) (.*)$',
	'^%$(initcache) (.*)$',
	'^%$(active) (%d%d?)$',
	'^%$(active)$',
	'^%$(getid)$',
	'^%$(updatelocale) (.*)$',
	'^%$(realm) (.+)$'
}

function plugin.cron()
	db:bgsave()
end

plugin.cron = nil

local function bot_leave(chat_id)
	local res = api.leaveChat(chat_id)
	if not res then
		return 'Check the id, it could be wrong'
	else
		db:srem('bot:groupsid', chat_id)
		db:sadd('bot:groupsid:removed', chat_id)
		return 'Chat leaved!'
	end
end

local function round(num, decimals)
  local mult = 10^(decimals or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function load_lua(code, msg)
	local output = loadstring('local msg = '..vtext(msg)..'\n'..code)()
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

function plugin.onTextMessage(msg, blocks)
	
	if not roles.is_superadmin(msg.from.id) then return end
	
	blocks = {}
	
	for _, trigger in pairs(triggers2) do
		blocks = match_pattern(trigger, msg.text)
		if blocks then break end
	end
	
	if not blocks or not next(blocks) then return true end --leave this plugin and continue to match the others
	
	if blocks[1] == 'admin' then
		local text = ''
		for k,v in pairs(triggers2) do
			text = text..v..'\n'
		end
		api.sendMessage(msg.from.id, text)
	end
	if blocks[1] == 'init' then
		db:bgsave()
		local n_plugins = bot_init(true) or 0
		api.sendReply(msg, '*Bot reloaded!*\n_'..n_plugins..' plugins enabled_', true)
	end
	if blocks[1] == 'stop' then
		db:bgsave()
		is_started = false
		api.sendReply(msg, '*Stopping bot*', true)
	end
	if blocks[1] == 'backup' then
		db:bgsave()
		local cmd = io.popen('sudo tar -cpf '..bot.first_name:gsub(' ', '_')..'.tar *')
    	cmd:read('*all')
    	cmd:close()
    	api.sendDocument(msg.from.id, './'..bot.first_name:gsub(' ', '_')..'.tar')
    end
	if blocks[1] == 'save' then
		db:bgsave()
		api.sendMessage(msg.chat.id, 'Redis updated', true)
	end
    if blocks[1] == 'stats' then
    	local text = '#stats `['..misc.get_date()..']`:\n'
        local hash = 'bot:general'
	    local names = db:hkeys(hash)
	    local num = db:hvals(hash)
	    for i=1, #names do
	        text = text..'- *'..names[i]..'*: `'..num[i]..'`\n'
	    end
	    local kb = collectgarbage("count")
	    text = text..'- *kilobytes used*: `'..kb..'`\n'
	    text = text..'- *uptime*: `from '..(os.date("%c", start_timestamp))..' (GMT+2)`\n'
	    text = text..'- *last hour msgs*: `'..last.h..'`\n'
	    text = text..'   • *average msgs/minute*: `'..round((last.h/60), 3)..'`\n'
	    text = text..'   • *average msgs/second*: `'..round((last.h/(60*60)), 3)..'`\n'
	    
	    local usernames = db:hkeys('bot:usernames')
	    text = text..'- *usernames cache*: `'..#usernames..'`\n'
	    
	    --db info
	    text = text.. '\n*DB stats*\n'
		local dbinfo = db:info()
	    text = text..'- *uptime days*: `'..dbinfo.server.uptime_in_days..'('..dbinfo.server.uptime_in_seconds..' seconds)`\n'
	    text = text..'- *keyspace*:\n'
	    for dbase,info in pairs(dbinfo.keyspace) do
	    	for real,num in pairs(info) do
	    		local keys = real:match('keys=(%d+),.*')
	    		if keys then
	    			text = text..'  '..dbase..': `'..keys..'`\n'
	    		end
	    	end
    	end
    	text = text..'- *ops/sec*: `'..dbinfo.stats.instantaneous_ops_per_sec..'`\n'
	    
		api.sendMessage(msg.chat.id, text, true)
	end
	if blocks[1] == 'lua' then
		local output = load_lua(blocks[2], msg)
		api.sendMessage(msg.chat.id, output, true)
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
	end
	if blocks[1] == 'block' then
		local id = blocks[2]
		local response = db:sadd('bot:blocked', id)
		local text
		if response == 1 then
			text = id..' has been blocked'
		else
			text = id..' is already blocked'
		end
		api.sendReply(msg, text)
	end
	if blocks[1] == 'unblock' then
		local id = blocks[2]
		local response = db:srem('bot:blocked', id)
		local text
		if response == 1 then
			text = id..' has been unblocked'
		else
			text = id..' is already unblocked'
		end
		api.sendReply(msg, text)
	end
	if blocks[1] == 'leave' then
		local text
		if not blocks[2] then
			if msg.chat.type == 'private' then
				text = 'ID missing'
			else
				text = bot_leave(msg.chat.id) 
			end
		else
			text = bot_leave(blocks[2])
		end
		api.sendMessage(msg.from.id, text)
	end
	if blocks[1] == 'forward' then
		if msg.chat.type == 'private' then
			if msg.forward_from then
				api.sendReply(msg, msg.forward_from.id)
			end
		end
		return msg.text:gsub('###forward:', '')
	end
    if blocks[1] == 'api errors' then
    	local errors = db:hkeys('bot:errors')
    	local times = db:hvals('bot:errors')
    	local text = 'Api errors:\n'
    	for i=1,#errors do
    		text = text..errors[i]..': '..times[i]..'\n'
    	end
    	api.sendMessage(msg.from.id, text)
    end
    if blocks[1] == 'rediscli' then
    	local redis_f = blocks[2]:gsub(' ', '(\'', 1)
    	redis_f = redis_f:gsub(' ', '\',\'')
    	redis_f = 'return db:'..redis_f..'\')'
    	redis_f = redis_f:gsub('$chat', msg.chat.id)
    	redis_f = redis_f:gsub('$from', msg.from.id)
    	local output = load_lua(redis_f)
    	api.sendReply(msg, output, true)
    end
	if blocks[1] == 'sendfile' then
		local path = './'..blocks[2]
		api.sendDocument(msg.from.id, path)
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
			local download_link = misc.telegram_file_link(res)
			path, code = misc.download_to_file(download_link, file_name)
			if path then
				text = 'Saved to:\n'..path
			else
				text = 'Download failed\nCode: '..code
			end
			api.sendMessage(msg.chat.id, text)
		end
	end
	if blocks[1] == 'resid' then
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
	if blocks[1] == 'update' then
		local groups = db:smembers('bot:groupsid')
		local n = 0
		for chat_id in pairs(groups) do
			local hash = 'chat:'..chat_id..':media'
			db:hdel(hash, 'TGlink')
			
			--[[local image = db:hget(hash, 'image')
			db:hdel(hash, 'image')
			local file = db:hget(hash, 'file')
			db:hdel(hash, 'file')
			if image and type(image) == 'string' then
				db:hset(hash, 'photo', image)
				n = n + 1
			end
			if file and type(file) == 'string' then
				db:hset(hash, 'document', file)
				n = n + 1
			end]]
		end
		api.sendReply(msg, 'Done. Replaced '..n..' key(s)')
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
	if blocks[1] == 'selectdb' then
		local db_number = tonumber(blocks[2])
		db:select(db_number)
		api.sendReply(msg, 'Current database: *'..db_number..'*\n(Main: *0*)', true)
	end
	if blocks[1] == 'aa' then
		api.sendAdmin(msg.chat.id)
	end
	if blocks[1] == 'remban' then
		local user_id = misc.resolve_user(blocks[2])
		local text
		if user_id then
			db:del('ban:'..user_id)
			text = 'Done'
		else
			text = 'Username not stored'
		end
		api.sendReply(msg, text)
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
	if blocks[1] == 'cleandeadgroups' then
		--not tested
		local dead_groups = db:smembers('bot:groupsid:removed')
		for _, chat_id in pairs(dead_groups) do
			misc.remGroup(chat_id, true)
		end
		api.sendReply(msg, 'Done. Groups passed: '..#dead_groups)
	end
	if blocks[1] == 'initgroup' then
		misc.initGroup(blocks[2])
		api.sendMessage(msg.chat.id, 'Done')
	end
	if blocks[1] == 'remgroup' then
		local full = false
		local chat_id = blocks[2]
		if blocks[2] == 'true' then
			full = true
			chat_id = blocks[3]
		end
		misc.remGroup(chat_id, full)
		api.sendMessage(msg.chat.id, 'Removed (heavy: '..tostring(full)..')')
	end
	if blocks[1] == 'remold' then
		local hash = 'bot:chat:latsmsg'
		local removed_groups = 0
		local today_n = tonumber(os.date("%j"))
		print('TODAY N°\t'..today_n..'\nRemoved groups:\n')
		for chat_id, group_timestamp in pairs(db:hgetall(hash)) do
			local groupday_n = tonumber(os.date("%j", group_timestamp))
			if 7 < (today_n - groupday_n) then
				print(chat_id, 'day n° '..groupday_n)
				misc.remGroup(chat_id, true)
				--db:hdel(hash, chat_id)
				--db:sadd('remolden_chats', chat_id)
				removed_groups = removed_groups + 1
			end
		end
		api.sendReply(msg, 'Groups older than 7 days removed from the db: '..removed_groups)
	end
	if blocks[1] == 'cache' then
		local chat_id
		if blocks[2] == '$chat' then
			chat_id = msg.chat.id
		else
			chat_id = blocks[2]
		end
		local members = db:smembers('cache:chat:'..chat_id..':admins')
		api.sendMessage(msg.chat.id, chat_id..' ➤ '..tostring(#members)..'\n'..vtext(members))
	end
	if blocks[1] == 'initcache' then
		local chat_id, text
		if blocks[2] == '$chat' then
			chat_id = msg.chat.id
		else
			chat_id = blocks[2]
		end
		local res, code = misc.cache_adminlist(chat_id)
		if res then
			text = 'Cached ➤ '..code..' admins stored'
		else
			text = 'Failed: '..tostring(code)
		end
		api.sendMessage(msg.chat.id, text)
	end
	if blocks[1] == 'active' then
		local days = tonumber(blocks[2]) or 7
		local now = os.time()
		local seconds_per_day = 60*60*24
		local groups = db:hgetall('bot:chats:latsmsg')
		local n = 0
		for chat_id, timestamp in pairs(groups) do
			if tonumber(timestamp) > (now - (seconds_per_day * days)) then
				n = n + 1
			end
		end
		api.sendMessage(msg.chat.id, 'Active groups in the last '..days..' days: '..n)
	end
	if blocks[1] == 'getid' then
		if msg.forward_from then
			api.sendMessage(msg.chat.id, '`'..msg.forward_from.id..'`', true)
		end
	end
	if blocks[1] == 'updatelocale' then
		local lang = blocks[2]
		misc.bash('./launch.sh update-locale '..lang)
		api.sendMessage(msg.chat.id, 'Updating `'..lang..'`... (check by yourself)', true)
	end
	if blocks[1] == 'realm' then
		local chat_id
		if blocks[2] == '$chat' then
			chat_id = msg.chat.id
		else
			chat_id = blocks[2]
		end
		local text = 'Group: '..chat_id..'\nIs in the general list: '..tostring(db:sismember('bot:realms', chat_id))..'\n'
		local subgroups = db:hgetall('realm:'..chat_id..':subgroups')
		if not next(subgroups) then
			text = text..'Doesn\'t have subgroups paired'
		else
			text = text..'Subgroups:\n'
			for subgroup_id, subgroup_name in pairs(subgroups) do
				text = text..subgroup_id
				local subgroup_paired_realm = (db:get('chat:'..subgroup_id..':realm')) or 'none'
				text = text..' X '..subgroup_paired_realm..'\n'
			end
		end
		api.sendMessage(msg.chat.id, text)
	end
end

plugin.triggers = {
	onTextMessage = {'^%$'}
}
		
return plugin
