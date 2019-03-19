local controller = require "groupbutler.controller"
local health = require "groupbutler.health"

local _M = {}

function _M.go()
	controller.run()
end

function _M.health()
	health.run()
end

return _M
