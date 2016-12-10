local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

local function send_in_group(chat_id)
	local res = db:hget('chat:'..chat_id..':settings', 'Rules')
	if res == 'on' then
		return true
	else
		return false
	end
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type == 'private' then
    	if blocks[1] == 'start' then
    		msg.chat.id = tonumber(blocks[2])

			local res = api.getChat(msg.chat.id)
			if not res then
				api.sendMessage(msg.from.id, _("🚫 Unknown or non-existent group"))
				return
			end
			-- Private chats have no an username
			local private = not res.result.username

			local res = api.getChatMember(msg.chat.id, msg.from.id)
			if not res or (res.result.status == 'left' or res.result.status == 'kicked') and private then
				api.sendMessage(msg.from.id, _("🚷 You are not a member of this chat. " ..
					"You can't read the rules of a private group."))
				return
			end
    	else
    		return
    	end
    end
    
    local hash = 'chat:'..msg.chat.id..':info'
    if blocks[1] == 'rules' or blocks[1] == 'start' then
    	local link_preview = db:hget(('chat:%d:settings'):format(msg.chat.id), 'Preview')
    	if link_preview and link_preview == 'off' then link_preview = nil end
        local out = misc.getRules(msg.chat.id)
    	if msg.chat.type == 'private' or (not roles.is_admin_cached(msg) and not send_in_group(msg.chat.id)) then
    		api.sendMessage(msg.from.id, out, true, nil, nil, link_preview)
    	else
        	api.sendReply(msg, out, true, nil, nil, link_preview)
        end
    end
	
	if not roles.is_admin_cached(msg) then return end
	
	if blocks[1] == 'setrules' then
		local input = blocks[2]
		--ignore if not input text
		if not input then
			api.sendReply(msg, _("Please write something next this poor `/setrules`"), true)
			return
		end
    	--check if a mod want to clean the rules
		if input == '-' then
			db:hdel(hash, 'rules')
			api.sendReply(msg, _("Rules has been deleted."))
			return
		end
		
		--set the new rules	
		local res, code = api.sendReply(msg, input, true)
		if not res then
			api.sendMessage(msg.chat.id, misc.get_sm_error_string(code), true)
		else
			db:hset(hash, 'rules', input)
			local id = res.result.message_id
			api.editMessageText(msg.chat.id, id, _("New rules *saved successfully*!"), true)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(setrules)$',
		config.cmd..'(setrules) (.*)',
		config.cmd..'(rules)$',
		'^/(start) (-?%d+):rules$'
	}
}

return plugin
