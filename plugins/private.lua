local plugin = {}

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

local function doKeyboard_strings()
	local keyboard = {
		inline_keyboard = {}
	}
	for lang, flag in pairs(config.available_languages) do
		local line = {{text = flag, callback_data = 'sendpo:'..lang}}
		table.insert(keyboard.inline_keyboard, line)
	end
	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type ~= 'private' then return end
	
	if blocks[1] == 'ping' then
		local res = api.sendMessage(msg.from.id, 'Pong!', true)
		--[[if res then
			api.editMessageText(msg.chat.id, res.result.message_id, 'Response time: '..(os.clock() - clocktime_last_update))
		end]]
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
	if blocks[1] == 'strings' then
		local keyboard = doKeyboard_strings()
		api.sendMessage(msg.chat.id, _("*Choose your language:*"), true, keyboard)
	end
	if blocks[1] == 'about' then
		local keyboard = do_keybaord_credits()
		local text = 'This bot is based on [otouto](https://github.com/topkecleon/otouto) (AKA @mokubot, channel: @otouto), a multipurpose Lua bot.\nGroup Butler wouldn\'t exist without it.\n\nThe owner of this bot is @bac0nnn, do not pm him: use /groups command instead.\n\n*Some useful links*:'
		api.sendMessage(msg.chat.id, text, true, keyboard)
	end
	if blocks[1] == 'groups' then
		if config.help_groups and next(config.help_groups) then
			local keyboard = {inline_keyboard = {}}
			for group, link in pairs(config.help_groups) do
				if link then
					local line = {{text = group, url = link}}
					table.insert(keyboard.inline_keyboard, line)
				end
			end
			if next(keyboard.inline_keyboard) then
				api.sendMessage(msg.chat.id, _("Select a group:"), true, keyboard)
			end
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'about' then
		local keyboard = do_keybaord_credits()
		local text = 'This bot is based on [otouto](https://github.com/topkecleon/otouto) (AKA @mokubot, channel: @otouto), a multipurpose Lua bot.\nGroup Butler wouldn\'t exist without it.\n\nThe owner of this bot is @bac0nnn, do not pm him: use /groups command instead.\n\n*Some useful links*:'
		api.editMessageText(msg.chat.id, msg.message_id, text, true, keyboard)
	end
	if blocks[1] == 'groups' then
		if config.help_groups and next(config.help_groups) then
			local keyboard = {inline_keyboard = {}}
			for group, link in pairs(config.help_groups) do
				if link then
					local line = {{text = group, url = link}}
					table.insert(keyboard.inline_keyboard, line)
				end
			end
			if next(keyboard.inline_keyboard) then
				api.editMessageText(msg.chat.id, msg.message_id, _("Select a group:"), true, keyboard)
			end
		end
	end
	if blocks[1] == 'sendpo' then
		local lang = blocks[2]
		local instr_url = 'telegram.me/groupbutler_ch'
		local path = 'locales/'..lang..'.po'
		local button = {inline_keyboard = {{{text = _("Instructions"), url = instr_url}}}}
		api.editMessageText(msg.chat.id, msg.message_id, _("Sending `%s.po` file..."):format(lang), true, button)
		api.sendDocument(msg.chat.id, path)
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(ping)$',
		config.cmd..'(strings)$',
		config.cmd..'(strings) (%a%a)$',
		config.cmd..'(echo) (.*)$',
		config.cmd..'(about)$',
		config.cmd..'(groups)$',
		'^/start (groups)$'
	},
	onCallbackQuery = {
		'^###cb:fromhelp:(about)$',
		'^###cb:private:(groups)$',
		'^###cb:(sendpo):(.*)$'
	}
}

return plugin