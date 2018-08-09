local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)

local _M = {}

local bot

function _M.init()
	if not bot then
		bot = api.get_me()
	end
	return bot
end

return _M
