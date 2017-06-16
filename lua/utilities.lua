db = dofile('lua/database.lua') -- Load database abstraction layer

-- utilities.lua
-- Functions shared among plugins.

local utilities = {}

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

-- Rank related functions
-- returns true if user rank is equal to or higher than
function utilities.least_rank(least, chat_id, user_id)
	if type(chat_id) == 'table' then
		local msg = chat_id
		local chat_id = msg.chat.id
		local user_id = msg.from.id
	end
	-- local set = 'cache:chat:'..chat_id..':admins'
	-- TODO: check if adminlist hasn't "expired"
	-- if not db:exists(set) then
	utilities.cache_adminlist(chat_id, res)
	-- end
	local rank = db.getvcu(chat_id, user_id, 'rank')
	if rank == least or rank == 'owner' then
		return true
	elseif rank == 'admin' and least == 'mod' then
		return true
	else
		return false
	end
end

-- Chat related functions
function utilities.get_chat(val, chat_id) -- TODO: remove this function
	local result = db.getvchat(chat_id, val)
	if val == 'silentmode' then
		return result
	elseif val == 'rules' then
		if not val then
			return ("-*empty*-")
		else
			return val
		end
	end
	return val
end

function utilities.is_allowed(action, chat_id, user_obj)
	--[[ACTION

	"hammer": hammering functions (/ban, /kick, /tempban, /warn, /nowarn, /status, /user)
	"config": managing the group settings (read: /config command)
	"texts": getting the basic informations of the group (/rules, /adminlis, /modlist, #extras)]]

	if not user_obj.mod and not user_obj.admin then return end
	if user_obj.admin then return true end

	return getval('chat_mod', action, 'chatid', chat_id) == 't'
end

function utilities.is_superadmin(user_id)
	for i=1, #config.superadmins do
		if tonumber(user_id) == config.superadmins[i] then
			return true
		end
	end
	return false
end

function utilities.bot_is_admin(chat_id)
	local status = api.getChatMember(chat_id, bot:get('id')).result.status
	if not(status == 'administrator') then
		return false
	else
		return true
	end
end

function utilities.is_admin_request(msg)
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

function utilities.is_owner_request(msg)
	local status = api.getChatMember(msg.chat.id, msg.from.id).result.status
	if status == 'creator' then
		return true
	else
		return false
	end
end

function utilities.add_role(chat_id, user_obj)
	user_obj.admin = utilities.is_admin(chat_id, user_obj.id)
	user_obj.mod = utilities.is_mod(chat_id, user_obj.id)

	return user_obj
end

function utilities.cache_adminlist(chat_id)
	local res, code = api.getChatAdministrators(chat_id)
	if not res then
		return false, code
	end

	for _, admin in pairs(res.result) do
		db.initgroup(chat_id) -- Looks like sometimes the chat row doesn't exist when saving new members
		-- TODO: save admin username BEFORE creating the chat_use table
		db.setvusers(admin.user.id, 'username', "'unknown'")
		if admin.status == 'creator' then
			db.setvcu(chat_id, admin.user.id, 'rank', "'owner'") -- Save owner
		else
			db.setvcu(chat_id, admin.user.id, 'rank', "'admin'") -- Add admins
		end
	end

	-- TODO: figure out a way to "expire" the admin list
	-- db:expire(set, config.bot_settings.cache_time.adminlist)

	return true, #res.result or 0
end

function utilities.get_cached_admins_list(chat_id, second_try)
	local hash = 'cache:chat:'..chat_id..':admins'
	local list = db:smembers(hash)
	if not list or not next(list) then
		utilities.cache_adminlist(chat_id)
		if not second_try then
			return utilities.get_cached_admins_list(chat_id, true)
		else
			return false
		end
	else
		return list
	end
end

function utilities.is_blocked_global(user_id)
	return db.getvusers(user_id, 'blocked')
end

function string:trim() -- Trims whitespace from a string.
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

function utilities.dump(...)
	for _, value in pairs{...} do
		ngx.log(ngx.NOTICE,serpent.block(value, {comment=false}))
	end
end

function utilities.vtext(...)
	local lines = {}
	for _, value in pairs{...} do
		table.insert(lines, serpent.block(value, {comment=false}))
	end
	return table.concat(lines, '\n')
end

function utilities.download_to_file(url, file_path)
	ngx.log(ngx.NOTICE,"url to download: "..url)
	local respbody = {}
	local options = {
		url = url,
		sink = ltn12.sink.table(respbody),
		redirect = true
	}
	-- nil, code, headers, status
	local response = nil
	options.redirect = false
	response = {HTTPS.request(options)}
	local code = response[2]
	local headers = response[3]
	local status = response[4]
	if code ~= 200 then return false, code end
	ngx.log(ngx.NOTICE,"Saved to: "..file_path)
	file = io.open(file_path, "w+")
	file:write(table.concat(respbody))
	file:close()
	return file_path, code
end

function utilities.telegram_file_link(res)
	--res = table returned by getFile()
	return "https://api.telegram.org/file/bot"..config.api_token.."/"..res.result.file_path
end

function utilities.deeplink_constructor(chat_id, what)
	return 'https://telegram.me/'..bot:get('username')..'?start='..chat_id..'_'..what
end

function utilities.get_date(timestamp)
	if not timestamp then
		timestamp = os.time()
	end
	return os.date('%d/%m/%y', timestamp)
end

-- Resolves username. Returns ID of user if it was early stored in date base.
-- Argument username must begin with symbol @ (commercial 'at')
function utilities.resolve_user(username)
	assert(username:byte(1) == string.byte('@'))
	username = username:lower()

	local stored_id = tonumber(db:hget('bot:usernames', username))
	if not stored_id then return false end
	local user_obj = api.getChat(stored_id)
	if not user_obj then
		return stored_id
	else
		if not user_obj.result.username then return stored_id end
	end

	-- User could change his username
	if username ~= '@' .. user_obj.result.username:lower() then
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

function utilities.get_sm_error_string(code)
	local hyperlinks_text = ('More info [here](https://telegram.me/GB_tutorials/12)')
	local descriptions = {
		[109] = ("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(hyperlinks_text),
		[141] = ("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(hyperlinks_text),
		[142] = ("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(hyperlinks_text),
		[112] = ("This text breaks the markdown.\n"
					.. "More info about a proper use of markdown "
					.. "[here](https://telegram.me/GB_tutorials/10) and [here](https://telegram.me/GB_tutorials/12)."),
		[118] = ('This message is too long. Max lenght allowed by Telegram: 4000 characters'),
		[146] = ('One of the URLs that should be placed in an inline button seems to be invalid (not an URL). Please check it'),
		[137] = ("One of the inline buttons you are trying to set is missing the URL"),
		[149] = ("One of the inline buttons you are trying to set doesn't have a name"),
		[115] = ("Please input a text")
	}

	return descriptions[code] or ("Text not valid: unknown formatting error")
end

function string:escape_magic()
	self = self:gsub('%%', '%%%%')
	self = self:gsub('%-', '%%-')
	self = self:gsub('%?', '%%?')

	return self
end

function utilities.reply_markup_from_text(text)
	local clean_text = text
	local n = 0
	local reply_markup = {inline_keyboard={}}
	for label, url in text:gmatch("{{(.-)}{(.-)}}") do
		clean_text = clean_text:gsub('{{'..label:escape_magic()..'}{'..url:escape_magic()..'}}', '')
		if label and url and n < 3 then
			local line = {{text = label, url = url}}
			table.insert(reply_markup.inline_keyboard, line)
		end
		n = n + 1
	end
	if not next(reply_markup.inline_keyboard) then reply_markup = nil end

	return reply_markup, clean_text
end

function utilities.demote(chat_id, user_id)
	-- chat_id, user_id = tonumber(chat_id), tonumber(user_id)
	-- db:del(('chat:%d:mod:%d'):format(chat_id, user_id))
	-- local removed = db:srem('chat:'..chat_id..':mods', user_id)
	-- return removed == 1
	local removed = db.setvcu(chat_id, user_id, 'rank', "'user'")
	return removed < 0 -- Checks if the number of affected rows is greater than 0
end

function utilities.get_media_type(msg)
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

function utilities.get_media_id(msg)
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

function utilities.migrate_chat_info(old, new, on_request)
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

	for _, hash_name in pairs(config.chat_hashes) do
		local old_t = db:hgetall('chat:'..old..':'..hash_name)
		if next(old_t) then
			for key, val in pairs(old_t) do
				db:hset('chat:'..new..':'..hash_name, key, val)
			end
		end
	end

	for i=1, #config.chat_sets do
		local old_t = db:smembers('chat:'..old..':'..config.chat_sets[i])
		if next(old_t) then
			db:sadd('chat:'..new..':'..config.chat_sets[i], table.unpack(old_t))
		end
	end

	if on_request then
		api.sendReply(msg, 'Should be done')
	end
end

-- Perform substitution of placeholders in the text according given the message.
-- The second argument can be the flag to avoid the escape, if it's set, the
-- markdown escape isn't performed. In any case the following arguments are
-- considered as the sequence of strings - names of placeholders. If
-- placeholders to replacing are specified, this function processes only them,
-- otherwise it processes all available placeholders.
function string:replaceholders(msg, ...)
	if msg.new_chat_member then
		msg.from = msg.new_chat_member
	elseif msg.left_chat_member then
		msg.from = msg.left_chat_member
	end

	local tail_arguments = {...}
	-- check that the second argument is a boolean and true
	local non_escapable = tail_arguments[1] == true

	local replace_map
	if non_escapable then
		replace_map = {
			name = msg.from.first_name,
			surname = msg.from.last_name and msg.from.last_name or '',
			username = msg.from.username and '@'..msg.from.username or '-',
			id = msg.from.id,
			title = msg.chat.title,
			rules = utilities.deeplink_constructor(msg.chat.id, 'rules'),
		}
		-- remove flag about escaping
		table.remove(tail_arguments, 1)
	else
		replace_map = {
			name = msg.from.first_name:escape(),
			surname = msg.from.last_name and msg.from.last_name:escape() or '',
			username = msg.from.username and '@'..msg.from.username:escape() or '-',
			userorname = msg.from.username and '@'..msg.from.username:escape() or msg.from.first_name:escape(),
			id = msg.from.id,
			title = msg.chat.title:escape(),
			rules = utilities.deeplink_constructor(msg.chat.id, 'rules'),
		}
	end

	local substitutions = next(tail_arguments) and {} or replace_map
	for _, placeholder in pairs(tail_arguments) do
		substitutions[placeholder] = replace_map[placeholder]
	end

	return self:gsub('$(%w+)', substitutions)
end

-- Return user mention for output a text
function utilities.getname_final(user)
	return utilities.getname_link(user.first_name, user.username) or '<code>'..user.first_name:escape_html()..'</code>'
end

-- Return link to user profile or false, if he doesn't have login
function utilities.getname_link(name, username)
	if not name or not username then return nil end
	username = username:gsub('@', '')
	return ('<a href="%s">%s</a>'):format('https://telegram.me/'..username, name:escape_html())
end

function utilities.bash(str)
	local cmd = io.popen(str)
	local result = cmd:read('*all')
	cmd:close()
	return result
end

function utilities.telegram_file_link(res)
	--res = table returned by getFile()
	return "https://api.telegram.org/file/bot"..config.bot_api_key.."/"..res.result.file_path
end

function utilities.getAdminlist(chat_id)
	local list, code = api.getChatAdministrators(chat_id)
	if not list then
		return false, code
	end
	local creator = ''
	local adminlist = ''
	local count = 1
	for i,admin in pairs(list.result) do
		local name
		local s = ' ├ '
		if admin.status == 'administrator' or admin.status == 'moderator' then
			name = admin.user.first_name
			if admin.user.username then
				name = ('<a href="telegram.me/%s">%s</a>'):format(admin.user.username, name:escape_html())
			else
				name = name:escape_html()
			end
			if count + 1 == #list.result then s = ' └ ' end
			adminlist = adminlist..s..name..'\n'
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

	return ("<b>👤 Creator</b>\n└ %s\n\n<b>👥 Admins</b> (%d)\n%s"):format(creator, #list.result - 1, adminlist)
end

local function get_list_name(chat_id, user_id)
	local user = db:hgetall(('chat:%d:mod:%d'):format(chat_id, tonumber(user_id)))
	if not user.first_name then return false end
	return utilities.getname_final(user) or 'x'
end

function utilities.getModlist(chat_id)
	local mods = db:smembers('chat:'..chat_id..':mods')
	local text
	if not next(mods) then
		return false, ("<i>Empty moderators list</i>")
	else
		local list_name
		local modlist = {}
		local s = ' ├ '
		text = ("<b>👥 Moderators (%d)</b>\n"):format(#mods)
		for i=1, #mods do
			list_name = get_list_name(chat_id, mods[i]) or ('<code>unknown name</code>') --mods[i] -> string
			if i == #mods then s = ' └ ' end
			table.insert(modlist, s..list_name)
		end

		text = text..table.concat(modlist, '\n')

		return true, text
	end
end

local function sort_funct(a, b)
	ngx.log(ngx.NOTICE,a, b)
return a:gsub('#', '') < b:gsub('#', '') end

function utilities.getExtraList(chat_id)
	local hash = 'chat:'..chat_id..':extra'
	local commands = db:hkeys(hash)
	if not next(commands) then
		return ("No commands set")
	else
		local lines = {}
		for i, k in ipairs(commands) do
			table.insert(lines, (k:escape(true)))
		end
		return ("List of *custom commands*:\n") .. table.concat(lines, '\n')
	end
end

function utilities.getSettings(chat_id)
	local hash = 'chat:'..chat_id..':settings'

	local lang = db:get('lang:'..chat_id) or 'en' -- group language
	local message = ("Current settings for *the group*:\n\n")
			.. ("*Language*: %s\n"):format(config.available_languages[lang])

	--build the message
	local strings = {
		Welcome = ("Welcome message"),
		Goodbye = ("Goodbye message"),
		Extra = ("Extra"),
		Flood = ("Anti-flood"),
		Antibot = ("Ban bots"),
		Silent = ("Silent mode"),
		Rules = ("Rules"),
		Arab = ("Arab"),
		Rtl = ("RTL"),
		Reports = ("Reports"),
		Welbut = ("Welcome button")
	}
	for key, default in pairs(config.chat_settings['settings']) do

		local off_icon, on_icon = '🚫', '✅'
		if utilities.is_info_message_key(key) then
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
		message = message .. ("*Welcome type*: `GIF / sticker`\n")
	elseif type == 'custom' then
		message = message .. ("*Welcome type*: `custom message`\n")
	elseif type == 'no' then
		message = message .. ("*Welcome type*: `default message`\n")
	end

	local warnmax_std = (db:hget('chat:'..chat_id..':warnsettings', 'max')) or config.chat_settings['warnsettings']['max']
	local warnmax_media = (db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or config.chat_settings['warnsettings']['mediamax']

	return message .. ("Warns (`standard`): *%s*\n"):format(warnmax_std)
				 .. ("Warns (`media`): *%s*\n\n"):format(warnmax_media)
				 .. ("✅ = _enabled / allowed_\n")
				 .. ("🚫 = _disabled / not allowed_\n")
				 .. ("👥 = _sent in group (always for admins)_\n")
				 .. ("👤 = _sent in private_")
end

function utilities.changeSettingStatus(chat_id, field)
	local turned_off = {
		reports = ("@admin command disabled"),
		welcome = ("Welcome message won't be displayed from now"),
		goodbye = ("Goodbye message won't be displayed from now"),
		extra = ("#extra commands are now available only for moderator"),
		flood = ("Anti-flood is now off"),
		rules = ("/rules will reply in private (for users)"),
		silent = ("Silent mode is now off"),
		preview = ("Links preview disabled"),
		welbut = ("Welcome message without a button for the rules")
	}
	local turned_on = {
		reports = ("@admin command enabled"),
		welcome = ("Welcome message will be displayed"),
		goodbye = ("Goodbye message will be displayed"),
		extra = ("#extra commands are now available for all"),
		flood = ("Anti-flood is now on"),
		rules = ("/rules will reply in the group (with everyone)"),
		silent = ("Silent mode is now on"),
		preview = ("Links preview enabled"),
		welbut = ("The welcome message will have a button for the rules")
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
				return ("This setting is enabled, but the goodbye message won't be displayed in large groups, "
					.. "because I can't see service messages about left members"), true
			end
		end
		return turned_on[field:lower()]
	end
end

function utilities.changeMediaStatus(chat_id, media, new_status)
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
	return ("New status = %s"):format(new_status_icon), true
end

function utilities.sendStartMe(msg)
	local keyboard = {inline_keyboard = {{{text = ("Start me"), url = 'https://telegram.me/'..bot:get('username')}}}}
	api.sendMessage(msg.chat.id, ("_Please message me first so I can message you_"), true, keyboard)
end

function utilities.initGroup(chat_id)
	db.initgroup(chat_id)
	utilities.cache_adminlist(chat_id, api.getChatAdministrators(chat_id)) --init admin cache
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

local function empty_modlist(chat_id)
	local set = 'chat:'..chat_id..':mods'
	local mods = db:smembers(set)
	if next(mods) then
		local hash = ('chat:%d:mod:%d'):format(tonumber(chat_id), tonumber(mods[i]))
		for i=1, #mods do
			db:del(hash)
		end
	end

	db:del(set)
end

function utilities.remGroup(chat_id, full, converted_to_realm)
	db.delchat(chat_id)
end

function utilities.getnames_complete(msg, blocks)
	local admin, kicked

	admin = utilities.getname_link(msg.from.first_name, msg.from.username) or ("<code>%s</code>"):format(msg.from.first_name:escape_html())

	if msg.reply then
		kicked = utilities.getname_link(msg.reply.from.first_name, msg.reply.from.username) or ("<code>%s</code>"):format(msg.reply.from.first_name:escape_html())
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

function utilities.get_user_id(msg, blocks)
	--if no user id: returns false and the msg id of the translation for the problem
	if not msg.reply and not blocks[2] then
		return false, ("Reply to someone")
	else
		if msg.reply then
			if msg.reply.new_chat_member then
				msg.reply.from = msg.reply.new_chat_member
			end
			return msg.reply.from.id
		elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%w?%s(@[%w_]+)%s?') then
			local username = msg.text:match('%s(@[%w_]+)')
			local id = utilities.resolve_user(username)
			if not id then
				return false, ("I've never seen this user before.\nIf you want to teach me who is he, forward me a message from him")
			else
				return id
			end
		elseif msg.mention_id then
			return msg.mention_id
		elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%w?%s(%d+)') then
			local id = msg.text:match(config.cmd..'%w%w%w%w?%w?%w?%s(%d+)')
			return id
		else
			return false, ("I've never seen this user before.\nIf you want to teach me who is he, forward me a message from him")
		end
	end
end

function utilities.logEvent(event, msg, extra)
	-- local log_id = db:hget('bot:chatlogs', msg.chat.id)
	-- --utilities.dump(extra)

	-- if not log_id then return end
	-- local is_loggable = db:hget('chat:'..msg.chat.id..':tolog', event)
	-- if not is_loggable or is_loggable == 'no' then return end

	-- local text, reply_markup


	-- local chat_info = ("<b>Chat</b>: %s [#chat%d]"):format(msg.chat.title:escape_html(), msg.chat.id * -1)
	-- local member = ("%s [@%s] [#id%d]"):format(msg.from.first_name:escape_html(), msg.from.username or '-', msg.from.id)
	-- if event == 'mediawarn' then
	-- 	--MEDIA WARN
	-- 	--warns n°: warns
	-- 	--warns max: warnmax
	-- 	--media type: media
	-- 	text = ('#MEDIAWARN (<code>%d/%d</code>), %s\n• %s\n• <b>User</b>: %s'):format(extra.warns, extra.warnmax, extra.media, chat_info, member)
	-- 	if extra.hammered then text = text..('\n#%s'):format(extra.hammered:upper()) end
	-- elseif event == 'spamwarn' then
	-- 	--SPAM WARN
	-- 	--warns n°: warns
	-- 	--warns max: warnmax
	-- 	--media type: spam_type
	-- 	text = ('#SPAMWARN (<code>%d/%d</code>), <i>%s</i>\n• %s\n• <b>User</b>: %s'):format(extra.warns, extra.warnmax, extra.spam_type, chat_info, member)
	-- 	if extra.hammered then text = text..('\n#%s'):format(extra.hammered:upper()) end
	-- elseif event == 'flood' then
	-- 	--FLOOD
	-- 	--hammered?: hammered
	-- 	text = ('#FLOOD\n• %s\n• <b>User</b>: %s'):format(chat_info, member)
	-- 	if extra.hammered then text = text..('\n#%s'):format(extra.hammered:upper()) end
	-- elseif event == 'cleanmods' then
	-- 	text = ('%s\n• %s\n• <b>By</b>: %s'):format('#CLEAN_MODLIST', chat_info, extra.admin)
	-- elseif event == 'new_chat_photo' then
	-- 	text = ('%s\n• %s\n• <b>By</b>: %s'):format('#NEWPHOTO', chat_info, member)
	-- 	reply_markup = {inline_keyboard={{{text = ("Get the new photo"), url = ("telegram.me/%s?start=photo:%s"):format(bot:get('username'), msg.new_chat_photo[#msg.new_chat_photo].file_id)}}}}
	-- elseif event == 'delete_chat_photo' then
	-- 	text = ('%s\n• %s\n• <b>By</b>: %s'):format('#PHOTOREMOVED', chat_info, member)
	-- elseif event == 'new_chat_title' then
	-- 	text = ('%s\n• %s\n• <b>By</b>: %s'):format('#NEWTITLE', chat_info, member)
	-- elseif event == 'pinned_message' then
	-- 	text = ('%s\n• %s\n• <b>By</b>: %s'):format('#PINNEDMSG', chat_info, member)
	-- 	msg.message_id = msg.pinned_message.message_id --because of the "go to the message" link. The normal msg.message_id brings to the service message
	-- elseif event == 'report' then
	-- 	text = ('%s\n• %s\n• <b>By</b>: %s\n• <i>Reported to %d admin(s)</i>'):format('#REPORT', chat_info, member, extra.n_admins)
	-- elseif event == 'blockban' then
	-- 	text = ('#BLOCKBAN\n• %s\n• <b>User</b>: %s [#id%d]'):format(chat_info, extra.name, extra.id)
	-- elseif event == 'new_chat_member' then
	-- 	local member = ("%s [@%s] [#id%d]"):format(msg.new_chat_member.first_name:escape_html(), msg.new_chat_member.username or '-', msg.new_chat_member.id)
	-- 	text = ('%s\n• %s\n• <b>User</b>: %s'):format('#NEW_MEMBER', chat_info, member)
	-- 	if extra then --extra == msg.from
	-- 		text = text..("\n• <b>Added by</b>: %s [#id%d]"):format(utilities.getname_final(extra), extra.id)
	-- 	end
	-- else
	-- 	-- events that requires user + admin
	-- 	if event == 'warn' then
	-- 		--WARN
	-- 		--admin name formatted: admin
	-- 		--user name formatted: user
	-- 		--user id: user_id
	-- 		--warns n°: warns
	-- 		--warns max: warnmax
	-- 		--motivation: motivation
	-- 		text = ('#%s\n• <b>Admin</b>: %s [#id%d]\n• %s\n• <b>User</b>: %s [#id%d]\n• <b>Count</b>: <code>%d/%d</code>'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, extra.user_id, extra.warns, extra.warnmax)
	-- 		if extra.hammered then
	-- 			text = text..('\n<b>Action</b>: <i>%s</i>'):format(extra.hammered)
	-- 		end
	-- 	elseif event == 'nowarn' then
	-- 		--WARNS REMOVED
	-- 		--admin name formatted: admin
	-- 		--user name formatted: user
	-- 		--user id: user_id
	-- 		text = ('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]\n• <b>Warns found</b>: <i>normal: %s, for media: %s, spamwarns: %s</i>')
	-- 			:format('WARNS_RESET', extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id), extra.rem.normal, extra.rem.media, extra.rem.spam)
	-- 	elseif event == 'promote' or event == 'demote' then
	-- 		--PROMOTE OR DEMOTE
	-- 		--admin name formatted: admin
	-- 		--user name formatted: user
	-- 		--user id: user_id
	-- 		text = ('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>Moderator</b>: %s [#id%s]'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id))
	-- 	elseif event == 'block' or event == 'unblock' then
	-- 		text = ('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n'):format(event:upper(), utilities.getname_final(msg.from), msg.from.id, chat_info)
	-- 		if extra.n then
	-- 			text = text..('• <i>Users involved: %d</i>'):format(extra.n)
	-- 		elseif extra.user then
	-- 			text = text..('• <b>User</b>: %s [#id%d]'):format(extra.user, msg.reply.forward_from.id)
	-- 		end
	-- 	elseif event == 'tempban' then
	-- 		--TEMPBAN
	-- 		--admin name formatted: admin
	-- 		--user name formatted: user
	-- 		--user id: user_id
	-- 		--days: d
	-- 		--hours: h
	-- 		--motivation: motivation
	-- 		text = ('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]\n• <b>Duration</b>: %d days, %d hours'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id), extra.d, extra.h)
	-- 	else --ban or kick or unban
	-- 		--BAN OR KICK OR UNBAN
	-- 		--admin name formatted: admin
	-- 		--user name formatted: user
	-- 		--user id: user_id
	-- 		--motivation: motivation
	-- 		text = ('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]'):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id))
	-- 	end
	-- 	if event == 'ban' or event == 'tempban' then
	-- 		--logcb:unban:user_id:chat_id for ban, logcb:untempban:user_id:chat_id for tempban
	-- 		reply_markup = {inline_keyboard={{{text = ("Unban"), callback_data = ("logcb:un%s:%d:%d"):format(event, extra.user_id, msg.chat.id)}}}}
	-- 	end
	-- 	if extra.motivation then
	-- 		text = text..('\n• <i>%s</i>'):format(extra.motivation:escape_html())
	-- 	end
	-- end
	-- if msg.chat.username then
	-- 	text = text..('\n• <a href="telegram.me/%s/%d">%s</a>'):format(msg.chat.username, msg.message_id, ('Go to the message'))
	-- end

	-- if text then
	-- 	local res, code = api.sendMessage(log_id, text, 'html', reply_markup)
	-- 	if not res and code == 117 then
	-- 		db:hdel('bot:chatlogs', msg.chat.id)
	-- 	end
	-- end
end

function utilities.is_info_message_key(key)
	if key == 'Extra' or key == 'Rules' then
		return true
	else
		return false
end
end

return utilities
