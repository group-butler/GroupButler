local config = require "groupbutler.config"
local json = require "cjson"
local locale = require "groupbutler.languages"
local i18n = locale.translate
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

local function save_data(filename, data)
	local s = json.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()
end

local function load_data(filename)
	local f = io.open(filename)
	if f then
		local s = f:read('*all')
		f:close()
		return json.decode(s)
	else
		return {}
	end
end

local function gen_backup(self, chat_id)
	local red = self.red
	chat_id = tostring(chat_id)
	local file_path = '/tmp/snap'..chat_id..'.gbb'
	local t = {
		[chat_id] = {
			hashes = {},
			sets = {}
		}
	}
	local hash
	for i=1, #config.chat_hashes do
		hash = ('chat:%s:%s'):format(chat_id, config.chat_hashes[i])
		local content = red:hgetall(hash)
		if next(content) then
			t[chat_id].hashes[config.chat_hashes[i]] = {}
			for key, val in pairs(content) do
				t[chat_id].hashes[config.chat_hashes[i]][key] = val
			end
		end
	end
	for i=1, #config.chat_sets do
		local set = ('chat:%s:%s'):format(chat_id, config.chat_sets[i])
		local content = red:smembers(set)
		if next(content) then
			t[chat_id].sets[config.chat_sets[i]] = content
		end
	end
	-- u:dump(t)
	save_data(file_path, t)

	return file_path
end

local function get_time_remaining(seconds)
	local final = ''
	local hours = math.floor(seconds/3600)
	seconds = seconds - (hours*60*60)
	local min = math.floor(seconds/60)
	seconds = seconds - (min*60)

	if hours and hours > 0 then
		final = final..hours..'h '
	end
	if min and min > 0 then
		final = final..min..'m '
	end
	if seconds and seconds > 0 then
		final = final..seconds..'s'
	end

	return final
end

local imported_text = i18n([[Import was <b>successful</b>.

<b>Important</b>:
- #extra commands which are associated with a media must be set again if the bot you are using now is different from the bot that originated the backup.
]])

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local u = self.u

	if not msg:is_from_admin() then
		return
	end
	if blocks[1] == 'snap' then
		local key = 'chat:'..msg.chat.id..':lastsnap'
		local last_user = red:get(key)
			if last_user ~= null then
			-- A snapshot has been done recently
			local ttl = red:ttl(key)
			local time_remaining = get_time_remaining(ttl)
			local text = i18n([[<i>I'm sorry, this command has been used for the last time less then 3 hours ago by</i> %s (ask them for the file).
Wait [<code>%s</code>] to use it again
]]):format(last_user, time_remaining)
				msg:send_reply(text, 'html')
		else
			-- no snapshot has been done recently
				local name = u:getname_final(msg.from)
			red:setex(key, 10800, name) --3 hours
				local file_path = gen_backup(self, msg.chat.id)
				msg:send_reply(i18n('*Sent in private*'), "Markdown")
				api:sendDocument(msg.from.id, {path = file_path}, ('#snap\n%s'):format(msg.chat.title))
		end
	end
	if blocks[1] == 'import' then
		local text
		if not msg.reply then
			text = i18n('Invalid input. Please reply to the backup file (/snap command to get it)')
			api:sendMessage(msg.chat.id, text)
			return
		end
		if not msg.reply.document then
			text = i18n('Invalid input. Please reply to a document')
			api:sendMessage(msg.chat.id, text)
			return
		end
		if msg.reply.document.file_name ~= 'snap'..msg.chat.id..'.gbb' then
			text = i18n('This is not a valid backup file.\nReason: invalid name (%s)')
				:format(tostring(msg.reply_to_message.document.file_name))
			api:sendMessage(msg.chat.id, text)
			return
		end
		local res = api:getFile(msg.reply.document.file_id)
						local download_link = u:telegram_file_link(res)
						local file_path, code = u:download_to_file(download_link, '/tmp/'..msg.chat.id..'.json')

		if not file_path then
			text = i18n('Download of the file failed with code %s'):format(tostring(code))
			api:sendMessage(msg.chat.id, text)
			return
		end

		local data = load_data(file_path)
		for chat_id, group_data in pairs(data) do
			chat_id = tonumber(chat_id)
			if tonumber(chat_id) ~= msg.chat.id then
				text = i18n('Chat IDs don\'t match (%s and %s)'):format(tostring(chat_id), tostring(msg.chat.id))
				api:sendMessage(msg.chat.id, text)
				return
			end
			--restoring sets
			if group_data.sets and next(group_data.sets) then
				for set, content in pairs(group_data.sets) do
					red:sadd(('chat:%d:%s'):format(chat_id, set), unpack(content))
				end
			end

			--restoring hashes
			if group_data.hashes and next(group_data.hashes) then
				for hash, content in pairs(group_data.hashes) do
					if next(content) then
						--[[for key, val in pairs(content) do
							print('\tkey:', key)
							red:hset(('chat:%d:%s'):format(chat_id, hash), key, val)
						end]]
						red:hmset(('chat:%d:%s'):format(chat_id, hash), content)
					end
				end
			end
			api:sendMessage(msg.chat.id, imported_text, "html")
		end
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(snap)$',
		config.cmd..'(import)$'
	}
}

return _M
