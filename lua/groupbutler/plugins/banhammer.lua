local config = require "groupbutler.config"
local ChatMember = require("groupbutler.chatmember")
local User = require("groupbutler.user")

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
	local i18n = self.i18n
	local api_err = self.api_err
	local u = self.u

	if msg.from.chat.type == "private"
	or not msg.from:can("can_restrict_members") then
		return
	end
	local admin = msg.from
	local target
	do
		local err
		target, err = msg:getTargetMember(blocks)
		if not target and blocks[1] ~= "fwdban" then
			msg:send_reply(err, "Markdown")
			return
		end
	end
	if tonumber(target.user.id) == bot.id then return end

	--print(get_motivation(msg))

	if blocks[1] == 'tempban' then
		local time_value = msg.text:match(("%stempban.*\n"):format(config.cmd).."(%d+)")
		if time_value then --save the time value passed by the user
			if tonumber(time_value) > 100 then
				time_value = 100
			end
			local key = ('chat:%s:%s:tbanvalue'):format(msg.from.chat.id, target.user.id)
			red:setex(key, 3600, time_value)
		end
		local markup = markup_tempban(self, msg.from.chat.id, target.user.id)
		msg:send_reply(i18n("Use -/+ to edit the value, then select a timeframe to temporary ban the user"),
			"Markdown", nil, nil, markup)
	end

	local text
	if blocks[1] == 'kick' then
		local ok, err = target:kick()
		if not ok then
			msg:send_reply(err, "Markdown")
			return
		end
		u:logEvent("kick", msg, {
			motivation = get_motivation(msg),
			admin = admin.user,
			user = target.user,
			user_id = target.user.id
		})
		text = i18n("%s kicked %s!"):format(admin.user:getLink(), target.user:getLink())
		api:sendMessage(msg.from.chat.id, text, "html", true)
	end

	if blocks[1] == 'ban' then
		local ok, err = target:ban()
		if not ok then
			msg:send_reply(err, "Markdown")
		end
		u:logEvent("ban", msg, {
			motivation = get_motivation(msg),
			admin = admin.user,
			user = target.user,
			user_id = target.user.id
		})
		text = i18n("%s banned %s!"):format(admin.user:getLink(), target.user:getLink())
		api:sendMessage(msg.from.chat.id, text, "html", true)
	end

	if blocks[1] == 'fwdban' then
		if not msg.reply or not msg.reply.forward_from then
			msg:send_reply(i18n("_Use this command in reply to a forwarded message_"), "Markdown")
			return
		end
		target = msg.reply.forward_from
		local ok, err = target:ban()
		if not ok then
			msg:send_reply(err, "Markdown")
		end
		u:logEvent("ban", msg, {
			motivation = get_motivation(msg),
			admin = admin.user,
			user = target.user,
			user_id = target.user.id
		})
		text = i18n("%s banned %s!"):format(admin.user:getLink(), target.user:getLink())
		api:sendMessage(msg.from.chat.id, text, "html", true)
	end

	if blocks[1] == 'unban' then
		if target:isAdmin() then
			msg:send_reply(i18n("_An admin can't be unbanned_"), "Markdown")
			return
		end
		if target.status ~= "kicked" then
			msg:send_reply(i18n("This user is not banned!"))
			return
		end
		local ok, err = api:unbanChatMember(target.chat.id, target.user.id)
		if not ok then
			msg:send_reply(api_err:trans(err), "Markdown")
			return
		end
		u:logEvent("unban", msg, {
			motivation = get_motivation(msg),
			admin = admin,
			user = target.user,
			user_id = target.user.id
		})
		msg:send_reply(i18n("%s unbanned by %s!"):format(target.user:getLink(), admin.user:getLink()), 'html')
	end
end

function _M:onCallbackQuery(matches)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n

	if msg.from.chat.type == "private"
	or not msg.from:can("can_restrict_members") then
		api:answerCallbackQuery(msg.cb_id, i18n("Sorry, you don't have permission to restrict members"), true)
		return
	end

	if matches[1] == "nil" then
		api:answerCallbackQuery(msg.cb_id,
			i18n("Tap on the -/+ buttons to change this value. Then select a timeframe to execute the ban"), true)
		return
	end

	local target = ChatMember:new({
		user = User:new({id=matches[3]}, self),
		chat = msg.from.chat,
	}, self)

	if matches[1] == "val" then
		local key = ("chat:%d:%s:tbanvalue"):format(msg.from.chat.id, target.user.id)
		local current_value, new_value
		current_value = tonumber(red:get(key)) or 3
		if matches[2] == "m" then
			new_value = current_value - 1
			if new_value < 1 then
				api:answerCallbackQuery(msg.cb_id, i18n("You can't set a lower value"))
				return --don't proceed
			else
				red:setex(key, 3600, new_value)
			end
		elseif matches[2] == "p" then
			new_value = current_value + 1
			if new_value > 100 then
				api:answerCallbackQuery(msg.cb_id, i18n("Stop!!!"), true)
				return --don't proceed
			else
				red:setex(key, 3600, new_value)
			end
		end
		local markup = markup_tempban(self, msg.from.chat.id, target.user.id, new_value)
		api:editMessageReplyMarkup(msg.from.chat.id, msg.message_id, nil, markup)
		return
	end

	if matches[1] == 'ban' then
		local key = ('chat:%d:%s:tbanvalue'):format(msg.from.chat.id, target.user.id)
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
		local ok, err = target:ban(until_date)
		if not ok then
			api:editMessageText(msg.from.chat.id, msg.message_id, nil, err)
			return
		end
		local text = i18n("User banned for %d %s"):format(time_value, timeframe_string)
		api:editMessageText(msg.from.chat.id, msg.message_id, nil, text)
		red:del(key)
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
