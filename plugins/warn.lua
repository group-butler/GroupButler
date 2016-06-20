local function doKeyboard_warn(user_id)
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Reset warns', callback_data = 'resetwarns:'..user_id},
    		{text = 'Remove warn', callback_data = 'removewarn:'..user_id}
    	}
    }
    return keyboard
end

local function action(msg, blocks, ln)
    
    --chat:id:warntype
    --chat:id:warns (3d)
    --chat:id:max
    
    if msg.chat.type == 'private' then return end
    if not is_mod(msg) then
    	if msg.cb then --show a pop up if a normal user tap on an inline button
    		api.answerCallbackQuery(msg.cb_id, lang[ln].not_mod:mEscape_hard())
    	end
    	return
    end
    
    if blocks[1] == 'warnmax' then
    	local hash, new, default, is_media
    	if blocks[2] == 'media' then
    		hash = 'chat:'..msg.chat.id..':mediamax'
    		new = blocks[3]
    		default = 2
    		is_media = ' (media)'
    	else
    		hash = 'chat:'..msg.chat.id..':max'
    		new = blocks[2]
    		default = 3
    		is_media = ''
    	end
		local old = (db:get(hash)) or default
		db:set(hash, new)
        local text = make_text(lang[ln].warn.warnmax, old, new, is_media)
        api.sendReply(msg, text, true)
        mystat('/warnmax') --save stats
        return
    end
    
    if blocks[1] == 'warn' and blocks[2] and (blocks[2] == 'kick' or blocks[2] == 'ban') then
    	if blocks[2] == 'kick' or blocks[2] == 'ban' then
    		local hash = 'chat:'..msg.chat.id..':warntype'
			db:set(hash, blocks[2])
			api.sendReply(msg, make_text(lang[ln].warn.changed_type, blocks[2]), true)
			mystat('/warnkickban')
			return
		end
		--else, consider it a normal warn
    end
    
    if blocks[1] == 'resetwarns' and msg.cb then
    	local user_id = blocks[2]
    	print(msg.chat.id, user_id)
    	db:hdel('chat:'..msg.chat.id..':warns', user_id)
		db:hdel('chat:'..msg.chat.id..':mediawarn', user_id)
		
		api.editMessageText(msg.chat.id, msg.message_id, lang[ln].warn.nowarn, false, true)
		mystat('/cbresetwarns')
		return
	end
	
	if blocks[1] == 'removewarn' and msg.cb then
    	local user_id = blocks[2]
    	print(msg.chat.id, user_id)
		local num = db:hincrby('chat:'..msg.chat.id..':warns', user_id, -1) --add one warn
		local nmax = (db:get('chat:'..msg.chat.id..':max')) or 3 --get the max num of warnings
		local diff = tonumber(nmax)-tonumber(num)
		
		local text = make_text(lang[ln].warn.warn_removed, num, nmax)
		
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
		mystat('/cbremovewarn')
		return
	end
    
    --warning to reply to a message
    if not msg.reply then
        api.sendReply(msg, lang[ln].warn.warn_reply)
	    return
	end
	--return nil if a mod is warned
	if is_mod(msg.reply) then
		api.sendReply(msg, lang[ln].warn.mod)
	    return
	end		
	--return nil if an user flag the bot
	if msg.reply.from.id == bot.id then
	    return
	end
    
    if blocks[1] == 'warn' then
	    
	    local name = getname(msg.reply)
		local hash = 'chat:'..msg.chat.id..':warns'
		local hash_max = 'chat:'..msg.chat.id..':max'
		local num = db:hincrby(hash, msg.reply.from.id, 1) --add one warn
		local nmax = (db:get(hash_max)) or 3 --get the max num of warnings
		local text, res, motivation
		
		if tonumber(num) >= tonumber(nmax) then
			local type = db:get('chat:'..msg.chat.id..':warntype')
			--try to kick/ban
			if type == 'ban' then
				text = make_text(lang[ln].warn.warned_max_ban, name:mEscape())..' ('..num..'/'..nmax..')'
				local is_normal_group = false
	    		if msg.chat.type == 'group' then is_normal_group = true end
				res, motivation = api.banUser(msg.chat.id, msg.reply.from.id, is_normal_group, ln)
	    	else --kick
				text = make_text(lang[ln].warn.warned_max_kick, name:mEscape())..' ('..num..'/'..nmax..')'
		    	res, motivation = api.kickUser(msg.chat.id, msg.reply.from.id, ln)
		    end
		    --if kick/ban fails, send the motivation
		    if not res then
		    	if not motivation then
		    		motivation = lang[ln].banhammer.general_motivation
		    	end
		    	text = motivation
		    else
		    	cross.saveBan(msg.reply.from.id, 'warn') --add ban
		    	if type == 'ban' then --add to the banlist
		    		local why = lang[ln].warn.ban_motivation
		    		if blocks[2] then why = blocks[2] end
		    		cross.addBanList(msg.chat.id, msg.reply.from.id, name, why)
		    	end
		    	db:hdel('chat:'..msg.chat.id..':warns', msg.reply.from.id) --if kick/ban works, remove the warns
		    	db:hdel('chat:'..msg.chat.id..':mediawarn', msg.reply.from.id)
		    end
		    api.sendReply(msg, text, true) --if the user reached the max num of warns, kick and send message
		else
			local diff = tonumber(nmax)-tonumber(num)
			text = make_text(lang[ln].warn.warned, name:mEscape(), num, nmax)
			local keyboard = doKeyboard_warn(msg.reply.from.id)
			api.sendKeyboard(msg.chat.id, text, keyboard, true, msg.message_id) --if the user is under the max num of warnings, send the inline keyboard
		end
        
        mystat('/warn') --save stats
    end
    
    if blocks[1] == 'getwarns' then
        
	    local name = getname(msg.reply):mEscape()
		local num = (db:hget('chat:'..msg.chat.id..':warns', msg.reply.from.id)) or 0
		local max = (db:get('chat:'..msg.chat.id..':max')) or 3
		local num_media = (db:hget('chat:'..msg.chat.id..':mediawarn', msg.reply.from.id)) or 0
		local max_media = (db:get('chat:'..msg.chat.id..':mediamax')) or 2
		local text = make_text(lang[ln].warn.getwarns, name, num, max, num_media, max_media)
        
        api.sendReply(msg, text, true)
        mystat('/getwarns') --save stats
    end
    
    if blocks[1] == 'nowarns' then
		db:hdel('chat:'..msg.chat.id..':warns', msg.reply.from.id)
		db:hdel('chat:'..msg.chat.id..':mediawarn', msg.reply.from.id)
        
        api.sendReply(msg, lang[ln].warn.nowarn, true)
        mystat('/nowarns') --save stats
    end
end

return {
	action = action,
	triggers = {
		'^/(warn) (kick)$',
		'^/(warn) (ban)$',
		'^/(warnmax) (%d%d?)$',
		'^/(warnmax) (media) (%d%d?)$',
		'^/(warn)$',
		'^/(warn) (.*)$',
		'^/(getwarns)$',
		'^/(nowarns)$',
		'^###cb:(resetwarns):(%d+)$',
		'^###cb:(removewarn):(%d+)$',
	}
}