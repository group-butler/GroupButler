local function gsub_custom_welcome(msg, custom)
	local name = msg.added.first_name:mEscape()
	local id = msg.added.id
	local username
	local title = msg.chat.title:mEscape()
	if msg.added.username then
		username = '@'..msg.added.username:mEscape()
	else
		username = '(no username)'
	end
	custom = custom:gsub('$name', name):gsub('$username', username):gsub('$id', id):gsub('$title', title)
	return custom
end

local function get_welcome(msg, ln)
	if is_locked(msg, 'Welcome') then
		return false
	end
	local type = db:hget('chat:'..msg.chat.id..':welcome', 'type')
	local content = db:hget('chat:'..msg.chat.id..':welcome', 'content')
	if type == 'media' then
		local file_id = content
		api.sendDocumentId(msg.chat.id, file_id)
		return false
	elseif type == 'custom' then
		return gsub_custom_welcome(msg, content)
	elseif type == 'composed' then
		if not(content == 'no') then
			local abt = cross.getAbout(msg.chat.id, ln)
			local rls = cross.getRules(msg.chat.id, ln)
			local creator, admins = cross.getModlist(msg.chat.id, ln)
			print(admins)
			local mods
			if not creator then
				mods = '\n'
			else
				mods = make_text(lang[ln].service.welcome_modlist, creator:mEscape(), admins:gsub('*', ''):mEscape())
			end
			local text = make_text(lang[ln].service.welcome, msg.added.first_name:mEscape_hard(), msg.chat.title:mEscape_hard())
			if content == 'a' then
				text = text..'\n\n'..abt
			elseif content == 'r' then
				text = text..'\n\n'..rls
			elseif content == 'm' then
				text = text..mods
			elseif content == 'ra' then
				text = text..'\n\n'..abt..'\n\n'..rls
			elseif content == 'am' then
				text = text..'\n\n'..abt..mods
			elseif content == 'rm' then
				text = text..'\n\n'..rls..mods
			elseif content == 'ram' then
				text = text..'\n\n'..abt..'\n\n'..rls..mods
			end
			print(text)
			return text
		else
			return make_text(lang[ln].service.welcome, msg.added.first_name:mEscape_hard(), msg.chat.title:mEscape_hard())
		end
	end
end

local action = function(msg, blocks, ln)
	
	--avoid trolls
	if not msg.service then return end
	
	--if the bot join the chat
	if blocks[1] == 'botadded' then
		
		print('Bot added to '..msg.chat.title..' ['..msg.chat.id..']')
		
		if db:hget('bot:general', 'adminmode') == 'on' and not is_bot_owner(msg) then
			api.sendMessage(msg.chat.id, 'Admin mode is on: only the admin can add me to a new group')
			api.leaveChat(msg.chat.id)
			return
		end
		
		cross.initGroup(msg.chat.id)
		
		api.sendLog(vtext(msg.chat)..vtext(msg.adder))
		
        local out = make_text(lang[ln].service.new_group, msg.from.first_name:mEscape())
		api.sendMessage(msg.chat.id, out, true)
	end
	
	--if someone join the chat
	if blocks[1] == 'added' then
		
		if msg.chat.type == 'group' and is_banned(msg.chat.id, msg.added.id) then
			api.kickChatMember(msg.chat.id, msg.added.id)
			return
		end
		
		cross.remBanList(msg.chat.id, msg.added.id) --remove him from the banlist
		db:hdel('warn:'..msg.chat.id, msg.added.id) --remove the warns
		db:del('chat:'..msg.chat.id..':'..msg.added.id..':mediawarn') --remove the warn for media
		
		if msg.added.username then
			local username = msg.added.username:lower()
			if username:find('bot', -3) then return end
		end
		
		local text = get_welcome(msg, ln)
		if text then
			api.sendMessage(msg.chat.id, text, true)
		end
		--if not text: welcome is locked
	end
	
	--if the bot is removed from the chat
	if blocks[1] == 'botremoved' then
		
		print('Bot left '..msg.chat.title..' ['..msg.chat.id..']')
		
		--remove group id
		db:srem('bot:groupsid', msg.chat.id)
		
		--save stats
        local num = db:hincrby('bot:general', 'groups', -1)
        print('Stats saved', 'Groups: '..num)
	end

end

return {
	action = action,
	admin_not_needed = true,
	triggers = {
		'^###(botadded)',
		'^###(added)',
		'^###(botremoved)'
	}
}