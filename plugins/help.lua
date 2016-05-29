local function make_keyboard(mod)
	local keyboard = {}
	keyboard.inline_keyboard = {}
	if mod then --extra options for the mod
	    local list = {
	        ['Banhammer'] = '!banhammer',
	        ['Group info'] = '!info',
	        ['Flood manager'] = '!flood',
	        ['Media settings'] = '!media',
	        ['Welcome settings'] = '!welcome',
	        ['General settings'] = '!settings',
	        ['Extra commands'] = '!extra',
	        ['Warns'] = '!warns',
	        ['Characters strictness'] = '!char',
	        ['Links'] = '!links',
	        ['Languages'] = '!lang'
        }
        local line = {}
        for k,v in pairs(list) do
            if next(line) then
                local button = {text = '📍'..k, callback_data = v}
                table.insert(line, button)
                table.insert(keyboard.inline_keyboard, line)
                line = {}
            else
                local button = {text = '📍'..k, callback_data = v}
                table.insert(line, button)
            end
        end
        if next(line) then --if the numer of buttons is odd, then add the last button alone
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    local bottom_bar = {
		{text = '🔰 User', callback_data = '!user'},
		{text = '🔰 Admin', callback_data = '!mod'},
	}
	table.insert(keyboard.inline_keyboard, bottom_bar)
	local info_button = {
	    {text = 'Info', callback_data = '!info_button'}
    }
    table.insert(keyboard.inline_keyboard, info_button)
	return keyboard
end

local function do_keybaord_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Channel', url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = 'GitHub', url = 'https://github.com/RememberTheAir/GroupButler'},
    		{text = 'Rate me!', url = 'https://telegram.me/storebot?start='..bot.username},
		},
		{
		    {text = '🔙', callback_data = '!user'}
        }
	}
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
	        {text = '📕 All the commands', callback_data = '!user'}
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

local action = function(msg, blocks, ln)
    -- save stats
    if blocks[1] == 'start' then
        db:hset('bot:users', msg.from.id, 'xx')
        db:hincrby('bot:general', 'users', 1)
        if msg.chat.type == 'private' then
            local message = make_text(lang[ln].help.private, msg.from.first_name:mEscape())
            local keyboard = do_keyboard_private()
            api.sendKeyboard(msg.from.id, message, keyboard, true)
        end
        return
    end
    local keyboard = make_keyboard()
    if blocks[1] == 'help' then
        mystat('/help')
        if msg.chat.type == 'private' then
            local message = make_text(lang[ln].help.private, msg.from.first_name:mEscape())
            local keyboard = do_keyboard_private()
            api.sendKeyboard(msg.from.id, message, keyboard, true)
            return
        end
        local res = api.sendKeyboard(msg.from.id, 'Choose the *role* to see the available commands:', keyboard, true)
        if res then
            api.sendMessage(msg.chat.id, lang[ln].help.group_success, true)
        else
            api.sendKeyboard(msg.chat.id, lang[ln].help.group_not_success, do_keyboard_startme(), true)
        end
    end
    if msg.cb then
        local query = blocks[1]
        local msg_id = msg.message_id
        local text
        if query == 'info_button' then
            keyboard = do_keybaord_credits()
		    api.editMessageText(msg.chat.id, msg_id, lang[ln].credits, keyboard, true)
		    return
		end
        local with_mods_lines = true
        if query == 'user' then
            text = lang[ln].help.all
            with_mods_lines = false
        elseif query == 'mod' then
            text = lang[ln].help.kb_header
        end
        if query == 'info' then
        	text = lang[ln].help.mods[query]
        elseif query == 'banhammer' then
        	text = lang[ln].help.mods[query]
        elseif query == 'flood' then
        	text = lang[ln].help.mods[query]
        elseif query == 'media' then
        	text = lang[ln].help.mods[query]
        elseif query == 'welcome' then
        	text = lang[ln].help.mods[query]
        elseif query == 'extra' then
        	text = lang[ln].help.mods[query]
        elseif query == 'warns' then
        	text = lang[ln].help.mods[query]
        elseif query == 'char' then
        	text = lang[ln].help.mods[query]
        elseif query == 'links' then
        	text = lang[ln].help.mods[query]
        elseif query == 'lang' then
        	text = lang[ln].help.mods[query]
        elseif query == 'settings' then
        	text = lang[ln].help.mods[query]
        end
        keyboard = make_keyboard(with_mods_lines)
        local res, code = api.editMessageText(msg.chat.id, msg_id, text, keyboard, true)
        if not res and code and code == 111 then
            api.answerCallbackQuery(msg.cb_id, '📍 Already on this tab')
        end
    end
end

return {
	action = action,
	admin_not_needed = true,
	triggers = {
	    '^/(start)$',
	    '^/(help)$',
	    '^###cb:!(user)',
	    '^###cb:!(info_button)',
	    '^###cb:!(mod)',
	    '^###cb:!(info)',
	    '^###cb:!(banhammer)',
	    '^###cb:!(flood)',
	    '^###cb:!(media)',
	    '^###cb:!(links)',
	    '^###cb:!(lang)',
	    '^###cb:!(welcome)',
	    '^###cb:!(extra)',
	    '^###cb:!(warns)',
	    '^###cb:!(char)',
	    '^###cb:!(settings)',
    }
}