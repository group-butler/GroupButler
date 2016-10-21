local plugin = {}

function plugin.onTextMessage(msg, blocks)
	
	if not msg.service then return end
	
	if blocks[1] == 'new_chat_member:bot' then
		
		if misc.is_blocked_global(msg.from.id) then
			api.sendMessage(msg.chat.id, '_You (user ID: '..msg.from.id..') are in the blocked list_', true)
			api.leaveChat(msg.chat.id)
			return
		end
		if msg.chat.type == 'group' then
			api.sendMessage(msg.chat.id, '_I\'m sorry, I work only in a supergroup_', true)
			api.leaveChat(msg.chat.id)
			return
		end
		if config.bot_settings.admin_mode and not roles.is_superadmin(msg.from.id) then
			api.sendMessage(msg.chat.id, '_Admin mode is on: only the bot admin can add me to a new group_', true)
			api.leaveChat(msg.chat.id)
			return
		end
		
		misc.initGroup(msg.chat.id)
	end
	if blocks[1] == 'left_chat_member:bot' then
		misc.remGroup(msg.chat.id, nil, 'bot removed')
	end
	if blocks[1] == 'left_chat_member' then
		if msg.from and msg.left_chat_member then
			if msg.from.id ~= msg.left_chat_member.id and msg.from.id ~= bot.id then
				if msg.chat.type == 'supergroup' then
					misc.saveBan(msg.left_chat_member.id, 'ban')
				end
			end
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		'^###(new_chat_member:bot)',
		'^###(left_chat_member:bot)',
		'^###(left_chat_member)$'
	}
}

return plugin
