--Simple test plugin. If it triggers /test it will run your function. Please add it, before trying :)
local plugin = {}

function plugin.onEachMessage(msg)
	return true
end

plugin.onEachMessage = nil

function plugin.onTextMessage(msg, blocks)
	--test your stuffs here
	api.sendMessage(msg.chat.id, 'This is a button', nil, {inline_keyboard={{{text = 'Open tha chat list!', switch_inline_query = 'random parameter'}}}})
end

function plugin.onCallbackQuery(msg, blocks)
	api.answerCallbackQuery(msg.cb_id, 'Hey')
end

function plugin.onInlineQuery(msg, blocks)
	local input_message_content = {message_text = 'My ID: `'..msg.from.id..'`', parse_mode = 'Markdown'}
	local reply_markup = {inline_keyboard={{{text = 'A button', callback_data = 'testcb'}}}}
	local result = {{type = 'article', id = tostring(1), title = 'This is an example', input_message_content = input_message_content, reply_markup = reply_markup}}
	api.answerInlineQuery(msg.id, result, 1, true, 'I dare you to tap me', 'testplugin')
end

plugin.triggers = {
	onCallbackQuery = {
		'^###cb:testcb$'
	},
	onTextMessage = {
		'^/start testplugin'
	},
	onInlineQuery = {
		'^###inline:(.*)'
	}	
}

return plugin
