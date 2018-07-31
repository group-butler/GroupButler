local config = require "groupbutler.config"
local u = require "groupbutler.utilities"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local db = require "groupbutler.database"
local locale = require "groupbutler.languages"
local i18n = locale.translate

local plugin = {}

local function doKeyboard_warn(user_id)
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = i18n("Remove warn"), callback_data = 'removewarn:'..user_id}}}

	return keyboard
end

local function forget_user_warns(chat_id, user_id)
	local removed = {
		normal = db:hdel('chat:'..chat_id..':warns', user_id) == 1 and 'v' or '⨯',
		media = db:hdel('chat:'..chat_id..':mediawarn', user_id) == 1 and 'v' or '⨯',
		spam = db:hdel('chat:'..chat_id..':spamwarns', user_id) == 1 and 'v' or '⨯'
	}

	return removed
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type == 'private'
	or (msg.chat.type ~= 'private' and not u.is_allowed('hammer', msg.chat.id, msg.from)) then
		return
	end

	if blocks[1] == 'warnmax' then
		local new, default, text, key
		local hash = 'chat:'..msg.chat.id..':warnsettings'
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
		local old = (db:hget(hash, key)) or default
		db:hset(hash, key, new)
		text = text .. i18n("*Old* value was %d\n*New* max is %d"):format(tonumber(old), tonumber(new))
		u.sendReply(msg, text, "Markdown")
		return
	end

	if blocks[1] == 'cleanwarn' then
		local reply_markup =
		{
			inline_keyboard =
			{{{text = i18n('Yes'), callback_data = 'cleanwarns:yes'}, {text = i18n('No'), callback_data = 'cleanwarns:no'}}}
		}

		api.sendMessage(msg.chat.id,
			i18n('Do you want to continue and reset *all* the warnings received by *all* the users of the group?'),
			"Markdown", nil, nil, nil, reply_markup)

		return
	end

	--do not reply when...
	if not msg.reply
		or u.is_admin(msg.chat.id, msg.reply.from.id)
		or msg.reply.from.id == api.getMe().id then
		return
	end

	if blocks[1] == 'nowarn' then
		local removed = forget_user_warns(msg.chat.id, msg.reply.from.id)
		local admin = u.getname_final(msg.from)
		local user = u.getname_final(msg.reply.from)
		local text = i18n(
			'Done! %s has been forgiven.\n<b>Warns found</b>: <i>normal warns %s, for media %s, spamwarns %s</i>'
			):format(user, removed.normal or 0, removed.media or 0, removed.spam or 0)
		u.sendReply(msg, text, 'html')
		u.logEvent('nowarn', msg, {admin = admin, user = user, user_id = msg.reply.from.id, rem = removed})
	end

	if blocks[1] == 'warn'  or blocks[1] == 'sw' then

		local name = u.getname_final(msg.reply.from)
		local hash = 'chat:'..msg.chat.id..':warns'
		local num = db:hincrby(hash, msg.reply.from.id, 1) --add one warn
		local nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
		local text, res, err, hammer_log
		num, nmax = tonumber(num), tonumber(nmax)

		if num >= nmax then
			local type = (db:hget('chat:'..msg.chat.id..':warnsettings', 'type')) or 'kick'
			--try to kick/ban
			text = i18n("%s <b>%s</b>: reached the max number of warnings (<code>%d/%d</code>)")
			if type == 'ban' then
				hammer_log = i18n('banned')
				text = text:format(name, hammer_log, num, nmax)
				res, err = u.banUser(msg.chat.id, msg.reply.from.id)
			elseif type == 'kick' then --kick
				hammer_log = i18n('kicked')
				text = text:format(name, hammer_log, num, nmax)
				res, err = u.kickUser(msg.chat.id, msg.reply.from.id)
			elseif type == 'mute' then --kick
				hammer_log = i18n('muted')
				text = text:format(name, hammer_log, num, nmax)
				res, err = u.muteUser(msg.chat.id, msg.reply.from.id)
			end
			--if kick/ban fails, send the motivation
			if not res then
				if num > nmax then db:hset(hash, msg.reply.from.id, nmax) end --avoid to have a number of warnings bigger than the max
				text = err
			else
				forget_user_warns(msg.chat.id, msg.reply.from.id)
			end
			--if the user reached the max num of warns, kick and send message
			u.sendReply(msg, text, 'html')
			u.logEvent('warn', msg, {
				motivation = blocks[2],
				admin = u.getname_final(msg.from),
				user = u.getname_final(msg.reply.from),
				user_id = msg.reply.from.id,
				hammered = hammer_log,
				warns = num,
				warnmax = nmax
			})
		else
			text = i18n("%s <b>has been warned</b> (<code>%d/%d</code>)"):format(name, num, nmax)
			local keyboard = doKeyboard_warn(msg.reply.from.id)
			if blocks[1] ~= 'sw' then api.sendMessage(msg.chat.id, text, 'html', true, nil, nil, keyboard) end
			u.logEvent('warn', msg, {
				motivation = blocks[2],
				warns = num,
				warnmax = nmax,
				admin = u.getname_final(msg.from),
				user = u.getname_final(msg.reply.from),
				user_id = msg.reply.from.id
			})
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if not u.is_allowed('hammer', msg.chat.id, msg.from) then
		api.answerCallbackQuery(msg.cb_id, i18n("You are not allowed to use this button")) return
	end

	if blocks[1] == 'removewarn' then
		local user_id = blocks[2]
		local num = db:hincrby('chat:'..msg.chat.id..':warns', user_id, -1) --add one warn
		local text, nmax
		if tonumber(num) < 0 then
			text = i18n("The number of warnings received by this user is already <i>zero</i>")
			db:hincrby('chat:'..msg.chat.id..':warns', user_id, 1) --restore the previouvs number
		else
			nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
			text = i18n("<b>Warn removed!</b> (%d/%d)"):format(tonumber(num), tonumber(nmax))
		end

		text = text .. i18n("\n(Admin: %s)"):format(u.getname_final(msg.from))
		api.editMessageText(msg.chat.id, msg.message_id, nil, text, 'html')
	end
	if blocks[1] == 'cleanwarns' then
		if blocks[2] == 'yes' then
			db:del('chat:'..msg.chat.id..':warns')
			db:del('chat:'..msg.chat.id..':mediawarn')
			db:del('chat:'..msg.chat.id..':spamwarns')
			api.editMessageText(msg.chat.id, msg.message_id, nil,
				i18n('Done. All the warnings of this group have been erased by %s'):format(u.getname_final(msg.from)), 'html')
		else
			api.editMessageText(msg.chat.id, msg.message_id, nil, i18n('_Action aborted_'), "Markdown")
		end
	end
end

plugin.triggers = {
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

return plugin
