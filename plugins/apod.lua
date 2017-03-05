local config = require '../config'
local u = require 'utilities'
local api = require 'methods'
local HTTP = require('socket.http')
local URL = require('socket.url')

local plugin = {}

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'talk' then
    local base_url = "http://barreeeiroo.ga/es/cleverbot/"
    local key = config.cleverbot_api_key
    local input = urlencode(blocks[2])

    local url = base_url .. "?key=" .. key .. "&input=" .. input

    local output, res = HTTP.request(url)

    if not output or res ~= 200 or output:len() == 0 then
        url = base_url .. "?input=" .. request_text .. "&key=" .. api_key
        output, res = HTTP.request(url)
    end

    api.sendReply(msg, output, true, reply_markup)
  end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(talk) (.*)$'
	}
}

return plugin
