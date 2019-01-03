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

local chat_member_status = enum({
	creator = 0,
	administrator = 1,
	member = 2,
	restricted = 3,
	left = 4,
	kicked = 5,
})

local function string_toboolean(v)
	if v == false
	or v == "false"
	or v == "off"
	or v == "notok"
	or v == "no" then
		return false
	end
	if v == true
	or v == "true"
	or v == "on"
	or v == "ok"
	or v == "yes" then
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

function RedisStorage:cacheUser(user)
	if rawget(user, "username") then
		self.redis:hset("bot:usernames", "@"..rawget(user, "username"):lower(), user.id)
	end
end

function RedisStorage:getUserId(username)
	if username:byte(1) ~= string.byte("@") then
		username = "@"..username
	end
	return tonumber(self.redis:hget("bot:usernames", username:lower()))
end

function RedisStorage:getUserProperty(user, property) -- luacheck: ignore
end

function RedisStorage:getChatProperty(chat, property)
	if property == "title" then
		local title = self.redis:get("chat:"..chat.id..":title")
		if title == null then
			return
		end
		return title
	end
end

function RedisStorage:getChatAdministratorsCount(chat)
	return self.redis:scard("cache:chat:"..chat.id..":admins")
end

function RedisStorage:getChatAdministratorsList(chat)
	local admins = self.redis:smembers("cache:chat:"..chat.id..":admins") or {}
	local owner = self.redis:get("cache:chat:"..chat.id..":owner")
	if owner then
		table.insert(admins, owner)
	end
	return admins
end

function RedisStorage:getChatMemberProperty(chat, property) -- luacheck: ignore
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

local admins_permissions = {
	can_be_edited = false,
	can_change_info = false,
	can_delete_messages = false,
	can_invite_users = false,
	can_restrict_members = false,
	can_promote_members = false,
	can_pin_messages = false,
}

function RedisStorage:cacheAdmins(chat, list)
	local set = 'cache:chat:'..chat.id..':admins'
	local cache_time = config.bot_settings.cache_time.adminlist
	self.redis:del(set)
	for _, admin in pairs(list) do
		if admin.status == 'creator' then
			self.redis:set('cache:chat:'..chat.id..':owner', admin.user.id)
		else
			local set_permissions = "cache:chat:"..chat.id..":"..admin.user.id..":permissions"
			self.redis:del(set_permissions)
			for k, v in pairs(admin) do
				if v and admins_permissions[k] then
					self.redis:sadd(set_permissions, k)
				end
			end
			self.redis:expire(set_permissions, cache_time)
		end
		self.redis:sadd(set, admin.user.id)
	end
	self.redis:expire(set, cache_time)
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

function RedisStorage:cacheChatMember(member) -- luacheck: ignore 212
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

function PostgresStorage:cacheUser(user)
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
	if rawget(user, "username") then
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

function PostgresStorage:getUserId(username)
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

function PostgresStorage:getUserProperty(user, property)
	local query = interpolate('SELECT {property} FROM "user" WHERE id = {id}', {
		id = user.id,
		property = property,
	})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1][property] then
		return nil
	end
	return ok[1][property]
end

function PostgresStorage:getChatProperty(chat, property)
	local query = interpolate('SELECT {property} FROM "chat" WHERE id = {id}', {
		id = chat.id,
		property = property,
	})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1][property] then
		return nil
	end
	if property == "type" then
		return chat_type[ok[1][property]]
	end
	return ok[1][property]
end

function PostgresStorage:getChatMemberProperty(member, property)
	local query = interpolate('SELECT {property} FROM "chat_user" WHERE chat_id = {chat_id} AND user_id = {user_id}', {
		chat_id = member.chat.id,
		user_id = member.user.id,
		property = property,
	})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1][property] then
		return nil
	end
	if property == "status" then
		return chat_member_status[ok[1][property]]
	end
	return ok[1][property]
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

function PostgresStorage:getChatAdministratorsCount(chat)
	local row = {
		chat_id = chat.id,
		administrator = chat_member_status["administrator"],
	}
	local query = interpolate(
		'SELECT count(*) FROM "chat_user" WHERE chat_id = {chat_id} AND status = {administrator}', row)
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].count then
		return 0
	end
	return ok[1].count
end

function PostgresStorage:getChatAdministratorsList(chat)
	local row = {
		chat_id = chat.id,
		creator = chat_member_status["creator"],
		administrator = chat_member_status["administrator"],
	}
	local query = interpolate('SELECT user_id FROM "chat_user" WHERE chat_id = {chat_id}'..
		'AND (status = {creator} OR status = {administrator})', row)
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].user_id then
		return nil
	end
	local retval = {}
	for _,v in pairs(ok) do
		table.insert(retval, v.user_id)
	end
	return retval
end

function PostgresStorage:deleteChat(chat)
	local query = interpolate('DELETE FROM "chat" WHERE id = {id}', chat)
	self.pg:query(query)
	return true
end

