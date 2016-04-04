
local triggers = {
	''
}

local action = function(msg)
	
	--vardump(msg)
	
	--if the bot join the chat
	if msg.new_chat_participant and msg.new_chat_participant.id == bot.id then
		
		print('\nBot added to '..msg.chat.title..' ['..msg.chat.id..']')
		
		local uname = ''
		
		--check if the owner has a username, and save it. If not, use the name
		local jsoname = msg.from.first_name
		if msg.from.username then
			jsoname = '@'..tostring(msg.from.username)
		end
		
		--save group data in the json
		groups = load_data('groups.json')
		groups[tostring(msg.chat.id)] = {
			--owner = tostring(msg.from.id),
			--mods = {},
			rules = nil,
			about = nil,
			flag_blocked = {},
			--settings = {
				--s_rules = 'no',
				--s_about = 'no',
				--s_welcome = 'no',
				--s_modlist = 'no',
				--s_flag = 'yes',
				--welcome = 'no'},
		}
		
		save_data('groups.json', groups)
		
		--add owner as moderator
		--groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
		local hash = 'bot:'..msg.chat.id..':mod'
        local user = tostring(msg.from.id)
        client:hset(hash, user, jsoname)
        
        --add owner as owner
        hash = 'bot:'..msg.chat.id..':owner'
        client:hset(hash, user, jsoname)
		
		--default settings
		hash = 'chat:'..msg.chat.id..':settings'
		client:hset(hash, 'Rules', 'no')
		client:hset(hash, 'About', 'no')
		client:hset(hash, 'Modlist', 'no')
		client:hset(hash, 'Flag', 'yes')
		client:hset(hash, 'Welcome', 'no')
		client:set('warns:'..msg.chat.id..':max', 5)
		hash = 'chat:'..msg.chat.id..':welcome' --set the default welcome type
		client:hset(hash, 'wel', 'no')
		
		--save stats
		hash = 'bot:general'
        local num = client:hincrby(hash, 'groups', 1)
        print('Stats saved', 'Groups: '..num)
		sendMessage(msg.chat.id, 'Hi all!\n*'..msg.from.first_name..'* added me here to help you to manage this group.\nIf you want to know how I work, please start me in private or type /help  :)', true, false, true)
		return
	end
	
	--if someone join the chat
	if msg.new_chat_participant then
		
		print('\nUser '..msg.new_chat_participant.first_name..' ['..msg.new_chat_participant.id..'] added to '..msg.chat.title..' ['..msg.chat.id..']')
		
		--basic text
		text = 'Hi '..msg.new_chat_participant.first_name..', and welcome to *'..msg.chat.title..'*!'
		
		--ignore if welcome is locked
		if is_locked(msg, 'Welcome') then
			print('\27[31mNil: welcome diabled\27[39m')
			return nil
		end
		
		groups = load_data('groups.json')
		
		--retrive welcome settings
		local hash = 'chat:'..msg.chat.id..':welcome'
		local wlc_sett = client:hget(hash, 'wel')
		
		local abt = groups[tostring(msg.chat.id)]['about']
		local rls = groups[tostring(msg.chat.id)]['rules']
		local mods
		
		--check if the group has a decription
		if not abt then
            abt = 'No description for this group.'
        end
		
		--check if the group has rules
		if not rls then
            rls = 'Total anarchy!'
        end		
		
		--build the modlist
		-----------------JSON--------------------
		--if next(groups[tostring(msg.chat.id)]['mods']) == nil then
        	--mods = '\n\nThere are *no moderators* in this group.'
        	--sendMessage(msg.chat.id, 'No mods here')
    	--else
    		--local i = 1
    		--mods = '\n\n*Moderators list*:\n'
    		--for k,v in pairs(groups[tostring(msg.chat.id)]['mods']) do
        		--mods = mods..'*'..i..'* - @'..v..' (id: ' ..k.. ')\n'
        		--i = i + 1
    		--end
		--end
		------------------------JSON---------------------
		
		--build the modlist
		local hash = 'bot:'..msg.chat.id..':mod'
    	local mlist = client:hvals(hash) --the array can't be empty: there is always the owner in
    	local mods = '\n\n*Moderators list*:\n'
    	for i=1, #mlist do
        	mods = mods..'*'..i..'* - '..mlist[i]..'\n'
    	end
		
		--read welcome settings and build the message
		if wlc_sett == 'a' then
			text = text..'\n\n*Description*:\n'..abt
		elseif wlc_sett == 'r' then
			text = text..'\n\n*Rules*:\n'..rls
		elseif wlc_sett == 'm' then
			text = text..mods
		elseif wlc_sett == 'ra' then
			text = text..'\n\n*Description*:\n'..abt..'\n\n*Rules*:\n'..rls
    elseif wlc_sett == 'am' then
			text = text..'\n\n*Description*:\n'..abt..mods
    elseif wlc_sett == 'rm' then
			text = text..'\n\n*Rules*:\n'..rls..mods
		elseif wlc_sett == 'ram' then
			text = text..'\n\n*Description*:\n'..abt..'\n\n*Rules*:\n'..rls..mods
		end
		
		sendMessage(msg.chat.id, text, true, false, true)
	end
	
	--if the bot is removed from the chat
	if msg.left_chat_participant and msg.left_chat_participant.id == bot.id then
		
		print('\nBot left '..msg.chat.title..' ['..msg.chat.id..']')
		
		--clean the modlist and the owner. If the bot is added again, the owner will be who added the bot and the modlist will be empty (except for the new owner)
		clean_owner_modlist(msg.chat.id)
		
		--save stats
		local hash = 'bot:general'
        local num = client:hincrby(hash, 'groups', -1)
        print('Stats saved', 'Groups: '..num)
		sendMessage(msg.from.id, '*'..msg.chat.title..'* datas have been flushed.\nThanks for having used me!\nI\'m always here if you need an hand ;)', true, false, true)
	end
	
	return true

end

return {
	action = action,
	triggers = triggers
}
