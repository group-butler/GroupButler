local function make_keyboard(mod, mod_current_position)
	local keyboard = {}
	keyboard.inline_keyboard = {}
	if mod then --extra options for the mod
	    local list = {
	        ['Banhammer'] = 'banhammer',
	        ['Group info'] = 'info',
	        ['Flood manager'] = 'flood',
	        ['Media settings'] = 'media',
	        ['Welcome settings'] = 'welcome',
	        ['General settings'] = 'settings',
	        ['Extra commands'] = 'extra',
	        ['Warns'] = 'warns',
	        ['Characters strictness'] = 'char',
	        ['Links'] = 'links',
	        ['Languages'] = 'lang'
        }
        local line = {}
        for k,v in pairs(list) do
            --if mod_current_position ~= v:gsub('!', '') then --(to remove the current tab button)
            if next(line) then
                local button = {text = '📍'..k, callback_data = v}
                --change emoji if it's the current position button
                if mod_current_position == v then button.text = '💡 '..k end
                table.insert(line, button)
                table.insert(keyboard.inline_keyboard, line)
                line = {}
            else
                local button = {text = '📍'..k, callback_data = v}
                --change emoji if it's the current position button
                if mod_current_position == v:gsub('!', '') then button.text = '💡 '..k end
                table.insert(line, button)
            end
            --end --(to remove the current tab button)
        end
        if next(line) then --if the numer of buttons is odd, then add the last button alone
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    local bottom_bar
    if mod then
		bottom_bar = {{text = '🔰 User commands', callback_data = 'user'}}
	else
	    bottom_bar = {{text = '🔰 Admin commands', callback_data = 'mod'}}
	end
	table.insert(bottom_bar, {text = 'Info', callback_data = 'fromhelp:info'}) --insert the "Info" button
	table.insert(keyboard.inline_keyboard, bottom_bar)
	return keyboard
end

local function do_keyboard_private()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = '👥 Add me to a group', url = 'https://telegram.me/'..bot.username..'?startgroup=new'},
    		{text = '📢 Bot channel', url = 'https://telegram.me/'..config.channel:gsub('@', '')},
	    },
	    {
	        {text = '📕 All the commands', callback_data = 'user'}
        }
    }
    return keyboard
end

local function do_keyboard_startme()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Start me', url = 'https://telegram.me/'..bot.username}
	    }
    }
    return keyboard
end

local action = function(msg, blocks)
    -- save stats
    if blocks[1] == 'start' then
        if msg.chat.type == 'private' then
            db:hincrby('bot:general', 'users', 1)
            local message = lang[msg.ln].help.private:compose(msg.from.first_name:mEscape())
            local keyboard = do_keyboard_private()
            api.sendKeyboard(msg.from.id, message, keyboard, true)
        end
        return
    end
    local keyboard = make_keyboard()
    if blocks[1] == 'help' then
        local res = api.sendKeyboard(msg.from.id, lang[msg.ln].help.initial, keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                if msg.chat.type ~= 'private' then
                    api.sendMessage(msg.chat.id, lang[msg.ln].help.group_success, true)
                end
            else
                api.sendKeyboard(msg.chat.id, lang[msg.ln].help.group_not_success, do_keyboard_startme(), true)
            end
        end
    end
    if msg.cb then
        local query = blocks[1]
        local text
        if query == 'info_button' then
            keyboard = do_keybaord_credits()
		    api.editMessageText(msg.chat.id, msg.message_id, lang[msg.ln].credits, keyboard, true)
		    return
		end
        local with_mods_lines = true
        if query == 'user' then
            text = lang[msg.ln].help.all
            with_mods_lines = false
        elseif query == 'mod' then
            text = lang[msg.ln].help.kb_header
        end
        if query == 'info' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'banhammer' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'flood' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'media' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'welcome' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'extra' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'warns' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'char' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'links' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'lang' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'settings' then
        	text = lang[msg.ln].help.mods[query]
        end
        keyboard = make_keyboard(with_mods_lines, query)
        local res, code = api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
        if not res and code and code == 111 then
            api.answerCallbackQuery(msg.cb_id, '❗️ Already on this tab')
        elseif query ~= 'user' and query ~= 'mod' and query ~= 'info_button' then
            api.answerCallbackQuery(msg.cb_id, '💡 '..lang[msg.ln].help.mods[query]:sub(1, string.find(lang[msg.ln].help.mods[query], '\n')):mEscape_hard())
        end
    end
end

return {
	action = action,
	admin_not_needed = true,
	triggers = {
	    config.cmd..'(start)$',
	    config.cmd..'(help)$',
	    '^###cb:(user)$',
	    '^###cb:(mod)$',
	    '^###cb:(info)$',
	    '^###cb:(banhammer)$',
	    '^###cb:(flood)$',
	    '^###cb:(media)$',
	    '^###cb:(links)$',
	    '^###cb:(lang)$',
	    '^###cb:(welcome)$',
	    '^###cb:(extra)$',
	    '^###cb:(warns)$',
	    '^###cb:(char)$',
	    '^###cb:(settings)$',
    }
}