local function isChatMemberPropertyOptional(status, k)
	if status == "administrator" then
		if k == "can_be_edited"
		or k == "can_change_info"
		or k == "can_delete_messages"
		or k == "can_invite_users"
		or k == "can_restrict_members"
		or k == "can_promote_members"
		or k == "can_pin_messages" then
		-- or k == "can_post_messages" -- Channels only
		-- or k == "can_edit_messages" then -- Channels only
			return true
		end
	end
	if status == "restricted" then
		if k == "until_date"
		or k == "can_send_messages"
		or k == "can_send_media_messages"
		or k == "can_send_other_messages"
		or k == "can_add_web_page_previews"	then
			return true
		end
	end
end

function PostgresStorage:cacheChatMember(member)
	if member.chat.type ~= "supergroup" then -- don't cache private chats, channels, etc.
		return
	end
	do
		local ok = self:cacheChat(member.chat)
		if not ok then
			return false
		end
	end
	do
		local ok = self:cacheUser(member.user)
		if not ok then
			return false
		end
	end
	local status = rawget(member, "status")
	local row = {
		chat_id = member.chat.id,
		user_id = member.user.id,
		status = chat_member_status[status] or chat_member_status["member"],
	}
	local insert = 'INSERT INTO "chat_user" (chat_id, user_id, status'
	local values = ") VALUES ({chat_id}, {user_id}, {status}"
	local on_conflict = ") ON CONFLICT (chat_id, user_id) DO NOTHING"
	if status then
		on_conflict = ") ON CONFLICT (chat_id, user_id) DO UPDATE SET status = {status}"
		for k, v in pairs(member) do
			if isChatMemberPropertyOptional(status, k) then
				row[k] = v
				insert = insert..", "..k
				values = values..", {"..k.."}"
				on_conflict = on_conflict..", "..k.." = {"..k.."}"
			end
		end
	end
	local query = interpolate(insert..values..on_conflict, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
	end
	return true
end

function PostgresStorage:wipeAdmins(chat)
	local row = {
		chat_id = chat.id,
		member = chat_member_status["member"],
		administrator = chat_member_status["administrator"],
	}
	local set = 'UPDATE "chat_user" SET status = {member}'
	local where = ' WHERE chat_id = {chat_id} AND status = {administrator}'
	for k, v in pairs(admins_permissions) do
		row[k] = v
		set = set..", "..k.." = {"..k.."}"
	end
	local query = interpolate(set..where, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
		return false
	end
	return true
end

function PostgresStorage:cacheAdmins(chat, list)
	do
		local ok = self:wipeAdmins(chat)
		if not ok then
			return false
		end
	end
	for _, admin in pairs(list) do
		admin.chat = chat
		do
			local ok = self:cacheChatMember(admin)
			if not ok then
				return false
			end
		end
	end
	return true
end

function PostgresStorage:set_keepalive()
	return self.pg:keepalive()
end

function PostgresStorage:get_reused_times() -- luacheck: ignore 212
	return "Unknown"
end

function MixedStorage:cacheUser(user)
	local res, ok = pcall(function() return self.postgres_storage:cacheUser(user) end)
	if not res or not ok then
		self.redis_storage:cacheUser(user)
	end
end

function MixedStorage:getUserId(username)
	local ok, id = pcall(function() return self.postgres_storage:getUserId(username) end)
	if not ok or not id then
		return self.redis_storage:getUserId(username)
	end
	return id
end

function MixedStorage:getUserProperty(user, property)
	local ok, retval = pcall(function() return self.postgres_storage:getUserProperty(user, property) end)
	if not ok or not retval then
		return self.redis_storage:getUserProperty(user, property)
	end
	return retval
end

function MixedStorage:getChatProperty(chat, property)
	local ok, retval = pcall(function() return self.postgres_storage:getChatProperty(chat, property) end)
	if not ok or not retval then
		return self.redis_storage:getChatProperty(chat, property)
	end
	return retval
end

function MixedStorage:getChatMemberProperty(member, property)
	local ok, retval = pcall(function() return self.postgres_storage:getChatMemberProperty(member, property) end)
	if not ok or not retval then
		return self.redis_storage:getChatMemberProperty(member, property)
	end
	return retval
end

function MixedStorage:cacheChat(chat)
	local res, ok = pcall(function() return self.postgres_storage:cacheChat(chat) end)
	if not res or not ok then
		self.redis_storage:cacheChat(chat)
	end
end

function MixedStorage:getChatAdministratorsCount(chat)
	local ok, title = pcall(function() return self.postgres_storage:getChatAdministratorsCount(chat) end)
	if not ok or not title then
		return self.redis_storage:getChatAdministratorsCount(chat)
	end
	return title
end

function MixedStorage:getChatAdministratorsList(chat)
	local ok, title = pcall(function() return self.postgres_storage:getChatAdministratorsList(chat) end)
	if not ok or not title then
		return self.redis_storage:getChatAdministratorsList(chat)
	end
	return title
end

function MixedStorage:deleteChat(chat)
	pcall(function() return self.postgres_storage:deleteChat(chat) end)
	self.redis_storage:deleteChat(chat)
end

function MixedStorage:cacheChatMember(member)
	pcall(function() return self.postgres_storage:cacheChatMember(member) end)
end

function MixedStorage:cacheAdmins(chat, list)
	local res, ok = pcall(function() return self.postgres_storage:cacheAdmins(chat, list) end)
	if not res or not ok then
		self.redis_storage:cacheAdmins(chat, list)
	end
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
