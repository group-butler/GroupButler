local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local null = require "groupbutler.null"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local triggers2 = {
	'^%$(init)$',
	'^%$(backup)$',
	'^%$(save)$',
	'^%$(stats)$',
	'^%$(lua) (.*)$',
	'^%$(run) (.*)$',
	'^%$(admin)$',
	'^%$(block)$',
	'^%$(block) (%d+)$',
	'^%$(blocked)$',
	'^%$(unblock) (%d+)$',
	'^%$(leave) (-%d+)$',
	'^%$(leave)$',
	'^%$(api errors)$',
	'^%$(rediscli) (.*)$',
	'^%$(sendfile) (.*)$',
	'^%$(res) (@%a[%w_]+)',
	'^%$(tban) (get)$',
	'^%$(tban) (flush)$',
	'^%$(remban) (@[%w_]+)$',
	'^%$(rawinfo) (.*)$',
	'^%$(rawinfo2) (.*)$',
	'^%$(initgroup) (-%d+)$',
	'^%$(remgroup) (-%d+)$',
	'^%$(remgroup) (true) (-%d+)$',
	'^%$(cache) (.*)$',
	'^%$(initcache) (.*)$',
	'^%$(active) (%d%d?)$',
	'^%$(active)$',
	'^%$(getid)$',
	'^%$(permission)s?'
}

local function bot_leave(self, chat_id)
	local db = self.db
	local res = api.leaveChat(chat_id)
	if not res then
		return 'Check the id, it could be wrong'
	end
	db:srem('bot:groupsid', chat_id)
	db:sadd('bot:groupsid:removed', chat_id)
	return 'Chat left!'
end

-- local function round(num, decimals)
--   local mult = 10^(decimals or 0)
--   return math.floor(num * mult + 0.5) / mult
-- end

-- local function load_lua(code, msg)
-- 	local output = loadstring('local msg = '..u:vtext(msg)..'\n'..code)()
-- 	if not output then
-- 		output = '`Done! (no output)`'
-- 	else
-- 		if type(output) == 'table' then
-- 			output = u:vtext(output)
-- 		end
-- 		output = '```\n' .. output .. '\n```'
-- 	end
-- 	return output
-- end

local function match_pattern(self, pattern, text)
	local bot = self.bot
  if text then
		text = text:gsub('@'..bot.username, '')
		local matches = { string.match(text, pattern) }
		if next(matches) then
			return matches
		end
  end
end

local function get_chat_id(msg)
	if msg.text:find('$chat') then
		return msg.chat.id
	elseif msg.text:find('-%d+') then
		return msg.text:match('(-%d+)')
	elseif msg.reply then
		if msg.reply.text:find('-%d+') then
			return msg.reply.text:match('(-%d+)')
		end
	else
		return false
	end
end

