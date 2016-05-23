local function tell(msg, ln)
	if msg.reply then
		msg = msg.reply
	end
	
	local text = ''

	text = text..'*ID*: '..msg.from.id..'\n'
	
	if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
		text = text..make_text(lang[ln].bonus.tell, msg.chat.id)
		return text
	else
		return text
	end
end

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

local action = function(msg, blocks, ln)
	if blocks[1] == 'ping' then
		api.sendMessage(msg.from.id, '*Pong!*', true)
		mystat('/ping') --save stats
	end
	if blocks[1] == 'helpme' then
		if not is_owner(msg) or msg.chat.type == 'private' then
			return
		end
		db:sadd('bot:tofix', msg.chat.id)
		change_one_header(msg.chat.id)
		api.sendReply(msg, 'All should be ok now.\nIf not, contact the bot owner! (with _/c_ command)', true)
	end
	if blocks[1] == 'fixextra' then
		if not is_owner(msg) or msg.chat.type == 'private' then
			return
		end
		db:sadd('bot:tofixextra', msg.chat.id)
		change_extra_header(msg.chat.id)
		api.sendReply(msg, 'All should be ok now.\nIf not, contact the bot owner! (with _/c_ command)', true)
	end
	if blocks[1] == 'strings' then
		if not blocks[2] then
			local file_id = db:get('trfile:EN')
			if not file_id then return end
			api.sendDocumentId(msg.chat.id, file_id, msg.message_id)
		else
			local l_code = blocks[2]
			local exists = is_lang_supported(l_code)
			if exists then
				local file_id = db:get('trfile:'..l_code:upper())
				if not file_id then return end
				api.sendDocumentId(msg.chat.id, file_id, msg.message_id)
			else
				api.sendReply(msg, lang[ln].setlang.error, true)
			end
		end
	end
	if blocks[1] == 'tell' then
		local text = tell(msg, ln)
		api.sendReply(msg, text, true)
		mystat('/tell')
	end
	if blocks[1] == 'echo' then
		local res, code = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, lang[ln].bonus.too_long)
			else
				api.sendMessage(msg.chat.id, lang[ln].breaks_markdown, true)
			end
		end
	end
	if blocks[1] == 'c' then
		if msg.chat.type ~= 'private' then
        	return
    	end
        local input = blocks[2]
        local receiver = msg.from.id
        
        --allert if not feedback
        if not input and not msg.reply then
            api.sendMessage(msg.from.id, lang[ln].report.no_input)
            return
        end
        
        if msg.reply then
        	msg = msg.reply
        end
	    
	    api.forwardMessage (config.admin, msg.from.id, msg.message_id)
	    api.sendMessage(receiver, lang[ln].report.sent)
	    mystat('/c')
	end
	if blocks[1] == 'info' then
		local keyboard = {}
		keyboard = do_keybaord_credits()
		api.sendKeyboard(msg.chat.id, lang[ln].credits, keyboard, true)
		mystat('/credits')
	end
	if blocks[1] == 'pin' then
		local id = db:get('pin:id')
		if not id then return end
		local type = db:get('pin:type')
		if type == 'document' then
			api.sendDocumentId(msg.chat.id, id, msg.message_id)
		elseif type == 'photo' then
			api.sendPhotoId(msg.chat.id, id, msg.message_id)
		end
	end
	if blocks[1] == 'resolve' then
		local id = res_user_group(blocks[2], msg.chat.id)
		if not id then
			message = lang[ln].bonus.no_user
		else
			message = '*'..id..'*'
		end
		api.sendMessage(msg.chat.id, message, true)
	end
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
    	local out
        local creator, adminlist = cross.getModlist(msg.chat.id)
        if not creator then
            out = lang[ln].bonus.adminlist_admin_required --creator is false, admins is the error code
        else
            out = make_text(lang[ln].mod.modlist, creator, adminlist)
        end
        if is_locked(msg, 'Modlist') and not is_mod(msg) then
        	api.sendMessage(msg.from.id, out, true)
        else
            api.sendReply(msg, out, true)
        end
        mystat('/adminlist')
    end
    if blocks[1] == 'status' then
    	if msg.chat.type == 'private' then return end
    	if is_mod(msg) then
    		local user_id = res_user_group(blocks[2], msg.chat.id)
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
		 		api.sendReply(msg, text, true)
		 	end
	 	end
 	end
end

return {
	action = action,
	triggers = {
		'^/(ping)$',
		'^/(helpme)$',
		'^/(fixextra)$',
		'^/(strings)$',
		'^/(strings) (%a%a)$',
		'^/(tell)$',
		'^/(echo) (.*)$',
		'^/(c)$',
		'^/(c) (.*)',
		'^/(info)$',
		'^/(pin)$',
		'^/(resolve) (@[%w_]+)$',
		'^/(initgroup)$',
		'^/(adminlist)$',
		'^/(status) (@[%w_]+)$',
	}
}