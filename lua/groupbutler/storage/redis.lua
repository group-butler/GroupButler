local redis = require("resty.redis")
local config = require("groupbutler.config")
local null = require("groupbutler.null")
local log = require("groupbutler.logging")
local StorageUtil = require("groupbutler.storage.util")

local RedisStorage = {}

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

function RedisStorage:new(redis_db)
	local obj = setmetatable({}, {__index = self})
	obj.redis = redis_db
	if not redis_db then
		obj.red = redis:new()
		local ok, err = obj.red:connect(config.redis.host, config.redis.port)
		if not ok then
			log.error("Redis connection failed: {err}", {err=err})
			return nil, err
		end
		obj.red:select(config.redis.db)
	end
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
	if setting == "Arab"
	or setting == "Rtl" then
		local default = config.chat_settings.char[setting]
		return self:_hget_default("chat:"..chat_id..":char", setting, default)
	end
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


function RedisStorage:getChatMemberProperty(member, property)
	if StorageUtil.isAdminPermission[property] then
		local set = ("cache:chat:%s:%s:permissions"):format(member.chat.id, member.user.id)
		return self.redis:sismember(set, property) == 1
	end
	if property == "status" then
		if tonumber(self.redis:get("cache:chat:"..member.chat.id..":owner")) == member.user.id then
			return "creator"
		end
		if self.redis:sismember("cache:chat:"..member.chat.id..":admins", member.user.id) == 1 then
			return "administrator"
		end
		return nil
	end
end

function RedisStorage:cacheChat(chat)
	if chat.type ~= "supergroup" then -- don"t cache private chats, channels, etc.
		return
	end
	local keys = {
		["chat:"..chat.id..":title"] = chat.title,
	}
	for k,v in pairs(keys) do
		self.redis:set(k, v)
	end
end


function RedisStorage:cacheAdmins(chat, list)
	local set = "cache:chat:"..chat.id..":admins"
	local cache_time = config.bot_settings.cache_time.adminlist
	self.redis:del(set)
	for _, admin in pairs(list) do
		if admin.status == "creator" then
			self.redis:set("cache:chat:"..chat.id..":owner", admin.user.id)
		else
			local set_permissions = "cache:chat:"..chat.id..":"..admin.user.id..":permissions"
			self.redis:del(set_permissions)
			for k, v in pairs(admin) do
				if v and StorageUtil.isAdminPermission[k] then
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
		self.redis:del("chat:"..chat.id..":"..set)
	end

	local keys = {
		"cache:chat:"..chat.id..":admins",
		"cache:chat:"..chat.id..":owner",
		"chat:"..chat.id..":title",
		"chat:"..chat.id..":userlast",
		"chat:"..chat.id..":members",
		"chat:"..chat.id..":pin",
		"lang:"..chat.id,
	}
	local owner_id = self.redis:get("cache:chat:"..chat.id..":owner")
	if  owner_id
	and owner_id ~= null then
		table.insert(keys, "cache:chat:"..chat.id..":"..owner_id..":permissions")
	end
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

return RedisStorage
