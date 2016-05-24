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

local action = function(msg, blocks, ln)
	if msg.chat.type ~= 'private' then
		if is_mod(msg) then
			if blocks[1] == 'banlist' then
   				local banlist = getBanList(msg.chat.id, ln)
   				api.sendReply(msg, banlist, true)
   				return
   			end
		    if not msg.reply_to_message and not blocks[2] then
		        api.sendReply(msg, lang[ln].banhammer.reply)
		        return nil
		    end
		    if msg.reply and msg.reply.from.id == bot.id then
		    	return
		    end
		 	--now, try to kick
		 	local res
		 	local user_id = get_user_id(msg, blocks)
		 	if not user_id then
		 		api.sendReply(msg, lang[ln].bonus.no_user, true)
		 		return
		 	end
		 	local chat_id = msg.chat.id
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
   				if not(status == 'kicked') then
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
   			if blocks[1] == 'gban' then
	   			if is_bot_owner(msg) then
	   				local groups = db:smembers('bot:groupsid')
    				local succ = 0
    				local not_succ = 0
	    			for k,v in pairs(groups) do
	    				local res = api.banUserId(v, msg.reply.from.id, getname(msg.reply), true, true)
	    				if res then
	    					print('Global banned', v)
	   						succ = succ + 1
	   					else
	   						print('Not banned', v)
	   						not_succ = not_succ + 1
    					end
    				end
    				api.sendMessage(msg.chat.id, make_text(lang[ln].banhammer.globally_banned, name)..'\nDone: '..succ..'\nErrors: '..not_succ)
    				mystat('/gban')
    			end
    		end
		end
	else
    	api.sendMessage(msg.chat.id, lang[ln].pv)
	end
end

return {
	action = action,
	triggers = {
		'^/(kick) (@[%w_]+)',
		'^/(kick)',
		'^/(banlist)$',
		'^/(ban) (@[%w_]+)',
		'^/(ban)',
		'^/(unban) (@[%w_]+)',
		'^/(unban)',
		'^/(gban)$',
	}
}