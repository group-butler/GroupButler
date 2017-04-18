local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local block, unblock = {}, {}

function block.User(chat_id, user_object)
    local hash = 'chat:'..chat_id..':blocked'
    local name = u.getname_final(user_object)
    return db:hset(hash, user_object.id, name..' [<code>'..user_object.id..'</code>]')
end

function block.Users(chat_id, users)
    local hash = 'chat:'..chat_id..':blocked'
    local n = 0
    for user_id, username in pairs(users) do
        local is_new = db:hset(hash, user_id, username..' [<code>'..user_id..'</code>]')
        if is_new then n = n + 1 end
    end
    
    return n
end

function unblock.User(chat_id, user_id)
    local hash = 'chat:'..chat_id..':blocked'
    return db:hdel(hash, user_id) == 1
end

function unblock.Users(chat_id, users)
    local hash = 'chat:'..chat_id..':blocked'
    local n = 0
    for user_id, username in pairs(users) do
        local is_blocked = db:hdel(hash, user_id) == 1
        if is_blocked then n = n + 1 end
    end
    
    return n
end

local function getUsernamesList(text)
    local users = {}
    local not_found = {}
    local user_id
    for username in text:gmatch('%s+(@%w[%w_]+)') do
        user_id = u.resolve_user(username)
        if user_id then
            users[user_id] = username
        else
            table.insert(not_found, username)
        end
    end
    
    return users, not_found
end
 
function plugin.onTextMessage(msg, blocks)
    if msg.chat.id < 0 and u.is_allowed('hammer', msg.chat.id, msg.from) then
        local text, reply_markup
        if blocks[1] == 'block' or blocks[1] == 'unblock' then
            if not blocks[2] and msg.reply then
                if not msg.reply.forward_from then
                    text = ("<i>Please reply to a forwarded message to block the original sender, or provide me a list of usernames</i>")
                else
                    if u.is_mod(msg.chat.id, msg.reply.forward_from.id) and blocks[1] == 'block'  then
                        --/unblock on an admin/mod is possible because an user can be blocked by username even if he is mod/admin
                        text = ("<i>You can't block an admin or a mod</i>")
                    else
                        if blocks[1] == 'block' then
                            local is_new = block.User(msg.chat.id, msg.reply.forward_from)
                            if not is_new then
                                text = ("<i>This user is already in the blocked list</i>")
                            else
                                local name = u.getname_final(msg.reply.forward_from)
                                text = ("%s added to the blocked list"):format(name)
                                u.logEvent('block', msg, {user = name})
                            end
                        elseif blocks[1] == 'unblock' then
                            local is_not_blocked = unblock.User(msg.chat.id, msg.reply.forward_from.id)
                            if not is_not_blocked then
                                text = ("<i>This user is not in the blocked list</i>")
                            else
                                local name = u.getname_final(msg.reply.forward_from)
                                text = ("%s removed from the blocked list"):format(name)
                                u.logEvent('unblock', msg, {user = name})
                            end
                        end
                    end
                end
            elseif blocks[2] then
                local users, not_found = getUsernamesList(blocks[2])
                if blocks[1] == 'block' then
                    local users_blocked = block.Users(msg.chat.id, users)
                    text = ("<b>New users blocked</b>: %d"):format(users_blocked)
                    if users_blocked > 0 then
                        u.logEvent('block', msg, {n = users_blocked})
                    end
                elseif blocks[1] == 'unblock' then
                    local users_unblocked = unblock.Users(msg.chat.id, users)
                    text = ("<b>Users unblocked</b>: %d"):format(users_unblocked)
                    if users_unblocked > 0 then
                        u.logEvent('unblock', msg, {n = users_unblocked})
                    end
                end
                if next(not_found) then --if some usernames are not in the db
                    text = text..("\n\nUnknown usernames:\n%s"):format(table.concat(not_found, '\n'))
                end
            else
                return --without the return, if the user sends "/block" (not in reply to a message), the sendMessage at the end is executed, but text is nil
            end
        end
        if blocks[1] == 'blockedlist' or blocks[1] == 'blocklist' then
            text = ('Where do you want to receive the list?')
            reply_markup = {inline_keyboard={{
                {text = ("Here"), callback_data = 'blockedlist:group'},
                {text = ("Private"), callback_data = 'blockedlist:private'}
            }}}
        end
        api.sendReply(msg, text, 'html', reply_markup)
    end
end

function plugin.onCallbackQuery(msg, blocks)
    if u.is_allowed('info', msg.chat.id, msg.from) then
        local hash = ('chat:%d:blocked'):format(msg.chat.id)
        local users_blocked = db:hvals(hash)
        if not next(users_blocked) then
            api.editMessageText(msg.chat.id, msg.message_id, ('<i>The list is empty</i>'), 'html')
        else
            local text = ([[<b>List of blocked users (%d)</b>:

- %s

<i>When a blocked user joins and gets banned, he's removed from this list</i>]]):format(#users_blocked, table.concat(users_blocked, '\n- '))
            local res, code
            if blocks[1] == 'private' then
                res, code = api.sendMessage(msg.from.id, text, 'html')
                if res then
                    api.editMessageText(msg.chat.id, msg.message_id, ("I've sent you the list in private"))
                end
            elseif blocks[1] == 'group' then
                res, code = api.editMessageText(msg.chat.id, msg.message_id, text, 'html')
            end
            
            if not res then --something went wrong while sending/editing the message
                local text
                if code == 118 then
                    text = ("<i>I'm sorry, the list is too long. I can't show you the whole list now. This problem will be solved soon</i>")
                elseif code == 144 or code == 145 then
                    text = ("<i>Something went wrong with the formattation of the list</i>")
                elseif (code == 403 or code == 110) and blocks[1] == 'private' then
                    api.answerCallbackQuery(msg.cb_id, ("You need to start me first.\nClick/tap here: t.me/%s"):format(bot.username), true)
                    return
                else
                    text = ("<i>An unknown error occurred</i>. Code: %d"):format(code)
                end
                api.editMessageText(msg.chat.id, msg.message_id, text, 'html')
            end
        end
    else
        api.answerCallbackQuery(msg.cb_id, ("You are not allowed to use this button"), true)
    end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(block)$',
		config.cmd..'(block)( [@%w_%s]+)',
		config.cmd..'(unblock)$',
		config.cmd..'(unblock)( [@%w_%s]+)',
		config.cmd..'(blockedlist)$',
		config.cmd..'(blocklist)$',
	},
	onCallbackQuery = {
		'^###cb:blockedlist:(%a+)$'
	}
}

return plugin