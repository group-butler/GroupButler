local config = require "groupbutler.config"
local utils = require "groupbutler.utilities"

local plugin = {}

plugin.onTextMessage = utils.reportDeletedCommand("t.me/groupbutler_beta/70")

plugin.triggers = {
	onTextMessage = {
		config.cmd..'block',
		config.cmd..'unblock',
		config.cmd..'blockedlist$',
		config.cmd..'blocklist$'
	}
}

return plugin
