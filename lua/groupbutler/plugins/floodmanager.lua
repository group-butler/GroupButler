local config = require "groupbutler.config"
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

local function get_button_description(self, key)
	local i18n = self.i18n
	if key == 'num' then
		return i18n("⚖ Current sensitivity. Tap on the + or the - to change it")
	elseif key == 'voice' then
		return i18n([[Choose which media must be ignored by the antiflood (the bot won't consider them).
✅: ignored
❌: not ignored]])
	else
		return i18n("Description not available")
	end
end

local function do_keyboard_flood(self, chat_id)
	local red = self.red
	local i18n = self.i18n
	--no: enabled, yes: disabled
	local status = red:hget('chat:'..chat_id..':settings', 'Flood')
	if status == null then status = config.chat_settings['settings']['Flood'] end

	if status == 'on' then
		status = i18n("✅ | ON")
	else
		status = i18n("❌ | OFF")
	end

	local hash = 'chat:'..chat_id..':flood'
	local action = red:hget(hash, 'ActionFlood')
	if action == null then action = config.chat_settings['flood']['ActionFlood'] end
	if action == 'kick' then
		action = i18n("👞️ kick")
	elseif action == 'ban' then
		action = i18n("🔨 ️ban")
	elseif action == 'mute' then
		action = i18n("👁 mute")
	end
	local num = tonumber(red:hget(hash, 'MaxFlood')) or config.chat_settings['flood']['MaxFlood']
	local keyboard = {
		inline_keyboard = {
			{
				{text = status, callback_data = 'flood:status:'..chat_id},
				{text = action, callback_data = 'flood:action:'..chat_id},
			},
			{
				{text = '➖', callback_data = 'flood:dim:'..chat_id},
				{text = tostring(num), callback_data = 'flood:alert:num:'..i18n:getLanguage()},
				{text = '➕', callback_data = 'flood:raise:'..chat_id},
			}
		}
	}

	local exceptions = {
		text = i18n("Texts"),
		forward = i18n("Forwards"),
		sticker = i18n("Stickers"),
		photo = i18n("Images"),
		gif = i18n("GIFs"),
		video = i18n("Videos"),
	}

	hash = 'chat:'..chat_id..':floodexceptions'
	for media, translation in pairs(exceptions) do
		--ignored by the antiflood-> yes, no
		local exc_status = red:hget(hash, media)
		if exc_status == null then exc_status = config.chat_settings['floodexceptions'][media] end

		if exc_status == 'yes' then
			exc_status = '✅'
		else
			exc_status = '❌'
		end
		local line = {
			{text = translation, callback_data = 'flood:alert:voice:'..i18n:getLanguage()},
			{text = exc_status, callback_data = 'flood:exc:'..media..':'..chat_id},
		}
		table.insert(keyboard.inline_keyboard, line)
	end

	--back button
	table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})

	return keyboard
end

local function changeFloodSettings(self, chat_id, screm)
	local red = self.red
	local i18n = self.i18n
	local hash = 'chat:'..chat_id..':flood'
	if type(screm) == 'string' then
		if screm == 'mute' then
			red:hset(hash, 'ActionFlood', 'ban')
			return i18n("Flooders will be banned")
		elseif screm == 'ban' then
			red:hset(hash, 'ActionFlood', 'kick')
			return i18n("Flooders will be kicked")
		elseif screm == 'kick' then
			red:hset(hash, 'ActionFlood', 'mute')
			return i18n("Flooders will be muted")
		end
	elseif type(screm) == 'number' then
		local old = tonumber(red:hget(hash, 'MaxFlood')) or 5
		local new
		if screm > 0 then
			new = red:hincrby(hash, 'MaxFlood', 1)
			if new > 25 then
				red:hincrby(hash, 'MaxFlood', -1)
				return i18n("%d is not a valid value!\n"):format(new)
					.. ("The value should be higher than 3 and lower then 26")
			end
		elseif screm < 0 then
			new = red:hincrby(hash, 'MaxFlood', -1)
			if new < 3 then
				red:hincrby(hash, 'MaxFlood', 1)
				return i18n("%d is not a valid value!\n"):format(new)
					.. ("The value should be higher than 2 and lower then 26")
			end
		end
		return string.format('%d → %d', old, new)
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local u = self.u
	local red = self.red
	local i18n = self.i18n
	local chat_id = msg.target_id
	if chat_id and not u:is_allowed('config', chat_id, msg.from) then
		api:answerCallbackQuery(msg.cb_id, i18n("You're no longer an admin"))
	else
		local header = i18n([[You can manage the antiflood settings from here.

It is also possible to choose which type of messages the antiflood will ignore (✅)]])

		local text

		if blocks[1] == 'config' then
			text = i18n("Antiflood settings")
		end

		if blocks[1] == 'alert' then
			i18n:setLanguage(blocks[3])
			text = get_button_description(self, blocks[2])
			api:answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
			return
		end

		if blocks[1] == 'exc' then
			local media = blocks[2]
			local hash = 'chat:'..chat_id..':floodexceptions'
			local status = red:hget(hash, media)
			if status == 'no' then
				red:hset(hash, media, 'yes')
				text = i18n("❎ [%s] will be ignored by the anti-flood"):format(media)
			else
				red:hset(hash, media, 'no')
				text = i18n("🚫 [%s] won't be ignored by the anti-flood"):format(media)
			end
		end

		local action
		if blocks[1] == 'action' or blocks[1] == 'dim' or blocks[1] == 'raise' then
			if blocks[1] == 'action' then
				action = red:hget('chat:'..chat_id..':flood', 'ActionFlood')
				if action == null then action = config.chat_settings.flood.ActionFlood end
			elseif blocks[1] == 'dim' then
				action = -1
			elseif blocks[1] == 'raise' then
				action = 1
			end
			text = changeFloodSettings(self, chat_id, action)
		end

		if blocks[1] == 'status' then
			text = u:changeSettingStatus(chat_id, 'Flood')
		end

		local keyboard = do_keyboard_flood(self, chat_id)
		api:editMessageText(msg.chat.id, msg.message_id, nil, header, "Markdown", nil, keyboard)
		api:answerCallbackQuery(msg.cb_id, text)
	end
end

_M.triggers = {
	onCallbackQuery = {
		'^###cb:flood:(alert):([%w_]+):([%w_]+)$',
		'^###cb:flood:(status):(-?%d+)$',
		'^###cb:flood:(action):(-?%d+)$',
		'^###cb:flood:(dim):(-?%d+)$',
		'^###cb:flood:(raise):(-?%d+)$',
		'^###cb:flood:(exc):(%a+):(-?%d+)$',

		'^###cb:(config):antiflood:'
	}
}

return _M
