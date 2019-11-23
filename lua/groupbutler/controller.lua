local _M = {}

local json = require "cjson"
local main = require "groupbutler.main"
local log = require "groupbutler.logging"

local function process_update(_, update, update_json)
	local update_obj = main:new(update)
	local ok, retval = xpcall(function() return update_obj:process() end, debug.traceback)
	if not ok or not retval then
		retval = retval or ""
		log.error("Error processing update: {update}\n{retval}", {update = update_json, retval = retval})
	end
end

function _M.run()
	ngx.req.read_body()
	local update_json = ngx.req.get_body_data()
	ngx.log(ngx.DEBUG, "Incoming update:", update_json)

	local ok, update = pcall(json.decode, update_json)
	if not ok then
		ngx.status = ngx.HTTP_BAD_REQUEST
		return ngx.exit(ngx.HTTP_BAD_REQUEST)
	end

	ngx.timer.at(0, process_update, update, update_json)

	ngx.status = ngx.HTTP_OK
	ngx.say("{}")

	return ngx.exit(ngx.HTTP_OK)
end

function _M.mock(update)
	local update_obj = main:new(update)
	return update_obj:process()
end

return _M
