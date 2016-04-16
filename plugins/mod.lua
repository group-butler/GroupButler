--groups = load_data('groups.json')

local triggers = {
	'^/(promote)$',
	'^/(demote)$',
	'^/(owner)$',
	'^/(modlist)$',
	'^/(modlist)@GroupButler_bot',
}

local action = function(msg, blocks, ln)
 
 --ignore if via pm
    if msg.chat.type == 'private' then
        local out = make_text(lang[ln].pv)
        api.sendMessage(msg.from.id, out)
    	return nil
    end
 
if blocks[1] == 'promote' then
    --only the owner can promote
    if not is_owner(msg) then
        local out = make_text(lang[ln].mod.not_owner)
        api.sendReply(msg, out, true)
    else
        --allert if is not a reply
        if not msg.reply_to_message then
            local out = make_text(lang[ln].mod.reply_promote)
            api.sendReply(msg, out)
			return nil
		end
	
		msg = msg.reply_to_message
        
        --ignore if replied to the bot
        if msg.from.id == bot.id then
	        return nil
	    end
	    
	    --ignore if is promoting itself
	    if is_owner(msg) then
	        return nil
	    end
        
        --check if it has a username. if not, save the name
        local jsoname = tostring(msg.from.first_name)
        if msg.from.username then
            jsoname = '@'..tostring(msg.from.username)
        end
        
        --save him as a moderator in redis
        local hash = 'bot:'..msg.chat.id..':mod'
        local user = tostring(msg.from.id)
        local val = client:hset(hash, user, jsoname)
        
        --warn and update the name if already a moderator
        if val == false then --don't know why, redis is returning boolean instead of intgers with hset
            local out = make_text(lang[ln].mod.already_mod, msg.from.first_name, msg.chat.title)
            api.sendReply(msg, out, true)
            return nil
        end
        
        mystat('promote') --save stats
        local out = make_text(lang[ln].mod.promoted, msg.from.first_name, msg.chat.title)
        api.sendReply(msg, out, true)
    end
end

if blocks[1] == 'demote' then
    --only the owner can promote or demote
    if not is_owner(msg) then
        local out = make_text(lang[ln].mod.not_owner)
        api.sendReply(msg, out, true)
    else
        --allert if is not a reply
        if not msg.reply_to_message then
            local out = make_text(lang[ln].mod.reply_demote)
            api.sendReply(msg, out, false)
			return nil
		end
	    
		msg = msg.reply_to_message
		
	    --ignore if is demoting itself
	    if is_owner(msg) then
	        return nil
	    end
	    
		--ignored if demoted the bot
        if msg.from.id == bot.id then
	        return nil
	    end
        
        --remove the moderator from redis
        local hash = 'bot:'..msg.chat.id..':mod'
        local user = tostring(msg.from.id)
        local val = client:hdel(hash, user)
        
        --ignore and warn if the user was not a moderator
        if val == 0 then
            local out = make_text(lang[ln].mod.not_mod, msg.from.first_name, msg.chat.title)
            api.sendReply(msg, out, true)
            return nil
        end
        
        mystat('demote') --save stats
        local out = make_text(lang[ln].mod.demoted, msg.from.first_name)
        api.sendReply(msg, out, true)
    end
end

if blocks[1] == 'owner' then
    --only the owner can change the owner
    if not is_owner(msg) then
        local out = make_text(lang[ln].mod.not_owner)
        api.sendReply(msg, out, true)
    else
        --allert if it's not a reply to someone and return nil
        if not msg.reply_to_message then
            local out = make_text(lang[ln].mod.reply_owner)
            api.sendReply(msg, out, false)
			return nil
		end
		
	    local old = msg.from.id --sender
		local msg = msg.reply_to_message --replied message
        
        --ignore if replied to the bot
        if msg.from.id == bot.id then
	        return nil
	    end
        
        --allert if the owner is promoting as owner itself
        if is_owner(msg) then
            local out = make_text(lang[ln].mod.already_owner)
            api.sendReply(msg, out, true)
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
        api.sendReply(msg, out, true)
    end
end

if blocks[1] == 'modlist' then
    --ignore if the command is locked and the user is not a moderator
    if is_locked(msg, 'Modlist') and not is_mod(msg) then
    	return nil
    end
    
    --retrive the moderators list
    local hash = 'bot:'..msg.chat.id..':mod'
    local mlist = client:hvals(hash) --the array can't be empty: there is always the owner in
    
    local message = ''

    --build the list
    for i=1, #mlist do
        message = message..i..' - '..mlist[i]..'\n'
    end
    mystat('modlist') --save stats
    --send the list
    local out = make_text(lang[ln].mod.modlist, msg.chat.title, message)
    api.sendReply(msg, out)
end

end

return {
	action = action,
	triggers = triggers
}