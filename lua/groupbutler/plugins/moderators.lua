local config = require "groupbutler.config"
local utils = require "groupbutler.utilities"

local plugin = {}

plugin.onTextMessage = utils.reportDeletedCommand("t.me/groupbutler_beta/70")

plugin.triggers = {
	onTextMessage = {
		config.cmd..'promote',
		config.cmd..'demote',
		config.cmd..'modlist'
	}
}

return plugin
