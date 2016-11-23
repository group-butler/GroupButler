--Simple test plugin. If it triggers /test it will run your function. Please add it, before trying :)
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

function plugin.onEachMessage(msg)
	return true
end

plugin.onEachMessage = nil

function plugin.onTextMessage(msg, blocks)
	--test your stuffs here
	api.sendMessage(msg.chat.id, 'This is a button', nil, {inline_keyboard={{{text = 'Open tha chat list!', callback_data = 'test'}}}})
end

function plugin.onCallbackQuery(msg, blocks)
	api.answerCallbackQuery(msg.cb_id, 'Hey')
end

plugin.triggers = {
	onTextMessage = {
		'^/test'
	},
	onCallbackQuery = {
		'###cb:test'	
	}
}

return plugin