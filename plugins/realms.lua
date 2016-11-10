local plugin = {}

function is_realm(chat_id)
	if db:sismember('bot:realms', chat_id) then
		return true
	else
		return false
	end
end

function is_paired(chat_id)
	--realm_id: the chat has a realm associated and the chat_id appears in the subgroups of the realm
	--FALSE, 1: the chat_id is a realm
	--FALSE, 2: the chat doesn't have an associated realm
	--FALSE, 3: the chat has an associated realm but the chat_id doesn't appear between the realm subgroups
	
	if db:sismember('bot:realms', chat_id) then
		return false, 1
	else
		local realm_id = db:get('chat:'..chat_id..':realm')
		if not realm_id then
			return false, 2
		else
			local is_in_the_list = db:hget('realm:'..realm_id..':subgroups', chat_id)
			if not is_in_the_list then
				return false, 3
			else
				return realm_id
			end
		end
	end
end

function is_subgroup(chat_id)
	if db:sismember('bot:realms') then
		return false
	else
		local realm_id = db:get('chat:'..chat_id..':realm')
		if realm_id then
			return realm_id
		else
			return false
		end
	end
end

function get_realm_id(chat_id)
	return db:get('chat:'..chat_id..':realm')
end

function get_realm_info(realm_id)
	local text = ''
	if not db:sismember('bot:realms') then
		text = text ..'- Not indexed in "bot:realms"'
	else
		text = text ..'- Indexed in "bot:realms"'
	end
	
	local subgroups = db:hgetall('realm:'..msg.chat.id..':subgroups')
	if not next(subgroups) then
		text = text..'\n\n[No subgroups]'
	else
		text = text..'\n\nSubgroups:\n'
		for subgroup_id, subgroup_name in pairs(subgroups) do
			local subgroup_realm = (db:get('chat:'..subgroup_id..':realm')) or 'none'
			text = text..'   ['..subgroup_id..']>['..subgroup_realm..']\n'
		end
	end
	
	return text
end

function get_subgroup_info(chat_id)
	local realm_id = db:get('chat:'..chat_id..':realm')
	if not realm_id then
		return 'No realm paired'
	else
		local text = 'Realm id (chat:'..chat_id..':realm) = '..realm_id..'\n'
		local subgroup_name = db:hget('realm:'..realm_id..':subgroups', chat_id)
		if subgroup_name then
			text = text..'Listed in the realm subgroups as "'..subgroup_name..'"'
		else
			text = text..'Not listed in the realm subgroups'
		end
		return text
	end
end

function remRealm(realm_id)
	local subgroups = db:hgetall('realm:'..realm_id..':subgroups')
	if subgroups then
		if next(subgroups) then
			local count = {total = 0, subgroup_keys_deleted = 0}
			for subgroup_id, subgroup_name in pairs(subgroups) do
				count.total = count.total + 1
				local subgroup_realm_id = db.get('chat:'..subgroup_id..':realm')
				if subgroup_realm_id then
					if tonumber(subgroup_realm_id) == tonumber(realm_id) then
						count.subgroup_keys_deleted = count.subgroup_keys_deleted + 1
						db:del('chat:'..subgroup_id..':realm')
					end
				end
			end
		end
	end
	
	db:del('realm:'..realm_id..':subgroups')
	db:srem('bot:realms', realm_id)
	
	if count then return count end
end

function unpair_group(realm_id, subgroup_id)
	local subgroup = {
		title = db:hget('realm:'..realm_id..':subgroups', subgroup_id),
		realm = db:get('chat:'..subgroup_id..':realm')
	}
	
	db:del('chat:'..subgroup_id..':realm')
	db:hdel('realm:'..realm_id..':subgroups', subgroup_id)
	
	return subgroup
end

--is_realm
--is_paired
--is_subgroup
--get_429_timeout
--comando per eliminare un realm. Richiede l'approvazione tramite tastiera inline ("are you sure? yes/no")

--misc.get_adminlist must return false + code if an api limit is hit

--must be placed after onmessage.lua

--in remGroup, se "hard", rimuovi anche il realm associato al gruppo, ed il gruppo dai subgruppi del realm associato (unapir_groups)

--[[
GENERAL:
	bot:realms
		REALM_ID
		REALM_ID
		...

REALMS:
	realm:chat_id:subgroups
		ID = TITLE
		ID = TITLE
		...

SUBGROUP:
	chat:chat_id:realm
		REALM_ID
	
]]

