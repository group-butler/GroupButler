local config = require 'config'
local api = require 'methods'

local plugin = {}

local function get_button_description(key)
	if key == 'rules_on_join' then
		return _("When you join a group moderated by this bot, you will receive the group rules in private")
	elseif key == 'reports' then
		return _("If enabled, you will receive all the messages reported with the @admin command in the groups you are moderating")
	else
		return _("Description not available")
	end
end

local function change_private_setting(user_id, key)
	local hash = 'user:'..user_id..':settings'
	local val = 'off'
	local current_status = (db:hget(hash, key)) or config.private_settings[key]
	if current_status == 'off' then
		val = 'on'
	end
	db:hset(hash, key, val)
end

local function doKeyboard_privsett(user_id)
	local hash = 'user:'..user_id..':settings'
	local user_settings = db:hgetall(hash)
	if not next(user_settings) then
		user_settings = config.private_settings
	else
		for key, default_status in pairs(config.private_settings) do
			if not user_settings[key] then
				user_settings[key] = default_status
			end
		end
	end

	local keyboard = {inline_keyboard = {}}
	local button_names = {
		['rules_on_join'] = _('Rules on join'),
		['reports'] = _('Users reports')
	}
	for key, status in pairs(user_settings) do
		local icon
		if status == 'on' then icon = '✅' else icon = '☑️'end
		table.insert(keyboard.inline_keyboard, {{text = button_names[key], callback_data = 'myset:alert:'..key}, {text = icon, callback_data = 'myset:switch:'..key}})
	end

	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type == 'private' then
		local keyboard = doKeyboard_privsett(msg.from.id)
		api.sendMessage(msg.from.id, _('Change your private settings'), true, keyboard)
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'alert' then
		api.answerCallbackQuery(msg.cb_id, get_button_description(blocks[2]), true)
	else
		change_private_setting(msg.from.id, blocks[2])
		local keyboard = doKeyboard_privsett(msg.from.id)
		api.editMarkup(msg.from.id, msg.message_id, keyboard)
		api.answerCallbackQuery(msg.cb_id, _('⚙ Setting applied'))
	end
end

plugin.triggers = {
	onTextMessage = {config.cmd..'(mysettings)$'},
	onCallbackQuery = {
		'^###cb:myset:(alert):(.*)$',
		'^###cb:myset:(switch):(.*)$',
		}
}

return plugin
