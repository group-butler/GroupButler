local serpent = require 'serpent'
local config = require 'config'
local api = require 'methods'

-- utilities.lua
-- Functions shared among plugins.

local utilities = {misc = {}, roles = {}}

-- Escape markdown for Telegram. This function makes non-clickable usernames,
-- hashtags, commands, links and emails, if only_markup flag isn't setted.
function string:escape(only_markup)
	if not only_markup then
		-- insert word joiner
		self = self:gsub('([@#/.])(%w)', '%1\xE2\x81\xA0%2')
	end
	return self:gsub('[*_`[]', '\\%0')
end

function string:escape_html()
	self = self:gsub('&', '&amp;')
	self = self:gsub('"', '&quot;')
	self = self:gsub('<', '&lt;'):gsub('>', '&gt;')
	return self
end

-- Remove specified formating or all markdown. This function useful for put
-- names into message. It seems not possible send arbitrary text via markdown.
function string:escape_hard(ft)
	if ft == 'bold' then
		return self:gsub('%*', '')
	elseif ft == 'italic' then
		return self:gsub('_', '')
	elseif ft == 'fixed' then
		return self:gsub('`', '')
	elseif ft == 'link' then
		return self:gsub(']', '')
	else
		return self:gsub('[*_`[%]]', '')
	end
end

function utilities.roles.is_superadmin(user_id)
	for i=1, #config.superadmins do
		if tonumber(user_id) == config.superadmins[i] then
			return true
		end
	end
	return false
end

function utilities.roles.bot_is_admin(chat_id)
	local status = api.getChatMember(chat_id, bot.id).result.status
	if not(status == 'administrator') then
		return false
	else
		return true
	end
end

function utilities.roles.is_admin(msg)
	local res = api.getChatMember(msg.chat.id, msg.from.id)
	if not res then
		return false, false
	end
	local status = res.result.status
	if status == 'creator' or status == 'administrator' then
		return true, true
	else
		return false, true
	end
end

-- Returns the admin status of the user. The first argument can be the message,
-- then the function checks the rights of the sender in the incoming chat.
function utilities.roles.is_admin_cached(chat_id, user_id)
	if type(chat_id) == 'table' then
		local msg = chat_id
		chat_id = msg.chat.id
		user_id = msg.from.id
	end

	local hash = 'cache:chat:'..chat_id..':admins'
	if not db:exists(hash) then
		utilities.misc.cache_adminlist(chat_id, res)
	end
	return db:sismember(hash, user_id)
end

function utilities.roles.is_admin2(chat_id, user_id)
	local res = api.getChatMember(chat_id, user_id)
	if not res then
		return false, false
	end
	local status = res.result.status
	if status == 'creator' or status == 'administrator' then
		return true, true
	else
		return false, true
	end
end

function utilities.roles.is_owner(msg)
	local status = api.getChatMember(msg.chat.id, msg.from.id).result.status
	if status == 'creator' then
		return true
	else
		return false
	end
end

function utilities.roles.is_owner_cached(chat_id, user_id)
	if type(chat_id) == 'table' then
		local msg = chat_id
		chat_id = msg.chat.id
		user_id = msg.from.id
	end
	
	local hash = 'cache:chat:'..chat_id..':owner'
	local owner_id, res = nil, true
	repeat
		owner_id = db:get(hash)
		if not owner_id then
			res = utilities.misc.cache_adminlist(chat_id)
		end
	until owner_id or not res

	if owner_id then
		if tonumber(owner_id) == tonumber(user_id) then
			return true
		end
	end
	
	return false
end	

function utilities.roles.is_owner2(chat_id, user_id)
	local status = api.getChatMember(chat_id, user_id).result.status
	if status == 'creator' then
		return true
	else
		return false
	end
end

function utilities.misc.cache_adminlist(chat_id)
	local res, code = api.getChatAdministrators(chat_id)
	if not res then
		return false, code
	end
	local hash = 'cache:chat:'..chat_id..':admins'
	for _, admin in pairs(res.result) do
		if admin.status == 'creator' then
			db:set('cache:chat:'..chat_id..':owner', admin.user.id)
		end
		db:sadd(hash, admin.user.id)
	end
	db:expire(hash, config.bot_settings.cache_time.adminlist)
	
	return true, #res.result or 0
