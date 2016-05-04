local included_fields = {
    'settings',
    'about',
    'rules',
    'mod',
    'extra'
}

local function doKeyboard(action, chat_id)
    keyboard = {}
    if action == 'dashboard' or action == 'dash' then
        keyboard.inline_keyboard = {
	        {
		        {text = "Settings", callback_data = 'dashsettings//'..chat_id},
		    },
	        {
		        {text = "Rules", callback_data = 'dashrules//'..chat_id},
		        {text = "About", callback_data = 'dashabout//'..chat_id}
    	    },
	   	    {
	   	        {text = "Moderators", callback_data = 'dashmodlist//'..chat_id},
	   	        {text = "Extra commands", callback_data = 'dashextra//'..chat_id}
	        }
        }
    end
    if action == 'menu' or action == 'panel' then
        local settings = client:hgetall('chat:'..chat_id..':settings')
        keyboard.inline_keyboard = {}
        for key,val in pairs(settings) do
            if val == 'yes' then val = '🔐' end
            if val == 'no' then val = '🔓' end
            local current = {
                {text = key, callback_data = 'panelalert//'},
                {text = val, callback_data = 'panel'..key..'//'..chat_id}
            }
            table.insert(keyboard.inline_keyboard, current)
        end
        local hash = 'chat:'..chat_id..':flood'
        local action = client:hget(hash, 'ActionFlood')
        --if not action then
            --action = 'kick'
            --client:hset(hash, 'ActionFlood', 'kick')
        --end
        local num = client:hget(hash, 'MaxFlood')
        local flood = {
            {text = '➖', callback_data = 'panelDimFlood//'..chat_id},
            {text = '📍'..num..' ⚡️'..action, callback_data = 'panelActionFlood//'..chat_id},
            {text = '➕', callback_data = 'panelRaiseFlood//'..chat_id},
        }
        table.insert(keyboard.inline_keyboard, flood)
    end
    
    return keyboard
end

local action = function(msg, blocks, ln)
    print('Text', msg.text)
    --get the interested chat id
    local chat_id
    if msg.cb then
        chat_id = msg.data:gsub('%a+//', '')
    else
        chat_id = msg.chat.id
    end
    
    local keyboard = {}
    
    --reply from the group
    if not(msg.chat.type == 'private') and not msg.cb then
        keyboard = doKeyboard(blocks[1], chat_id)
        if blocks[1] == 'dashboard' then
            --everyone can use this
            api.sendMessage(msg.chat.id, lang[ln].all.dashboard, true)
	        api.sendKeyboard(msg.from.id, lang[ln].all.dashboard_first, keyboard, true)
	        return
        end
        if blocks[1] == 'menu' then
            if not is_mod(msg) then return end --only mods can use this
            api.sendMessage(msg.chat.id, lang[ln].all.menu, true)
	        api.sendKeyboard(msg.from.id, lang[ln].all.menu_first, keyboard, true)
	        return
        end
    end
    
    --callback reply
    if msg.cb then
        local msg_id = msg.message_id
        local text
        if blocks[1] == 'dash' then
            keyboard = doKeyboard(blocks[1], chat_id)
            if blocks[2] == 'settings' then
                text = cross.getSettings(chat_id, ln)
            end
            if blocks[2] == 'rules' then
                text = cross.getRules(chat_id, ln)
            end
            if blocks[2] == 'about' then
                text = cross.getAbout(chat_id, ln)
            end
            if blocks[2] == 'modlist' then
                text = cross.getModlist(chat_id):mEscape()
                text = make_text(lang[ln].bonus.mods_list, text)
            end
            if blocks[2] == 'extra' then
                text = cross.getExtraList(chat_id, ln)
            end
            api.editMessageText(msg.chat.id, msg_id, text, keyboard, true)
        end
        if blocks[1] == 'panel' then
            if blocks[2] == 'alert' then
                api.answerCallbackQuery(msg.cb_id, 'Tap on a lock!')
                return
            end
            keyboard = doKeyboard(blocks[1], chat_id)
            if blocks[2] == 'DimFlood' or blocks[2] == 'RaiseFlood' or blocks[2] == 'ActionFlood' then
                local action
                if blocks[2] == 'DimFlood' then
                    action = -1
                elseif blocks[2] == 'RaiseFlood' then
                    action = 1
                elseif blocks[2] == 'ActionFlood' then
                    action = (client:hget('chat:'..chat_id..':flood', 'ActionFlood')) or 'kick'
                end
                text = cross.changeFloodSettings(chat_id, action, ln)
            else
                text = cross.changeSettingStatus(chat_id, blocks[2], ln)
            end
            keyboard = doKeyboard(blocks[1], chat_id) --have to be updated with the new status of the settings
            api.editMessageText(msg.chat.id, msg_id, text, keyboard, true)
        end
    end
	
end

return {
	action = action,
	triggers = {
		'^/(dashboard)$',
		'^/(dasboard)@'..bot.username..'$',
		'^/(menu)$',
		'^/(menu)@'..bot.username..'$',
		'^###cb:(dash)(settings)//',
    	'^###cb:(dash)(rules)//',
	    '^###cb:(dash)(about)//',
	    '^###cb:(dash)(modlist)//',
	    '^###cb:(dash)(extra)//',
    	'^###cb:(panel)(alert)//',
    	'^###cb:(panel)(Rules)//',
    	'^###cb:(panel)(About)//',
    	'^###cb:(panel)(Modlist)//',
    	'^###cb:(panel)(Rtl)//',
    	'^###cb:(panel)(Arab)//',
    	'^###cb:(panel)(Report)//',
    	'^###cb:(panel)(Welcome)//',
    	'^###cb:(panel)(Extra)//',
    	'^###cb:(panel)(Flood)//',
    	'^###cb:(panel)(DimFlood)//',
    	'^###cb:(panel)(RaiseFlood)//',
    	'^###cb:(panel)(ActionFlood)//',
	}
}