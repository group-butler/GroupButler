local _M = {}

function _M.connect(config)
	local redis = require 'resty.redis' -- Load redis client
	local red = redis:new()
	red:set_timeout(1000) -- 1 second
	local ok, err = red:connect(config.redis_host, config.redis_port)
	if not ok then
		ngx.log(ngx.CRIT, 'Redis connection failed: ', err)
		return
	end
	red:select(config.redis_db)
	return red
end

return _M
