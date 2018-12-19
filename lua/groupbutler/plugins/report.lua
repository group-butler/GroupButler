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

local function seconds2minutes(seconds)
	seconds = tonumber(seconds)
	local minutes = math.floor(seconds/60)
	seconds = seconds % 60
	return minutes, seconds
end

local function report(self, msg, description)
	local api = self.api
	local red = self.red
	local i18n = self.i18n
	local u = self.u

	local text = i18n(
		'• <b>Message reported by</b>: %s (<code>%d</code>)'):format(u:getname_final(msg.from.user), msg.from.user.id)
	local chat_link = red:hget('chat:'..msg.from.chat.id..':links', 'link')
	if msg.reply.forward_from or msg.reply.forward_from_chat or msg.reply.sticker then
		text = text..i18n(
			'\n• <b>Reported message sent by</b>: %s (<code>%d</code>)'
			):format(u:getname_final(msg.reply.from.user), msg.reply.from.user.id)
	end
	if chat_link == null then
		text = text..i18n('\n• <b>Group</b>: %s'):format(msg.from.chat.title:escape_html())
	else
		text = text..i18n('\n• <b>Group</b>: <a href="%s">%s</a>'):format(chat_link, msg.from.chat.title:escape_html())
	end
	if msg.from.chat.username then
		text = text..i18n(
			'\n• <a href="%s">Go to the message</a>'
			):format('telegram.me/'..msg.from.chat.username..'/'..msg.message_id)
	end
	if description then
		text = text..i18n('\n• <b>Description</b>: <i>%s</i>'):format(description:escape_html())
	end

	local n = 0

	local admins_list = u:get_cached_admins_list(msg.from.chat.id)
	if not admins_list then return false end

	local desc_msg
	local markup = {inline_keyboard={{{text = i18n("Address this report")}}}}
	local callback_data = ("report:%d:"):format(msg.from.chat.id)
	local hash = 'chat:'..msg.from.chat.id..':report:'..msg.message_id --stores the user_id and the msg_id of the report messages sent to the admins
	for i=1, #admins_list do
		local receive_reports = red:hget('user:'..admins_list[i]..':settings', 'reports')
		if receive_reports ~= null and receive_reports == 'on' then
			local res_fwd = api:forwardMessage(admins_list[i], msg.from.chat.id, msg.reply.message_id)
			if res_fwd then
				markup.inline_keyboard[1][1].callback_data = callback_data..(msg.message_id)
				desc_msg = api:sendMessage(admins_list[i], text, 'html', true, nil, res_fwd.message_id, markup)
				if desc_msg then
					red:hset(hash, admins_list[i], desc_msg.message_id) --save the msg_id of the msg sent to the admin
					n = n + 1
				end
			end
		end
	end

	red:expire(hash, 3600 * 48)

	return n
end

local function user_is_abusing(self, chat_id, user_id)
	local red = self.red

	local hash = 'chat:'..chat_id..':report'
	local user_key = hash..':'..user_id
	local times = tonumber(red:get(user_key)) or 1
	local times_allowed = tonumber(red:hget(hash, 'times_allowed')) or config.bot_settings.report.times_allowed
	local duration = tonumber(red:hget(hash, 'duration')) or config.bot_settings.report.duration
	if times <= times_allowed then
		red:setex(user_key, duration, times + 1)
		return false
	else
		local ttl = red:ttl(user_key)
		red:setex(user_key, tonumber(ttl), times)
		return true
	end
end

