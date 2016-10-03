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

local function action(msg, blocks)

    --warns/mediawarn

    if msg.chat.type == 'private' then return end
    if not roles.is_admin(msg) then
    	if msg.cb then --show a pop up if a normal user tap on an inline button
    		api.answerCallbackQuery(msg.cb_id, _("You are not an admin"))
    	end
    	return
    end

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

    if blocks[1] == 'resetwarns' and msg.cb then
    	local user_id = blocks[2]
    	print(msg.chat.id, user_id)
    	db:hdel('chat:'..msg.chat.id..':warns', user_id)
		db:hdel('chat:'..msg.chat.id..':mediawarn', user_id)

		local text = _("Warns *reset*\n(Admin: %s)"):format(misc.getname_final(msg.from))
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
		return
	end

	if blocks[1] == 'removewarn' and msg.cb then
    	local user_id = blocks[2]
		local num = db:hincrby('chat:'..msg.chat.id..':warns', user_id, -1) --add one warn
		local text, nmax, diff
		if tonumber(num) < 0 then
			text = _("The number of warnings received by this user is already _zero_")
			db:hincrby('chat:'..msg.chat.id..':warns', user_id, 1) --restore the previouvs number
		else
			nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
			diff = nmax - num
			text = _("*Warn removed!* (%d/%d)"):format(tonumber(num), tonumber(nmax))
		end

		text = text .. _("\n(Admin: %s)"):format(misc.getname_final(msg.from))
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
		return
	end

    --do not reply when...
    if not msg.reply or roles.is_admin_cached(msg.reply) or msg.reply.from.id == bot.id then
	    return
	end

    if blocks[1] == 'warn' then

	    local name = misc.getname_final(msg.reply.from)
		local hash = 'chat:'..msg.chat.id..':warns'
		local num = db:hincrby(hash, msg.reply.from.id, 1) --add one warn
		local nmax = (db:hget('chat:'..msg.chat.id..':warnsettings', 'max')) or 3 --get the max num of warnings
		local text, res, motivation
		num, nmax = tonumber(num), tonumber(nmax)

		if num >= nmax then
			local type = (db:hget('chat:'..msg.chat.id..':warnsettings', 'type')) or 'kick'
			--try to kick/ban
			if type == 'ban' then
				text = _("%s *banned*: reached the max number of warnings (%d/%d)"):format(name, num , nmax)
				res, motivation = api.banUser(msg.chat.id, msg.reply.from.id)
	    	else --kick
				text = _("%s *kicked*: reached the max number of warnings (%d/%d)"):format(name, num , nmax)
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
		    api.sendReply(msg, text, true)
		else
			local diff = nmax - num
			text = _("%s *has been warned* (%d/%d)"):format(name, num, nmax)
			local keyboard = doKeyboard_warn(msg.reply.from.id)
			api.sendKeyboard(msg.chat.id, text, keyboard, true)
		end
    end
end

return {
	action = action,
	triggers = {
		config.cmd..'(warnmax) (%d%d?)$',
		config.cmd..'(warnmax) (media) (%d%d?)$',
		config.cmd..'(warn)$',
		config.cmd..'(warn) (.*)$',
		'^###cb:(resetwarns):(%d+)$',
		'^###cb:(removewarn):(%d+)$',
	}
}
