local function do_keybaord_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Channel', url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = 'GitHub', url = 'https://github.com/RememberTheAir/GroupButler'},
    		{text = 'Rate me!', url = 'https://telegram.me/storebot?start='..bot.username},
		},
		{
			{text = '👥 Groups', callback_data = 'private:groups'}
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
				api.sendReply(msg, lang[msg.ln].setlang.error, true)
			end
		end
	end
	if blocks[1] == 'echo' then
		local res, code = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, lang[msg.ln].bonus.too_long)
			else
				api.sendMessage(msg.chat.id, lang[msg.ln].breaks_markdown, true)
			end
		end
	end
	if blocks[1] == 'info' then
		local keyboard = do_keybaord_credits()
		local text = '🕔 Bot version: `'..config.version..'`\n🔗 '..lang[msg.ln].credits, keyboard
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
					api.editMessageText(msg.chat.id, msg.message_id, 'Select a group:', keyboard, true)
				else
					api.sendKeyboard(msg.chat.id, 'Select a group:', keyboard, true)
				end
			end
		end
	end
	if blocks[1] == 'resolve' then
		local id = misc.res_user_group(blocks[2], msg.chat.id)
		if not id then
			message = lang[msg.ln].bonus.no_user
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