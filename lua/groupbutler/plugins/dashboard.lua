local config = require "groupbutler.config"
local null = require "groupbutler.null"
local Chat = require("groupbutler.chat")
local ChatMember = require("groupbutler.chatmember")

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function getFloodSettings_text(self, chat_id)
	local red = self.red
	local i18n = self.i18n
	local status = red:hget('chat:'..chat_id..':settings', 'Flood') -- (default: disabled)
	if status == 'no' or status == 'on' then
		status = i18n("✅ | ON")
	else
		status = i18n("❌ | OFF")
	end
	local hash = 'chat:'..chat_id..':flood'
	local action = red:hget(hash, 'ActionFlood')
	if action == null then action = config.chat_settings['flood']['ActionFlood'] end

	if action == 'kick' then
		action = i18n("👞 kick")
	elseif action == 'ban' then
		action = i18n("🔨 ban")
	elseif action == 'mute' then
		action = i18n("👁 mute")
	end

	local num = tonumber(red:hget(hash, 'MaxFlood')) or config.chat_settings['flood']['MaxFlood']
	local exceptions = {
		text = i18n("Texts"),
		forward = i18n("Forwards"),
		sticker = i18n("Stickers"),
		photo = i18n("Images"),
		gif = i18n("GIFs"),
		video = i18n("Videos"),
	}
	hash = 'chat:'..chat_id..':floodexceptions'
	local list_exc = ''
	for media, translation in pairs(exceptions) do
		--ignored by the antiflood-> yes, no
		local exc_status = red:hget(hash, media)
		if exc_status == 'yes' then
			exc_status = '✅'
		else
			exc_status = '❌'
		end
		list_exc = list_exc..'• `'..translation..'`: '..exc_status..'\n'
	end
	return i18n("- *Status*: `%s`\n"):format(status)
			.. i18n("- *Action* to perform when a user floods: `%s`\n"):format(action)
			.. i18n("- Number of messages allowed *every 5 seconds*: `%d`\n"):format(num)
			.. i18n("- *Ignored media*:\n%s"):format(list_exc)
end

local function doKeyboard_dashboard(self, chat_id)
	local i18n = self.i18n
	local reply_markup = { inline_keyboard = {
		{
			{text = i18n("Settings"), callback_data = 'dashboard:settings:'..chat_id},
			{text = i18n("Admins"), callback_data = 'dashboard:adminlist:'..chat_id}
		},
		{
			{text = i18n("Rules"), callback_data = 'dashboard:rules:'..chat_id},
			{text = i18n("Extra commands"), callback_data = 'dashboard:extra:'..chat_id}
		},
		{
			{text = i18n("Flood settings"), callback_data = 'dashboard:flood:'..chat_id},
			{text = i18n("Media settings"), callback_data = 'dashboard:media:'..chat_id}
		},
	}}

	return reply_markup
end

function _M:onTextMessage()
	local api = self.api
	local msg = self.message
	local u = self.u
	local i18n = self.i18n
	if msg.from.chat.type ~= 'private' then
		local chat_id = msg.from.chat.id
		local reply_markup = doKeyboard_dashboard(self, chat_id)
		local ok = api:send_message{
			chat_id = msg.from.user.id,
			text = i18n("Navigate this message to see *all the info* about this group!"),
			parse_mode = "Markdown",
			reply_markup = reply_markup
		}
		if not u:is_silentmode_on(msg.from.chat.id) then --send the responde in the group only if the silent mode is off
			if not ok then
				u:sendStartMe(msg)
				return
			end
			api:sendMessage(msg.from.chat.id, i18n("_I've sent you the group dashboard via private message_"), "Markdown")
		end
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local u = self.u
	local red = self.red
	local i18n = self.i18n

	local request = blocks[2]
	local text, notification
	local parse_mode = "Markdown"

	local chat = Chat:new({id=msg.target_id}, self)
	local member = ChatMember:new({
		chat = chat,
		user = msg.from.user,
	}, self)

	if member.status == 'left'
	or member.status == 'kicked' then
		api:editMessageText(msg.from.user.id, msg.message_id, nil, i18n("🚷 You are not a member of the chat. " ..
			"You can't see the settings of a private group."))
		return
	end
	local reply_markup = doKeyboard_dashboard(self, chat.id)
	if request == 'settings' then
		text = u:getSettings(chat.id)
		notification = i18n("ℹ️ Group ► Settings")
	end
	if request == 'rules' then
		text = u:getRules(chat.id)
		notification = i18n("ℹ️ Group ► Rules")
	end
	if request == 'adminlist' then
		parse_mode = 'html'
		local adminlist = u:getAdminlist(chat)
		if adminlist then
			text = adminlist
		else
			text = i18n("I got kicked out of this group 😓")
		end
		notification = i18n("ℹ️ Group ► Admin list")
	end
	if request == 'extra' then
		text = u:getExtraList(chat.id)
		notification = i18n("ℹ️ Group ► Extra")
	end
	if request == 'flood' then
		text = getFloodSettings_text(self, chat.id)
		notification = i18n("ℹ️ Group ► Flood")
	end
	if request == 'media' then
		local media_texts = {
			photo = i18n("Images"),
			gif = i18n("GIFs"),
			video = i18n("Videos"),
			document = i18n("Documents"),
			TGlink = i18n("telegram.me links"),
			voice = i18n("Voice Messages"),
			link = i18n("Links"),
			audio = i18n("Music"),
			sticker = i18n("Stickers"),
			contact = i18n("Contacts"),
			game = i18n("Games"),
			location = i18n("Locations"),
			venue = i18n("Venues"),
		}
		text = i18n("*Current media settings*:\n\n")
		for media, default_status in pairs(config.chat_settings['media']) do
			local status = red:hget('chat:'..chat.id..':media', media)
			if status == null then status = default_status end
			if status == 'ok' then
				status = '✅'
			else
				status = '🚫'
			end
			local media_cute_name = media_texts[media] or media
			text = text..'`'..media_cute_name..'` ≡ '..status..'\n'
		end
		notification = i18n("ℹ️ Group ► Media")
	end
	api:edit_message_text(msg.from.user.id, msg.message_id, nil, text, parse_mode, true, reply_markup)
	api:answerCallbackQuery(msg.cb_id, notification)
end

_M.triggers = {
	onTextMessage = {config.cmd..'(dashboard)$'},
	onCallbackQuery = {'^###cb:(dashboard):(%a+):(-%d+)'}
}

return _M
