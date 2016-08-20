local function cron()
	local all = db:hgetall('tempbanned')
	if next(all) then
		for unban_time,info in pairs(all) do
			if os.time() > tonumber(unban_time) then
				local chat_id, user_id = info:match('(-%d+):(%d+)')
				api.unbanUser(chat_id, user_id, true)
				api.unbanUser(chat_id, user_id, false)
				db:hdel('tempbanned', unban_time)
				db:srem('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
			end
		end
	end
end

local function get_user_id(msg, blocks)
	if msg.cb then
		return blocks[2]
	elseif msg.reply then
		return msg.reply.from.id
	elseif blocks[2] then
		if msg.mention_id then
			return msg.mention_target_id
		else
			return misc.res_user_group(blocks[2], msg.chat.id)
		end
	end
end

local function get_nick(msg, blocks)
	local admin, target
	--admin
	if msg.from.username then
		admin = misc.getname_link(msg.from.first_name, msg.from.username)
	else
		admin = msg.from.first_name:mEscape()
	end
	--target
	if msg.reply then --kick/ban the replied user
		if msg.reply.from.username then
			target = misc.getname_link(msg.reply.from.first_name, msg.reply.from.username)
		else
			target = msg.reply.from.first_name:mEscape()
		end
	elseif blocks then
		target = misc.getname_link(blocks[2]:gsub('@', ''), blocks[2])
	end
	return admin, target
end

local function check_valid_time(temp)
	temp = tonumber(temp)
	if temp == 0 then
		return false, 1
	elseif temp > 10080 then --1 week
		return false, 2
	else
		return temp
	end
end

local function get_time_reply(minutes)
	local time_string = ''
	local time_table = {}
	time_table.days = math.floor(minutes/(60*24))
	minutes = minutes - (time_table.days*60*24)
	time_table.hours = math.floor(minutes/60)
	time_table.minutes = minutes % 60
	if not(time_table.days == 0) then
		time_string = time_table.days..'d'
	end
	if not(time_table.hours == 0) then
		time_string = time_string..' '..time_table.hours..'h'
	end
	time_string = time_string..' '..time_table.minutes..'m'
	return time_string, time_table
end

local action = function(msg, blocks, ln)
	if msg.chat.type ~= 'private' then
		if roles.is_admin_cached(msg) then
			--commands that don't need a target user
			if blocks[1] == 'kickme' then
				api.sendReply(msg, lang[msg.ln].kick_errors[2], true)
				return
			end
		    
		    --commands that need a target user
		    
		    if not msg.reply_to_message and not blocks[2] and not msg.cb then
		        api.sendReply(msg, lang[msg.ln].banhammer.reply) return
		    end
		    if msg.reply and msg.reply.from.id == bot.id then return end
		 	
		 	local res
		 	local chat_id = msg.chat.id
		 	
		 	if blocks[1] == 'tempban' then
				if not msg.reply then
					api.sendReply(msg, lang[msg.ln].banhammer.reply)
					return
				end
				local user_id = msg.reply.from.id
				local temp, code = check_valid_time(blocks[2])
				if not temp then
					if code == 1 then
						api.sendReply(msg, lang[msg.ln].banhammer.tempban_zero)
					else
						api.sendReply(msg, lang[msg.ln].banhammer.tempban_week)
					end
					return
				end
				local val = msg.chat.id..':'..user_id
				local unban_time = os.time() + (temp * 60)
				
				--try to kick
				local res, motivation = api.banUser(chat_id, user_id, is_normal_group, msg.ln)
		    	if not res then
		    		if not motivation then
		    			motivation = lang[msg.ln].banhammer.general_motivation
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		misc.saveBan(user_id, 'tempban') --save the ban
		    		db:hset('tempbanned', unban_time, val) --set the hash
					local time_reply = get_time_reply(temp)
					local banned_name = misc.getname(msg.reply)
					local is_already_tempbanned = db:sismember('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
					if is_already_tempbanned then
						api.sendMessage(chat_id, make_text(lang[msg.ln].banhammer.tempban_updated..time_reply, banned_name))
					else
						api.sendMessage(chat_id, make_text(lang[msg.ln].banhammer.tempban_banned..time_reply, banned_name))
						db:sadd('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
					end
				end
			end
		 	
		 	--get the user id, send message and break if not found
		 	local user_id = get_user_id(msg, blocks)
		 	if not user_id then
		 		api.sendReply(msg, lang[msg.ln].bonus.no_user, true)
		 		return
		 	end
		 	
		 	if blocks[1] == 'kick' then
		    	local res, motivation = api.kickUser(chat_id, user_id, msg.ln)
		    	if not res then
		    		if not motivation then
		    			motivation = lang[msg.ln].banhammer.general_motivation
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		local kicker, kicked = get_nick(msg, blocks)
		    		misc.saveBan(user_id, 'kick')
		    		api.sendMessage(msg.chat.id, lang[msg.ln].banhammer.kicked:compose(kicker, kicked), true)
		    	end
	    	end
	   		if blocks[1] == 'ban' then
	   			local res, motivation = api.banUser(chat_id, user_id, msg.normal_group, msg.ln)
		    	if not res then
		    		if not motivation then
		    			motivation = lang[msg.ln].banhammer.general_motivation
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		--save the ban
		    		misc.saveBan(user_id, 'ban')
		    		--add to banlist
		    		local nick = get_nick(msg, blocks) --banned user
		    		local why
		    		if msg.reply then
		    			why = msg.text:input()
		    		else
		    			why = msg.text:gsub(config.cmd..'ban @[%w_]+%s?', '')
		    		end
		    		local banner, banned = get_nick(msg, blocks)
		    		api.sendKeyboard(msg.chat.id, lang[msg.ln].banhammer.banned:compose(banner, banned), {inline_keyboard = {{{text = 'Unban', callback_data = 'unban:'..user_id}}}}, true)
		    	end
    		end
   			if blocks[1] == 'unban' then
   				local status = misc.getUserStatus(chat_id, user_id)
   				if not(status == 'kicked') and not(msg.chat.type == 'group') then
   					api.sendReply(msg, lang[msg.ln].banhammer.not_banned, true)
   					return
   				end
   				local res = api.unbanUser(chat_id, user_id, msg.normal_group)
   				local text
   				if not res and msg.chat.type == 'group' then
   					text = lang[msg.ln].banhammer.not_banned
   				else
   					misc.remBanList(msg.chat.id, user_id)
   					text = lang[msg.ln].banhammer.unbanned:compose(misc.getname_link(msg.from.first_name, msg.from.username) or msg.from.first_name:mEscape())
   				end
   				--send reply if normal message, edit message if callback
   				if not msg.cb then
   					api.sendReply(msg, text, true)
   				else
   					api.editMessageText(msg.chat.id, msg.message_id, text..'\n`[user_id: '..user_id..']`', false, true)
   				end
   			end
		else
			if blocks[1] == 'kickme' then
				api.kickUser(msg.chat.id, msg.from.id, msg.ln)
			end
			if msg.cb then --if the user tap on 'unban', show the pop-up
				api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
			end
		end
	end
end

return {
	action = action,
	cron = cron,
	triggers = {
		config.cmd..'(kickme)%s?',
		config.cmd..'(kick) (@[%w_]+)',
		config.cmd..'(kick)',
		config.cmd..'(ban) (@[%w_]+)',
		config.cmd..'(ban)',
		config.cmd..'(tempban) (%d+)',
		config.cmd..'(unban) (@[%w_]+)',
		config.cmd..'(unban)',
		
		'^###cb:(unban):(%d+)$',
		'^###cb:(banlist)(-)$',
	}
}