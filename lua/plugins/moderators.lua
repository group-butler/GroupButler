local config = require 'config'
local utils = require 'utilities'

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
