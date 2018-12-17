-- Generic storage backend
local null = require "groupbutler.null"
local log = require "groupbutler.logging"
local config = require "groupbutler.config"
local pgmoon
do
	local _
	_, pgmoon = pcall(require, "pgmoon")
end

local RedisStorage = {}

local PostgresStorage = {}

local MixedStorage = {}

local function enum(t)
	local new_t = {}
	for k,v in pairs(t) do
		new_t[k] = v
		new_t[v] = k
	end
	return new_t
end

local chat_type = enum({
	-- private = 0, -- Not supported
	-- group = 1, -- Not supported
	supergroup = 2,
	channel = 3,
})

local function string_toboolean(v)
	if v == false or "false" or v == "off" or v == "notok" or v == "no" then
		return false
	end
	if v == true or "true" or v == "on" or v == "ok" or v == "yes" then
		return true
	end
	log.warn("Tried toboolean on non truthy value")
	return v
end

local function boolean_tostring(v)
	if v == false then
		return "off"
	end
	if v == true then
		return "on"
	end
	log.warn("Tried tostring on non boolean value")
	return v
end

local function interpolate(s, tab)
	return s:gsub('(%b{})', function(w)
		local v = tab[w:sub(2, -2)]
		if v == false then
			return "false"
		end
		if v == true then
			return "true"
		end
		if v == nil or v == null then
			return "NULL"
		end
		return v
	end)
end

function RedisStorage:new(redis_db)
	local obj = setmetatable({}, {__index = self})
	obj.redis = redis_db
	return obj
end

function PostgresStorage:new()
	local obj = setmetatable({}, {__index = self})
	obj.pg = pgmoon.new(config.postgres)
	assert(obj.pg:connect())
	return obj
end

function MixedStorage:new(redis_db)
	setmetatable(self, {__index = RedisStorage}) -- Any unimplemented method falls back to redis
	local obj = setmetatable({}, {__index = self})
	obj.redis = redis_db
	obj.redis_storage = RedisStorage:new(redis_db)
	local _
	_, obj.postgres_storage = pcall(function() return PostgresStorage:new() end)
	return obj
end

function RedisStorage:_hget_default(hash, key, default)
	local val = self.redis:hget(hash, key)
	if val == null then
		return default
	end
	return val
end

function RedisStorage:forgetUserWarns(chat_id, user_id)
	self.redis:hdel("chat:"..chat_id..":warns", user_id)
	self.redis:hdel("chat:"..chat_id..":mediawarn", user_id)
	self.redis:hdel("chat:"..chat_id..":spamwarns", user_id)
end

function RedisStorage:get_chat_setting(chat_id, setting)
	local default = config.chat_settings.settings[setting]
	local val = self:_hget_default("chat:"..chat_id..":settings", setting, default)
	return string_toboolean(val)
end

function RedisStorage:set_chat_setting(chat_id, setting, value)
	self.redis:hset("chat:"..chat_id..":settings", setting, boolean_tostring(value))
end

function RedisStorage:get_user_setting(user_id, setting)
	local default = config.private_settings[setting]
	local val = self:_hget_default("user:"..user_id..":settings", setting, default)
	return string_toboolean(val)
end

function RedisStorage:get_all_user_settings(user_id)
	local settings = self.redis:array_to_hash(self.redis:hgetall("user:"..user_id..":settings"))
	for setting, default in pairs(config.private_settings) do
		if not settings[setting] then
			settings[setting] = default
		end
		settings[setting] = string_toboolean(settings[setting])
	end
	return settings
end

function RedisStorage:set_user_setting(user_id, setting, value)
	self.redis:hset("user:"..user_id..":settings", setting, boolean_tostring(value))
end

function RedisStorage:toggle_user_setting(user_id, setting)
	self:set_user_setting(user_id, setting, not self:get_user_setting(user_id, setting))
end

function RedisStorage:cache_user(user)
	if user.username then
		self.redis:hset("bot:usernames", "@"..user.username:lower(), user.id)
	end
end

function RedisStorage:get_user_id(username)
	return tonumber(self.redis:hget("bot:usernames", username))
end

function RedisStorage:cacheChat(chat)
	if chat.type ~= "supergroup" then -- don't cache private chats, channels, etc.
		return
	end
	local keys = {
		["chat:"..chat.id..":title"] = chat.title,
	}
	for k,v in pairs(keys) do
		self.redis:set(k, v)
	end
end

function RedisStorage:getChatTitle(chat)
	local title = self.redis:get("chat:"..chat.id..":title")
	if title == null then
		return
	end
	return title
end

function RedisStorage:deleteChat(chat)
	self.redis:srem("bot:groupsid", chat.id)
	self.redis:sadd("bot:groupsid:removed", chat.id) -- add to the list of removed groups

	for i=1, #config.chat_hashes do
		self.redis:del("chat:"..chat.id..":"..config.chat_hashes[i])
	end

	for i=1, #config.chat_sets do
		self.redis:del("chat:"..chat.id..":"..config.chat_sets[i])
	end

	for set, _ in pairs(config.chat_settings) do
		self.redis:del('chat:'..chat.id..':'..set)
	end

	local owner_id = self.redis:get("cache:chat:"..chat.id..":owner")
	local keys = {
		"cache:chat:"..chat.id..":"..owner_id..":permissions",
		"cache:chat:"..chat.id..":admins",
		"cache:chat:"..chat.id..":owner",
		"chat:"..chat.id..":title",
		"chat:"..chat.id..":userlast",
		"chat:"..chat.id..":members",
		"chat:"..chat.id..":pin",
		"lang:"..chat.id,
	}
	for _,k in pairs(keys) do
		self.redis:del(k)
	end

	local fields = {
		"bot:logchats",
		"bot:chats:latsmsg",
		"bot:chatlogs",
	}
	for _,k in pairs(fields) do
		self.redis:hdel(k, chat.id)
	end
