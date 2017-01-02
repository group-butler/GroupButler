local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function doKeyboard_warn(user_id)
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("Reset warns"), callback_data = 'resetwarns:'..user_id},
    		{text = _("Remove warn"), callback_data = 'removewarn:'..user_id}
    	}
    }
    return keyboard
end

local function forget_user_warns(chat_id, user_id)
	db:hdel('chat:'..chat_id..':warns', user_id)
	db:hdel('chat:'..chat_id..':mediawarn', user_id)
	db:hdel('chat:'..chat_id..':spamwarns', user_id)
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type == 'private' or (msg.chat.type ~= 'private' and not u.is_allowed('hammer', msg.chat.id, msg.from)) then return end
	
	if blocks[1] == 'warnmax' then
    	local new, default, text, key
    	local hash = 'chat:'..msg.chat.id..':warnsettings'
    	if blocks[2] == 'media' then
    		new = blocks[3]
    		default = 2
    		key = 'mediamax'
			text = _("Max number of warnings changed (media).\n")
    	else
    		key = 'max'
    		new = blocks[2]
    		default = 3
			text = _("Max number of warnings changed.\n")
    	end
		local old = (db:hget(hash, key)) or default
		db:hset(hash, key, new)
		text = text .. _("*Old* value was %d\n*New* max is %d"):format(tonumber(old), tonumber(new))
        api.sendReply(msg, text, true)
        return
    end
	
	if blocks[1] == 'cleanwarn' then
		local reply_markup = {inline_keyboard = {{{text = _('Yes'), callback_data = 'cleanwarns:yes'}, {text = _('No'), callback_data = 'cleanwarns:no'}}}}
		api.sendMessage(msg.chat.id, _('Do you want to continue and reset *all* the warnings received by *all* the users of the group?'), true, reply_markup)
		return
	end
	
    --do not reply when...
    if not msg.reply
    	or u.is_mod(msg.chat.id, msg.reply.from.id)
    	or msg.reply.from.id == bot.id then
    	return
    end
	
	if blocks[1] == 'nowarn' then
		forget_user_warns(msg.chat.id, msg.reply.from.id)
		local admin = u.getname_final(msg.from)
		local user = u.getname_final(msg.reply.from)
		api.sendReply(msg, _('Done! %s has been forgiven'):format(user), 'html')
		u.logEvent('nowarn', msg, {admin = admin, user = user, user_id = msg.reply.from.id})
	end	
		
    if blocks[1] == 'warn'  or blocks[1] == 'sw' then

	    local name = u.getname_final(msg.reply.from)
		local hash = 'chat:'..msg.chat.id..':warns'
		local num = db:hincrby(hash, msg.reply.from.id, 1) --add one warn
		local nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
		local text, res, motivation, hammer_log
		num, nmax = tonumber(num), tonumber(nmax)

		if num >= nmax then
			local type = (db:hget('chat:'..msg.chat.id..':warnsettings', 'type')) or 'kick'
			--try to kick/ban
			if type == 'ban' then
				text = _("%s <b>banned</b>: reached the max number of warnings (<code>%d/%d</code>)"):format(name, num, nmax)
				hammer_log = _('banned')
				res, code, motivation = api.banUser(msg.chat.id, msg.reply.from.id)
	    	else --kick
				text = _("%s <b>kicked</b>: reached the max number of warnings (<code>%d/%d</code>)"):format(name, num, nmax)
				hammer_log = _('kicked')
		    	res, code, motivation = api.kickUser(msg.chat.id, msg.reply.from.id)
		    end
		    --if kick/ban fails, send the motivation
		    if not res then
		    	if not motivation then
		    		motivation = _("I can't kick this user.\n"
						.. "Probably I'm not an Admin, or the user is an Admin iself")
    			end
	    		if num > nmax then db:hset(hash, msg.reply.from.id, nmax) end --avoid to have a number of warnings bigger than the max
		    	text = motivation
		    else
		    	u.saveBan(msg.reply.from.id, 'warn') --add ban
		    	forget_user_warns(msg.chat.id, msg.reply.from.id)
		    end
			--if the user reached the max num of warns, kick and send message
		    api.sendReply(msg, text, 'html')
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
			local diff = nmax - num
			local reason = blocks[2]
			if not reason then
				text = _("%s <b>has been warned</b> (<code>%d/%d</code>)"):format(name, num, nmax)
			else
				text = _("%s <b>has been warned</b>\nReason: %s \n(<code>%d/%d</code>)"):format(name, reason, num, nmax)
			end
			local keyboard = doKeyboard_warn(msg.reply.from.id)
			if blocks[1] ~= 'sw' then api.sendMessage(msg.chat.id, text, 'html', keyboard) end
			u.logEvent('warn', msg, {
				motivation = blocks[2],
				warns = num,
				warnmax = nmax,
				admin = u.getname_final(msg.from),
		    	user = u.getname_final(msg.reply.from),
		    	user_id = msg.reply.from.id,
		    	warns = num,
		    	warnmax = nmax
		    })
		end
    end
end

function plugin.onCallbackQuery(msg, blocks)
	if not u.is_allowed('hammer', msg.chat.id, msg.from) then
		api.answerCallbackQuery(msg.cb_id, _("You are not allowed to use this button")) return
	end
	
	if blocks[1] == 'resetwarns' then
    	local user_id = blocks[2]
    	forget_user_warns(msg.chat.id, user_id)
		
		local admin = u.getname_final(msg.from)
		local text = _("Warns <b>reset</b> by %s"):format(admin)
		api.editMessageText(msg.chat.id, msg.message_id, text, 'html')
		u.logEvent('nowarn', msg, {admin = admin, user = ('<code>%s</code>'):format(user_id), user_id = user_id})
	end
	if blocks[1] == 'removewarn' then
    	local user_id = blocks[2]
		local num = db:hincrby('chat:'..msg.chat.id..':warns', user_id, -1) --add one warn
		local text, nmax, diff
		if tonumber(num) < 0 then
			text = _("The number of warnings received by this user is already <i>zero</i>")
			db:hincrby('chat:'..msg.chat.id..':warns', user_id, 1) --restore the previouvs number
		else
			nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
			diff = nmax - num
			text = _("<b>Warn removed!</b> (%d/%d)"):format(tonumber(num), tonumber(nmax))
		end

		text = text .. _("\n(Admin: %s)"):format(u.getname_final(msg.from))
		api.editMessageText(msg.chat.id, msg.message_id, text, 'html')
	end
	if blocks[1] == 'cleanwarns' then
		if blocks[2] == 'yes' then
			db:del('chat:'..msg.chat.id..':warns')
			db:del('chat:'..msg.chat.id..':mediawarn')
			db:del('chat:'..msg.chat.id..':spamwarns')
			api.editMessageText(msg.chat.id, msg.message_id, _('Done. All the warnings of this group have been erased by %s'):format(u.getname_final(msg.from)), 'html')
		else
			api.editMessageText(msg.chat.id, msg.message_id, _('_Action aborted_'), true)
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
		config.cmd..'(sw)%s',
		config.cmd..'(sw)$'
	},
	onCallbackQuery = {
		'^###cb:(resetwarns):(%d+)$',
		'^###cb:(removewarn):(%d+)$',
		'^###cb:(cleanwarns):(%a%a%a?)$'
	}
}

return plugin
