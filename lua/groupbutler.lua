local controller = require "groupbutler.controller"
local health = require "groupbutler.health"

local _M = {}

function _M.go()
	controller.run()
end

function _M.health()
	health.run()
end

function _M.test(update)
	controller.mock(update)
end

return _M
