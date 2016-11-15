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

function plugin.onTextMessage(msg, blocks)
	print('ok')
	if msg.chat.type == 'private' or (msg.chat.type ~= 'private' and not roles.is_admin_cached(msg)) then return end
	
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

    --do not reply when...
    if not msg.reply or roles.is_admin_cached(msg.reply) or msg.reply.from.id == bot.id then return end
	
	if blocks[1] == 'nowarn' then
		db:hdel('chat:'..msg.chat.id..':warns', msg.reply.from.id)
		db:hdel('chat:'..msg.chat.id..':mediawarn', msg.reply.from.id)
		db:hdel('chat:'..msg.chat.id..':spamwarns', msg.reply.from.id)
		api.sendReply(msg, _('Done! %s has been forgiven'):format(misc.getname_final(msg.reply.from)), 'html')
	end	
		
    if blocks[1] == 'warn'  or blocks[1] == 'sw' then

	    local name = misc.getname_final(msg.reply.from)
		local hash = 'chat:'..msg.chat.id..':warns'
		local num = db:hincrby(hash, msg.reply.from.id, 1) --add one warn
		local nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
		local text, res, motivation, hammer_log
		num, nmax = tonumber(num), tonumber(nmax)

		if num >= nmax then
			local type = (db:hget('chat:'..msg.chat.id..':warnsettings', 'type')) or 'kick'
			--try to kick/ban
			if type == 'ban' then
				text = _("%s <b>banned</b>: reached the max number of warnings (<code>%d/%d</code>)"):format(name, num , nmax)
				hammer_log = _('banned')
				res, motivation = api.banUser(msg.chat.id, msg.reply.from.id)
	    	else --kick
				text = _("%s <b>kicked</b>: reached the max number of warnings (<code>%d/%d</code>)"):format(name, num , nmax)
				hammer_log = _('kicked')
		    	res, motivation = api.kickUser(msg.chat.id, msg.reply.from.id)
		    end
		    --if kick/ban fails, send the motivation
		    if not res then
		    	if not motivation then
		    		motivation = _("I can't kick this user.\n"
						.. "Probably I'm not an Admin, or the user is an Admin iself")
		    	end
		    	text = motivation
		    else
		    	misc.saveBan(msg.reply.from.id, 'warn') --add ban
		    	db:hdel('chat:'..msg.chat.id..':warns', msg.reply.from.id) --if kick/ban works, remove the warns
		    	db:hdel('chat:'..msg.chat.id..':mediawarn', msg.reply.from.id)
		    end
			--if the user reached the max num of warns, kick and send message
		    api.sendReply(msg, text, 'html')
		    misc.logEvent('warn', msg, {
		    	motivation = blocks[2],
		    	admin = misc.getname_final(msg.from),
		    	user = misc.getname_final(msg.reply.from),
		    	user_id = msg.reply.from.id,
		    	hammered = hammer_log,
		    	warns = num,
		    	warnmax = nmax
		    })
		else
			local diff = nmax - num
			text = _("%s <b>has been warned</b> (<code>%d/%d</code>)"):format(name, num, nmax)
			local keyboard = doKeyboard_warn(msg.reply.from.id)
			if blocks[1] ~= 'sw' then api.sendMessage(msg.chat.id, text, 'html', keyboard) end
			misc.logEvent('warn', msg, {
				motivation = blocks[2],
				warns = num,
				warnmax = nmax,
				admin = misc.getname_final(msg.from),
		    	user = misc.getname_final(msg.reply.from),
		    	user_id = msg.reply.from.id,
		    	warns = num,
		    	warnmax = nmax
		    })
		end
    end
end

function plugin.onCallbackQuery(msg, blocks)
	if not roles.is_admin_cached(msg) then
		api.answerCallbackQuery(msg.cb_id, _("You are not an admin")) return
	end
	
	if blocks[1] == 'resetwarns' then
    	local user_id = blocks[2]
    	db:hdel('chat:'..msg.chat.id..':warns', user_id)
		db:hdel('chat:'..msg.chat.id..':mediawarn', user_id)
		db:hdel('chat:'..msg.chat.id..':spamwarns', user_id)

		local text = _("Warns <b>reset</b> by %s"):format(misc.getname_final(msg.from))
		api.editMessageText(msg.chat.id, msg.message_id, text, 'html')
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

		text = text .. _("\n(Admin: %s)"):format(misc.getname_final(msg.from))
		api.editMessageText(msg.chat.id, msg.message_id, text, 'html')
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(warnmax) (%d%d?)$',
		config.cmd..'(warnmax) (media) (%d%d?)$',
		config.cmd..'(warn)$',
		config.cmd..'(nowarn)s?$',
		config.cmd..'(warn) (.*)$',
		'[!/](sw)%s',
		'[!/](sw)$'
	},
	onCallbackQuery = {
		'^###cb:(resetwarns):(%d+)$',
		'^###cb:(removewarn):(%d+)$'
	}
}

return plugin
