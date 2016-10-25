local plugin = {}

local function is_locked(chat_id, thing)
  	local hash = 'chat:'..chat_id..':settings'
  	local current = db:hget(hash, thing)
  	if current == 'off' then
  		return true
  	else
  		return false
  	end
end

local function get_welcome(msg)
	if is_locked(msg.chat.id, 'Welcome') then
		return false
	end
	local type = (db:hget('chat:'..msg.chat.id..':welcome', 'type')) or config.chat_settings['welcome']['type']
	local content = (db:hget('chat:'..msg.chat.id..':welcome', 'content')) or config.chat_settings['welcome']['content']
	if type == 'media' then
		local file_id = content
		api.sendDocumentId(msg.chat.id, file_id)
		return false
	elseif type == 'custom' then
		return content:replaceholders(msg)
	else
		return _("Hi %s, and welcome to *%s*!"):format(msg.new_chat_member.first_name:escape(), msg.chat.title:escape_hard('bold'))
	end
end

local function get_goodbye(msg)
	if is_locked(msg.chat.id, 'Goodbye') then
		return false
	end
	local type = db:hget('chat:'..msg.chat.id..':goodbye', 'type') or 'custom'
	local content = db:hget('chat:'..msg.chat.id..':goodbye', 'content')
	if type == 'media' then
		local file_id = content
		api.sendDocumentId(msg.chat.id, file_id)
		return false
	elseif type == 'custom' then
		if not content then
			local name = msg.left_chat_member.first_name
			if msg.left_chat_member.username then
				name = name:escape() .. ' (@' .. msg.left_chat_member.username:escape() .. ')'
			end
			return _("Goodbye, %s!"):format(name)
		end
		return content:replaceholders(msg)
	end
end

function plugin.onTextMessage(msg, blocks)
    if blocks[1] == 'welcome' then
        
        if msg.chat.type == 'private' or not roles.is_admin_cached(msg) then return end
        
        local input = blocks[2]
        
        if not input and not msg.reply then
			api.sendReply(msg, _("Welcome and...?")) return
        end
        
        local hash = 'chat:'..msg.chat.id..':welcome'
        
        if not input and msg.reply then
            local replied_to = misc.get_media_type(msg.reply)
            if replied_to == 'sticker' or replied_to == 'gif' then
                local file_id
                if replied_to == 'sticker' then
                    file_id = msg.reply.sticker.file_id
                else
                    file_id = msg.reply.document.file_id
                end
                db:hset(hash, 'type', 'media')
                db:hset(hash, 'content', file_id)
                api.sendReply(msg, _("A form of media has been set as the welcome message: `%s`"):format(replied_to), true)
            else
                api.sendReply(msg, _("Reply to a `sticker` or a `gif` to set them as the *welcome message*"), true)
            end
        else
            db:hset(hash, 'type', 'custom')
            db:hset(hash, 'content', input)
            local res, code = api.sendReply(msg, input:gsub('$rules', misc.deeplink_constructor(msg.chat.id, 'rules')), true)
            if not res then
                db:hset(hash, 'type', 'no') --if wrong markdown, remove 'custom' again
                db:hset(hash, 'content', 'no')
                if code == 118 then
				    api.sendMessage(msg.chat.id, _("This message is too long, I can't send it"))
			    else
					api.sendMessage(msg.chat.id, _("This text breaks the markdown.\n"
						.. "More info about proper markdown usage can be found "
						.. "[here](https://telegram.me/GroupButler_ch/46)."), true)
			    end
            else
                local id = res.result.message_id
                api.editMessageText(msg.chat.id, id, _("*Custom welcome message saved!*"), true)
            end
        end
    end
	if blocks[1] == 'goodbye' then
		if msg.chat.type == 'private' or not roles.is_admin_cached(msg) then return end

		local input = blocks[2]
		local hash = 'chat:'..msg.chat.id..':goodbye'

		-- ignore if not input text and not reply
		if not input and not msg.reply then
			api.sendReply(msg, _("No goodbye message"), false)
			return
		end

		if not input and msg.reply then
			local replied_to = misc.get_media_type(msg.reply)
			if replied_to == 'sticker' or replied_to == 'gif' then
				local file_id
				if replied_to == 'sticker' then
					file_id = msg.reply.sticker.file_id
				else
					file_id = msg.reply.document.file_id
				end
				db:hset(hash, 'type', 'media')
				db:hset(hash, 'content', file_id)
				api.sendReply(msg, _("New media setted as goodbye message: `%s`"):format(replied_to), true)
			else
				api.sendReply(msg, _("Reply to a `sticker` or a `gif` to set them as *goodbye message*"), true)
			end
			return
		end

		input = input:gsub('^%s*(.-)%s*$', '%1') -- trim spaces
		db:hset(hash, 'type', 'custom')
		db:hset(hash, 'content', input)
		local res, code = api.sendReply(msg, _("*Custom goodbye message* setted!\n\n%s"):format(input), true)
		if not res then
			db:hset(hash, 'type', 'composed') --if wrong markdown, remove 'custom' again
			db:hset(hash, 'content', 'no')
			if code == 118 then
				api.sendMessage(msg.chat.id, _("This text is too long, I can't send it"))
			else
				api.sendMessage(msg.chat.id, _("This text breaks the markdown.\n"
						.. "More info about a proper use of markdown "
						.. "[here](https://telegram.me/GroupButler_ch/46)."), true)
			end
		else
			local id = res.result.message_id
			api.editMessageText(msg.chat.id, id, _("*Custom goodbye message saved!*"), true)
		end
	end
    if blocks[1] == 'new_chat_member' then
		if not msg.service then return end
		
		if msg.new_chat_member.username then
			local username = msg.new_chat_member.username:lower()
			if username:find('bot', -3) then
				return
			end
		end
		
		local text = get_welcome(msg)
		if text then --if not text: welcome is locked or is a gif/sticker
			local keyboard
			local attach_button = (db:hget('chat:'..msg.chat.id..':settings', 'Welbut')) or config.chat_settings['settings']['Welbut']
			if attach_button == 'on' then
				keyboard = {inline_keyboard={{{text = _('Read the rules'), url = misc.deeplink_constructor(msg.chat.id, 'rules')}}}}
			end
			api.sendMessage(msg.chat.id, text, true, keyboard)
		end
		
		local send_rules_private = db:hget('user:'..msg.new_chat_member.id..':settings', 'rules_on_join')
		if send_rules_private and send_rules_private == 'on' then
		    local rules = db:hget('chat:'..msg.chat.id..':info', 'rules')
		    if rules then
		        api.sendMessage(msg.new_chat_member.id, rules, true)
		    end
	    end
	end
	if blocks[1] == 'left_chat_member' then
		if not msg.service then return end

		if msg.left_chat_member.username and msg.left_chat_member.username:lower():find('bot', -3) then return end
		local text = get_goodbye(msg)
		if text then
			api.sendMessage(msg.chat.id, text, true)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(welcome) (.*)$',
		config.cmd..'set(welcome) (.*)$',
		config.cmd..'(welcome)$',
		config.cmd..'set(welcome)$',
		config.cmd..'(goodbye) (.*)$',
		config.cmd..'set(goodbye) (.*)$',
		config.cmd..'(goodbye)$',
		config.cmd..'set(goodbye)$',

		'^###(new_chat_member)$',
		'^###(left_chat_member)$',
	}
}

return plugin