function _M:onTextMessage(blocks)
	local msg = self.message
	local red = self.red
	local i18n = self.i18n
	local u = self.u

	if msg.from.chat.id < 0 then
		if #blocks > 1 and u:is_allowed('config', msg.from.chat.id, msg.from.user) then
			local times_allowed, duration = tonumber(blocks[2]), tonumber(blocks[3])
			local text
			if times_allowed < 1 or times_allowed > 1000 then
				text = i18n("_Invalid value:_ number of times allowed (`input: %d`)"):format(times_allowed)
			elseif duration < 1 or duration > 10080 then
				text = i18n("_Invalid value:_ time (`input: %d`)"):format(duration)
			else
				local hash = 'chat:'..msg.from.chat.id..':report'
				red:hset(hash, 'times_allowed', times_allowed)
				red:hset(hash, 'duration', (duration * 60))
				text = i18n(
					'*New parameters saved*.\nUsers will be able to use @admin %d times/%d minutes'
					):format(times_allowed, duration)
			end
			msg:send_reply(text, "Markdown")
		else
			if not msg.reply or msg:is_from_admin() then
				return
			end

			local status = red:hget('chat:'..msg.from.chat.id..':settings', 'Reports')
			if status == null then status = config.chat_settings['settings']['Reports'] end

			if status == 'off' then return end

			local text
			if user_is_abusing(self, msg.from.chat.id, msg.from.user.id) then
				local hash = 'chat:'..msg.from.chat.id..':report'
				local duration = tonumber(red:hget(hash, 'duration')) or config.bot_settings.report.duration
				local times_allowed = tonumber(red:hget(hash, 'times_allowed')) or config.bot_settings.report.times_allowed
				local ttl = red:ttl(hash..':'..msg.from.user.id)
				local minutes, seconds = seconds2minutes(ttl)
				text = i18n([[_Please, do not abuse this command. It can be used %d times every %d minutes_.
Wait other %d minutes, %d seconds.]]):format(times_allowed, (duration / 60), minutes, seconds)
				msg:send_reply(text, "Markdown")
			else
				local description
				if blocks[1] and blocks[1] ~= '@admin' and blocks[1] ~= config.cmd..'report' then
					description = blocks[1]
				end

				local n_sent = report(self, msg, description) or 0

				text = i18n('_Reported to %d admin(s)_'):format(n_sent)

				u:logEvent('report', msg, {n_admins = n_sent})
				msg:send_reply(text, "Markdown")
			end
		end
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n

	if not blocks[2] then --###cb:issueclosed
		api:answerCallbackQuery(msg.cb_id,
			i18n('You closed this issue and deleted all the other reports sent to the admins'), true, 48 * 3600)
		return
	end

	local chat_id, msg_id = blocks[2], blocks[3]
	local hash = 'chat:'..chat_id..':report:'..msg_id
	if red:exists(hash) == 0 then
		--if the hash doesn't exist, the message is too old
		api:answerCallbackQuery(msg.cb_id, i18n("This message is too old (>2 days)"), true)
	else
		if blocks[1] == "report" then
			local addressed_by = red:get(hash..':addressed')
			if addressed_by == null then
				--no one addressed the issue yet

					local name = msg.from.user.first_name:sub(1, 120)
					local chats_reached = red:hgetall(hash)
					if next(chats_reached) then
						local markup = {inline_keyboard={
							{{text = i18n("❕ Already (being) adressed"), callback_data = ("report:%s:%s"):format(chat_id, msg_id)}}
						}}
						local close_issue_line = {{text = i18n("Close issue"), callback_data = ("close:%s:%s"):format(chat_id, msg_id)}}
						for user_id, message_id in pairs(chats_reached) do
							api:editMessageReplyMarkup(user_id, message_id, markup)
						end
						table.insert(markup.inline_keyboard, close_issue_line)
						api:editMessageReplyMarkup(msg.from.user.id, msg.message_id, markup)
					end
					red:setex(hash..':addressed', 3600*24*2, name)
					api:answerCallbackQuery(msg.cb_id, "✅")
			else
				api:answerCallbackQuery(msg.cb_id, i18n("%s has/will address this report"):format(addressed_by), true, 48 * 3600)
			end
		elseif blocks[1] == 'close' then
			local key = hash .. (':close:%d'):format(msg.from.user.id)
			local second_tap = red:get(key)
			if second_tap == null then
				red:setex(key, 3600*24, 'x')
				api:answerCallbackQuery(msg.cb_id, i18n(
					'This button will delete all the reports sent to the other admins. Tap it again to confirm'), true)
			else
				local chats_reached = red:hgetall(hash)
				for user_id, message_id in pairs(chats_reached) do
					if tonumber(user_id) ~= msg.from.user.id then
						api:deleteMessages(user_id, { [1] = message_id, [2] = (tonumber(message_id) - 1) })
					end
				end
				local markup = {inline_keyboard={{{text = i18n("(issue closed by you)"), callback_data = "issueclosed"}}}}
				api:editMessageReplyMarkup(msg.from.user.id, msg.message_id, nil, markup)
			end
		end
	end
end

_M.triggers = {
	onTextMessage = {
		'^@admin$',
		'^@admin (.+)',
		config.cmd..'report$',
		config.cmd..'report (.+)',
		config.cmd..'(reportflood) (%d+)[%s/:](%d+)'
	},
	onCallbackQuery = {
		"^###cb:(report):(-%d+):(%d+)$",
		"^###cb:(close):(-%d+):(%d+)$",
		"^###cb:issueclosed$"
	}
}

return _M
