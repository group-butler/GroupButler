local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local HTTP = require('socket.http')
local URL = require('socket.url')

local plugin = {}

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'cat' or blocks[1] == 'cats' then
		local url = "http://barreeeiroo.ga/BarrePolice/cats/"
		local output, res = HTTP.request(url)
		if not output or res ~= 200 or output:len() == 0 then
		      output, res = HTTP.request(url)
		end
		local message = "[Cat's are our Gods!]("..output..")"
		api.sendReply(msg, message, true, nil, true)
  end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(cat)s?$'
	}
}

return plugin
