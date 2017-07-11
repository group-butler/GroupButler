local config = require 'config'
local api = require 'methods'

local plugin = {}

function plugin.onTextMessage(msg, blocks)
	if msg.from.admin then
		api.sendReply(msg, "This command has been removed \\[[read more](t.me/groupbutler_beta/70)]", true)
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'block',
		config.cmd..'unblock',
		config.cmd..'blockedlist$',
		config.cmd..'blocklist$'
	}
}

return plugin