local function get_subgroups_number(realm_id, subgroups)
	if not subgroups then
		subgroups = db:hgetall('realm:'..realm_id..':subgroups')
	end
	
	if not next(subgroups) then
		return 0
	else
		local n = 0
		for id, name in pairs(subgroups) do
			n = n + 1
		end
		return n
	end
end

local function realm_get_userid(text)
	--if no user id: returns false and the msg id of the translation for the problem
	if text:match('(@[%w_]+)') then
		local username = text:match('(@[%w_]+)')
		local id = misc.resolve_user(username)
		if not id then
			return false, "I've never seen this user before.\n"
				.. "If you want to teach me who is he, forward me a message from him"
		else
			return id
		end
	elseif text:match('(%d+)') then
		local id = text:match('(%d+)')
		return id
	else
		return false, "I've never seen this user before.\n"
				.. "If you want to teach me who is he, forward me a message from him"
	end
end	

local function setrules_subgroup(subgroup_id, subgroup_name, others)
	db:hset('chat:'..subgroup_id..':info', 'rules', others.rules)
end

local function sendmessage_subgroup(subgroup_id, subgroup_name, others)
	local res = api.sendMessage(subgroup_id, others.text, true)
	if res then
		return true
	else
		return false
	end
end

local function subgroups_iterator(realm_id, callback_function, others)
	local subgroups = db:hgetall('realm:'..realm_id..':subgroups')
	if not next(subgroups) then
		return false
	else
		local i = 0
		for subgroup_id, subgroup_name in pairs(subgroups) do
			local result = callback_function(subgroup_id, subgroup_name, others)
			if result then
				if type(result) == 'number' then
					i = i + result
				else
					i = i + 1
				end
			end
		end
		return true, i
	end
end
	
local function doKeyboard_subgroups(subgroups, callback_identifier, insert_all_button)
	local keyboard = {inline_keyboard={}}
	if insert_all_button then
		table.insert(keyboard.inline_keyboard, {{text = 'ALL', callback_data = 'realm:'..callback_identifier..':all'}})
	end
	
	for subgroup_id, name in pairs(subgroups) do
		local line = {{text = name, callback_data = 'realm:'..callback_identifier..':'..subgroup_id}}
		table.insert(keyboard.inline_keyboard, line)
	end
	return keyboard
end

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'setrules' then
		local rules = db:get('temp:realm:'..msg.chat.id..':setrules')
		if not rules then
			api.editMessageText(msg.chat.id, msg.message_id, _('_Expired_'), true)
		else
			if blocks[2]:match('^-%d+$') then
				db:hset('chat:'..blocks[2]..':info', 'rules', rules)
				local keyboard = doKeyboard_subgroups(subgroups, 'setrules', true)
				api.editMessageText(msg.chat.id, msg.message_id, msg.original_text..'\nApplied to: '..db:hget('realm:'..msg.chat.id..':subgroups', blocks[2]), false, keyboard)
				api.answerCallbackQuery(msg.cb_id, _('Applied'))
			elseif blocks[2] == 'all' then
				local has_subgroups = subgroups_iterator(msg.chat.id, setrules_subgroup, {rules = rules})
				api.editMessageText(msg.chat.id, msg.message_id, _('Rules applied to every group'))
			end
		end
	end
	if blocks[1] == 'adminlist' then
		local subgroup_id = blocks[2]
		local text, code = misc.getAdminlist(subgroup_id)
		if not text then
			if code == 429 then
				text = _('Too many requests. Please wait some minutes and try again. Note that if you flood this command, I\'ll leave the group and block you')
			else
				text = _('An unexpected error with the api occurred. Please try again later')
			end
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, true)
	end
	if blocks[1] == 'send' then
		local text_to_send = db:get('temp:realm:'..msg.chat.id..':send')
		if not text_to_send then
			api.editMessageText(msg.chat.id, msg.message_id, _('_Expired_'), true)
		else
			if blocks[2]:match('^-%d+$') then
				local res, motivation = api.sendMessage(blocks[2], text_to_send, true)
				if res then
					api.editMessageText(msg.chat.id, msg.message_id, _('*Message sent*'), true)
				else
					api.answerCallbackQuery(msg.cb_id, _('I can\'t send the text\nMotivation: %s'):format(motivation), true)
				end
			elseif blocks[2] == 'all' then
				local has_subgroups, i = subgroups_iterator(msg.chat.id, sendmessage_subgroup, {text = text})
				api.editMessageText(msg.chat.id, msg.message_id, _('Message sent in %d groups'):format(i))
			end
		end
	end
	if blocks[1] == 'remsubgroup' then
		if not roles.is_owner_cached(msg) then
			api.answerCallbackQuery(msg.cb_id, _('_Only the realm owner can remove a group_'), true)
		else
			local subgroup_info = unpair_group(msg.chat.id, blocks[2])
			local subgroups = db:hgetall('realm:'..msg.chat.id..':subgroups')
			if not next(subgroups) then
				api.editMessageText(msg.chat.id, msg.message_id, '_No groups paired_', true)
			else
				local keyboard = doKeyboard_subgroups(subgroups, 'remove')
				local group_label = blocks[2]
				if subgroup_info.title then group_label = subgroup_info.title end
				api.editMessageText(msg.chat.id, msg.message_id, _('%s removed from your subgroups'):format(group_label), false, keyboard)
			end
		end
	end
