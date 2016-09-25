local function is_locked(chat_id)
  	local hash = 'chat:'..chat_id..':settings'
  	local current = db:hget(hash, 'Welcome')
  	if current == 'off' then
  		return true
  	else
  		return false
  	end
end

local function get_welcome(msg)
	if is_locked(msg.chat.id) then
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
		return _("Hi %s, and welcome to *%s*!"):format(msg.added.first_name:escape_hard(), msg.chat.title:escape_hard())
	end
end

local function action(msg, blocks)
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
                api.sendReply(msg, _("New media setted as welcome message: `%s`"):format(replied_to), true)
            else
                api.sendReply(msg, _("Reply to a `sticker` or a `gif` to set them as *welcome message*"), true)
            end
        else
            db:hset(hash, 'type', 'custom')
            db:hset(hash, 'content', input)
            local res, code = api.sendReply(msg, input:gsub('$rules', misc.deeplink_constructor(msg.chat.id, 'rules')), true)
            if not res then
                db:hset(hash, 'type', 'no') --if wrong markdown, remove 'custom' again
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
                api.editMessageText(msg.chat.id, id, _("*Custom welcome message saved!*"), false, true)
            end
        end
    end
    if blocks[1] == 'added' then
		if not msg.service then return end
		
		if msg.added.username then
			local username = msg.added.username:lower()
			if username:find('bot', -3) then
				local antibot_status = db:hget('chat:'..msg.chat.id..':settings', 'Antibot')
				if antibot_status and antibot_status == 'on' and msg.from and not roles.is_admin_cached(msg) then
					api.banUser(msg.chat.id, msg.added.id)
				end
				return
			end
		end
		
		local text = get_welcome(msg)
		if text then
			api.sendMessage(msg.chat.id, text, true)
		end
		--if not text: welcome is locked or is a gif/sticker
	end
end

return {
    action = action,
    triggers = {
        config.cmd..'(welcome) (.*)$',
		config.cmd..'(welcome)$',
		'^###(added)'
	}
}