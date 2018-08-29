local config = require "groupbutler.config"
local locale = require "groupbutler.languages"
local i18n = locale.translate

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function markup_tempban(self, chat_id, user_id, time_value)
	local red = self.red
	local key = ('chat:%s:%s:tbanvalue'):format(chat_id, user_id)
	time_value = time_value or tonumber(red:get(key)) or 3

	local markup = {inline_keyboard={
		{--first line
			{text = '-', callback_data = ('tempban:val:m:%s:%s'):format(user_id, chat_id)},
			{text = "🕑 "..time_value, callback_data = "tempban:nil"},
			{text = '+', callback_data = ('tempban:val:p:%s:%s'):format(user_id, chat_id)}
		},
		{--second line
			{text = 'minutes', callback_data = ('tempban:ban:m:%s:%s'):format(user_id, chat_id)},
			{text = 'hours', callback_data = ('tempban:ban:h:%s:%s'):format(user_id, chat_id)},
			{text = 'days', callback_data = ('tempban:ban:d:%s:%s'):format(user_id, chat_id)},
		}
	}}

	return markup
end

local function get_motivation(msg)
	if msg.reply then
		return msg.text:match(("%sban (.+)"):format(config.cmd))
			or msg.text:match(("%skick (.+)"):format(config.cmd))
			or msg.text:match(("%stempban .+\n(.+)"):format(config.cmd))
	else
		if msg.text:find(config.cmd.."ban @%w[%w_]+ ") or msg.text:find(config.cmd.."kick @%w[%w_]+ ") then
			return msg.text:match(config.cmd.."ban @%w[%w_]+ (.+)") or msg.text:match(config.cmd.."kick @%w[%w_]+ (.+)")
		elseif msg.text:find(config.cmd.."ban %d+ ") or msg.text:find(config.cmd.."kick %d+ ") then
			return msg.text:match(config.cmd.."ban %d+ (.+)") or msg.text:match(config.cmd.."kick %d+ (.+)")
		elseif msg.entities then
			return msg.text:match(config.cmd.."ban .+\n(.+)") or msg.text:match(config.cmd.."kick .+\n(.+)")
		end
	end
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local bot = self.bot
	local red = self.red
	local u = self.u

	if msg.chat.type ~= 'private' then
		if u:can(msg.chat.id, msg.from.id, "can_restrict_members") then

			local user_id, error_translation_key = u:get_user_id(msg, blocks)

			if not user_id and blocks[1] ~= 'kickme' and blocks[1] ~= 'fwdban' then
				msg:send_reply(error_translation_key, "Markdown") return
			end
			if tonumber(user_id) == bot.id then return end

			local chat_id = msg.chat.id
			local admin, kicked = u:getnames_complete(msg, blocks)

			--print(get_motivation(msg))

			if blocks[1] == 'tempban' then
				local time_value = msg.text:match(("%stempban.*\n"):format(config.cmd).."(%d+)")
				if time_value then --save the time value passed by the user
					if tonumber(time_value) > 100 then
						time_value = 100
					end
					local key = ('chat:%s:%s:tbanvalue'):format(msg.chat.id, user_id)
					red:setex(key, 3600, time_value)
				end

				local markup = markup_tempban(self, msg.chat.id, user_id)
				msg:send_reply(i18n("Use -/+ to edit the value, then select a timeframe to temporary ban the user"),
					"Markdown", nil, nil, markup)
			end
			if blocks[1] == 'kick' then
				local ok, err = u:kickUser(chat_id, user_id)
				if ok then
					u:logEvent('kick', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
					api:sendMessage(msg.chat.id, i18n("%s kicked %s!"):format(admin, kicked), 'html', true)
				else
					msg:send_reply(err, "Markdown")
				end
			end
			if blocks[1] == 'ban' then
				local ok, err = u:banUser(chat_id, user_id)
				if ok then
					u:logEvent('ban', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
					api:sendMessage(msg.chat.id, i18n("%s banned %s!"):format(admin, kicked), 'html', true)
				else
					msg:send_reply(err, "Markdown")
				end
			end
			if blocks[1] == 'fwdban' then
				if not msg.reply or not msg.reply.forward_from then
					msg:send_reply(i18n("_Use this command in reply to a forwarded message_"), "Markdown")
				else
					user_id = msg.reply.forward_from.id
					local ok, err = u:banUser(chat_id, user_id)
					if ok then
						u:logEvent('ban', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
						api:sendMessage(msg.chat.id, i18n("%s banned %s!"):format(admin, u:getname_final(msg.reply.forward_from)), 'html')
					else
						msg:send_reply(err, "Markdown")
					end
				end
			end
			if blocks[1] == 'unban' then
				if u:is_admin(chat_id, user_id) then
					msg:send_reply(i18n("_An admin can't be unbanned_"), "Markdown")
				else
					local result = api:getChatMember(chat_id, user_id)
					local text
					if result.status ~= 'kicked' then
						text = i18n("This user is not banned!")
					else
						api:unbanChatMember(chat_id, user_id)
						u:logEvent('unban', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
						text = i18n("%s unbanned by %s!"):format(kicked, admin)
					end
					msg:send_reply(text, 'html')
				end
			end
		end
	end
end

function _M:onCallbackQuery(msg, matches)
	local api = self.api
	local red = self.red
	local u = self.u

	if not u:can(msg.chat.id, msg.from.id, 'can_restrict_members') then
		api:answerCallbackQuery(msg.cb_id, i18n("You don't have the permissions to restrict members"), true)
	else
		if matches[1] == 'nil' then
			api:answerCallbackQuery(msg.cb_id,
				i18n("Tap on the -/+ buttons to change this value. Then select a timeframe to execute the ban"), true)
		elseif matches[1] == 'val' then
			local user_id = matches[3]
			local key = ('chat:%d:%s:tbanvalue'):format(msg.chat.id, user_id)
			local current_value, new_value
			current_value = tonumber(red:get(key)) or 3
			if matches[2] == 'm' then
				new_value = current_value - 1
				if new_value < 1 then
					api:answerCallbackQuery(msg.cb_id, i18n("You can't set a lower value"))
					return --don't proceed
				else
					red:setex(key, 3600, new_value)
				end
			elseif matches[2] == 'p' then
				new_value = current_value + 1
				if new_value > 100 then
					api:answerCallbackQuery(msg.cb_id, i18n("Stop!!!"), true)
					return --don't proceed
				else
					red:setex(key, 3600, new_value)
				end
			end

			local markup = markup_tempban(self, msg.chat.id, user_id, new_value)
			api:editMessageReplyMarkup(msg.chat.id, msg.message_id, nil, markup)
		elseif matches[1] == 'ban' then
			local user_id = matches[3]
			local key = ('chat:%d:%s:tbanvalue'):format(msg.chat.id, user_id)
			local time_value = tonumber(red:get(key)) or 3
			local timeframe_string, until_date
			if matches[2] == 'h' then
				time_value = time_value <= 24 and time_value or 24
				timeframe_string = i18n('hours')
				until_date = msg.date + (time_value * 3600)
			elseif matches[2] == 'd' then
				time_value = time_value <= 30 and time_value or 30
				timeframe_string = i18n('days')
				until_date = msg.date + (time_value * 3600 * 24)
			elseif matches[2] == 'm' then
				time_value = time_value <= 60 and time_value or 60
				timeframe_string = i18n('minutes')
				until_date = msg.date + (time_value * 60)
			end

			local ok, err = u:banUser(msg.chat.id, user_id, until_date)
			if ok then
				local text = i18n("User banned for %d %s"):format(time_value, timeframe_string)
				api:editMessageText(msg.chat.id, msg.message_id, nil, text)
				red:del(key)
			else
				api:editMessageText(msg.chat.id, msg.message_id, nil, err)
			end
		end
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(kick) (.+)',
		config.cmd..'(kick)$',
		config.cmd..'(ban) (.+)',
		config.cmd..'(ban)$',
		config.cmd..'(fwdban)$',
		config.cmd..'(tempban)$',
		config.cmd..'(tempban) (.+)',
		config.cmd..'(unban) (.+)',
		config.cmd..'(unban)$'
	},
	onCallbackQuery = {
		'^###cb:tempban:(val):(%a):(%d+):(-%d+)',
		'^###cb:tempban:(ban):(%a):(%d+):(-%d+)',
		'^###cb:tempban:(nil)$'
	}
}

return _M
