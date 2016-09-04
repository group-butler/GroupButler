local function do_keybaord_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("Channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = _("GitHub"), url = 'https://github.com/RememberTheAir/GroupButler'},
    		{text = _("Rate me!"), url = 'https://telegram.me/storebot?start='..bot.username},
		},
		{
			{text = _("👥 Groups"), callback_data = 'private:groups'}
		}
	}
	return keyboard
end

local action = function(msg, blocks)
    
    if msg.chat.type ~= 'private' then return end
    
	if blocks[1] == 'ping' then
		api.sendMessage(msg.from.id, '*Pong!*', true)
	end
	if blocks[1] == 'strings' then
		if not blocks[2] then
			local file_id = db:get('trfile:EN')
			if not file_id then return end
			api.sendDocumentId(msg.chat.id, file_id, msg.message_id)
		else
			local l_code = blocks[2]
			local exists = misc.is_lang_supported(l_code)
			if exists then
				local file_id = db:get('trfile:'..l_code:upper())
				if not file_id then return end
				api.sendDocumentId(msg.chat.id, file_id, msg.message_id)
			else
				api.sendReply(msg, _("Language not yet supported"), true)
			end
		end
	end
	if blocks[1] == 'echo' then
		local res, code = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, _("This text is too long, I can't send it"))
			else
				local message_text = _("This text breaks the markdown.\n"
						.. "More info about a proper use of markdown "
						.. "[here](https://telegram.me/GroupButler_ch/46).")
				api.sendMessage(msg.chat.id, message_text, true)
			end
		end
	end
	if blocks[1] == 'info' then
		local keyboard = do_keybaord_credits()
		local text = _("🕔 Bot version: `%s`\n🔗 *Some useful links*:"):format(config.version)
		if msg.cb then
			api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
		else
			api.sendKeyboard(msg.chat.id, text, keyboard, true)
		end
	end
	if blocks[1] == 'groups' then
		if config.help_groups and next(config.help_groups) then
			keyboard = {inline_keyboard = {}}
			for group, link in pairs(config.help_groups) do
				if link then
					local line = {{text = group, url = link}}
					table.insert(keyboard.inline_keyboard, line)
				end
			end
			if next(keyboard.inline_keyboard) then
				if msg.cb then
					api.editMessageText(msg.chat.id, msg.message_id, _("Select a group:"), keyboard, true)
				else
					api.sendKeyboard(msg.chat.id, _("Select a group:"), keyboard, true)
				end
			end
		end
	end
	if blocks[1] == 'resolve' then
		local id = misc.resolve_user(blocks[2], msg.chat.id)
		if not id then
			message = _("I've never seen this user before.\n"
				.. "If you want to teach me who is he, forward me a message from him")
		else
			message = '*'..id..'*'
		end
		api.sendMessage(msg.chat.id, message, true)
	end
end

return {
	action = action,
	triggers = {
		config.cmd..'(ping)$',
		config.cmd..'(strings)$',
		config.cmd..'(strings) (%a%a)$',
		config.cmd..'(echo) (.*)$',
		config.cmd..'(info)$',
		config.cmd..'(groups)$',
		config.cmd..'(resolve) (@[%w_]+)$',
		
		'^###cb:fromhelp:(info)$',
		'^###cb:private:(groups)$'
	}
}