end

function RedisStorage:set_keepalive()
	self.redis:set_keepalive()
end

function RedisStorage:get_reused_times()
	return self.redis:get_reused_times()
end

local function is_user_property_optional(k)
	if k == "last_name"
	or k == "username"
	or k == "language_code" then
		return true
	end
end

function PostgresStorage:cache_user(user)
	local row = {
		id = user.id,
		is_bot = user.is_bot,
		first_name = self.pg:escape_literal(user.first_name)
	}
	for k, _ in pairs(user) do
		if is_user_property_optional(k) then
			row[k] = self.pg:escape_literal(user[k])
		end
	end
	local username = ""
	if user.username then
		username = 'UPDATE "user" SET username = NULL WHERE lower(username) = lower({username});\n'
	end
	local insert = 'INSERT INTO "user" (id, is_bot, first_name'
	local values = ") VALUES ({id}, {is_bot}, {first_name}"
	local on_conflict = " ON CONFLICT (id) DO UPDATE SET first_name = {first_name}"
	for k, _ in pairs(row) do
		if is_user_property_optional(k) then
			insert = insert..", "..k
			values = values..", {"..k.."}"
			on_conflict = on_conflict..", "..k.." = {"..k.."}"
		end
	end
	values = values..")"
	local query = interpolate(username..insert..values..on_conflict, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
	end
	return true
end

function PostgresStorage:get_user_id(username)
	if username:byte(1) == string.byte("@") then
		username = username:sub(2)
	end
	local query = interpolate('SELECT id FROM "user" WHERE lower(username) = lower({username})',
		{username = self.pg:escape_literal(username)})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].id then
		return false
	end
	return ok[1].id
end

local function is_chat_property_optional(k)
	if k == "username"
	or k == "invite_link" then
		return true
	end
end

function PostgresStorage:cacheChat(chat)
	if chat.type ~= "supergroup" then -- don't cache private chats, channels, etc.
		return
	end
	local row = {
		id = chat.id,
		type = chat_type[chat.type],
		title = self.pg:escape_literal(chat.title)
	}
	for k, _ in pairs(chat) do
		if is_chat_property_optional(k) then
			row[k] = self.pg:escape_literal(chat[k])
		end
	end
	local insert = 'INSERT INTO "chat" (id, type, title'
	local values = ") VALUES ({id}, '{type}', {title}"
	local on_conflict = ") ON CONFLICT (id) DO UPDATE SET title = {title}"
	for k, _ in pairs(row) do
		if is_chat_property_optional(k) then
			insert = insert..", "..k
			values = values..", {"..k.."}"
			on_conflict = on_conflict..", "..k.." = {"..k.."}"
		end
	end
	local query = interpolate(insert..values..on_conflict, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
	end
	return true
end

function PostgresStorage:getChatTitle(chat)
	local query = interpolate('SELECT title FROM "chat" WHERE id = {id}', chat)
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].title then
		return false
	end
	return ok[1].title
end

function PostgresStorage:deleteChat(chat)
	local query = interpolate('DELETE FROM "chat" WHERE id = {id}', chat)
	self.pg:query(query)
end

function PostgresStorage:set_keepalive()
	return self.pg:keepalive()
end

function PostgresStorage:get_reused_times() -- luacheck: ignore 212
	return "Unknown"
end

function MixedStorage:cache_user(user)
	local res, ok = pcall(function() return self.postgres_storage:cache_user(user) end)
	if not res or not ok then
		self.redis_storage:cache_user(user)
	end
end

function MixedStorage:get_user_id(username)
	local ok, id = pcall(function() return self.postgres_storage:get_user_id(username) end)
	if not ok or not id then
		return self.redis_storage:get_user_id(username)
	end
	return id
end

function MixedStorage:cacheChat(chat)
	local res, ok = pcall(function() return self.postgres_storage:cacheChat(chat) end)
	if not res or not ok then
		self.redis_storage:cacheChat(chat)
	end
end

function MixedStorage:getChatTitle(chat)
	local ok, title = pcall(function() return self.postgres_storage:getChatTitle(chat) end)
	if not ok or not title then
		return self.redis_storage:getChatTitle(chat)
	end
	return title
end

function MixedStorage:deleteChat(chat)
	pcall(function() return self.postgres_storage:deleteChat(chat) end)
	self.redis_storage:deleteChat(chat)
end

function MixedStorage:set_keepalive()
	pcall(function() return self.postgres_storage:set_keepalive() end)
	self.redis_storage:set_keepalive()
end

function MixedStorage:get_reused_times()
	local redis = self.redis_storage:get_reused_times()
	local ok, postgres = pcall(function() return self.postgres_storage:get_reused_times() end)
	local str = "Redis: "..redis
	-- pgmoon does not currently implement this so it will always return "Unknown"
	if ok and postgres then
		str = str.."\nPostgres: "..postgres
	end
	return str
end

return MixedStorage
