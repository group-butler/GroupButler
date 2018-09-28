local config = require "groupbutler.config"
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

local function doKeyboard_media(self, chat_id)
	local red = self.red
	local keyboard = {}
	keyboard.inline_keyboard = {}
	for media, default_status in pairs(config.chat_settings['media']) do
		local status = red:hget('chat:'..chat_id..':media', media)
		if status == null then status = default_status end

		if status == 'ok' then
			status = '✅'
		elseif status == 'notok' then
			status = '❌'
		elseif status == 'del' then
			status = '🗑'
		end

		local media_texts = {
			photo = i18n("Images"),
			gif = i18n("GIFs"),
			video = i18n("Videos"),
			video_note = i18n("Video messages"),
			document = i18n("Documents"),
			--TGlink = i18n("telegram.me links"),
			voice = i18n("Vocal messages"),
			link = i18n("Links"),
			audio = i18n("Music"),
			sticker = i18n("Stickers"),
			contact = i18n("Contacts"),
			game = i18n("Games"),
			location = i18n("Locations"),
			venue = i18n("Venues"),
		}
		local media_text = media_texts[media] or media
		local line = {
			{text = media_text, callback_data = 'mediallert:'..locale.language},
			{text = status, callback_data = 'media:'..media..':'..chat_id}
		}
		table.insert(keyboard.inline_keyboard, line)
	end

	--MEDIA WARN
	--action line
	local max = red:hget('chat:'..chat_id..':warnsettings', 'mediamax')
	if max == null then max = config.chat_settings['warnsettings']['mediamax'] end
	local action = red:hget('chat:'..chat_id..':warnsettings', 'mediatype')
	if action == null then action = config.chat_settings['warnsettings']['mediatype'] end

	local caption
	if action == 'kick' then
		caption = i18n("Warnings | %d | kick"):format(tonumber(max))
	elseif action == 'mute' then
		caption = i18n("Warnings | %d | mute"):format(tonumber(max))
	else
		caption = i18n("Warnings | %d | ban"):format(tonumber(max))
	end
	table.insert(keyboard.inline_keyboard, {{text = caption, callback_data = 'mediatype:'..chat_id}})
	--buttons line
	local warn = {
		{text = '➖', callback_data = 'mediawarn:dim:'..chat_id},
		{text = '➕', callback_data = 'mediawarn:raise:'..chat_id},
	}
	table.insert(keyboard.inline_keyboard, warn)

	--back button
	table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})

	return keyboard
end

local function change_media_status(self, chat_id, media)
	local red = self.red
	local hash = ('chat:%s:media'):format(chat_id)
	local status = red:hget(hash, media)
	if status == null then status = config.chat_settings.media[media] end

	if status == 'ok' then
		red:hset(hash, media, 'notok')
		return i18n('❌ warning')
	elseif status == 'notok' then
		red:hset(hash, media, 'del')
		return i18n('🗑 delete')
	elseif status == 'del' then
		red:hset(hash, media, 'ok')
		return ''
	else
		red:hset(hash, media, 'ok')
		return i18n('✅ allowed')
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local u = self.u
	local chat_id = msg.target_id
	if chat_id and not u:is_allowed('config', chat_id, msg.from) then
		api:answerCallbackQuery(msg.cb_id, i18n("You're no longer an admin"))
	else
		local media_first = i18n([[
Tap on an option on the right to *change the setting*
You can use the last lines to change how many warnings the bot should give before kicking/banning/muting someone.
The number is not related the the normal `/warn` command.

Possible statuses: ✅ allowed, ❌ warning, 🗑 delete.
When a media is set to delete, the bot will give a warning *only* when this is the users last warning
]])

		if blocks[1] == 'config' then
			local keyboard = doKeyboard_media(self, chat_id)
			api:editMessageText(msg.chat.id, msg.message_id, nil, media_first, "Markdown", nil, keyboard)
		else
			if blocks[1] == 'mediallert' then
				if config.available_languages[blocks[2]] then
					locale.language = blocks[2]
				end
				api:answerCallbackQuery(msg.cb_id, i18n("⚠️ Tap on the right column"), false,
					config.bot_settings.cache_time.alert_help)
				return
			end
			local cb_text
			if blocks[1] == 'mediawarn' then
				local current = tonumber(red:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or 2
				if blocks[2] == 'dim' then
					if current < 2 then
						cb_text = i18n("⚙ The new value is too low ( < 1)")
					else
						local new = red:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', -1)
						cb_text = string.format('⚙ %d → %d', current, new)
					end
				elseif blocks[2] == 'raise' then
					if current > 11 then
						cb_text = i18n("⚙ The new value is too high ( > 12)")
					else
						local new = red:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', 1)
						cb_text = string.format('⚙ %d → %d', current, new)
					end
				end
			end
			if blocks[1] == 'mediatype' then
				local hash = 'chat:'..chat_id..':warnsettings'
				local current = red:hget(hash, 'mediatype')
				if current == null then current = config.chat_settings['warnsettings']['mediatype'] end

				if current == 'ban' then
					red:hset(hash, 'mediatype', 'kick')
					cb_text = i18n("👞 New status is kick")
				elseif current == 'kick' then
					red:hset(hash, 'mediatype', 'mute')
					cb_text = i18n("👁 New status is mute")
				elseif current == 'mute' then
					red:hset(hash, 'mediatype', 'ban')
					cb_text = i18n("🔨 New status is ban")
				end
			end
			if blocks[1] == 'media' then
				local media = blocks[2]
				cb_text = change_media_status(self, chat_id, media)
			end
			local keyboard = doKeyboard_media(self, chat_id)
			api:editMessageText(msg.chat.id, msg.message_id, nil, media_first, "Markdown", nil, keyboard)
			api:answerCallbackQuery(msg.cb_id, cb_text)
		end
	end
end

_M.triggers = {
	onCallbackQuery = {
		'^###cb:(media):([%a_]+):(-?%d+)',
		'^###cb:(mediatype):(-?%d+)',
		'^###cb:(mediawarn):(%a+):(-?%d+)',
		'^###cb:(mediallert):([%w_]+)$',

		'^###cb:(config):media:(-?%d+)$'
	}
}

return _M
