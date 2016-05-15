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
		{text = '🔰 Owner', callback_data = '!owner'},
	}
	table.insert(keyboard.inline_keyboard, bottom_bar)
	local info_button = {
	    {text = 'Info', callback_data = '!info_button'}
    }
    table.insert(keyboard.inline_keyboard, info_button)
	return keyboard
end

local action = function(msg, blocks, ln)
    -- save stats
    if blocks[1] == 'start' then
        if msg.chat.type == 'private' then
            local message = make_text(lang[ln].help.private, name)
            api.sendMessage(msg.from.id, message, true)
        end
        return
    end
    local keyboard = make_keyboard()
    if blocks[1] == 'help' then
        mystat('/help')
        if msg.chat.type == 'private' then
            local name = msg.from.first_name:mEscape()
            api.sendMessage(msg.chat.id, make_text(lang[ln].help.private, name), true)
            return
        end
        local res = api.sendKeyboard(msg.from.id, 'Choose the *role* to see the available commands:', keyboard, true)
        if res then
            api.sendMessage(msg.chat.id, lang[ln].help.group_success, true)
        else
            api.sendMessage(msg.chat.id, lang[ln].help.group_not_success, true)
        end
    end
    if msg.cb then
        local query = blocks[1]
        local msg_id = msg.message_id
        local text
        local with_mods_lines = true
        if query == 'user' then
            text = lang[ln].help.all
            with_mods_lines = false
        elseif query == 'mod' then
            text = lang[ln].help.kb_header
        elseif query == 'owner' then
            text = lang[ln].help.owner
            with_mods_lines = false
        elseif query == 'info_button' then
            text = lang[ln].credits
            with_mods_lines = false
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
        api.editMessageText(msg.chat.id, msg_id, text, keyboard, true)
    end
end

return {
	action = action,
	triggers = {
	    '^/(start)$',
	    '^/(help)$',
	    '^###cb:!(user)',
	    '^###cb:!(info_button)',
    	'^###cb:!(owner)',
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