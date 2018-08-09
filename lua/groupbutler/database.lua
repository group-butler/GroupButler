local config = require "groupbutler.config"
local redis = require "redis"

local _M = {}

_M.__index = _M

setmetatable(_M, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function _M.new()
	local self = setmetatable({}, _M)
	-- self.db = redis:new()
	-- self.db:connect(config.redis.host, config.redis.port)
	self.db = redis.connect(config.redis.host, config.redis.port)
	self.db:select(config.redis.db)
	return self.db
end

return _M
