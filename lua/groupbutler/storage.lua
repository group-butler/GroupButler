-- Generic storage backend
local null = require "groupbutler.null"
local config = require "groupbutler.config"

-- local _M = {}

local RedisStorage = {}

local function _is_truthy(val)
	if val == false or val == "notok" or val == "off" or val == "no" then
		return false
	end
	if val == true or val == "ok" or val == "on" or val == "yes" then
		return true
	end
	return val
end

function RedisStorage:new(redis_db)
	local obj = setmetatable({}, {__index = self})
	obj.redis = redis_db
	return obj
end

function RedisStorage:_hget_default(hash, key, default)
	local val = self.redis:hget(hash, key)
	if val == null then
		return default
	end
	return val
end

function RedisStorage:get_chat_setting(chat_id, setting)
	local default = config.chat_settings.settings[setting]
	local val = self:_hget_default("chat:"..chat_id..":settings", setting, default)
	return _is_truthy(val)
end

function RedisStorage:set_chat_setting(chat_id, setting, value)
	self.redis:hset("chat:"..chat_id..":settings", setting, value)
end

function RedisStorage:get_user_setting(user_id, setting)
	local default = config.private_settings[setting]
	local val = self:_hget_default("user:"..user_id..":settings", setting, default)
	return _is_truthy(val)
end

function RedisStorage:get_all_user_settings(user_id)
	local settings = self.redis:array_to_hash(self.redis:hgetall("user:"..user_id..":settings"))
	for setting, default in pairs(config.private_settings) do
		if not settings[setting] then
			settings[setting] = default
		end
		settings[setting] = _is_truthy(settings[setting])
	end
	return settings
end

function RedisStorage:set_user_setting(user_id, setting, value)
	self.redis:hset("user:"..user_id..":settings", setting, value)
end

function RedisStorage:toggle_user_setting(user_id, setting)
	local old_val = self:get_user_setting(user_id, setting)
	local new_val = "on"
	if old_val then
		new_val = "off"
	end
	self:set_user_setting(user_id, setting, new_val)
end

function RedisStorage:cache_user(user)
	if user.username then
		self.redis:hset("bot:usernames", "@"..user.username:lower(), user.id)
	end
end

function RedisStorage:get_user_id(username)
	return tonumber(self.redis:hget("bot:usernames", username))
end

-- _M.storage = {
-- 	redis=RedisStorage
-- }

-- _M.cache = {
-- 	-- None yet
-- }

-- return _M
return RedisStorage
