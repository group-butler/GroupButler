local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function is_locked(chat_id)
  	local hash = 'chat:'..chat_id..':settings'
  	local current = db:hget(hash, 'Extra')
  	if current == 'off' then
  		return true
  	else
  		return false
  	end
end

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
