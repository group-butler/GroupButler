local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local db = require 'database'
local locale = require 'languages'
local i18n = locale.translate

local plugin = {}

local function seconds2minutes(seconds)
	seconds = tonumber(seconds)
	local minutes = math.floor(seconds/60)
	seconds = seconds % 60
	return minutes, seconds
end

local function report(msg, description)
	local text = i18n(
		'• <b>Message reported by</b>: %s (<code>%d</code>)'):format(u.getname_final(msg.from), msg.from.id)
	local chat_link = db:hget('chat:'..msg.chat.id..':links', 'link')
	if msg.reply.forward_from or msg.reply.forward_from_chat or msg.reply.sticker then
		text = text..i18n(
			'\n• <b>Reported message sent by</b>: %s (<code>%d</code>)'
			):format(u.getname_final(msg.reply.from), msg.reply.from.id)
	end
	if chat_link then
		text = text..i18n('\n• <b>Group</b>: <a href="%s">%s</a>'):format(chat_link, msg.chat.title:escape_html())
	else
		text = text..i18n('\n• <b>Group</b>: %s'):format(msg.chat.title:escape_html())
	end
	if msg.chat.username then
		text = text..i18n(
			'\n• <a href="%s">Go to the message</a>'
			):format('telegram.me/'..msg.chat.username..'/'..msg.message_id)
	end
	if description then
		text = text..i18n('\n• <b>Description</b>: <i>%s</i>'):format(description:escape_html())
	end

	local n = 0

	local admins_list = u.get_cached_admins_list(msg.chat.id)
	if not admins_list then return false end

	local desc_msg
	local markup = {inline_keyboard={{{text = i18n("Address this report")}}}}
	local callback_data = ("report:%d:"):format(msg.chat.id)
	local hash = 'chat:'..msg.chat.id..':report:'..msg.message_id --stores the user_id and the msg_id of the report messages sent to the admins
	for i=1, #admins_list do
		local receive_reports = db:hget('user:'..admins_list[i]..':settings', 'reports')
		if receive_reports and receive_reports == 'on' then
			local res_fwd = api.forwardMessage(admins_list[i], msg.chat.id, msg.reply.message_id)
			if res_fwd then
				markup.inline_keyboard[1][1].callback_data = callback_data..(msg.message_id)
				desc_msg = api.sendMessage(admins_list[i], text, 'html', markup, res_fwd.result.message_id)
				if desc_msg then
					db:hset(hash, admins_list[i], desc_msg.result.message_id) --save the msg_id of the msg sent to the admin
					n = n + 1
				end
			end
		end
	end

	db:expire(hash, 3600 * 48)

	return n
end

