local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local locale = require "groupbutler.languages"
local i18n = locale.translate
local null = require "groupbutler.null"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

local function get_button_description(key)
	local button_description = {
		-- TRANSLATORS: these strings should be shorter than 200 characters
		Reports = i18n("When enabled, users will be able to report messages with the @admin command"),
		Goodbye = i18n("Enable or disable the goodbye message. Can't be sent in large groups"),
		Welcome = i18n("Enable or disable the welcome message"),
		Weldelchain = i18n("When enabled, every time a new welcome message is sent, the previously sent welcome message is removed"), -- luacheck: ignore 631
		Silent = i18n("When enabled, the bot doesn't answer in the group to /dashboard, /config and /help commands (it will just answer in private)"), -- luacheck: ignore 631
		Flood = i18n("Enable and disable the anti-flood system (more info in the /help message)"),
		Welbut = i18n("If the welcome message is enabled, it will include an inline button that will send to the user the rules in private"), -- luacheck: ignore 631
		Rules = i18n([[When someone uses /rules
👥: the bot will answer in the group (always, with admins)
👤: the bot will answer in private]]),
		Extra = i18n([[When someone uses an #extra
👥: the bot will answer in the group (always, with admins)
👤: the bot will answer in private]]),
		Arab = i18n("Select what the bot should do when someone sends a message with arab characters"),
		Antibot = i18n("Bots will be banned when added by normal users"),
		Rtl = i18n("Select what the bot should do when someone sends a message with the RTL character, or has it in their name"), -- luacheck: ignore 631
		warnsnum = i18n("Change how many times a user has to be warned before being kicked/banned"),
		warnsact = i18n("Change the action to perform when a user reaches the max. number of warnings"),
	} set_default(button_description, i18n("Description not available"))

	return button_description[key]
end

local function changeWarnSettings(self, chat_id, action)
	local db = self.db
	local current = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'max'))
		or config.chat_settings['warnsettings']['max']
	local new_val
	if action == 1 then
		if current > 12 then
			return i18n("The new value is too high ( > 12)")
		else
			new_val = db:hincrby('chat:'..chat_id..':warnsettings', 'max', 1)
			return current..'->'..new_val
		end
	elseif action == -1 then
		if current < 2 then
			return i18n("The new value is too low ( < 1)")
		else
			new_val = db:hincrby('chat:'..chat_id..':warnsettings', 'max', -1)
			return current..'->'..new_val
		end
	elseif action == 'status' then
		local status = db:hget('chat:'..chat_id..':warnsettings', 'type')
		if status == null then status = config.chat_settings.warnsettings.type end

		if status == 'kick' then
			db:hset('chat:'..chat_id..':warnsettings', 'type', 'ban')
			return i18n("New action on max number of warns received: ban")
		elseif status == 'ban' then
			db:hset('chat:'..chat_id..':warnsettings', 'type', 'mute')
			return i18n("New action on max number of warns received: mute")
		elseif status == 'mute' then
			db:hset('chat:'..chat_id..':warnsettings', 'type', 'kick')
			return i18n("New action on max number of warns received: kick")
		end
	end
end

local function changeCharSettings(self, chat_id, field)
	local db = self.db
	local humanizations = {
		kick = i18n("Action -> kick"),
		ban = i18n("Action -> ban"),
		mute = i18n("Action -> mute"),
		allow = i18n("Allowed ✅")
	}

	local hash = 'chat:'..chat_id..':char'
	local status = db:hget(hash, field)

	if status == 'allowed' then
		db:hset(hash, field, 'kick')
		return humanizations['kick']
	elseif status == 'kick' then
		db:hset(hash, field, 'ban')
		return humanizations['ban']
	elseif status == 'ban' then
		db:hset(hash, field, 'mute')
		return humanizations['mute']
	else
		db:hset(hash, field, 'allowed')
		return humanizations['allow']
	end
end

local function usersettings_table(self, settings, chat_id)
	local db = self.db
	local return_table = {}
	local icon_off, icon_on = '👤', '👥'
	for field, default in pairs(settings) do
		if field == 'Extra' or field == 'Rules' then
			local status = db:hget('chat:'..chat_id..':settings', field)
			if status == null then status = default end
			if status == 'off' then
				return_table[field] = icon_off
			elseif status == 'on' then
				return_table[field] = icon_on
			end
		end
	end

	return return_table
end

local function adminsettings_table(self, settings, chat_id)
	local db = self.db
	local return_table = {}
	local icon_off, icon_on = '☑️', '✅'
	for field, default in pairs(settings) do
		if field ~= 'Extra' and field ~= 'Rules' then
			local status = db:hget('chat:'..chat_id..':settings', field)
			if status == null then status = default end

			if status == 'off' then
				return_table[field] = icon_off
			elseif status == 'on' then
				return_table[field] = icon_on
			end
		end
	end

	return return_table
end

local function charsettings_table(self, settings, chat_id)
	local db = self.db
	local return_table = {}
	for field, default in pairs(settings) do
		local status = db:hget('chat:'..chat_id..':char', field)
		if status == null then status = default end

		if status == 'kick' then
			return_table[field] = i18n('👞 kick')
		elseif status == 'ban' then
			return_table[field] = i18n('🔨 ban')
		elseif status == 'mute' then
			return_table[field] = i18n('👁 mute')
		elseif status == 'allowed' then
			return_table[field] = i18n('✅')
		end
	end

	return return_table
