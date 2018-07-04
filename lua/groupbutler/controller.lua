local _M = {}

local json = require "cjson"
local main = require "groupbutler.main"

local function process_update(_, u)
	main.parseMessageFunction(u)
end

function _M.run()
	local ok, update
	ngx.req.read_body()
	update = ngx.req.get_body_data()
	ngx.log(ngx.DEBUG, "Incoming update:", update)

	ok, update = pcall(json.decode, update)
	if not ok then
		ngx.status = ngx.HTTP_BAD_REQUEST
		return ngx.exit(ngx.HTTP_BAD_REQUEST)
	end

	-- Process update on another thread. Returns HTTP_OK instantly, regardless of sucess processing the update.
	-- Prevents showing API token on log since nginx error_log is not customizable.
	-- Prevents trying to process troublesome updates more than once.
	ngx.timer.at(0, process_update, update)

	ngx.status = ngx.HTTP_OK
	ngx.say("{}")
	return ngx.exit(ngx.HTTP_OK)
end

return _M
