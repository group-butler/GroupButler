local function promote(chat_id, user_id, name)
    local hash = 'chat:'..chat_id..':mod'
    local res = db:hset(hash, user_id, name)
    return res   
end

local function demote(chat_id, user_id)
    local hash = 'chat:'..chat_id..':mod'
    local res = db:hdel(hash, user_id)
    return res 
end

local function can_prom_dem(msg, blocks, ln)
    if not is_owner(msg) then
        return false, lang[ln].mod.not_owner
    else
        local id
        if blocks[2] then
            id = res_user(blocks[2])
            if not id  then
                return false, lang[ln].bonus.no_user
            end
        else
            if not msg.reply then
                return false, lang[ln].bonus.reply
            end
            id = msg.reply.from.id
        end
        if tonumber(id) == tonumber(bot.id) then
            return false
        else
            return true, id
        end
    end
end

local action = function(msg, blocks, ln)
 
    --ignore if via pm
    if msg.chat.type == 'private' then
        api.sendMessage(msg.from.id, lang[ln].pv)
    	return
    end
 
    if blocks[1] == 'promote' or blocks[1] == 'demote' then
        
        local allowed, res = can_prom_dem(msg, blocks, ln)
        
        if not allowed then
            if res then
                api.sendReply(msg, res, true)
            end
            return
        end
        
        local id = res
        local name
        if blocks[2] then
            name = blocks[2]
        else
            name = getname(msg.reply)
        end
        
        local val  
        if blocks[1] == 'promote' then
            mystat('/promote')
            val = promote(msg.chat.id, id, name)
        elseif blocks[1] == 'demote' then
            mystat('/demote')
            val = demote(msg.chat.id, id)
        end
        print(val)    
        --warn and update the name if already a moderator
        if val == false then --don't know why, redis is returning boolean instead of intgers with hset
            if blocks[1] == 'promote' then
                out = make_text(lang[ln].mod.already_mod, name:mEscape(), msg.chat.title:mEscape_hard())
            elseif blocks[1] == 'demote' then
                out = make_text(lang[ln].mod.not_mod, name:mEscape(), msg.chat.title:mEscape_hard())
            end
            api.sendReply(msg, out, true)
            return
        end
        
        local out = make_text(lang[ln].mod[blocks[1]..'d'], name:mEscape_hard(), msg.chat.title:mEscape_hard())
        api.sendReply(msg, out, true)
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
            local jsoname = getname(msg)
        
            --remove old owner from owner hash and add the new one
            local hash = 'chat:'..msg.chat.id..':owner'
	        local owner_list = db:hkeys(hash) --get the current owner list (of only one item)
	        local owner = owner_list[1] --get the current owner id
	        db:hdel(hash, owner)
	        local new_owner = tostring(msg.from.id)
	        db:hset(hash, new_owner, jsoname) --add the new owner
	    
	        --remove the old owner from moderators list and add the new one
	        hash = 'chat:'..msg.chat.id..':mod'
	        db:hdel(hash, owner)
	        db:hset(hash, new_owner, jsoname)
        
            local out = make_text(lang[ln].mod.new_owner, msg.from.first_name, msg.chat.title:mEscape())
            api.sendReply(msg, out, true)
            mystat('/owner')
        end
    end

    if blocks[1] == 'modlist' then
        local message = cross.getModlist(msg.chat.id):mEscape()
        local out = make_text(lang[ln].mod.modlist, msg.chat.title:mEscape_hard(), message)
        if is_locked(msg, 'Modlist') and not is_mod(msg) then
        	api.sendMessage(msg.from.id, out, true)
        else
            api.sendReply(msg, out, true)
        end
        mystat('/modlist')
    end
end

return {
	action = action,
	triggers = {
	    '^/(promote)$',
	    '^/(promote) (@[%w_]+)$',
	    '^/(demote)$',
	    '^/(demote) (@[%w_]+)$',
	    '^/(owner)$',
	    '^/(modlist)$',
    }
}