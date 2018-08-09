local _M = {}

local json = require "cjson"
local main = require "groupbutler.main"

function _M.run()
	-- Decode the update
	ngx.req.read_body()
	local update = ngx.req.get_body_data()
	ngx.log(ngx.DEBUG, "Incoming update:", update)

	local ok, res = pcall(json.decode, update)
	if not ok then
		ngx.status = ngx.HTTP_BAD_REQUEST
		return ngx.exit(ngx.HTTP_BAD_REQUEST)
	end

	update = res

	-- Parse the update
	local response_body = main.parseMessageFunction(update)

	-- Finally, encode the response and send it to Telegram
	response_body = json.encode(response_body or {})
	ngx.status = ngx.HTTP_OK
	ngx.say(response_body)
	ngx.log(ngx.DEBUG, "Outgoing response: "..response_body)
	return ngx.exit(ngx.HTTP_OK)
end

return _M
