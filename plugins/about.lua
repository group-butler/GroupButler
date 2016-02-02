local command = 'about'
local doc = '`Returns information about the bot.`'

local triggers = {
	''
}

local action = function(msg)


	if msg.new_chat_participant and msg.new_chat_participant.id == bot.id then
		--sendMessage(msg.chat.id, msg.new_chat_participant.id)
		mystat('gps')
		local uname = ''
		--asks to set up a username if the owner doesn't have it
		local jsoname = msg.from.first_name
		if msg.from.username then
			jsoname = '@'..tostring(msg.from.username)
		end
		groups = load_data('groups.json')
		groups[tostring(msg.chat.id)] = {
			owner = tostring(msg.from.id),
			mods = {},
			rules = nil,
			about = nil,
			flag_blocked = {},
			settings = {
				s_rules = 'no',
				s_about = 'no',
				s_welcome = 'no',
				s_modlist = 'no',
				s_flag = 'no',
				welcome = 'no'},
		}
		--add owner as moderator
		groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
		save_data('groups.json', groups)
		sendMessage(msg.chat.id, 'Hi all!\n*'..msg.from.first_name..'* added me here to help you to manage this group.\nIf you want to know how I work, please start me in private or type /help  :)', true, false, true)
		return
	end
	
	if msg.new_chat_participant then
		text = 'Hi '..msg.new_chat_participant.first_name..', and welcome to *'..msg.chat.title..'*!'
		groups = load_data('groups.json')
		if groups[tostring(msg.chat.id)]['settings']['s_welcome'] == 'yes' then
			return nil
		end
		local wlc_sett = groups[tostring(msg.chat.id)]['settings']['welcome']
		
		local abt = groups[tostring(msg.chat.id)]['about']
		local rls = groups[tostring(msg.chat.id)]['rules']
		local mods
		if not abt then
            abt = 'No description for this group.'
        end
		if not rls then
            rls = 'Total anarchy for this group.'
        end		
		--Make the modlist
		if next(groups[tostring(msg.chat.id)]['mods']) == nil then
        	mods = '\n\nThere are *no moderators* in this group.'
        	sendMessage(msg.chat.id, 'No mods here')
    	else
    		local i = 1
    		mods = '\n\n*Moderators list*:\n'
    		for k,v in pairs(groups[tostring(msg.chat.id)]['mods']) do
        		mods = mods..'*'..i..'* - @'..v..' (id: ' ..k.. ')\n'
        		i = i + 1
    		end
		end
		
		if wlc_sett == 'a' then
			text = text..'\n\n*Description*:\n'..abt
		elseif wlc_sett == 'r' then
			text = text..'\n\n*Rules*:\n'..rls
		elseif wlc_sett == 'm' then
			text = text..mods
		elseif wlc_sett == 'ra' then
			text = text..'\n\n*Rules*:\n'..rls..'\n\n*Description*:\n'..abt
		elseif wlc_sett == 'ram' then
			text = text..'\n\n*Rules*:\n'..rls..'\n\n*Description*:\n'..abt..mods
		end
		sendMessage(msg.chat.id, text, true, false, true)
	end
	
	if msg.left_chat_participant and msg.left_chat_participant.id == bot.id then
		mystat('rem')
		sendMessage(msg.from.id, '*'..msg.chat.title..'* datas have been flushed.\nThanks for having used me!\nI\'m always here if you need an hand ;)', true, false, true)
	end
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
