-- Generic storage backend
local null = require "groupbutler.null"

local _M = {}

local RedisStorage = {}

RedisStorage.__index = RedisStorage

setmetatable(RedisStorage, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

local function _is_truthy(val)
	if val == true or val == "notok" or val == "off" or val == "no" then
		return false
	elseif val == false or val == "ok" or val == "on" or val == "yes" then
		return true
	end

	return false
end

function RedisStorage.new(redis_db)
	local self = setmetatable({}, _M)
	self.redis = redis_db
	return self
end

function RedisStorage:_hget_default(hash, key, default)
	local val = self.redis:hget(hash, key)
	if val == null then
		return default
	else
		return val
	end
end

function RedisStorage:get_chat_setting(chat_id, setting, default)
	return self:_hget_default("chat:"..chat_id..":settings", setting, default)
end

function RedisStorage:get_user_setting(user_id, setting, default)
	return self:_hget_default("user:"..user_id..":settings", setting, default)
end

function RedisStorage:get_chat_setting_truthy(chat_id, setting, default)
	local val = self:get_chat_setting(chat_id, setting, default)
	return _is_truthy(val)
end

function RedisStorage:get_chat_setting_truthy(chat_id, setting, default)
	local val = self:get_chat_setting(chat_id, setting, default)
	return _is_truthy(val)
end

_M.storage = {
	redis=RedisStorage
}

_M.cache = {
	-- None yet
}

return _M
