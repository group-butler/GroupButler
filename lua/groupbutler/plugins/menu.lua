local config = require "groupbutler.config"
local null = require "groupbutler.null"
local Chat = require("groupbutler.chat")
local ChatMember = require("groupbutler.chatmember")
local ApiUtil = require("telegram-bot-api.utilities")

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

function _M:getSettings()
	local i18n = self.i18n
	local boolean = {
		[false] = "☑️",
		[true] = "✅",
	}
	local char = {
		allowed = i18n("✅"),
		ban = i18n("🔨 ban"),
		kick = i18n("👞 kick"),
		mute = i18n("👁 mute"),
	}
	local settings = {
		general = {
			Antibot = {
				name = i18n("Ban bots"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("Bots will be banned when added by normal users"),
				states = boolean
			},
			Arab = {
				name = i18n("Arab"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("Select what the bot should do when someone sends a message with arab characters"),
				states = char
			},
			Clean_service_msg = {
				name = i18n("Clean Service Messages"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n('When enabled, Telegram service messages such as "User joined the group" will be removed'),
				states = boolean
			},
			Extra = {
				name = i18n("Extra"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n([[When someone uses an #extra
👥: the bot will answer in the group (always, with admins)
👤: the bot will answer in private]]),
				states = {
					[false] = "👥",
					[true] = "👤",
				}
			},
			Goodbye = {
				name = i18n("Goodbye"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("Enable or disable the goodbye message. Can't be sent in large groups"),
				states = boolean
			},
			Reports = {
				name = i18n("Reports"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("When enabled, users will be able to report messages with the @admin command"),
				states = boolean
			},
			Rules = {
				name = i18n("Rules"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n([[When someone uses /rules
👥: the bot will answer in the group (always, with admins)
👤: the bot will answer in private]]),
				states = {
					[false] = "👤",
					[true] = "👥",
				}
			},
			Rtl = {
				name = i18n("RTL"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("Select what the bot should do when someone sends a message with the RTL character, or has it in their name"), -- luacheck: ignore 631
				states = char
			},
			Silent = {
				name = i18n("Silent mode"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("When enabled, the bot doesn't answer in the group to /dashboard, /config and /help commands (it will just answer in private)"), -- luacheck: ignore 631
				states = boolean
			},
			Welcome = {
				name = i18n("Welcome"),
				description = i18n("Enable or disable the welcome message"),
				states = boolean
			},
			Welbut = {
				name = i18n("Welcome + rules button"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("If the welcome message is enabled, it will include an inline button that will send to the user the rules in private"), -- luacheck: ignore 631
				states = boolean
			},
			Weldelchain = {
				name = i18n("Delete last welcome message"),
				-- TRANSLATORS: this string should be shorter than 200 characters
				description = i18n("When enabled, every time a new welcome message is sent, the previously sent welcome message is removed"), -- luacheck: ignore 631
				states = boolean
			},
		}
	}
	return settings
end

function _M:buildGeneral(reply_markup, chat_id)
	local db = self.db
	local settings = self:getSettings()
	for k,v in pairs(settings.general) do
		reply_markup:row(
			{text = v.name or k, callback_data = "menu:alert:settings:"..k},
			{text = v.states[db:get_chat_setting(chat_id, k)], callback_data = "menu:"..k..":"..chat_id}
		)
	end
	return reply_markup
end

local function get_button_description(self, key)
	local i18n = self.i18n
	local button_description = {
		-- TRANSLATORS: this string should be shorter than 200 characters
		warnsnum = i18n("Change how many times a user has to be warned before being kicked/banned"),
		-- TRANSLATORS: this string should be shorter than 200 characters
		warnsact = i18n("Change the action to perform when a user reaches the max. number of warnings"),
	}
	return button_description[key] or self:getSettings().general[key].description
end

local function changeWarnSettings(self, chat_id, action)
	local red = self.red
	local i18n = self.i18n
	local current = tonumber(red:hget('chat:'..chat_id..':warnsettings', 'max'))
		or config.chat_settings['warnsettings']['max']
	local new_val
	if action == 1 then
		if current > 12 then
			return i18n("The new value is too high ( > 12)")
		else
			new_val = red:hincrby('chat:'..chat_id..':warnsettings', 'max', 1)
			return current..'->'..new_val
		end
	elseif action == -1 then
		if current < 2 then
			return i18n("The new value is too low ( < 1)")
		else
			new_val = red:hincrby('chat:'..chat_id..':warnsettings', 'max', -1)
			return current..'->'..new_val
		end
	elseif action == 'status' then
		local status = red:hget('chat:'..chat_id..':warnsettings', 'type')
		if status == null then status = config.chat_settings.warnsettings.type end

		if status == 'kick' then
			red:hset('chat:'..chat_id..':warnsettings', 'type', 'ban')
			return i18n("New action on max number of warns received: ban")
		elseif status == 'ban' then
			red:hset('chat:'..chat_id..':warnsettings', 'type', 'mute')
			return i18n("New action on max number of warns received: mute")
		elseif status == 'mute' then
			red:hset('chat:'..chat_id..':warnsettings', 'type', 'kick')
			return i18n("New action on max number of warns received: kick")
		end
	end
end

local function changeCharSettings(self, chat_id, field)
	local red = self.red
	local i18n = self.i18n
	local humanizations = {
		kick = i18n("Action -> kick"),
		ban = i18n("Action -> ban"),
		mute = i18n("Action -> mute"),
		allow = i18n("Allowed ✅")
	}

	local hash = 'chat:'..chat_id..':char'
	local status = red:hget(hash, field)

	if status == 'allowed' then
		red:hset(hash, field, 'kick')
		return humanizations['kick']
	elseif status == 'kick' then
		red:hset(hash, field, 'ban')
		return humanizations['ban']
	elseif status == 'ban' then
		red:hset(hash, field, 'mute')
		return humanizations['mute']
	else
		red:hset(hash, field, 'allowed')
		return humanizations['allow']
	end
end

local function doKeyboard_menu(self, chat_id)
	local red = self.red
	local i18n = self.i18n

	local reply_markup = ApiUtil.InlineKeyboardMarkup:new()

	self:buildGeneral(reply_markup, chat_id)

	--warn
	local max = red:hget('chat:'..chat_id..':warnsettings', 'max')
	if max == null then max = config.chat_settings['warnsettings']['max'] end

	local action = red:hget('chat:'..chat_id..':warnsettings', 'type')
	if action == null then action = config.chat_settings['warnsettings']['type'] end

	if action == 'kick' then
		action = i18n("👞 kick")
	elseif action == 'ban' then
		action = i18n("🔨️ ban")
	elseif action == 'mute' then
		action = i18n("👁 mute")
	end

	reply_markup:row(
		{text = i18n("Warnings"), callback_data = "menu:alert:settings:warnsact"},
		{text = action, callback_data = "menu:ActionWarn:"..chat_id}
	)
	reply_markup:row(
		{text = "➖", callback_data = "menu:DimWarn:"..chat_id},
		{text = max, callback_data = "menu:alert:settings:warnsnum"},
		{text = "➕", callback_data = "menu:RaiseWarn:"..chat_id}
	)

	reply_markup:row({text = "🔙", callback_data = "config:back:"..chat_id})

	return reply_markup
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local u = self.u
	local i18n = self.i18n

	if blocks[2] == "alert" then
		local text = get_button_description(self, blocks[3]) or i18n("Description not available")
		api:answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
		return
	end

	local member = ChatMember:new({
		chat = Chat:new({id=msg.target_id}, self),
		user = msg.from.user,
	}, self)

	if not member:can("can_change_info") then
		api:answerCallbackQuery(msg.cb_id, i18n("Sorry, you don't have permission to change settings"))
		return
	end

	local menu_first = i18n("Manage the settings of the group. Click on the left column to get a small hint")

	local keyboard, text, show_alert

	if blocks[1] == "config" then
		keyboard = doKeyboard_menu(self, member.chat.id)
		api:editMessageText(msg.from.chat.id, msg.message_id, nil, menu_first, "Markdown", nil, keyboard)
		return
	end

	if blocks[2] == "DimWarn" then
		text = changeWarnSettings(self, member.chat.id, -1)
	elseif blocks[2] == "RaiseWarn" then
		text = changeWarnSettings(self, member.chat.id, 1)
	elseif blocks[2] == "ActionWarn" then
		text = changeWarnSettings(self, member.chat.id, "status")
	elseif blocks[2] == "Rtl" or blocks[2] == "Arab" then
		text = changeCharSettings(self, member.chat.id, blocks[2])
	else
		text, show_alert = u:changeSettingStatus(member.chat.id, blocks[2])
	end
	keyboard = doKeyboard_menu(self, member.chat.id)
	api:editMessageText(msg.from.chat.id, msg.message_id, nil, menu_first, "Markdown", nil, keyboard)
	if text then
		--workaround to avoid to send an error to users who are using an old inline keyboard
		api:answerCallbackQuery(msg.cb_id, "⚙ "..text, show_alert)
	end
end

_M.triggers = {
	onCallbackQuery = {
		'^###cb:(menu):(alert):settings:([%w_]+)$',
		'^###cb:(menu):(.*):',
		'^###cb:(config):menu:(-?%d+)$'
	}
}

return _M
