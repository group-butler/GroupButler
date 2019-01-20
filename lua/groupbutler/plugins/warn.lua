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
	keyboard.inline_keyboard = {{{text = i18n("Remove warn"), callback_data = 'removewarn:'..user_id}}}

	return keyboard
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local bot = self.bot
	local red = self.red
	local db = self.db
	local i18n = self.i18n
	local u = self.u

	if msg.from.chat.type == "private"
	or not msg.from:isAdmin() then
		return
	end

	if blocks[1] == 'warnmax' then
		local new, default, text, key
		local hash = 'chat:'..msg.from.chat.id..':warnsettings'
		if blocks[2] == 'media' then
			new = blocks[3]
			default = 2
			key = 'mediamax'
			text = i18n("Max number of warnings changed (media).\n")
		else
			key = 'max'
			new = blocks[2]
			default = 3
			text = i18n("Max number of warnings changed.\n")
		end
		local old = red:hget(hash, key)
		if old == null then old = default end

		red:hset(hash, key, new)
		text = text .. i18n("*Old* value was %d\n*New* max is %d"):format(tonumber(old), tonumber(new))
		msg:send_reply(text, "Markdown")
		return
	end

	if blocks[1] == 'cleanwarn' then
		local reply_markup =
		{
			inline_keyboard =
			{{{text = i18n('Yes'), callback_data = 'cleanwarns:yes'}, {text = i18n('No'), callback_data = 'cleanwarns:no'}}}
		}

		api:sendMessage(msg.from.chat.id,
			i18n('Do you want to continue and reset *all* the warnings received by *all* the users of the group?'),
			"Markdown", nil, nil, nil, reply_markup)

		return
	end

	--do not reply when...
	local admin = msg.from
	local target
	do
		local err
		target, err = msg:getTargetMember(blocks)
		if not target then
			msg:send_reply(err, "Markdown")
			return
		end
	end
	if tonumber(target.user.id) == bot.id then return end

	if blocks[1] == 'nowarn' then
		db:forgetUserWarns(msg.from.chat.id, msg.reply.from.user.id)
		local text = i18n("Done! %s has been forgiven."):format(target.user:getLink())
		msg:send_reply(text, 'html')
		u:logEvent('nowarn', msg, {
			admin = admin.user,
			user = target.user,
			user_id = target.user.id
		})
		return
	end

	if target:isAdmin() then return end

	if blocks[1] == 'warn'  or blocks[1] == 'sw' then
		local hash = 'chat:'..msg.from.chat.id..':warns'
		local num = tonumber(red:hincrby(hash, target.user.id, 1)) --add one warn
		local nmax = tonumber(red:hget('chat:'..msg.from.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
		local text, res, err, hammer_log

		if num >= nmax then
			local type = red:hget('chat:'..msg.from.chat.id..':warnsettings', 'type')
			if type == null then type = 'kick' end

			--try to kick/ban
			text = i18n("%s <b>%s</b>: reached the max number of warnings (<code>%d/%d</code>)")
			if type == 'ban' then
				hammer_log = i18n('banned')
				text = text:format(target.user:getLink(), hammer_log, num, nmax)
				res, err = target:ban()
			elseif type == 'kick' then --kick
				hammer_log = i18n('kicked')
				text = text:format(target.user:getLink(), hammer_log, num, nmax)
				res, err = target:kick()
			elseif type == 'mute' then --kick
				hammer_log = i18n('muted')
				text = text:format(target.user:getLink(), hammer_log, num, nmax)
				res, err = target:mute()
			end
			--if kick/ban fails, send the motivation
			if not res then
				if num > nmax then red:hset(hash, target.user.id, nmax) end --avoid to have a number of warnings bigger than the max
				text = err
			else
				db:forgetUserWarns(msg.from.chat.id, target.user.id)
			end
			--if the user reached the max num of warns, kick and send message
			msg:send_reply(text, 'html')
			u:logEvent('warn', msg, {
				motivation = blocks[2],
				admin = admin.user,
				user = target.user,
				user_id = target.user.id,
				hammered = hammer_log,
				warns = num,
				warnmax = nmax
			})
		else
			if blocks[1] ~= 'sw' then
				text = i18n("%s <b>has been warned</b> (<code>%d/%d</code>)"):format(target.user:getLink(), num, nmax)
				local keyboard = doKeyboard_warn(self, target.user.id)
				api:sendMessage(msg.from.chat.id, text, 'html', true, nil, nil, keyboard)
			end
			u:logEvent('warn', msg, {
				motivation = blocks[2],
				warns = num,
				warnmax = nmax,
				admin = admin.user,
				user = target.user,
				user_id = target.user.id
			})
		end
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n

	if msg.from.chat.type == "private"
	or not msg.from:isAdmin() then
		api:answerCallbackQuery(msg.cb_id, i18n("You are not allowed to use this button"))
		return
	end

	local admin = msg.from.user

	if blocks[1] == 'removewarn' then
		local user_id = blocks[2]
		local num = tonumber(red:hincrby('chat:'..msg.from.chat.id..':warns', user_id, -1)) --add one warn
		local text, nmax
		if num < 0 then
			text = i18n("The number of warnings received by this user is already <i>zero</i>")
			red:hincrby('chat:'..msg.from.chat.id..':warns', user_id, 1) --restore the previouvs number
		else
			nmax = tonumber(red:hget('chat:'..msg.from.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
			text = i18n("<b>Warn removed!</b> (%d/%d)"):format(num, nmax)
		end

		text = text .. i18n("\n(Admin: %s)"):format(admin:getLink())
		api:editMessageText(msg.from.chat.id, msg.message_id, nil, text, 'html')
	end

	if blocks[1] == 'cleanwarns' then
		if blocks[2] == 'yes' then
			red:del('chat:'..msg.from.chat.id..':warns')
			red:del('chat:'..msg.from.chat.id..':mediawarn')
			red:del('chat:'..msg.from.chat.id..':spamwarns')
			api:editMessageText(msg.from.chat.id, msg.message_id, nil,
				i18n('Done. All the warnings of this group have been erased by %s'):format(admin:getLink()), 'html')
		else
			api:editMessageText(msg.from.chat.id, msg.message_id, nil, i18n('_Action aborted_'), "Markdown")
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