end

local function insert_settings_section(keyboard, settings_section, chat_id)
	local strings = {
		Welcome = i18n("Welcome"),
		Goodbye = i18n("Goodbye"),
		Extra = i18n("Extra"),
		Flood = i18n("Anti-flood"),
		Silent = i18n("Silent mode"),
		Rules = i18n("Rules"),
		Arab = i18n("Arab"),
		Rtl = i18n("RTL"),
		Antibot = i18n("Ban bots"),
		Reports = i18n("Reports"),
		Weldelchain = i18n("Delete last welcome message"),
		Welbut = i18n("Welcome + rules button"),
		Clean_service_msg = i18n("Clean Service Messages")
	}

	for key, icon in pairs(settings_section) do
		local current = {
			{text = strings[key] or key, callback_data = 'menu:alert:settings:'..key..':'..locale.language},
			{text = icon, callback_data = 'menu:'..key..':'..chat_id}
		}
		table.insert(keyboard.inline_keyboard, current)
	end

	return keyboard
end

local function doKeyboard_menu(self, chat_id)
	local db = self.db
	local keyboard = {inline_keyboard = {}}

	local settings_section = adminsettings_table(self, config.chat_settings['settings'], chat_id)
	keyboard = insert_settings_section(keyboard, settings_section, chat_id)

	settings_section = usersettings_table(self, config.chat_settings['settings'], chat_id)
	keyboard = insert_settings_section(keyboard, settings_section, chat_id)

	settings_section = charsettings_table(self, config.chat_settings['char'], chat_id)
	keyboard = insert_settings_section(keyboard, settings_section, chat_id)

	--warn
	local max = db:hget('chat:'..chat_id..':warnsettings', 'max')
	if max == null then max = config.chat_settings['warnsettings']['max'] end

	local action = db:hget('chat:'..chat_id..':warnsettings', 'type')
	if action == null then action = config.chat_settings['warnsettings']['type'] end

	if action == 'kick' then
		action = i18n("👞 kick")
	elseif action == 'ban' then
		action = i18n("🔨️ ban")
	elseif action == 'mute' then
		action = i18n("👁 mute")
	end
	local warn = {
		{
			{text = i18n('Warns: ')..max, callback_data = 'menu:alert:settings:warnsnum:'..locale.language},
			{text = '➖', callback_data = 'menu:DimWarn:'..chat_id},
			{text = '➕', callback_data = 'menu:RaiseWarn:'..chat_id},
		},
		{
			{text = i18n('Action:'), callback_data = 'menu:alert:settings:warnsact:'..locale.language},
			{text = action, callback_data = 'menu:ActionWarn:'..chat_id}
		}
	}
	for _, button in pairs(warn) do
		table.insert(keyboard.inline_keyboard, button)
	end

	--back button
	table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})

	return keyboard
end

function _M:onCallbackQuery(blocks)
	local msg = self.message
	local u = self.u
	local chat_id = msg.target_id
	if chat_id and not u:is_allowed('config', chat_id, msg.from) then
		api.answerCallbackQuery(msg.cb_id, i18n("You're no longer an admin"))
	else
		local menu_first = i18n("Manage the settings of the group. Click on the left column to get a small hint")

		local keyboard, text, show_alert

		if blocks[1] == 'config' then
			keyboard = doKeyboard_menu(self, chat_id)
			api.editMessageText(msg.chat.id, msg.message_id, nil, menu_first, "Markdown", nil, keyboard)
		else
			if blocks[2] == 'alert' then
				if config.available_languages[blocks[4]] then
					locale.language = blocks[4]
				end
				text = get_button_description(blocks[3])
				api.answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
				return
			end
			if blocks[2] == 'DimWarn' or blocks[2] == 'RaiseWarn' or blocks[2] == 'ActionWarn' then
				if blocks[2] == 'DimWarn' then
					text = changeWarnSettings(self, chat_id, -1)
				elseif blocks[2] == 'RaiseWarn' then
					text = changeWarnSettings(self, chat_id, 1)
				elseif blocks[2] == 'ActionWarn' then
					text = changeWarnSettings(self, chat_id, 'status')
				end
			elseif blocks[2] == 'Rtl' or blocks[2] == 'Arab' then
				text = changeCharSettings(self, chat_id, blocks[2])
			else
				text, show_alert = u:changeSettingStatus(chat_id, blocks[2])
			end
			keyboard = doKeyboard_menu(self, chat_id)
			api.editMessageText(msg.chat.id, msg.message_id, nil, menu_first, "Markdown", nil, keyboard)
			if text then
				--workaround to avoid to send an error to users who are using an old inline keyboard
				api.answerCallbackQuery(msg.cb_id, '⚙ '..text, show_alert)
			end
		end
	end
end

_M.triggers = {
	onCallbackQuery = {
		'^###cb:(menu):(alert):settings:([%w_]+):([%w_]+)$',
		'^###cb:(menu):(.*):',
		'^###cb:(config):menu:(-?%d+)$'
	}
}

return _M