local function user_is_abusing(chat_id, user_id)
	local hash = 'chat:'..chat_id..':report'
	local user_key = hash..':'..user_id
	local times = tonumber(db:get(user_key)) or 1
	local times_allowed = tonumber(db:hget(hash, 'times_allowed')) or config.bot_settings.report.times_allowed
	local duration = tonumber(db:hget(hash, 'duration')) or config.bot_settings.report.duration
	if times <= times_allowed then
		db:setex(user_key, duration, times + 1)
		return false
	else
		local ttl = db:ttl(user_key)
		db:setex(user_key, tonumber(ttl), times)
		return true
	end
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.id < 0 then
		if #blocks > 1 and u.is_allowed('config', msg.chat.id, msg.from) then
			local times_allowed, duration = tonumber(blocks[2]), tonumber(blocks[3])
			local text
			if times_allowed < 1 or times_allowed > 1000 then
				text = i18n("_Invalid value:_ number of times allowed (`input: %d`)"):format(times_allowed)
			elseif duration < 1 or duration > 10080 then
				text = i18n("_Invalid value:_ time (`input: %d`)"):format(duration)
			else
				local hash = 'chat:'..msg.chat.id..':report'
				db:hset(hash, 'times_allowed', times_allowed)
				db:hset(hash, 'duration', (duration * 60))
				text = i18n(
					'*New parameters saved*.\nUsers will be able to use @admin %d times/%d minutes'
					):format(times_allowed, duration)
			end
			api.sendReply(msg, text, true)
		else
			if msg.from.admin
				or not msg.reply
				or u.is_mod(msg.chat.id, msg.reply.from.id) then
				return
			end

			local status = (db:hget('chat:'..msg.chat.id..':settings', 'Reports')) or config.chat_settings['settings']['Reports']
			if not status or status == 'off' then return end

			local text
			if user_is_abusing(msg.chat.id, msg.from.id) then
				local hash = 'chat:'..msg.chat.id..':report'
				local duration = tonumber(db:hget(hash, 'duration')) or config.bot_settings.report.duration
				local times_allowed = tonumber(db:hget(hash, 'times_allowed')) or config.bot_settings.report.times_allowed
				local ttl = db:ttl(hash..':'..msg.from.id)
				local minutes, seconds = seconds2minutes(ttl)
				text = i18n([[_Please, do not abuse this command. It can be used %d times every %d minutes_.
Wait other %d minutes, %d seconds.]]):format(times_allowed, (duration / 60), minutes, seconds)
				api.sendReply(msg, text, true)
			else
				local description
				if blocks[1] and blocks[1] ~= '@admin' and blocks[1] ~= config.cmd..'report' then
					description = blocks[1]
				end

				local n_sent = report(msg, description) or 0

				text = i18n('_Reported to %d admin(s)_'):format(n_sent)

				u.logEvent('report', msg, {n_admins = n_sent})
				api.sendReply(msg, text, true)
			end
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if not blocks[2] then --###cb:issueclosed
		api.answerCallbackQuery(msg.cb_id, i18n('You closed this issue and deleted all the other reports sent to the admins'),
			true, 48 * 3600)
		return
	end

	local chat_id, msg_id = blocks[2], blocks[3]
	local hash = 'chat:'..chat_id..':report:'..msg_id
	if not db:exists(hash) then
		--if the hash doesn't exist, the message is too old
		api.answerCallbackQuery(msg.cb_id, i18n("This message is too old (>2 days)"), true)
	else
		if blocks[1] == "report" then
			local addressed_by = db:get(hash..':addressed')
			if not addressed_by then
				--no one addressed the issue yet

					local name = msg.from.first_name:sub(1, 120)
					local chats_reached = db:hgetall(hash)
					if next(chats_reached) then
						local markup = {inline_keyboard={
							{{text = i18n("❕ Already (being) adressed"), callback_data = ("report:%s:%s"):format(chat_id, msg_id)}}
						}}
						local close_issue_line = {{text = i18n("Close issue"), callback_data = ("close:%s:%s"):format(chat_id, msg_id)}}
						for user_id, message_id in pairs(chats_reached) do
							api.editMessageReplyMarkup(user_id, message_id, markup)
						end
						table.insert(markup.inline_keyboard, close_issue_line)
						api.editMessageReplyMarkup(msg.from.id, msg.message_id, markup)
					end
					db:setex(hash..':addressed', 3600*24*2, name)
					api.answerCallbackQuery(msg.cb_id, "✅")
			else
				api.answerCallbackQuery(msg.cb_id, i18n("%s has/will address this report"):format(addressed_by), true, 48 * 3600)
			end
		elseif blocks[1] == 'close' then
			local key = hash .. (':close:%d'):format(msg.from.id)
			local second_tap = db:get(key)
			if not second_tap then
				db:setex(key, 3600*24, 'x')
				api.answerCallbackQuery(msg.cb_id, i18n(
					'This button will delete all the reports sent to the other admins. Tap it again to confirm'), true)
			else
				local chats_reached = db:hgetall(hash)
				for user_id, message_id in pairs(chats_reached) do
					if tonumber(user_id) ~= msg.from.id then
						api.deleteMessages(user_id, { [1] = message_id, [2] = (tonumber(message_id) - 1) })
					end
				end
				local markup = {inline_keyboard={{{text = i18n("(issue closed by you)"), callback_data = "issueclosed"}}}}
				api.editMessageReplyMarkup(msg.from.id, msg.message_id, markup)
			end
		end
	end
end

plugin.triggers = {
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

return plugin
