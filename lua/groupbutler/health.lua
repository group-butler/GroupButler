local _M = {}

local json = require "cjson"

function _M.run()
	local body = {
		ok = true
	}

	if body.ok then
		ngx.status = ngx.HTTP_OK
	else
		ngx.status = 500
	end
	ngx.say(json.encode(body))
end

return _M
