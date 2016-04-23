local function is_report_blocked(msg)
    local hash = 'chat:'..msg.chat.id..':reportblocked'
    return client:sismember(hash, msg.from.id)
end

local function send_to_admin(mods, chat, msg_id)
    for i=1,#mods do
        api.forwardMessage(mods[i], chat, msg_id)
    end
end       

local action = function(msg, blocks, ln)
    if msg.chat.type == 'private' then--return nil if it's a private chat
		api.sendMessage(msg.from.id, lang[ln].pv)
    	return nil
    end
    local hash = 'chat:'..msg.chat.id..':reportblocked'
    if blocks[1] == 'admin' then
        --return nil if 'report' is locked, if is a mod or if the user is blocked from using @admin
        if is_locked(msg, 'Report') or is_mod(msg) or is_report_blocked(msg) then
            return nil 
        end
        if not blocks[2] and not msg.reply then
            api.sendReply(msg, lang[ln].flag.no_input)
        else
            if is_report_blocked(msg) then
                return nil
            end
            if msg.reply and tonumber(msg.reply.from.id) == tonumber(bot.id) then
                return
            end
            local mods = client:hkeys('bot:'..msg.chat.id..':mod')
            local msg_id = msg.message_id
            if msg.reply then
                blocks[2] = false
                msg_id = msg.reply.message_id
            end
            send_to_admin(mods, msg.chat.id, msg_id)
            api.sendReply(msg, lang[ln].flag.reported)
        end
    end
    if blocks[1] == 'report' then
        if is_mod(msg) then
            if not msg.reply then
                api.sendReply(msg, lang[ln].flag.no_reply)
            else
                if blocks[2] == 'off' then
                    local result = client:sadd(hash, msg.reply.from.id)
                    if result == 1 then
                        api.sendReply(msg, lang[ln].flag.blocked)
                    elseif result == 0 then
                        api.sendReply(msg, lang[ln].flag.already_blocked)
                    end
                elseif blocks[2] == 'on' then
                    local result = client:srem(hash, msg.reply.from.id)
                    if result == 1 then
                        api.sendReply(msg, lang[ln].flag.unblocked)
                    elseif result == 0 then
                        api.sendReply(msg, lang[ln].flag.already_unblocked)
                    end
                end
            end
        end
    end
end

return {
	action = action,
	triggers = {
	    '^@(admin)$',
	    '^@(admin) (.*)$',
	    '^/(report) (on)$',
	    '^/(report) (off)$',
    }
}