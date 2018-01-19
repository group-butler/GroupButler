local _M = {}

local controller = require "groupbutler.controller"
local health = require "groupbutler.health"

function _M.go()
	controller.run()
end

function _M.health()
	health.run()
end

return _M