end

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'setrealm' and blocks[2] then
		if roles.is_owner_cached(msg) then
			if is_realm(msg.chat.id) then
				api.sendReply(msg, _('_This group is a realm, you can set a realm for a realm_'), true)
			else
				local text
				if not is_realm(blocks[2]) then
					text = _('_The id you sent doesn\'t belong to a realm_')
				else
					local realm = blocks[2]
					local subgroup = msg.chat.id
					local subgroups_number = get_subgroups_number(realm)
					if subgroups_number >= config.bot_settings.realm_max_subgroups then
						text = _('This realm [%s] already reached the max [%d] number of subgroups'):format(realm, subgroups_number)
					else
						print(realm, subgroup)
						local old_realm = db:get('chat:'..subgroup..':realm')
						
						db:set('chat:'..subgroup..':realm', realm)
						db:hset('realm:'..realm..':subgroups', subgroup, msg.chat.title)
						if old_realm and old_realm ~= realm then
							db:hdel('realm:'..old_realm..':subgroups', msg.chat.id)
							text = _('The realm of this group changed: `%s`')
						else
							if realm == old_realm then
								text = _('Already a sub-group of: `%s`')
							else
								text = _('Group added to the sub-groups of: `%s`')
							end
						end
					end
					api.sendReply(msg, text:format(blocks[2]), true)
				end
			end
		end
		return
	end
	if blocks[1] == 'setrealm' and not blocks[2] then
		if is_realm(msg.chat.id) then
			api.sendReply(msg, _('This group is already a realm.\n*Realm id*: `%s`'):format(msg.chat.id), true)
		else
			if not roles.is_owner_cached(msg) then
				api.sendReply(msg, _('_Only the owner can decide to use this group as a realm_'), true)
			else
				if msg.chat.username then
					api.sendReply(msg, _('_I\'m sorry, a public group can\'t be used as realms_'), true)
				else
					local n_members = api.getChatMembersCount(msg.chat.id)
					if not n_members then
						api.sendReply(msg, _('_I\'m sorry, I can\'t get the number of the members of this group now. Try again later_'), true)
					else
						n_members = n_members.result
						if n_members > config.bot_settings.realm_max_members then
							api.sendReply(msg, _('_You can\'t use as realm a group with more than %d members_'):format(config.bot_settings.realm_max_members), true)
						else
							db:sadd('bot:realms', msg.chat.id)
							api.sendReply(msg, _('This group can now be used as realm. To add a sub-group, the group owner must write in the chat:\n"/setrealm %s. He can copy-paste there the following text:"'):format(msg.chat.id))
							api.sendMessage(msg.chat.id, '`/setrealm '..msg.chat.id..'`', true)
						end
					end
				end
			end
		end
		return
	end
	if blocks[1] == 'new_chat_title' and msg.service then
		local realm_id = get_realm_id(msg.chat.id)
		if realm_id then
			db:hset('realm:'..realm_id..':subgroups', msg.chat.id, msg.chat.title)
		end
		return
	end		
	
	if not is_realm(msg.chat.id) then return true end
	local subgroups = db:hgetall('realm:'..msg.chat.id..':subgroups')
	if not next(subgroups) then
		api.sendReply(msg, _('_I\'m sorry, this realm doesn\'t have subgroups paired with it_'), true) return
	end
	
	if blocks[1] == 'subgroups' then
		local body = ''
		local n = 0
		for id, name in pairs(subgroups) do
			n = n + 1
			body = body..n..' - '..name..'\n'
		end
		local text = _('Your subgroups:\n\n')..body
		local keyboard = {inline_keyboard={{{text = 'Refresh names', callback_data = 'realm:refreshnames:'..msg.chat.id}}}}
		api.sendMessage(msg.chat.id, text, false, keyboard)
	end
	if blocks[1] == 'remove' then
		local keyboard = doKeyboard_subgroups(subgroups, 'remsubgroup')
		api.sendMessage(msg.chat.id, _('Choose the subgroup you want to un-pair:'), false, keyboard)
	end
	
	if blocks[1] == 'setrules' then
		local res, code = api.sendReply(msg, blocks[2], true)
		if not res then
			if code == 118 then
				api.sendMessage(msg.chat.id, _("This text is too long, I can't send it"))
			else
				api.sendMessage(msg.chat.id, _("This text breaks the markdown.\n"
					.. "More info about a proper use of markdown "
					.. "[here](https://telegram.me/GroupButler_ch/46)."), true)
			end
		else
			local keyboard = doKeyboard_subgroups(subgroups, 'setrules', true)
			db:setex('temp:realm:'..msg.chat.id..':setrules', 3600, blocks[2])
			api.editMessageText(msg.chat.id, res.result.message_id, 'Choose the group where apply the rules (choose *within one hour from now*)', true, keyboard)
		end
	end
	if blocks[1] == 'ban' or blocks[1] == 'kick' then
		local user_id
		if blocks[2] then
			user_id = realm_get_userid(blocks[2])
		else
			if not msg.reply.forward_from then
				api.sendReply(msg, _('_Answer to a forwarded message_'), true) return
			else
				user_id = msg.reply.forward_from.id
			end
		end
		
		local failed = {limits = 0, not_admin = 0, is_admin = 0, others = 0, names = ''}
		local success = 0
		local hammer_function
		if blocks[1] == 'ban' then
			hammer_function = api.banUser
		else
			hammer_function = api.kickUser
		end
		for subgroup_id, subgroup_name in pairs(subgroups) do
			local res, code = hammer_function(subgroup_id, user_id)
			if not res then
				print(code)
				if code == 429 then
					failed.limits = failed.limits + 1
				elseif code == 101 then
					failed.not_admin = failed.not_admin + 1 --the bot can't kick because it's not admin
				elseif code == 102 then
					failed.is_admin = failed.is_admin + 1 --trying to kick an admin
				else
					failed.others = failed.others + 1
				end
				failed.names = failed.names..'- '..subgroup_name..'\n'
			else
				success = success + 1
			end
		end
		
		local text = _([[Processed.
		
Success: %d
The bot is not admin: %d
The user is admin: %d
Failed because of limits: %d
Failed because of other reasons: %d
Failed to ban from:
%s]])
		api.sendReply(msg, text:format(success, failed.not_admin, failed.is_admin, failed.limits, failed.others, failed.names))
	end
	if blocks[1] == 'adminlist' then
		local keyboard = doKeyboard_subgroups(subgroups, 'adminlist')
		api.sendMessage(msg.chat.id, 'Choose a group to see the list of the admins', false, keyboard)
	end
	if blocks[1] == 'send' then
		local res, code = api.sendReply(msg, blocks[2], true)
		if not res then
			local text = misc.get_sm_error_string(code)
			api.sendReply(msg, text, true)
		else
			local keyboard = doKeyboard_subgroups(subgroups, 'send', true)
			db:setex('temp:realm:'..msg.chat.id..':send', 3600, blocks[2])
			api.editMessageText(msg.chat.id, res.result.message_id, 'Choose the group where I have to send the message *within one hour from now*', true, keyboard)
		end
	end
	
end

plugin.triggers = {
	onTextMessage = {
		'^/(setrealm)$',
		'^/(setrealm) (-%d+)$',
		'^/(subgroups)$',
		'^/(remove)$',
		'^/(adminlist)$',
		'^/(ban)$',
		'^/(kick)$',
		'^/(ban) (.*)$',
		'^/(kick) (.*)$',
		'^/(setrules) (.*)$',
		'^/(send) (.*)$',
		'^###(new_chat_title)$'
	},
	onCallbackQuery = {
		'^###cb:realm:(%w+):(-%d+)$',
		'^###cb:realm:(%w+):(all)$',
	}
}

return plugin