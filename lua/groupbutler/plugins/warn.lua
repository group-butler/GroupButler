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

local function doKeyboard_warn(self, user_id)
	local i18n = self.i18n
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = i18n:_("Remove warn"), callback_data = 'removewarn:'..user_id}}}

	return keyboard
end

local function forget_user_warns(self, chat_id, user_id)
	local red = self.red

	local removed = {
		normal = red:hdel('chat:'..chat_id..':warns', user_id) == 1 and 'v' or '⨯',
		media = red:hdel('chat:'..chat_id..':mediawarn', user_id) == 1 and 'v' or '⨯',
		spam = red:hdel('chat:'..chat_id..':spamwarns', user_id) == 1 and 'v' or '⨯'
	}

	return removed
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local bot = self.bot
	local red = self.red
	local i18n = self.i18n
	local u = self.u

	if msg.chat.type == 'private'
	or (msg.chat.type ~= 'private' and not u:is_allowed('hammer', msg.chat.id, msg.from)) then
		return
	end

	if blocks[1] == 'warnmax' then
		local new, default, text, key
		local hash = 'chat:'..msg.chat.id..':warnsettings'
		if blocks[2] == 'media' then
			new = blocks[3]
			default = 2
			key = 'mediamax'
			text = i18n:_("Max number of warnings changed (media).\n")
		else
			key = 'max'
			new = blocks[2]
			default = 3
			text = i18n:_("Max number of warnings changed.\n")
		end
		local old = red:hget(hash, key)
		if old == null then old = default end

		red:hset(hash, key, new)
		text = text .. i18n:_("*Old* value was %d\n*New* max is %d"):format(tonumber(old), tonumber(new))
		msg:send_reply(text, "Markdown")
		return
	end

	if blocks[1] == 'cleanwarn' then
		local reply_markup =
		{
			inline_keyboard =
			{{{text = i18n:_('Yes'), callback_data = 'cleanwarns:yes'}, {text = i18n:_('No'), callback_data = 'cleanwarns:no'}}}
		}

		api:sendMessage(msg.chat.id,
			i18n:_('Do you want to continue and reset *all* the warnings received by *all* the users of the group?'),
			"Markdown", nil, nil, nil, reply_markup)

		return
	end

	--do not reply when...
	local user_id, err_msg = u:get_user_id(msg, blocks)
	if not user_id then
		msg:send_reply(err_msg, "Markdown")
		return
	end
	if tonumber(user_id) == bot.id then return end

	if blocks[1] == 'nowarn' then
		local removed = forget_user_warns(self, msg.chat.id, msg.reply.from.id)
		local admin = u:getname_final(msg.from)
		local user = u:getname_final(msg.reply.from)
		local text = i18n:_(
			'Done! %s has been forgiven.\n<b>Warns found</b>: <i>normal warns %s, for media %s, spamwarns %s</i>'
			):format(user, removed.normal or 0, removed.media or 0, removed.spam or 0)
		msg:send_reply(text, 'html')
		u:logEvent('nowarn', msg, {admin = admin, user = user, user_id = msg.reply.from.id, rem = removed})
	end

	if u:is_admin(msg.chat.id, user_id) then return end

	if blocks[1] == 'warn'  or blocks[1] == 'sw' then
		-- Get the user that was targeted, again, but get the name this time
		local admin_name, target_name = u:getnames_complete(msg)

		local hash = 'chat:'..msg.chat.id..':warns'
		local num = tonumber(red:hincrby(hash, user_id, 1)) --add one warn
		local nmax = tonumber(red:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
		local text, res, err, hammer_log

		if num >= nmax then
			local type = red:hget('chat:'..msg.chat.id..':warnsettings', 'type')
			if type == null then type = 'kick' end

			--try to kick/ban
			text = i18n:_("%s <b>%s</b>: reached the max number of warnings (<code>%d/%d</code>)")
			if type == 'ban' then
				hammer_log = i18n:_('banned')
				text = text:format(target_name, hammer_log, num, nmax)
				res, err = u:banUser(msg.chat.id, user_id)
			elseif type == 'kick' then --kick
				hammer_log = i18n:_('kicked')
				text = text:format(target_name, hammer_log, num, nmax)
				res, err = u:kickUser(msg.chat.id, user_id)
			elseif type == 'mute' then --kick
				hammer_log = i18n:_('muted')
				text = text:format(target_name, hammer_log, num, nmax)
				res, err = u:muteUser(msg.chat.id, user_id)
			end
			--if kick/ban fails, send the motivation
			if not res then
				if num > nmax then red:hset(hash, user_id, nmax) end --avoid to have a number of warnings bigger than the max
				text = err
			else
				forget_user_warns(self, msg.chat.id, user_id)
			end
			--if the user reached the max num of warns, kick and send message
			msg:send_reply(text, 'html')
			u:logEvent('warn', msg, {
				motivation = blocks[2],
				admin = admin_name,
				user = target_name,
				user_id = user_id,
				hammered = hammer_log,
				warns = num,
				warnmax = nmax
			})
		else
			text = i18n:_("%s <b>has been warned</b> (<code>%d/%d</code>)"):format(target_name, num, nmax)
			local keyboard = doKeyboard_warn(self, user_id)
			if blocks[1] ~= 'sw' then api:sendMessage(msg.chat.id, text, 'html', true, nil, nil, keyboard) end
			u:logEvent('warn', msg, {
				motivation = blocks[2],
				warns = num,
				warnmax = nmax,
				admin = admin_name,
				user = target_name,
				user_id = user_id
			})
		end
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n
	local u = self.u

	if not u:is_allowed('hammer', msg.chat.id, msg.from) then
		api:answerCallbackQuery(msg.cb_id, i18n:_("You are not allowed to use this button")) return
	end

	if blocks[1] == 'removewarn' then
		local user_id = blocks[2]
		local num = tonumber(red:hincrby('chat:'..msg.chat.id..':warns', user_id, -1)) --add one warn
		local text, nmax
		if num < 0 then
			text = i18n:_("The number of warnings received by this user is already <i>zero</i>")
			red:hincrby('chat:'..msg.chat.id..':warns', user_id, 1) --restore the previouvs number
		else
			nmax = tonumber(red:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
			text = i18n:_("<b>Warn removed!</b> (%d/%d)"):format(num, nmax)
		end

		text = text .. i18n:_("\n(Admin: %s)"):format(u:getname_final(msg.from))
		api:editMessageText(msg.chat.id, msg.message_id, nil, text, 'html')
	end
	if blocks[1] == 'cleanwarns' then
		if blocks[2] == 'yes' then
			red:del('chat:'..msg.chat.id..':warns')
			red:del('chat:'..msg.chat.id..':mediawarn')
			red:del('chat:'..msg.chat.id..':spamwarns')
			api:editMessageText(msg.chat.id, msg.message_id, nil,
				i18n:_('Done. All the warnings of this group have been erased by %s'):format(u:getname_final(msg.from)), 'html')
		else
			api:editMessageText(msg.chat.id, msg.message_id, nil, i18n:_('_Action aborted_'), "Markdown")
		end
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(warnmax) (%d%d?)$',
		config.cmd..'(warnmax) (media) (%d%d?)$',
		config.cmd..'(warn)$',
		config.cmd..'(nowarn)s?$',
		config.cmd..'(warn) (.*)$',
		config.cmd..'(cleanwarn)s?$',
		'[/!#](sw)%s',
		'[/!#](sw)$'
	},
	onCallbackQuery = {
		'^###cb:(resetwarns):(%d+)$',
		'^###cb:(removewarn):(%d+)$',
		'^###cb:(cleanwarns):(%a%a%a?)$'
	}
}

return _M
