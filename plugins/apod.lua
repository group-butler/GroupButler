local config = require '../config'
local u = require 'utilities'
local api = require 'methods'
local HTTP = require('socket.http')
local URL = require('socket.url')

local plugin = {}

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'apod' then
		local base_url = "http://barreeeiroo.ga/BarrePolice/apod/?key="..config.apod_api_key
		if not blocks[2] then
			message = """
*Command methods:*
- /apod `image` - _Sends the NASA Image of the day_
- /apod `hd` - Sends the NASA Image of the day in HD quality_
- /apod `data` - Sends the data of the NASA Image of the day_
			"""
			api.sendReply(msg, message, true, reply_markup)
		else
			if blocks[2] == 'image' then
				local url = base_url .. "&image"
				local output, res = HTTP.request(url)
		    if not output or res ~= 200 or output:len() == 0 then
		        url = url = base_url .. "&image"
		        output, res = HTTP.request(url)
		    end
				message = "<a href='"..output.."'></a>'"
				api.sendReply(msg, message, true, html, reply_markup)
			elseif blocks[2] == 'hd' then

			elseif blocks[2] == 'data' then

			else
				message = "Unknown request"
				api.sendReply(msg, message, true, reply_markup)
			end
		end
  end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(apod) (.*)$'
	}
}

return plugin
