local _M = {}

local json = require "cjson"
local main = require "groupbutler.main"

local function process_update(_, update)
	local update_obj = main:new(update)
	update_obj:process()
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

	ngx.timer.at(0, process_update, update)

	ngx.status = ngx.HTTP_OK
	ngx.say("{}")

	return ngx.exit(ngx.HTTP_OK)
end

return _M
