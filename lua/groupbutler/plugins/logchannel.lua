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

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

local function get_alert_text(self, key)
	local i18n = self.i18n
	local alert_text = {
		new_chat_member = i18n("Log every time a user join the group"),
		ban = i18n("Bans will be logged. I can't log manual bans"),
		kick = i18n("Kicks will be logged. I can't log manual kicks"),
		warn = i18n("Manual warns will be logged"),
		mediawarn = i18n("Forbidden media will be logged in the channel"),
		spamwarn = i18n("Spam links/forwards from channels will be logged in the channel, only if forbidden"),
		flood = i18n("Log when a user is flooding (new log message every 5 flood messages)"),
		new_chat_photo = i18n("Log when an admin changes the group icon"),
		delete_chat_photo = i18n("Log when an admin deletes the group icon"),
		new_chat_title = i18n("Log when an admin change the group title"),
		pinned_message = i18n("Log pinned messages"),
		blockban = i18n("Log when a user who has been blocked is banned from the group on join"),
		nowarn = i18n("Log when an admin removes the warning received by a user"),
		report = i18n("Log when a user reports a message with the @admin command"),
	} set_default(alert_text, i18n("Description not available"))

	return alert_text[key]
end

local function toggle_event(self, chat_id, event)
	local red = self.red
	local hash = ('chat:%s:tolog'):format(chat_id)
	local current_status = red:hget(hash, event)
	if current_status == null then current_status = config.chat_settings['tolog'][event] end

	if current_status == 'yes' then
		red:hset(hash, event, 'no')
	else
		red:hset(hash, event, 'yes')
	end
end

