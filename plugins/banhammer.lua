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
	if msg.reply then
		return msg.reply.from.id
	elseif blocks[2] then
		return res_user_group(blocks[2], msg.chat.id)
	end
end

local function getBanList(chat_id, ln)
    local text = lang[ln].banhammer.banlist_header
    local hash = 'chat:'..chat_id..':bannedlist'
    local banned_users, mot = rdb.get(hash)
    if not banned_users or not next(banned_users) then
        return lang[ln].banhammer.banlist_empty
    else
        local i = 1
        for banned_id,info in pairs(banned_users) do
            text = text..'*'..i..'* - '..info.nick:mEscape()
            if info.why then text = text..'\n*⌦* '..info.why:mEscape() end
            text = text..'\n'
            i = i + 1
        end
        return text
    end
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
		if is_mod(msg) then
			if blocks[1] == 'kickme' then
				api.sendReply(msg, lang[ln].kick_errors[2], true)
				return
			end
			--[[if blocks[1] == 'banlist' then
   				local banlist = getBanList(msg.chat.id, ln)
   				api.sendReply(msg, banlist, true)
   				return
   			end]]
		    if not msg.reply_to_message and not blocks[2] then
		        api.sendReply(msg, lang[ln].banhammer.reply)
		        return nil
		    end
		    if msg.reply and msg.reply.from.id == bot.id then
		    	return
		    end
		 	--now, try to kick
		 	local res
		 	local chat_id = msg.chat.id
		 	if blocks[1] == 'tempban' then
				if not msg.reply then
					api.sendReply(msg, lang[ln].banhammer.reply)
					return
				end
				local user_id = msg.reply.from.id
				local temp, code = check_valid_time(blocks[2])
				if not temp then
					if code == 1 then
						api.sendReply(msg, lang[ln].banhammer.tempban_zero)
					else
						api.sendReply(msg, lang[ln].banhammer.tempban_week)
					end
					return
				end
				local val = msg.chat.id..':'..user_id
				local unban_time = os.time() + (temp * 60)
				
				--try to kick
				local res, motivation = api.banUser(chat_id, user_id, is_normal_group, ln)
		    	if not res then
		    		if not motivation then
		    			motivation = lang[ln].banhammer.general_motivation
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		--set the hash
		    		db:hset('tempbanned', unban_time, val)
					local time_reply = get_time_reply(temp)
					local banned_name = getname(msg.reply)
					local is_already_tempbanned = db:sismember('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
					if is_already_tempbanned then
						api.sendMessage(chat_id, make_text(lang[ln].banhammer.tempban_updated..time_reply, banned_name))
					else
						api.sendMessage(chat_id, make_text(lang[ln].banhammer.tempban_banned..time_reply, banned_name))
						db:sadd('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
					end
				end
			end
		 	local user_id = get_user_id(msg, blocks)
		 	if not user_id then
		 		api.sendReply(msg, lang[ln].bonus.no_user, true)
		 		return
		 	end
		 	if blocks[1] == 'kick' then
		    	local res, motivation = api.kickUser(chat_id, user_id, ln)
		    	if not res then
		    		if not motivation then
		    			motivation = lang[ln].banhammer.general_motivation
		    		end
		    		api.sendReply(msg, motivation, true)
		    	end
		    	mystat('/kick')
	    	end
	   		local is_normal_group = false
	   		if msg.chat.type == 'group' then is_normal_group = true end
	   		if blocks[1] == 'ban' then
	   			local res, motivation = api.banUser(chat_id, user_id, is_normal_group, ln)
		    	if not res then
		    		if not motivation then
		    			motivation = lang[ln].banhammer.general_motivation
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		--add to banlist
		    		local why, nick
		    		if msg.reply then
		    			nick = getname(msg.reply)
		    			why = msg.text:input()
		    		else
		    			nick = blocks[2]
		    			why = msg.text:gsub('^/ban @[%w_]+%s?', '')
		    		end
		    		cross.addBanList(msg.chat.id, user_id, nick, why)
		    	end
		    	mystat('/ban')
    		end
   			if blocks[1] == 'unban' then
   				local status = cross.getUserStatus(chat_id, user_id)
   				if not(status == 'kicked') and not(msg.chat.type == 'group') then
   					api.sendReply(msg, lang[ln].banhammer.not_banned, true)
   					return
   				end
   				local res = api.unbanUser(chat_id, user_id, is_normal_group)
   				if not res and msg.chat.type == 'group' then
   					api.sendReply(msg, lang[ln].banhammer.not_banned, true)
   				else
   					cross.remBanList(msg.chat.id, user_id)
   					api.sendReply(msg, lang[ln].banhammer.unbanned, true)
   				end
   				mystat('/unban')
   			end
		else
			if blocks[1] == 'kickme' then
				api.kickUser(msg.chat.id, msg.from.id, ln)
			end
		end
	else
    	api.sendMessage(msg.chat.id, lang[ln].pv)
	end
end

return {
	action = action,
	cron = cron,
	triggers = {
		'^/(kickme)%s?',
		'^/(kick) (@[%w_]+)',
		'^/(kick)',
		'^/(banlist)$',
		'^/(ban) (@[%w_]+)',
		'^/(ban)',
		--'^/(tempban) (@[%w_]+) (%d+)',
		'^/(tempban) (%d+)',
		'^/(unban) (@[%w_]+)',
		'^/(unban)',
	}
}