end

function utilities.misc.get_cached_admins_list(chat_id, second_try)
	local hash = 'cache:chat:'..chat_id..':admins'
	local list = db:smembers(hash)
	if not list or not next(list) then
		utilities.misc.cache_adminlist(chat_id)
		if not second_try then
			return utilities.misc.get_cached_admins_list(chat_id, true)
		else
			return false
		end
	else
		return list
	end
end

function utilities.misc.is_blocked_global(id)
	if db:sismember('bot:blocked', id) then
		return true
	else
		return false
	end
end

function string:trim() -- Trims whitespace from a string.
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

function utilities.misc.vardump(...)
	for _, value in pairs{...} do
		print(serpent.block(value, {comment=false}))
	end
end

function utilities.misc.vtext(...)
	local lines = {}
	for _, value in pairs{...} do
		table.insert(lines, serpent.block(value, {comment=false}))
	end
	return table.concat(lines, '\n')
end

function utilities.misc.deeplink_constructor(chat_id, what)
	return 'https://telegram.me/'..bot.username..'?start='..chat_id..':'..what
end

function table.clone(t)
  local new_t = {}
  local i, v = next(t, nil)
  while i do
    new_t[i] = v
    i, v = next(t, i)
  end
  return new_t
end

function utilities.misc.get_date(timestamp)
	if not timestamp then
		timestamp = os.time()
	end
	return os.date('%d/%m/%y', timestamp)
end

-- Resolves username. Returns ID of user if it was early stored in date base.
-- Argument username must begin with symbol @ (commercial 'at')
function utilities.misc.resolve_user(username)
	assert(username:byte(1) == string.byte('@'))

	local stored_id = tonumber(db:hget('bot:usernames', username:lower()))
	if not stored_id then return false end
	local user_obj = api.getChat(stored_id)
	if not user_obj then
		return stored_id
	else
		if not user_obj.result.username then return stored_id end
	end
	
	-- User could change his username
	if username ~= '@' .. user_obj.result.username then
		if user_obj.result.username then
			-- Update it if it exists
			db:hset('bot:usernames', user_obj.result.username:lower(), user_obj.result.id)
		end
		-- And return false because this user not the same that asked
		return false
	end

	assert(stored_id == user_obj.result.id)
	return user_obj.result.id
end

function utilities.misc.get_sm_error_string(code)
	local descriptions = {
		[109] = _("Inline link formatted incorrectly. Check the text between brackets -> \\[]()"),
		[141] = _("Inline link formatted incorrectly. Check the text between brackets -> \\[]()"),
		[142] = _("Inline link formatted incorrectly. Check the text between brackets -> \\[]()"),
		[112] = _("This text breaks the markdown.\n"
					.. "More info about a proper use of markdown "
					.. "[here](https://telegram.me/GroupButler_ch/46)."),
		[118] = _('This message is too long. Max lenght allowed by Telegram: 4000 characters')
	}
	
	return descriptions[code] or _("Unknown markdown error")
end

function utilities.misc.get_media_type(msg)
	if msg.photo then
		return 'photo'
	elseif msg.video then
		return 'video'
	elseif msg.audio then
		return 'audio'
	elseif msg.voice then
		return 'voice'
	elseif msg.document then
		if msg.document.mime_type == 'video/mp4' then
			return 'gif'
		else
			return 'document'
		end
	elseif msg.sticker then
		return 'sticker'
	elseif msg.contact then
		return 'contact'
	elseif msg.location then
		return 'location'
	elseif msg.game then
		return 'game'
	elseif msg.venue then
		return 'venue'
	else
		return false
	end
end