function _M:onTextMessage(blocks)
	local msg = self.message
	local bot = self.bot
	local u = self.u
	local db = self.db
	if not u:is_superadmin(msg.from.id) then return end

	for i=1, #triggers2 do
		blocks = match_pattern(self, triggers2[i], msg.text)
		if blocks then break end
	end

	if not blocks or not next(blocks) then return true end --leave this plugin and continue to match the others

	if blocks[1] == 'admin' then
		api.sendMessage(msg.from.id, u:vtext(triggers2))
	end
	-- if blocks[1] == 'init' then
	-- 	local n_plugins = bot.init(true)
	-- 	local reply = '*Bot reloaded!*'
	-- 	if n_plugins then reply = reply..'\n_'..n_plugins..' plugins enabled_' end
	-- 	msg:send_reply(reply, "Markdown")
	-- end
	if blocks[1] == 'backup' then
		db:bgsave()
		local cmd = io.popen('sudo tar -cpf '..bot.first_name:gsub(' ', '_')..'.tar *')
		cmd:read('*all')
		cmd:close()
		api.sendDocument(msg.from.id, './'..bot.first_name:gsub(' ', '_')..'.tar')
	end
	if blocks[1] == 'save' then
		local res = db:save()
		api.sendMessage(msg.chat.id, 'res: '..tostring(res))
	end
	if blocks[1] == 'stats' then
		local text = '#stats `['..u:get_date()..']`:\n'
		local hash = 'bot:general'  -- Todo: update this for the new metrics
		local names = db:hkeys(hash)
		local num = db:hvals(hash)
		for i=1, #names do
			text = text..'- *'..names[i]..'*: `'..num[i]..'`\n'
		end
		text = text..'- *total msg*: '..(u:metric_get("messages_count") or "No Data")..' \n'
		-- text = text..'- *uptime*: `from '..(os.date("%c", bot.start_timestamp))..' (GMT+2)`\n'
		-- text = text..'- *last hour msgs*: `'..bot.last.h..'`\n'
		-- text = text..'   • *average msgs/minute*: `'..round((bot.last.h/60), 3)..'`\n'
		-- text = text..'   • *average msgs/second*: `'..round((bot.last.h/(60*60)), 3)..'`\n'

		--db info
		-- text = text.. '\n*DB stats*\n'
		-- local dbinfo = db:info()
		-- text = text..'- *uptime days*: `'..dbinfo.server.uptime_in_days..'('..dbinfo.server.uptime_in_seconds..' seconds)`\n'
		-- text = text..'- *keyspace*:\n'
		-- for dbase,info in pairs(dbinfo.keyspace) do
		-- 	for real, _ in pairs(info) do
		-- 		local keys = real:match('keys=(%d+),.*')
		-- 		if keys then
		-- 			text = text..'  '..dbase..': `'..keys..'`\n'
		-- 		end
		-- 	end
		-- end
		-- text = text..'- *ops/sec*: `'..dbinfo.stats.instantaneous_ops_per_sec..'`\n'

		api.sendMessage(msg.chat.id, text, "Markdown")
	end
	-- if blocks[1] == 'lua' then
	-- 	local output = load_lua(blocks[2], msg)
	-- 	api.sendMessage(msg.chat.id, output, "Markdown")
	-- end
	if blocks[1] == 'run' then
		--read the output
		local output = io.popen(blocks[2]):read('*all')
		--check if the output has a text
		if output:len() == 0 then
			output = 'Done!'
		else
			output = '```\n'..output..'\n```'
		end
		msg:send_reply(output, "Markdown")
	end
	if blocks[1] == 'block' then
		local id
		if blocks[2] then
			id = blocks[2]
		else
			id = msg.reply.forward_from.id
		end
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
	if blocks[1] == 'blocked' then
		api.sendMessage(msg.chat.id, u:vtext(db:smembers('bot:blocked')))
	end
	if blocks[1] == 'leave' then
		local text
		if not blocks[2] then
			if msg.chat.type == 'private' then
				text = 'ID missing'
			else
				text = bot_leave(self, msg.chat.id)
			end
		else
			text = bot_leave(self, blocks[2])
		end
		api.sendMessage(msg.from.id, text)
	end
	if blocks[1] == 'api errors' then
		local t = db:hgetall('bot:errors')
		api.sendMessage(msg.chat.id, u:vtext(t))
	end
	-- if blocks[1] == 'rediscli' then
	-- 	local redis_f = blocks[2]:gsub(' ', '(\'', 1)
	-- 	redis_f = redis_f:gsub(' ', '\',\'')
	-- 	redis_f = 'return db:'..redis_f..'\')'
	-- 	redis_f = redis_f:gsub('$chat', msg.chat.id)
	-- 	redis_f = redis_f:gsub('$from', msg.from.id)
	-- 	local output = load_lua(redis_f)
	-- 	msg:send_reply(output, "Markdown")
	-- end
	if blocks[1] == 'sendfile' then
		local path = blocks[2]
		api.sendDocument(msg.from.id, path)
	end
	if blocks[1] == 'res' then
		local username = blocks[2]
		local user_id = {
			normal = u:resolve_user(username),
			lower = u:resolve_user(username:lower())
		}
		api.sendMessage(msg.chat.id, u:vtext(user_id))
	end
	if blocks[1] == 'tban' then
		if blocks[2] == 'flush' then
			db:del('tempbanned')
			msg:send_reply('Flushed!')
		end
		if blocks[2] == 'get' then
			api.sendMessage(msg.chat.id, u:vtext(db:hgetall('tempbanned')))
		end
	end
	if blocks[1] == 'remban' then
		local user_id = u:resolve_user(blocks[2])
		local text
		if user_id then
			db:del('ban:'..user_id)
			text = 'Done'
		else
			text = 'Username not stored'
		end
		msg:send_reply(text)
	end
	if blocks[1] == 'rawinfo' then
		local chat_id = blocks[2]
		if blocks[2] == '$chat' then
			chat_id = msg.chat.id
		end
		local text = '<code>'..chat_id..'\n'
		for set, _ in pairs(config.chat_settings) do
			text = text..u:vtext(db:hgetall('chat:'..chat_id..':'..set))
		end

		local log_channel = db:hget('bot:chatlogs', chat_id)
		if log_channel ~= null then text = text..'\nLog channel: '..log_channel end

		text = text..'</code>'

		api.sendMessage(msg.chat.id, text, 'html')
	end
	if blocks[1] == 'rawinfo2' then
		local chat_id
		if blocks[2] == '$chat' then
			chat_id = msg.chat.id
		else
			chat_id = blocks[2]
		end
		local text = chat_id..'\n'

		local section
		for i=1, #config.chat_hashes do
			section = u:vtext(db:hgetall(('chat:%s:%s'):format(tostring(chat_id), config.chat_hashes[i]))) or '{}'
			text = text..config.chat_hashes[i]..'(hash)>'..section
		end
		for i=1, #config.chat_sets do
			section = u:vtext(db:smembers(('chat:%s:%s'):format(tostring(chat_id), config.chat_sets[i]))) or '{}'
			text = text..config.chat_sets[i]..'(set)>'..section
		end
		local ok, err = api.sendMessage(msg.chat.id, text)
		if not ok and err.description:match("message is too long") then
			local file_path = '/tmp/'..chat_id..'.txt'
			local file = io.open(file_path, "w")
			file:write(text)
			file:close()
			api.sendDocument(msg.chat.id, file_path)
		end
	end
	if blocks[1] == 'initgroup' then
		u:initGroup(blocks[2])
		api.sendMessage(msg.chat.id, 'Done')
	end
	if blocks[1] == 'remgroup' then
		local full = false
		local chat_id = blocks[2]
		if blocks[2] == 'true' then
			full = true
			chat_id = blocks[3]
		end
		u:remGroup(chat_id, full)
		api.sendMessage(msg.chat.id, 'Removed (heavy: '..tostring(full)..')')
	end
	if blocks[1] == 'cache' then
		local chat_id = get_chat_id(msg)
		local members = db:smembers('cache:chat:'..chat_id..':admins')
		for i=1, #members do
			local permissions = db:smembers("cache:chat:"..chat_id..":"..members[i]..":permissions")
			members[members[i]] = permissions
		end
		api.sendMessage(msg.chat.id, chat_id..' ➤ '..tostring(#members)..'\n'..u:vtext(members))
	end
	if blocks[1] == 'initcache' then
		local chat_id, text
		chat_id = get_chat_id(msg)
		local res, code = u:cache_adminlist(chat_id)
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
		for _, timestamp in pairs(groups) do
			if tonumber(timestamp) > (now - (seconds_per_day * days)) then
				n = n + 1
			end
		end
		api.sendMessage(msg.chat.id, 'Active groups in the last '..days..' days: '..n)
	end
	if blocks[1] == 'getid' then
		if msg.reply.forward_from then
			api.sendMessage(msg.chat.id, '`'..msg.reply.forward_from.id..'`', true)
		end
	end
	if blocks[1] == 'permission' then
		local chat_id = get_chat_id(msg)
		if not chat_id then
			api.sendMessage(msg, "Can't find a chat_id")
		else
			local res = api.getChatMember(chat_id, bot.id)
			api.sendMessage(msg.chat.id, ('%s\n%s'):format(chat_id, u:vtext(res)))
		end
	end
end

_M.triggers = {
	onTextMessage = {'^%$'}
}

return _M
