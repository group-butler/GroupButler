local _M = {}

local json = require "cjson"
local main = require "groupbutler.main"
local log = require "groupbutler.logging"

local function process_update(_, update, update_json)
	local update_obj = main:new(update)
	-- TODO: make :process() return true on good updates
	local ok --[[, retval]] = pcall(function() return update_obj:process() end)
	if not ok --[[or not retval]] then
		log.critical("Error processing update: {update}", {update = update_json})
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

return _M