function utilities.misc.get_media_id(msg)
	if msg.photo then
		return msg.photo[#msg.photo].file_id, 'photo'
	elseif msg.document then
		return msg.document.file_id
	elseif msg.video then
		return msg.video.file_id, 'video'
	elseif msg.audio then
		return msg.audio.file_id
	elseif msg.voice then
		return msg.voice.file_id, 'voice'
	elseif msg.sticker then
		return msg.sticker.file_id
	else
		return false, 'The message has not a media file_id'
	end
end

function utilities.misc.migrate_chat_info(old, new, on_request)
	if not old or not new then
		return false
	end
	
	for hash_name, hash_content in pairs(config.chat_settings) do
		local old_t = db:hgetall('chat:'..old..':'..hash_name)
		if next(old_t) then
			for key, val in pairs(old_t) do
				db:hset('chat:'..new..':'..hash_name, key, val)
			end
		end
	end
	
	for _, hash_name in pairs(config.chat_custom_texts) do
		local old_t = db:hgetall('chat:'..old..':'..hash_name)
		if next(old_t) then
			for key, val in pairs(old_t) do
				db:hset('chat:'..new..':'..hash_name, key, val)
			end
		end
	end
	
	if on_request then
		api.sendReply(msg, 'Should be done')
	end
end

-- Perform substitution of placeholders in the text according given the
-- message. If placeholders to replacing are specified, this function processes
-- only them, otherwise it processes all available placeholders.
function string:replaceholders(msg, ...)
	if msg.new_chat_member then
		msg.from = msg.new_chat_member
	elseif msg.left_chat_member then
		msg.from = msg.left_chat_member
	end

	local replace_map = {
		name = msg.from.first_name:escape(),
		surname = msg.from.last_name and msg.from.last_name:escape() or '',
		username = msg.from.username and '@'..msg.from.username:escape() or '-',
		id = msg.from.id,
		title = msg.chat.title:escape(),
		rules = utilities.misc.deeplink_constructor(msg.chat.id, 'rules')
	}

	local substitutions = next{...} and {} or replace_map
	for _, placeholder in pairs{...} do
		substitutions[placeholder] = replace_map[placeholder]
	end

	return self:gsub('$(%w+)', substitutions)
end

function utilities.misc.to_supergroup(msg)
	local old = msg.chat.id
	local new = msg.migrate_to_chat_id
	local done = utilities.misc.migrate_chat_info(old, new, false)
	if done then
		utilities.misc.remGroup(old, true, 'to supergroup')
		api.sendMessage(new, '(_service notification: migration of the group executed_)', true)
	end
end

-- Return user mention for output a text
function utilities.misc.getname_final(user)
	return utilities.misc.getname_link(user.first_name, user.username) or '<code>'..user.first_name:escape_html()..'</code>'
end

-- Return link to user profile or false, if he doesn't have login
function utilities.misc.getname_link(name, username)
	if not name or not username then return nil end
	username = username:gsub('@', '')
	return ('<a href="%s">%s</a>'):format('https://telegram.me/'..username, name:escape_html())
end

function utilities.misc.bash(str)
	local cmd = io.popen(str)
    local result = cmd:read('*all')
    cmd:close()
    return result
end

function utilities.misc.telegram_file_link(res)
	--res = table returned by getFile()
	return "https://api.telegram.org/file/bot"..config.bot_api_key.."/"..res.result.file_path
end

function utilities.misc.is_silentmode_on(chat_id)
	local hash = 'chat:'..chat_id..':settings'
	local res = db:hget(hash, 'Silent')
	if res and res == 'on' then
		return true
	else
		return false
	end
end

function utilities.misc.getRules(chat_id)
	local hash = 'chat:'..chat_id..':info'
	local rules = db:hget(hash, 'rules')
    if not rules then
        return _("-*empty*-")
    else
       	return rules
    end
end

function utilities.misc.getAdminlist(chat_id)
	local list, code = api.getChatAdministrators(chat_id)
	if not list then
		return false, code
	end
	local creator = ''
	local adminlist = ''
	local count = 1
	for i,admin in pairs(list.result) do
		local name
		if admin.status == 'administrator' then
			name = admin.user.first_name
			if admin.user.username then
				name = ('<a href="telegram.me/%s">%s</a>'):format(admin.user.username, name:escape_html())
			else
				name = name:escape_html()
			end
			adminlist = adminlist..'<b>'..count..'</b> - '..name..'\n'
			count = count + 1
		elseif admin.status == 'creator' then
			creator = admin.user.first_name
			if admin.user.username then
				creator = ('<a href="telegram.me/%s">%s</a>'):format(admin.user.username, creator:escape_html())
			else
				creator = creator:escape_html()
			end
		end
	end
	if adminlist == '' then adminlist = '-' end
	if creator == '' then creator = '-' end
	return creator, adminlist
end

function utilities.misc.getExtraList(chat_id)
	local hash = 'chat:'..chat_id..':extra'
	local commands = db:hkeys(hash)
	if not next(commands) then
		return _("No commands set")
	else
		local lines = {}
		for k, v in pairs(commands) do
			table.insert(lines, (v:escape(true)))
		end
		return _("List of *custom commands*:\n") .. table.concat(lines, '\n')
	end
end

function utilities.misc.getSettings(chat_id)
    local hash = 'chat:'..chat_id..':settings'
        
	local lang = db:get('lang:'..chat_id) or 'en' -- group language
    local message = _("Current settings for *the group*:\n\n")
			.. _("*Language*: %s\n"):format(config.available_languages[lang])
        
    --build the message
	local strings = {
		Welcome = _("Welcome message"),
		Goodbye = _("Goodbye message"),
		Extra = _("Extra"),
		Flood = _("Anti-flood"),
		Antibot = _("Ban bots"),
		Silent = _("Silent mode"),
		Rules = _("Rules"),
		Arab = _("Arab"),
		Rtl = _("RTL"),
		Reports = _("Reports"),
		Welbut = _("Welcome button"),
	}
    for key, default in pairs(config.chat_settings['settings']) do
        
        local off_icon, on_icon = '🚫', '✅'
        if utilities.misc.is_info_message_key(key) then
        	off_icon, on_icon = '👤', '👥'
        end
        
        local db_val = db:hget(hash, key)
        if not db_val then db_val = default end
        
        if db_val == 'off' then
            message = message .. string.format('%s: %s\n', strings[key], off_icon)
        else
            message = message .. string.format('%s: %s\n', strings[key], on_icon)
        end
    end
    
    --build the char settings lines
    hash = 'chat:'..chat_id..':char'
    off_icon, on_icon = '🚫', '✅'
    for key, default in pairs(config.chat_settings['char']) do
    	db_val = db:hget(hash, key)
        if not db_val then db_val = default end
    	if db_val == 'off' then
            message = message .. string.format('%s: %s\n', strings[key], off_icon)
        else
            message = message .. string.format('%s: %s\n', strings[key], on_icon)
        end
    end
    	
    --build the "welcome" line
    hash = 'chat:'..chat_id..':welcome'
    local type = db:hget(hash, 'type')
    if type == 'media' then
		message = message .. _("*Welcome type*: `GIF / sticker`\n")
	elseif type == 'custom' then
		message = message .. _("*Welcome type*: `custom message`\n")
	elseif type == 'no' then
		message = message .. _("*Welcome type*: `default message`\n")
	end
    
    local warnmax_std = (db:hget('chat:'..chat_id..':warnsettings', 'max')) or config.chat_settings['warnsettings']['max']
    local warnmax_media = (db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or config.chat_settings['warnsettings']['mediamax']
    
	return message .. _("Warns (`standard`): *%s*\n"):format(warnmax_std)
				 .. _("Warns (`media`): *%s*\n\n"):format(warnmax_media)
				 .. _("✅ = _enabled / allowed_\n")
				 .. _("🚫 = _disabled / not allowed_\n")
				 .. _("👥 = _sent in group (always for admins)_\n")
				 .. _("👤 = _sent in private_")

end

function utilities.misc.changeSettingStatus(chat_id, field)
	local turned_off = {
		reports = _("@admin command disabled"),
		welcome = _("Welcome message won't be displayed from now"),
		goodbye = _("Goodbye message won't be displayed from now"),
		extra = _("#extra commands are now available only for moderator"),
		flood = _("Anti-flood is now off"),
		rules = _("/rules will reply in private (for users)"),
		antibot = _("Bots won't be kicked if added by an user"),
		welbut = _("Welcome message without a button for the rules")
	}
	local turned_on = {
		reports = _("@admin command enabled"),
		welcome = _("Welcome message will be displayed"),
		goodbye = _("Goodbye message will be displayed"),
		extra = _("#extra commands are now available for all"),
		flood = _("Anti-flood is now on"),
		rules = _("/rules will reply in the group (with everyone)"),
		antibot = _("Bots will be kicked if added by an user"),
		welbut = _("The welcome message will have a button for the rules")
	}

	local hash = 'chat:'..chat_id..':settings'
	local now = db:hget(hash, field)
	if now == 'on' then
		db:hset(hash, field, 'off')
		return turned_off[field:lower()]
	else
		db:hset(hash, field, 'on')
		if field:lower() == 'goodbye' then
			local r = api.getChatMembersCount(chat_id)
			if r and r.result > 50 then
				return _("This setting is enabled, but the goodbye message won't be displayed in large groups, "
					.. "because I can't see service messages about left members"), true
			end
		end
		return turned_on[field:lower()]
	end
end

function utilities.misc.changeMediaStatus(chat_id, media, new_status)
	local old_status = db:hget('chat:'..chat_id..':media', media)
	local new_status_icon
	if new_status == 'next' then
		if not old_status then
			new_status = 'ok'
			new_status_icon = '✅'
		elseif old_status == 'ok' then
			new_status = 'notok'
			new_status_icon = '❌'
		elseif old_status == 'notok' then
			new_status = 'ok'
			new_status_icon = '✅'
		end
	end
	db:hset('chat:'..chat_id..':media', media, new_status)
	return _("New status = %s"):format(new_status_icon), true
end

function utilities.misc.sendStartMe(msg)
    local keyboard = {inline_keyboard = {{{text = _("Start me"), url = 'https://telegram.me/'..bot.username}}}}
	api.sendMessage(msg.chat.id, _("_Please message me first so I can message you_"), true, keyboard)
end

function utilities.misc.initGroup(chat_id)
	
	for set, setting in pairs(config.chat_settings) do
		local hash = 'chat:'..chat_id..':'..set
		for field, value in pairs(setting) do
			db:hset(hash, field, value)
		end
	end
	
	utilities.misc.cache_adminlist(chat_id, api.getChatAdministrators(chat_id)) --init admin cache
	
	--save group id
	db:sadd('bot:groupsid', chat_id)
	--remove the group id from the list of dead groups
	db:srem('bot:groupsid:removed', chat_id)
end

local function remRealm(chat_id)
	if db:exists('realm:'..chat_id..':subgroups') then
		local subgroups = db:hgetall('realm:'..chat_id..':subgroups')
		if next(subgroups) then
			for subgroup_id, _ in pairs(subgroups) do
				db:del('chat:'..subgroup_id..':realm')
			end
		end
		db:del('realm:'..chat_id..':subgroups')
		return true
	end
	db:srem('bot:realms', chat_id)
end

function utilities.misc.remGroup(chat_id, full, converted_to_realm)
	if not converted_to_realm then
		--remove group id
		db:srem('bot:groupsid', chat_id)
		--add to the removed groups list
		db:sadd('bot:groupsid:removed', chat_id)
		--remove the owner cached
		db:del('cache:chat:'..chat_id..':owner')
		--remove the realm data: the group is not being converted to realm -> remove all the info
		remRealm(chat_id)
	end
	
	for set,field in pairs(config.chat_settings) do
		db:del('chat:'..chat_id..':'..set)
	end
	
	db:del('cache:chat:'..chat_id..':admins') --delete the cache
	db:hdel('bot:logchats', chat_id) --delete the associated log chat
	db:del('chat:'..chat_id..':pin') --delete the msg id of the (maybe) pinned message
	db:del('chat:'..chat_id..':userlast')
	db:hdel('bot:chats:latsmsg', chat_id)
	db:hdel('bot:chatlogs', chat_id) --log channel
	
	--if chat_id has a realm
	if db:exists('chat:'..chat_id..':realm') then
		local realm_id = db:get('chat:'..chat_id..':realm') --get the realm id
		db:hdel('realm:'..realm_id..':subgroups', chat_id) --remove the group from the realm subgroups
		db:del('chat:'..chat_id..':realm') --remove the key with the group realm
	end
	
	if full or converted_to_realm then
		for i, set in pairs(config.chat_custom_texts) do
			db:del('chat:'..chat_id..':'..set)
		end
		db:del('lang:'..chat_id)
	end
end

function utilities.misc.getnames_complete(msg, blocks)
	local admin, kicked
	
	admin = utilities.misc.getname_link(msg.from.first_name, msg.from.username) or ("<code>%s</code>"):format(msg.from.first_name:escape_html())
	
	if msg.reply then
		kicked = utilities.misc.getname_link(msg.reply.from.first_name, msg.reply.from.username) or ("<code>%s</code>"):format(msg.reply.from.first_name:escape_html())
	elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%s(@[%w_]+)%s?') then
		local username = msg.text:match('%s(@[%w_]+)')
		kicked = username
	elseif msg.mention_id then
		for _, entity in pairs(msg.entities) do
			if entity.user then
				kicked = '<code>'..entity.user.first_name:escape_html()..'</code>'
			end
		end
	elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%s(%d+)') then
		local id = msg.text:match(config.cmd..'%w%w%w%w?%w?%s(%d+)')
		kicked = '<code>'..id..'</code>'
	end
	
	return admin, kicked
end

function utilities.misc.get_user_id(msg, blocks)
	--if no user id: returns false and the msg id of the translation for the problem
	if not msg.reply and not blocks[2] then
		return false, "Reply to someone"
	else
		if msg.reply then
			return msg.reply.from.id
		elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%w?%s(@[%w_]+)%s?') then
			local username = msg.text:match('%s(@[%w_]+)')
			local id = utilities.misc.resolve_user(username)
			if not id then
				return false, "I've never seen this user before.\n"
					.. "If you want to teach me who is he, forward me a message from him"
			else
				return id
			end
		elseif msg.mention_id then
			return msg.mention_id
		elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%w?%s(%d+)') then
			local id = msg.text:match(config.cmd..'%w%w%w%w?%w?%w?%s(%d+)')
			return id
		else
			return false, "I've never seen this user before.\n"
					.. "If you want to teach me who is he, forward me a message from him"
		end
	end
end

function utilities.misc.logEvent(event, msg, extra)
	local log_id = db:hget('bot:chatlogs', msg.chat.id)
	--vardump(extra)
	
	if not log_id then return end
	local is_loggable = db:hget('chat:'..msg.chat.id..':tolog', event)
	if not is_loggable or is_loggable == 'no' then return end
	
	local text, reply_markup
	
	local chat_info = _("<b>Chat</b>: %s [#chat%d]"):format(msg.chat.title:escape_html(), msg.chat.id * -1)
	
	local member = ("%s [@%s] [#id%d]"):format(msg.from.first_name:escape_html(), msg.from.username or '-', msg.from.id)
	if event == 'mediawarn' then
		--MEDIA WARN
		--warns n°: warns
		--warns max: warnmax
		--media type: media
		text = ('#MEDIAWARN (<code>%d/%d</code>), %s\n• %s\n• <b>User</b>: %s'):format(extra.warns, extra.warnmax, extra.media, chat_info, member)
		if extra.hammered then text = text..('\n#%s'):format(extra.hammered:upper()) end
	elseif event == 'spamwarn' then
		--SPAM WARN
		--warns n°: warns
		--warns max: warnmax
		--media type: spam_type
		text = ('#SPAMWARN (<code>%d/%d</code>), <i>%s</i>\n• %s\n• <b>User</b>: %s'):format(extra.warns, extra.warnmax, extra.spam_type, chat_info, member)
		if extra.hammered then text = text..('\n#%s'):format(extra.hammered:upper()) end
	elseif event == 'flood' then
		--FLOOD
		--hammered?: hammered
		text = ('#FLOOD\n• %s\n• <b>User</b>: %s'):format(chat_info, member)
		if extra.hammered then text = text..('\n#%s'):format(extra.hammered:upper()) end
	elseif event == 'new_chat_photo' then
		text = _('%s\n• %s\n• <b>By</b>: %s'):format('#NEWPHOTO', chat_info, member)
		reply_markup = {inline_keyboard={{{text = _("Get the new photo"), url = ("telegram.me/%s?start=photo:%s"):format(bot.username, msg.new_chat_photo[#msg.new_chat_photo].file_id)}}}}
	elseif event == 'delete_chat_photo' then
		text = _('%s\n• %s\n• <b>By</b>: %s'):format('#PHOTOREMOVED', chat_info, member)
	elseif event == 'new_chat_title' then
		text = _('%s\n• %s\n• <b>By</b>: %s'):format('#NEWTITLE', chat_info, member)
	elseif event == 'pinned_message' then
		text = _('%s\n• %s\n• <b>By</b>: %s'):format('#PINNEDMSG', chat_info, member)
		msg.message_id = msg.pinned_message.message_id --because of the "go to the message" link. The normal msg.message_id brings to the service message
	elseif event == 'report' then
		text = _('%s\n• %s\n• <b>By</b>: %s\n• <i>Reported to %d admin(s)</i>'):format('#REPORT', chat_info, member, extra.n_admins)
	elseif event == 'new_chat_member' then
		local member = ("%s [@%s] [#id%d]"):format(msg.new_chat_member.first_name:escape_html(), msg.new_chat_member.username or '-', msg.new_chat_member.id)
		text = _('%s\n• %s\n• <b>User</b>: %s'):format('#NEW_MEMBER', chat_info, member)
		if extra then --extra == msg.from
			text = text.._("\n• <b>Added by</b>: %s [#id%d]"):format(utilities.misc.getname_final(extra), extra.id)
		end
	else
		-- events that requires user + admin
		if event == 'warn' then
			--WARN
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			--warns n°: warns
			--warns max: warnmax
			--motivation: motivation
			text = _('#%s\n• <b>Admin</b>: %s [#id%d]\n• %s\n• <b>User</b>: %s [#id%d]\n• <b>Count</b>: <code>%d/%d</code>'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, extra.user_id, extra.warns, extra.warnmax)
			if extra.hammered then
				text = text.._('\n<b>Action</b>: <i>%s</i>'):format(extra.hammered)
			end
		elseif event == 'nowarn' then
			--WARNS REMOVED
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			local event_nowarn = _("WARNS_RESET")
			text = _('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]'):format(event_nowarn, extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id))
		elseif event == 'tempban' then
			--TEMPBAN
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			--days: d
			--hours: h
			--motivation: motivation
			text = _('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]\n• <b>Duration</b>: %d days, %d hours'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id), extra.d, extra.h)
		else --ban or kick
			--BAN OR KICK
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			--motivation: motivation
			text = _('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id))
		end
		if event == 'ban' or event == 'tempban' then
			--logcb:unban:user_id:chat_id for ban, logcb:untempban:user_id:chat_id for tempban
			reply_markup = {inline_keyboard={{{text = _("Unban"), callback_data = ("logcb:un%s:%d:%d"):format(event, extra.user_id, msg.chat.id)}}}}
		end
		if extra.motivation then
			text = text..('\n• <i>%s</i>'):format(extra.motivation:escape_html())
		end
	end
	if msg.chat.username then
		text = text..('\n• <a href="telegram.me/%s/%d">%s</a>'):format(msg.chat.username, msg.message_id, _('Go to the message'))
	end
	
	if text then
		api.sendMessage(log_id, text, 'html', reply_markup)
	end
end

function utilities.misc.saveBan(user_id, motivation)
	local hash = 'ban:'..user_id
	return db:hincrby(hash, motivation, 1)
end

function utilities.misc.is_info_message_key(key)
    if key == 'Extra' or key == 'Rules' then
        return true
    else
        return false
    end
end

function utilities.misc.table2keyboard(t)
	local keyboard = {inline_keyboard = {}}
    for i, line in pairs(t) do
        if type(line) ~= 'table' then return false, 'Wrong structure (each line need to be a table, not a single value)' end
        local new_line ={}
        for k,v in pairs(line) do
            if type(k) ~= 'string' then return false, 'Wrong structure (table of arrays)' end
            local button = {}
            button.text = k
            button.callback_data = v
            table.insert(new_line, button)
        end
        table.insert(keyboard.inline_keyboard, new_line)
    end
    
    return keyboard
end

return utilities
