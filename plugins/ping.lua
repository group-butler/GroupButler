local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'ping' then
    api.sendReply(msg, "*P*_O_`N`G", true, reply_markup)
  end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(ping)$'
	}
}

return plugin
