local triggers = {
	'^/(flag)$',
	'^/(flag)@groupbutler_bot',
	'^/(flag) (.*)', --flag with motivation
	'^/(flag block)$',
	'^/(flag free)$'
}

local action = function(msg, blocks, ln)
    if msg.chat.type == 'private' then--return nil if it's a private chat
		api.sendMessage(msg.from.id, lang[ln].pv)
    	return nil
    end
    local hash = 'bot:'..msg.chat.id..':flagblocked'
    if blocks[1] == 'flag' then
        --return nil if 's_flag' is locked
        if is_locked(msg, 'Flag') then --or is_mod(msg) then
            return nil 
        end
        --ignore if who is flagging is a mod
        if is_mod(msg) then
	        return nil
	    end
	    local res = client:sismember(hash, msg.from.id)
        --check if /flagblocked
        if res then
            return nil
        end
        --warning to reply to a message
        if not msg.reply_to_message then
            local out = make_text(lang[ln].flag.reply_flag)
            api.sendReply(msg, out)
		    return nil
	    end
	    local replied = msg.reply_to_message --load the replied message
	    --return nil if an user flag a mod
	    if is_mod(replied) then
	        return nil
	    end
	    --return nil if an user flag the bot
	    if replied.from.id == bot.id then
	        return nil
	    end
	    local desc = blocks[2]
	    --check if there is a description for the flag
	    if not desc then
	        desc = 'no description given'
	    end
	    --check if there is an username of flagging user
	    local titlefla = ''
        if msg.from.username then
            titlefla = ' (@'..msg.from.username..')'
        end
	    --check if there is an username of flagged user
	    local titlere = ''
        if replied.from.username then
            titlere = ' (@'..replied.from.username..')'
        end
	    for k,v in pairs(client:hkeys('bot:'..msg.chat.id..':mod') )do
	        print('Reported to ['..v..']')
	        local out = make_text(lang[ln].flag.mod_msg, msg.from.first_name, titlefla, replied.from.first_name, titlere, desc, replied.text)
            api.sendMessage(v, out)
            --sendMessage(v, msg.from.first_name..titlefla..' reported '..replied.from.first_name..titlere..'\nDescription: '..desc..'\nMessage reported:\n\n'..replied.text)
        end
        local out = make_text(lang[ln].flag.group_msg)
        api.sendMessage(msg.chat.id, out, true)
        mystat('/flag')
    end
    if blocks[1] == 'flag block' then
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        --warning to reply to a message
        if not msg.reply_to_message then
            local out = make_text(lang[ln].flag.reply_block)
            api.sendReply(msg, out)
		    return nil
	    end
	    local replied = msg.reply_to_message
	    --can't /flagblock a mod
	    if is_mod(replied) then --return nil if an user flag a mod
	        local out = make_text(lang[ln].flag.mod_cant_flag)
	        api.sendReply(msg, out)
	        return nil
	    end
	    --can't /flagblock the bot
	    if replied.from.id == bot.id then
	        return nil
	    end
	    --check if already unable to use /flag
	    local res = client:sismember(hash, replied.from.id)
	    if res then
	        local out = make_text(lang[ln].flag.already_unable, replied.from.first_name)
            api.sendReply(msg, out, true)
            return nil
        end
        --unable the user to use /flag and save datas
        --check if there is an username
        local title = replied.from.first_name
        if replied.from.username then
            title = '@'..replied.from.username
        end
        client:sadd(hash, replied.from.id)
        local out = make_text(lang[ln].flag.blocked, msg.from.first_name)
        api.sendReply(msg, out, true)
        mystat('/flagblock')
    end
    if blocks[1] == 'flag free' then
        --return nil if the user is not a moderator
        if not is_mod(msg) then
            return nil
        end
        --warning to reply to a message
        if not msg.reply_to_message then
            local out = make_text(lang[ln].flag.reply_unblock)
            api.sendReply(msg, out)
		    return nil
	    end
	    local replied = msg.reply_to_message
	    --an user can't /flagfree a mod
	    if is_mod(replied) then
	        local out = make_text(lang[ln].flag.mod_cant_flag)
	        api.sendReply(msg, out)
	        return nil
	    end
	    --can't /flagfree the bot
	    if replied.from.id == bot.id then
	        return nil
	    end
	    --check if already able to use /flag
	    local res = client:sismember(hash, replied.from.id)
	    if not res then
	        local out = make_text(lang[ln].flag.already_able, replied.from.first_name)
            api.sendReply(msg, out, true)
            return nil
        end
        --able the user to use /flag and save datas
        client:srem(hash, replied.from.id)
        local out = make_text(lang[ln].flag.unblocked, msg.from.first_name)
        api.sendReply(msg, out, true)
        mystat('/flagfree')
    end
end

return {
	action = action,
	triggers = triggers
}
