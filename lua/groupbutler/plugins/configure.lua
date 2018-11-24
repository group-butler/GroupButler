local config = require "groupbutler.config"
local log = require "groupbutler.logging"
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

local function cache_chat_title(self, chat_id)
	local api = self.api
	local red = self.red
	log.info('caching title...')
	local key = 'chat:'..chat_id..':title'
	local title = api:getChat(chat_id).title
	red:set(key, title)
	red:expire(key, config.bot_settings.cache_time.chat_titles)
	return title
end

local function get_chat_title(self, chat_id)
	local red = self.red
	local title = red:get('chat:'..chat_id..':title')
	if title == null then
		return cache_chat_title(self, chat_id)
	end
	return title
end

local function do_keyboard_config(self, chat_id, user_id) -- is_admin
	local u = self.u
	local i18n = self.i18n
	local keyboard = {
		inline_keyboard = {
			{{text = i18n:_("🛠 Menu"), callback_data = 'config:menu:'..chat_id}},
			{{text = i18n:_("⚡️ Antiflood"), callback_data = 'config:antiflood:'..chat_id}},
			{{text = i18n:_("🌈 Media"), callback_data = 'config:media:'..chat_id}},
			{{text = i18n:_("🚫 Antispam"), callback_data = 'config:antispam:'..chat_id}},
			{{text = i18n:_("📥 Log channel"), callback_data = 'config:logchannel:'..chat_id}}
		}
	}

	if u:can(chat_id, user_id, "can_restrict_members") then
		table.insert(keyboard.inline_keyboard,
			{{text = i18n:_("⛔️ Default permissions"), callback_data = 'config:defpermissions:'..chat_id}})
	end

	return keyboard
end

function _M:onTextMessage()
	local api = self.api
	local msg = self.message
	local u = self.u
	local red = self.red
	local i18n = self.i18n
	if msg.chat.type ~= 'private' then
		if u:is_allowed('config', msg.chat.id, msg.from) then
			local chat_id = msg.chat.id
			local keyboard = do_keyboard_config(self, chat_id, msg.from.id)
			if red:get('chat:'..chat_id..':title') == null then cache_chat_title(self, chat_id, msg.chat.title) end
			local res = api:sendMessage(msg.from.id,
				i18n:_("<b>%s</b>\n<i>Change the settings of your group</i>"):format(msg.chat.title:escape_html()), 'html',
					nil, nil, nil, keyboard)
			if not u:is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
				if res then
					api:sendMessage(msg.chat.id, i18n:_("_I've sent you the keyboard via private message_"), "Markdown")
				else
					u:sendStartMe(msg)
				end
			end
		end
	end
end

function _M:onCallbackQuery()
	local api = self.api
	local msg = self.message
	local i18n = self.i18n
	local chat_id = msg.target_id
	local keyboard = do_keyboard_config(self, chat_id, msg.from.id, msg:is_from_admin())
	local text = i18n:_("<i>Change the settings of your group</i>")
	local chat_title = get_chat_title(self, chat_id)
	if chat_title then
		text = ("<b>%s</b>\n"):format(chat_title:escape_html())..text
	end
	api:editMessageText(msg.chat.id, msg.message_id, nil, text, 'html', nil, keyboard)
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'config$',
		config.cmd..'settings$',
	},
	onCallbackQuery = {
		'^###cb:config:back:'
	}
}

return _M
