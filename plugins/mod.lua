--groups = load_data('groups.json')

local triggers = {
	'^/(promote)$',
	'^/(demote)$',
	'^/(owner)$',
	'^/(modlist)$'
}

local action = function(msg, blocks, ln)
 
 --ignore if via pm
    if msg.chat.type == 'private' then
        print('PV mod.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        local out = make_text(lang[ln].pv)
        sendMessage(msg.from.id, out)
    	return nil
    end
 
if blocks[1] == 'promote' then
    
    print('\n/promote', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --only the owner can promote
    if not is_owner(msg) then
        print('\27[31mNil: the user is not the owner\27[39m')
        local out = make_text(lang[ln].mod.not_owner)
        sendReply(msg, out, true)
    else
        --allert if is not a reply
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            local out = make_text(lang[ln].mod.reply_promote)
            sendReply(msg, out)
			return nil
		end
	
		msg = msg.reply_to_message
        
        --ignore if replied to the bot
        if msg.from.id == bot.id then
            print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
	    
	    --ignore if is promoting itself
	    if is_owner(msg) then
	        print('\27[31mNil: an owner can\'t promote itself\27[39m')
	        return nil
	    end
	    
	    -------------------------------JSON-----------------------------------
	    --ignore if already moderator
        --if groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
            --print('\27[31mNil: already a mod\27[39m')
            --sendReply(msg, '*'..msg.from.first_name..'* is already a moderator of *'..msg.chat.title..'*', true)
            --return nil
        --end
        ---------------------------------JSON-------------------------
        
        --check if it has a username. if not, save the name
        local jsoname = tostring(msg.from.first_name)
        if msg.from.username then
            jsoname = '@'..tostring(msg.from.username)
        end
        
        --------------------JSON----------------------------
        --save the moderator in the json
        --groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
        --save_data('groups.json', groups)
        ------------------JSON--------------------------
        
        --save him as a moderator in redis
        local hash = 'bot:'..msg.chat.id..':mod'
        local user = tostring(msg.from.id)
        local val = client:hset(hash, user, jsoname)
        
        --warn and update the name if already a moderator
        if val == false then --don't know why, redis is returning boolean instead of intgers with hset
            print('\27[31mNil: already a mod\27[39m')
            local out = make_text(lang[ln].mod.already_mod, msg.from.first_name, msg.chat.title)
            sendReply(msg, out, true)
            return nil
        end
        
        mystat('promote') --save stats
        local out = make_text(lang[ln].mod.promoted, msg.from.first_name, msg.chat.title)
        sendReply(msg, out, true)
    end
end

if blocks[1] == 'demote' then
    
    print('\n/demote', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --only the owner can promote or demote
    if not is_owner(msg) then
        print('\27[31mNil: the user is not the owner\27[39m')
        local out = make_text(lang[ln].mod.not_owner)
        sendReply(msg, out, true)
    else
        --allert if is not a reply
        if not msg.reply_to_message then
            print('\27[31mNil: no reply\27[39m')
            local out = make_text(lang[ln].mod.reply_demote)
            sendReply(msg, out, false)
			return nil
		end
	    
		msg = msg.reply_to_message
		
	    --ignore if is demoting itself
	    if is_owner(msg) then
	        print('\27[31mNil: an owner can\'t demote itself\27[39m')
	        return nil
	    end
	    
		--ignored if demoted the bot
        if msg.from.id == bot.id then
            print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
	    
	    -----------------------------------JSON----------------------
	    --allert if the replied users was not a moderator, and then ignore
        --if not is_mod(msg) then
            --print('\27[31mNil: user was not a moderator\27[39m')
            --sendReply(msg, '*'..msg.from.first_name..'* is not a moderator of *'..msg.chat.title..'*', true)
            --return nil
        --end
        --OLD ALLERT
        --if not groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
            --print('\27[31mNil: user was not a moderator\27[39m')
            --sendReply(msg, '*'..msg.from.first_name..'* is not a moderator of *'..msg.chat.title..'*', true)
            --return nil
        --end
        
        --remove the moderator
        --groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = nil
        --save_data('groups.json', groups)
        -------------------------------JSON-----------------------------
        
        --remove the moderator from redis
        local hash = 'bot:'..msg.chat.id..':mod'
        local user = tostring(msg.from.id)
        local val = client:hdel(hash, user)
        
        --ignore and warn if the user was not a moderator
        if val == 0 then
            print('\27[31mNil: user was not a moderator\27[39m')
            local out = make_text(lang[ln].mod.not_mod, msg.from.first_name, msg.chat.title)
            sendReply(msg, out, true)
            return nil
        end
        
        mystat('demote') --save stats
        local out = make_text(lang[ln].mod.demoted, msg.from.first_name)
        sendReply(msg, out, true)
    end
end

if blocks[1] == 'owner' then
    
    print('\n/owner', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --only the owner can change the owner
    if not is_owner(msg) then
        print('\27[31mNil: not the owner\27[39m')
        local out = make_text(lang[ln].mod.not_owner)
        sendReply(msg, out, true)
    else
        --allert if it's not a reply to someone and return nil
        if not msg.reply_to_message then
            print('\27[31mNil: not a reply\27[39m')
            local out = make_text(lang[ln].mod.reply_owner)
            sendReply(msg, out, false)
			return nil
		end
		
	    local old = msg.from.id --sender
		local msg = msg.reply_to_message --replied message
        
        --ignore if replied to the bot
        if msg.from.id == bot.id then
            print('\27[31mNil: bot replied\27[39m')
	        return nil
	    end
        
        -----------------------JSON------------------
        --allert if the owner is promoting as owner itself
        --if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
            --print('\27[31mNil: promoting as owner itself\27[39m')
            --sendReply(msg, '*'..msg.from.first_name..'* is already the owner of *'..msg.chat.title..'*', true)
            --return nil
        --end
        -----------------------JSON-----------------------
        
        --allert if the owner is promoting as owner itself
        if is_owner(msg) then
            print('\27[31mNil: promoting as owner itself\27[39m')
            local out = make_text(lang[ln].mod.already_owner)
            sendReply(msg, out, true)
            return nil
        end
        
        --check if the new owner has a username. If not, save the name
        local jsoname = tostring(msg.from.first_name)
        if msg.from.username then
            jsoname = '@'..tostring(msg.from.username)
        end
        
        --remove old owner from owner hash and add the new one
        --groups[tostring(msg.chat.id)]['mods'][tostring(old)] = nil
        local hash = 'bot:'..msg.chat.id..':owner'
	    local owner_list = client:hkeys(hash) --get the current owner list (of only one item)
	    local owner = owner_list[1] --get the current owner id
	    client:hdel(hash, owner)
	    local new_owner = tostring(msg.from.id)
	    client:hset(hash, new_owner, jsoname) --add the new owner
	    
	    --remove the old owner from moderators list and add the new one
	    hash = 'bot:'..msg.chat.id..':mod'
	    client:hdel(hash, owner)
	    client:hset(hash, new_owner, jsoname)
        
        --------------------------JSON-------------------
        --add the new one to moderators list
        --groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] = jsoname
        
        --save the owner id
        --groups[tostring(msg.chat.id)]['owner'] = tostring(msg.from.id)
        --save_data('groups.json', groups)
        ---------------------------JSON--------------------------------
        
        mystat('owner') --save stats
        local out = make_text(lang[ln].mod.new_owner, msg.from.first_name)
        sendReply(msg, out, true)
    end
end

if blocks[1] == 'modlist' then
    
    print('\n/modlist', msg.from.first_name..' ['..msg.from.id..'] --> '..msg.chat.title..' ['..msg.chat.id..']')
    
    --ignore if the command is locked and the user is not a moderator
    if is_locked(msg, 'Modlist') and not is_mod(msg) then
        print('\27[31mNil: action locked\27[39m')
    	return nil
    end
    
    -----------------------------JSON----------------------
    --check if the moderator list is empty. If it is, return a mesage
    --if next(groups[tostring(msg.chat.id)]['mods']) == nil then
        --print('\27[31mNil: no moderators\27[39m')
        --sendReply(msg, '*No moderators* in this group.', true)
        --return nil
    --end
    
    --build the moderator list
    --local i = 1
    --local message = '\nModerators list of *'..msg.chat.title..'*:\n'
    --for k,v in pairs(groups[tostring(msg.chat.id)]['mods']) do
        --message = message..'*'..i..'* - '..v..' (id: ' ..k.. ')\n'
        --i = i + 1
    --end
    -------------------------JSON-----------------------
    
    --retrive the moderators list
    local hash = 'bot:'..msg.chat.id..':mod'
    local mlist = client:hvals(hash) --the array can't be empty: there is always the owner in
    
    local message = ''

    --build the list
    for i=1, #mlist do
		--print(mlist[i])
        message = message..i..' - '..mlist[i]..'\n'
    end 
    --message = message..'end'
    mystat('modlist') --save stats
    --send the list
	--print(message)
	 --ignore if via pm
    local out = make_text(lang[ln].mod.modlist, msg.chat.title, message)
    sendReply(msg, out)
end

end

return {
	action = action,
	triggers = triggers
}