local function doKeyboard_logchannel(self, chat_id)
	local red = self.red
	local i18n = self.i18n
	local event_pretty = {
		['ban'] = i18n('Ban'),
		['kick'] = i18n('Kick'),
		['unban'] = i18n('Unban'),
		['tempban'] = i18n('Tempban'),
		['report'] = i18n('Report'),
		['warn'] = i18n('Warns'),
		['nowarn'] = i18n('Warns resets'),
		['new_chat_member'] = i18n('New members'),
		['mediawarn'] = i18n('Media warns'),
		['spamwarn'] = i18n('Spam warns'),
		['flood'] = i18n('Flood'),
		['new_chat_photo'] = i18n('New group icon'),
		['delete_chat_photo'] = i18n('Group icon removed'),
		['new_chat_title'] = i18n('New group title'),
		['pinned_message'] = i18n('Pinned messages'),
		['blockban'] = i18n("Users blocked and banned"),
		['block'] = i18n("Users blocked"),
		['unblock'] = i18n("Users unblocked")
	}

	local keyboard = {inline_keyboard={}}
	local icon

	for event, default_status in pairs(config.chat_settings['tolog']) do
		local current_status = red:hget('chat:'..chat_id..':tolog', event)
		if current_status == null then current_status = default_status end

		icon = '✅'
		if current_status == 'no' then icon = '☑️' end
		table.insert(keyboard.inline_keyboard,
			{
				{text = event_pretty[event] or event, callback_data = 'logchannel:alert:'..event},
				{text = icon, callback_data = 'logchannel:toggle:'..event..':'..chat_id}
			})
	end

	--back button
	table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})

	return keyboard
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local u = self.u
	local i18n = self.i18n

	if blocks[1] == 'logcb' then
		local chat_id = msg.target_id
		if not msg:is_from_admin() then
			api:answerCallbackQuery(msg.cb_id, i18n("You are not admin of this group"), true)
		else
			if blocks[2] == 'unban' or blocks[2] == 'untempban' then
				local user_id = blocks[3]
				api:unban_chat_member(chat_id, user_id)
				api:answerCallbackQuery(msg.cb_id, i18n("User unbanned!"), true)
			end
		end
	else
		if blocks[1] == 'alert' then
			local text = get_alert_text(self, blocks[2])
			api:answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
		else
			local chat_id = msg.target_id
			if not u:is_allowed('config', chat_id, msg.from.user) then
				api:answerCallbackQuery(msg.cb_id, i18n("You're no longer an admin"))
			else
				local text

				if blocks[1] == 'toggle' then
					toggle_event(self, chat_id, blocks[2])
					text = '👌🏼'
				end

				local reply_markup = doKeyboard_logchannel(self, chat_id)
				if blocks[1] == 'config' then
					local logchannel_first = i18n([[*Select the events the will be logged in the channel*
✅ = will be logged
☑️ = won't be logged

Tap on an option to get further information]])
					api:edit_message_text(msg.from.chat.id, msg.message_id, nil, logchannel_first, "Markdown", true, reply_markup)
				else
					api:editMessageReplyMarkup(msg.from.chat.id, msg.message_id, nil, reply_markup)
				end

				if text then api:answerCallbackQuery(msg.cb_id, text) end
			end
		end
	end
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n

	if msg.from.chat.type ~= 'private' then
		if not msg:is_from_admin() then return end

		if blocks[1] == 'setlog' then
			if msg.forward_from_chat then
				if msg.forward_from_chat.type == 'channel' then
					if not msg.forward_from_chat.username then
						local ok, err = api:getChatMember(msg.forward_from_chat.id, msg.from.user.id)
						if not ok then
							if err.error_code == 429 then
								msg:send_reply(i18n('_Too many requests. Retry later_'), "Markdown")
							else
								msg:send_reply(i18n('_I need to be admin in the channel_'), "Markdown")
							end
						else
							if ok.status == 'creator' then
								local text
								local old_log = red:hget('bot:chatlogs', msg.from.chat.id)
								if old_log == tostring(msg.forward_from_chat.id) then
									text = i18n('_Already using this channel_')
								else
									red:hset('bot:chatlogs', msg.from.chat.id,  msg.forward_from_chat.id)
									text = i18n('*Log channel added!*')
									if old_log then
										api:sendMessage(old_log,
											i18n("<i>%s</i> changed its log channel"):format(msg.from.chat.title:escape_html()), 'html')
									end
									api:sendMessage(msg.forward_from_chat.id,
										i18n("Logs of <i>%s</i> will be posted here"):format(msg.from.chat.title:escape_html()), 'html')
								end
								msg:send_reply(text, "Markdown")
							else
								msg:send_reply(i18n('_Only the channel creator can pair the chat with a channel_'), "Markdown")
							end
						end
					else
						msg:send_reply(i18n('_I\'m sorry, only private channels are supported for now_'), "Markdown")
					end
				end
			else
				msg:send_reply(i18n("You have to *forward* the message from the channel"), "Markdown")
			end
		elseif blocks[1] == 'unsetlog' then
			local log_channel = red:hget('bot:chatlogs', msg.from.chat.id)
			if log_channel == null then
				msg:send_reply(i18n("_This groups is not using a log channel_"), "Markdown")
			else
				red:hdel('bot:chatlogs', msg.from.chat.id)
				msg:send_reply(i18n("*Log channel removed*"), "Markdown")
			end
		elseif blocks[1] == 'logchannel' then
			local log_channel = red:hget('bot:chatlogs', msg.from.chat.id)
			if log_channel == null then
				msg:send_reply(i18n("_This groups is not using a log channel_"), "Markdown")
			else
				local channel_info, err = api:getChat(log_channel)
				if not channel_info and err.error_code == 403 then
					msg:send_reply(
						i18n("_This group has a log channel saved, but I'm not a member there, so I can't post/retrieve its info_"),
							"Markdown")
				else
					local channel_identifier = log_channel
					if channel_info and channel_info then
						channel_identifier = channel_info.title
					end
					msg:send_reply(i18n('<b>This group has a log channel</b>\nChannel: <code>%s</code>')
						:format(channel_identifier:escape_html()), 'html')
				end
			end
		end
	elseif blocks[1] == 'photo' then
		api:sendPhoto(msg.from.chat.id, blocks[2])
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(setlog)$',
		config.cmd..'(unsetlog)$',
		config.cmd..'(logchannel)$',

		--deeplinking from log buttons
		'^/start (photo)_(.*)$'
	},
	onCallbackQuery = {
		--callbacks from the log channel
		'^###cb:(logcb):(%w-):(%d+):(-%d+)$',

		--callbacks from the configuration keyboard
		'^###cb:logchannel:(toggle):([%w_]+):(-?%d+)$',
		'^###cb:logchannel:(alert):([%w_]+):([%w_]+)$',
		'^###cb:(config):logchannel:(-?%d+)$'
	}
}

return _M
