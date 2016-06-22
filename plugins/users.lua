local function do_keybaord_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Channel', url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = 'GitHub', url = 'https://github.com/RememberTheAir/GroupButler'},
    		{text = 'Rate me!', url = 'https://telegram.me/storebot?start='..bot.username},
		}
	}
	return keyboard
end

local function get_name_getban(msg, blocks, user_id)
	if blocks[2] then
		return blocks[2]..' ('..user_id..')'
	else
		return msg.reply.from.first_name..' ('..user_id..')'
	end
end

local function getUserBanText(user_id, ln)
	local hash = 'ban:'..user_id
	local ban_info = db:hgetall(hash)
	if not next(ban_info) then
		return lang[ln].getban.nothing
	else
		local ban_index = {
			['kick'] = lang[ln].getban.kick,
			['ban'] = lang[ln].getban.ban,
			['tempban'] = lang[ln].getban.tempban,
			['flood'] = lang[ln].getban.flood,
			['media'] = lang[ln].getban.media,
			['warn'] = lang[ln].getban.warn,
			['arab'] = lang[ln].getban.arab,
			['rtl'] = lang[ln].getban.rtl,
		}
		local text = ''
		for type,n in pairs(ban_info) do
			text = text..'`'..ban_index[type]..'`'..'*'..n..'*\n'
		end
		if text == '' then
			return lang[ln].getban.nothing
		else
			return text
		end
	end
end

local function do_keyboard_getban(user_id)
	local keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = 'Kick', callback_data = 'users:kick:'..user_id},
			{text = 'Ban', callback_data = 'users:ban:'..user_id}
		}
	}
	
	return keyboard
end

local function check_reply(msg)
	if not msg.reply then
		return false, 'Reply to the file'
	else
		if not msg.reply.document then
			return false, 'This is not a file'
		else
			if msg.reply.document.file_name ~= 'ban_data.json' then
				return false, 'This is not a valid file'
			else
				return true
			end
		end
	end
end			
			
--[[local function do_keyboard_userinfo(user_id)
	local keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = 'Next', callback_data = 'users:next:'..user_id}
		},
		{
			{text = 'Kick', callback_data = 'users:kick:'..user_id},
			{text = 'Ban', callback_data = 'users:ban:'..user_id}
		},
		{
			{text = 'Warn', callback_data = 'users:warn:'..user_id},
			{text = 'Hide', callback_data = 'users:hide:'..user_id}
		}
	}
	
	return keyboard
end]]

local function get_userinfo(user_id, chat_id, name, ln)
	local text = name..':\n'
	text = text..getUserBanText(user_id, ln)
		
	std_warns = (db:hget('chat:'..chat_id..':warns', user_id)) or 0
	media_warns = (db:hget('chat:'..chat_id..':mediawarn', user_id)) or 0
	group_msgs = (db:hget('chat:'..chat_id..':userstats', user_id)) or 0
	global_msgs = (db:hget('user:'..user_id, 'msgs')) or 0
	global_media = (db:hget('user:'..user_id, 'media')) or 0
	group_media = (db:hget('chat:'..chat_id..':usermedia', user_id)) or 0
	last_msg = (db:hget('chat:'..chat_id..':userlast', user_id)) or '-'
	
	text = text..'\n`Normal warns`: '..std_warns..'\n'
	text = text..'`Media warns`: '..media_warns..'\n'
	text = text..'`Messages in the group`: '..group_msgs..'\n'
	text = text..'`Media sent in the group`: '..group_media..'\n'
	if last_msg ~= '-' then last_msg = get_date(last_msg) end
	text = text..'`Last message here`: '..last_msg..'\n'
	
	text = text..'\n`Total messages`: '..global_msgs..'\n'
	text = text..'`Total media sent`: '..global_media..'\n'
	
	
	return text
end

local action = function(msg, blocks, ln)
	if blocks[1] == 'initgroup' then
		if msg.chat.type == 'private' then return end
		if is_mod(msg) then
			local set, is_ok = cross.getSettings(msg.chat.id, ln)
			if not is_ok then
				local nick = msg.from.first_name
				if msg.from.username then
					nick = nick..' ('..msg.from.username..')'
				end
        		cross.initGroup(msg.chat.id, msg.from.id, nick)
        		api.sendMessage(msg.chat.id, 'Should be ok. Try to run /settings command')
        		api.sendLog('#initGroup\n'..vtext(msg.chat)..vtext(msg.from))
        	else
        		api.sendMessage(msg.chat.id, 'This is already ok')
        	end
        end
    end
    if blocks[1] == 'adminlist' then
    	if msg.chat.type == 'private' then return end
    	local no_usernames
    	local send_reply = true
    	if is_locked(msg, 'Modlist') then
    		if is_mod(msg) then
        		no_usernames = true
        	else
        		no_usernames = false
        		send_reply = false
        	end
        else
            no_usernames = true
        end
    	local out
        local creator, adminlist = cross.getModlist(msg.chat.id, no_usernames)
        out = make_text(lang[ln].mod.modlist, creator, adminlist)
        if not send_reply then
        	api.sendMessage(msg.from.id, out, true)
        else
            api.sendReply(msg, out, true)
        end
        mystat('/adminlist')
    end
    if blocks[1] == 'status' then
    	if msg.chat.type == 'private' then return end
    	if is_mod(msg) then
    		local user_id
    		if blocks[2]:match('%d+$') then
    			user_id = blocks[2]
    		else
    			user_id = res_user_group(blocks[2], msg.chat.id)
    		end
    		if not user_id then
		 		api.sendReply(msg, lang[ln].bonus.no_user, true)
		 	else
		 		local res = api.getChatMember(msg.chat.id, user_id)
		 		if not res then
		 			api.sendReply(msg, lang[ln].status.unknown)
		 			return
		 		end
		 		local status = res.result.status
				local name = res.result.user.first_name
				if res.result.user.username then name = name..' (@'..res.result.user.username..')' end
				if msg.chat.type == 'group' and is_banned(msg.chat.id, user_id) then
					status = 'kicked'
				end
		 		local text = make_text(lang[ln].status[status], name)
		 		api.sendReply(msg, text)
		 	end
		 	mystat('/status')
	 	end
 	end
 	if blocks[1] == 'id' then
 		if not(msg.chat.type == 'private') and not is_mod(msg) then return end
 		local id
 		if msg.reply then
 			id = msg.reply.from.id
 		else
 			id = msg.chat.id
 		end
 		api.sendReply(msg, '`'..id..'`', true)
 		mystat('/tell')
 	end
	if blocks[1] == 'getban' then
		if msg.chat.type ~= 'private' and not is_mod(msg) then return end
		local user_id
		if blocks[2] then
			user_id = res_user_group(blocks[2], msg.chat.id)
			if not user_id then
				api.sendReply(msg, lang[ln].bonus.no_user, true)
		 		return
		 	end
		elseif msg.reply then
			if msg.reply.from.id == bot.id then return end
			user_id = msg.reply.from.id
		else
			api.sendReply(msg, lang[ln].banhammer.reply)
			return
		end
		if is_bot_owner(msg) and msg.reply then
			if msg.reply.forward_from then
				user_id = msg.reply.forward_from.id
			end
		end
		
		local name = get_name_getban(msg, blocks, user_id)
		local text = getUserBanText(user_id, ln)
		text = lang[ln].getban.header..name:mEscape()..'\n'..text
		
		if msg.chat.type == 'private' then
			api.sendReply(msg, text, true)
		else
			local keyboard = do_keyboard_getban(user_id)
			api.sendKeyboard(msg.chat.id, text, keyboard, true)
		end
	end
	if blocks[1] == 'kick' or blocks[1] == 'ban' then
		if not is_mod(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[ln].not_mod:mEscape_hard())
    		return
		end
		local res, text
		local user_id = msg.text:match('^###cb:users:%a%a%a%a?:(%d+)$')
		if blocks[1] == 'kick' then
			res, text = api.kickUser(msg.chat.id, user_id, ln)
		elseif blocks[1] == 'ban' then
			res, text = api.banUser(msg.chat.id, user_id, msg.normal_group, ln)
		end
		if res then
			cross.saveBan(user_id, blocks[1])
			if blocks[1] == 'kick' then
				text = lang[ln].getban.kicked
			elseif blocks[1] == 'ban' then
				text = lang[ln].getban.banned
			end
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end
	if blocks[1] == 'settings' then
        
        if msg.chat.type == 'private' then return end
        
        local message = cross.getSettings(msg.chat.id, ln)
        api.sendReply(msg, message, true)
        mystat('/settings') --save stats
    end
    if blocks[1] == 'welcome' then
        
        if msg.chat.type == 'private' or not is_mod(msg) then return end
        
        local input = blocks[2]
        
        --ignore if not input text and not reply
        if not input and not msg.reply then
            api.sendReply(msg, make_text(lang[ln].settings.welcome.no_input), false)
            return
        end
        
        local hash = 'chat:'..msg.chat.id..':welcome'
        
        if not input and msg.reply then
            local replied_to = get_media_type(msg.reply)
            if replied_to == 'sticker' or replied_to == 'gif' then
                local file_id-- = msg[replied_to].file_id
                if replied_to == 'sticker' then
                    file_id = msg.reply.sticker.file_id
                else
                    file_id = msg.reply.document.file_id
                end
                db:hset(hash, 'type', 'media')
                db:hset(hash, 'content', file_id)
                api.sendReply(msg, lang[ln].settings.welcome.media_setted..'`'..replied_to..'`', true)
            else
                api.sendReply(msg, lang[ln].settings.welcome.reply_media, true)
            end
            return
        end
        
        --change welcome settings
        if input == 'a' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'a')
            api.sendReply(msg, lang[ln].settings.welcome.a, true)
        elseif input == 'r' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'r')
            api.sendReply(msg, lang[ln].settings.welcome.r, true)
        elseif input == 'm' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'm')
            api.sendReply(msg, lang[ln].settings.welcome.m, true)
        elseif input == 'ar' or input == 'ra' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'ra')
            api.sendReply(msg, lang[ln].settings.welcome.ra, true)
        elseif input == 'mr' or input == 'rm' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'rm')
            api.sendReply(msg, lang[ln].settings.welcome.rm, true)
        elseif input == 'am' or input == 'ma' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'am')
            api.sendReply(msg, lang[ln].settings.welcome.am, true)
        elseif input == 'ram' or input == 'rma' or input == 'arm' or input == 'amr' or input == 'mra' or input == 'mar' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'ram')
            api.sendReply(msg, lang[ln].settings.welcome.ram, true)
        elseif input == 'no' then
            db:hset(hash, 'type', 'composed')
            db:hset(hash, 'content', 'no')
            api.sendReply(msg, lang[ln].settings.welcome.no, true)
        else
            db:hset(hash, 'type', 'custom')
            db:hset(hash, 'content', input)
            local res, code = api.sendReply(msg, make_text(lang[ln].settings.welcome.custom, input), true)
            if not res then
                db:hset(hash, 'type', 'composed') --if wrong markdown, remove 'custom' again
                db:hset(hash, 'content', 'no')
                if code == 118 then
				    api.sendMessage(msg.chat.id, lang[ln].bonus.too_long)
			    else
				    api.sendMessage(msg.chat.id, lang[ln].breaks_markdown, true)
			    end
            else
                local id = res.result.message_id
                api.editMessageText(msg.chat.id, id, lang[ln].settings.welcome.custom_setted, false, true)
            end
        end
       
        mystat('/welcome') --save stats
    end
    if blocks[1] == 'export' then
    	if msg.chat.type ~= 'private' then return end
    	if blocks[2] == 'ban' then
    		if is_bot_owner(msg) then
    			local users = db:hvals('bot:usernames')
				users = remove_duplicates(users)
				local final_table = {}
				for i,id in pairs(users) do
					local user_info = db:hgetall('ban:'..id)
					if next(user_info) then
						final_table[id] = {}
						for field, count in pairs(user_info) do
							final_table[id][field] = count
						end
					end
				end
				if next(final_table) then
					local path = 'ban_data.json'
					save_data(path, final_table)
					api.sendDocument(msg.chat.id, path)
				else
					api.sendMessage(msg.chat.id, 'Empty table')
				end
			else
				local file_id = db:get('bandata')
				if not file_id then
					api.sendReply(msg, 'Datas not available')
				else
					api.sendDocumentId(msg.chat.id, file_id)
				end
			end
		end
		if blocks[2] == 'save' then
			local is_valid, text = check_reply(msg)
			if is_valid then
				db:set('bandata', msg.reply.document.file_id)
				text = 'File id saved: '..msg.reply.document.file_id
			end
			api.sendReply(msg, text)
		end
	end
	if blocks[1] == 'importban' then
		if is_bot_owner(msg, true) then
			local is_valid, text = check_reply(msg)
			if is_valid then
				local file_name = 'ban_data_imported.json'
				local res = api.getFile(msg.reply.document.file_id)
				local download_link = telegram_file_link(res)
				path, code = download_to_file(download_link, file_name)
				local ban_info = load_data(file_name)
				if not ban_info or not next(ban_info) then
					text = 'Something went wrong: no data available'
				else
					local i = 0
					for user_id, info in pairs(ban_info) do
						
						--[[        SUM MODE
						local save_body = {} --user info to be saved in redis
						
						--get the already saved info
						local old_info = db:hgetall('ban:'..user_id)
						if old_info and next(old_info) then
							for field, count in pairs(old_info) do
								save_body[field] = tonumber(count)
							end
						end
						
						--add to the already saved info the new imported info
						for key, n in pairs(info) do
							local old_value = save_body[key] or 0
							save_body[key] = old_value + tonumber(n)
						end
						
						--save on redis
						if next(save_body) then
							for key,val in pairs(save_body) do
								db:hset('ban:'..user_id, key, val)
							end
						end]]
						
						--save on redis
						if next(info) then
							for field,count in pairs(info) do
								db:hset('ban:'..user_id, field, count)
							end
							i = i + 1
						end
					end
					text = 'Imported! New entries: '..i
				end
			end
			api.sendReply(msg, text)
		end
	end
	if blocks[1] == 'group' then
		if msg.chat.type ~= 'private' then return end
		if config.help_group and config.help_group ~= '' then
			api.sendMessage(msg.chat.id, '[Click/tap here to join :)]('..config.help_group..')', true)
		end
	end
	
	if blocks[1] == 'userinfo' then
		if not is_bot_owner(msg) then return end
		--if msg.chat.type == 'private' or not is_mod(msg) then return end
		local user_id = res_user_group(blocks[2], msg.chat.id)
		if not user_id then
			api.sendReply(msg, lang[ln].bonus.no_user, true)
		 	return
		end
		
		local name = get_name_getban(msg, blocks, user_id)
		local text = get_userinfo(user_id, msg.chat.id, name, ln)
		api.sendMessage(msg.chat.id, text, true)
	end
	--[[if blocks[1] == 'next' then
		if msg.chat.type == 'private' then return end
		if not is_mod(msg) then
			api.answerCallbackQuery(msg.cb_id, 'Not admin')
			return
		end
		local user_id = blocks[2]
		local keyboard = do_keyboard_userinfo(user_id)
		local next_i
		local n = msg.old_text:sub(1, 1)
		if n == '1' then
			next_i = 'ban'
		elseif n == '2' then
			next_i = 'other'
		end
		print(n, next_i)
		local text = get_userinfo(user_id, msg.chat.id, name, next_i, ln)
		api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
	end]]
end

return {
	action = action,
	triggers = {
		'^/(id)$',
		'^/(initgroup)$',
		'^/(adminlist)$',
		'^/(status) (@[%w_]+)$',
		'^/(status) (%d+)$',
		'^/(getban)$',
		'^/(getban) (@[%w_]+)$',
		'^/(settings)$',
		'^/(export)(ban)$',
		'^/(export)(save)$',
		'^/(importban)$',
		'^/(group)$',
		'^/(welcome) (.*)$',
		
		--'^/(userinfo)$',
		'^/(userinfo) (@[%w_]+)$',
		
		'^###cb:users:(kick):(%d+)$',
		'^###cb:users:(ban):(%d+)$',
		
		--'^###cb:users:(next):(%d+)$',
	}
}
