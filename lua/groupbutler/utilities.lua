local json = require "cjson"
local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local api_err = require "groupbutler.api_errors"
local locale = require "groupbutler.languages"
local log = require "groupbutler.logging"
local null = require "groupbutler.null"
local i18n = locale.translate
local http, HTTPS, ltn12, time_hires, sleep
if ngx then
	http = require "resty.http"
	time_hires = ngx.now
	sleep = ngx.sleep
else
	HTTPS = require "ssl.https"
	ltn12 = require "ltn12"
	local socket = require "socket"
	time_hires = socket.gettime
	sleep = socket.sleep
end

local _M = {} -- Functions shared among plugins

function _M:new(update_obj)
	local utilities_obj = {
		db = update_obj.db,
		bot = update_obj.bot
	}
	setmetatable(utilities_obj, {__index = self})
	return utilities_obj
end

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

-- API helper functions

function _M:sendReply(msg, text, parse_mode, disable_web_page_preview, disable_notification, reply_markup) -- luacheck: ignore 212
	return api.sendMessage(msg.chat.id, text, parse_mode, disable_web_page_preview, disable_notification,
		msg.message_id, reply_markup)
end

function _M:banUser(chat_id, user_id, until_date) -- luacheck: ignore 212
	local ok, err = api.kickChatMember(chat_id, user_id, until_date) --try to kick. "code" is already specific
	if ok then --if the user has been kicked, then...
		return ok --return res and not the text
	else
		return nil, api_err.trans(err)
	end
end

function _M:kickUser(chat_id, user_id) -- luacheck: ignore 212
	local ok, err = api.kickChatMember(chat_id, user_id) --try to kick
	if ok then --if the user has been kicked, then unban...
		api.unbanChatMember(chat_id, user_id)
		return ok
	else
		return nil, api_err.trans(err)
	end
end

function _M:muteUser(chat_id, user_id) -- luacheck: ignore 212
	local ok, err = api.restrictChatMember({
		chat_id = chat_id,
		user_id = user_id,
		can_send_messages = false
	})
	if ok then
		return ok
	else
		return nil, api_err.trans(err)
	end
end

-- Strings

-- Escape markdown for Telegram. This function makes non-clickable usernames,
-- hashtags, commands, links and emails, if only_markup flag isn't setted.
function string:escape(only_markup)
	if not only_markup then
		-- insert word joiner
		self = self:gsub('([@#/.])(%w)', '%1\226\129\160%2')
	end
	return self:gsub('[*_`[]', '\\%0')
end

function string:escape_html()
	self = self:gsub('&', '&amp;')
	self = self:gsub('"', '&quot;')
	self = self:gsub('<', '&lt;'):gsub('>', '&gt;')
	return self
end

-- Remove specified formating or all markdown. This function useful for putting names into message.
-- It seems not possible send arbitrary text via markdown.
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

function string:trim() -- Trim whitespace from a string
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

function string:escape_magic()
	self = self:gsub('%%', '%%%%')
	self = self:gsub('%-', '%%-')
	self = self:gsub('%?', '%%?')

	return self
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

	msg.chat.title = msg.chat.title and msg.chat.title or '-'

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
			-- rules = self:deeplink_constructor(msg.chat.id, 'rules'),
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
			-- rules = self:deeplink_constructor(msg.chat.id, 'rules'),
		}
	end

	local substitutions = next(tail_arguments) and {} or replace_map
	for _, placeholder in pairs(tail_arguments) do
		substitutions[placeholder] = replace_map[placeholder]
	end

	return self:gsub('$(%w+)', substitutions)
end

function _M:is_allowed(_, chat_id, user_obj) -- action is not used anymore
	return self:is_admin(chat_id, user_obj.id)
end

function _M:can(chat_id, user_id, permission)
	local db = self.db
	local set = ("cache:chat:%s:%s:permissions"):format(chat_id, user_id)

	local set_admins = 'cache:chat:'..chat_id..':admins'
	if db:exists(set_admins) == 0 then
		self:cache_adminlist(chat_id)
	end

	return db:sismember(set, permission) ~= 0
end

function _M:is_superadmin(user_id) -- luacheck: ignore 212
	for i=1, #config.superadmins do
		if tonumber(user_id) == config.superadmins[i] then
			return true
		end
	end
	return false
end

function _M:bot_is_admin(chat_id)
	local bot = self.bot
	local status = api.getChatMember(chat_id, bot.id).status
	if not(status == 'administrator') then
		return false
	else
		return true
	end
end

function _M:is_admin_request(msg) -- luacheck: ignore 212
	local res = api.getChatMember(msg.chat.id, msg.from.id)
	if not res then
		return false, false
	end
	local status = res.status
	if status == 'creator' or status == 'administrator' then
		return true, true
	else
		return false, true
	end
end

-- Returns the admin status of the user. The first argument can be the message,
-- then the function checks the rights of the sender in the incoming chat.
function _M:is_admin(chat_id, user_id)
	local db = self.db
	if type(chat_id) == 'table' then
		local msg = chat_id
		chat_id = msg.chat.id
		user_id = msg.from.id
	end

	local set = 'cache:chat:'..chat_id..':admins'
	if db:exists(set) == 0 then
		self:cache_adminlist(chat_id)
	end
	return db:sismember(set, user_id) ~= 0
end

function _M:is_owner_request(msg) -- luacheck: ignore 212
	local status = api.getChatMember(msg.chat.id, msg.from.id).status
	if status == 'creator' then
		return true
	end
		return false
end

function _M:is_owner(chat_id, user_id)
	local db = self.db
	if type(chat_id) == 'table' then
		local msg = chat_id
		chat_id = msg.chat.id
		user_id = msg.from.id
	end

	local hash = 'cache:chat:'..chat_id..':owner'
	local owner_id
	local res = true
	repeat
		owner_id = db:get(hash)
		if owner_id == null then
			res = self:cache_adminlist(chat_id)
		end
	until owner_id ~= null or not res

	if owner_id then
		if tonumber(owner_id) == tonumber(user_id) then
			return true
		end
	end

	return false
end

local admins_permissions = {
	can_change_info = true,
	can_delete_messages = true,
	can_invite_users = true,
	can_restrict_members = true,
	can_pin_messages = true,
	can_promote_member = true
}

local function set_creator_permissions(self, chat_id, user_id)
	local db = self.db
	local set = ("cache:chat:%s:%s:permissions"):format(chat_id, user_id)
	for k, _ in pairs(admins_permissions) do
		db:sadd(set, k)
	end
end

function _M:cache_adminlist(chat_id)
	local db = self.db

	local lock_key = "cache:chat:"..chat_id..":getadmin_lock"
	local set = 'cache:chat:'..chat_id..':admins'

	if db:exists(lock_key) == 1 then
		while db:exists(set) == 0 and db:exists(lock_key) == 1 do
			sleep(0.1)
		end
		if db:exists(set) == 1 then
			return true, 0 -- Another concurrent request has just updated the adminlist
		end
	end

	db:setex(lock_key, 1, "")
	log.info('Saving the adminlist for: {chat_id}', {chat_id=chat_id})
	self:metric_incr("api_getchatadministrators_count")
	local res, code = api.getChatAdministrators(chat_id)
	if not res then
		self:metric_incr("api_getchatadministrators_error_count")
		return false, code
	end
	local cache_time = config.bot_settings.cache_time.adminlist
	local set_permissions
	db:del(set)
	for _, admin in pairs(res) do
		if admin.status == 'creator' then
			db:set('cache:chat:'..chat_id..':owner', admin.user.id)
			set_creator_permissions(self, chat_id, admin.user.id)
		else
			set_permissions = "cache:chat:"..chat_id..":"..admin.user.id..":permissions"
			db:del(set_permissions)
			for k, v in pairs(admin) do
				if v and admins_permissions[k] then db:sadd(set_permissions, k) end
			end
			db:expire(set_permissions, cache_time)
		end

		db:sadd(set, admin.user.id)

		self:demote(chat_id, admin.user.id)
	end
	db:expire(set, cache_time)

	return true, #res or 0
end

function _M:get_cached_admins_list(chat_id, second_try)
	local db = self.db
	local hash = 'cache:chat:'..chat_id..':admins'
	local list = db:smembers(hash)
	if not list or not next(list) then
		self:cache_adminlist(chat_id)
		if not second_try then
			return self:get_cached_admins_list(chat_id, true)
		else
			return false
		end
	else
		return list
	end
end

function _M:is_blocked_global(id)
	local db = self.db
	return db:sismember('bot:blocked', id) ~= 0
end

function _M:dump(...) -- luacheck: ignore 212
	for _, value in pairs{...} do
		print(json.encode(value))
	end
end

function _M:download_to_file(url, file_path) -- luacheck: ignore 212
	log.info("url to download: {url}", {url=url})
	if ngx then
		local httpc = http.new()
		local res, err = httpc:request_uri(url)
		if not err and res.status == 200 then
			local file = io.open(file_path, "w+")
			file:write(res.body)
			file:close()
			return file_path, res.status
		else
			return nil, res.status
		end
	else
		local respbody = {}
		local options = {
			url = url,
			sink = ltn12.sink.table(respbody),
			redirect = true
		}
		-- nil, code, headers, status
		options.redirect = false
		local response = {HTTPS.request(options)}
		local code = response[2]
		-- local headers = response[3] -- unused variables
		-- local status = response[4] -- unused variables
		if code ~= 200 then return false, code end
		log.info("Saved to: {path}", {path=file_path})
		local file = io.open(file_path, "w+")
		file:write(table.concat(respbody))
		file:close()
		return file_path, code
	end
end

function _M:deeplink_constructor(chat_id, what)
	local bot = self.bot
	return 'https://telegram.me/'..bot.username..'?start='..chat_id..'_'..what
end

function _M:get_date(timestamp) -- luacheck: ignore 212
	if not timestamp then
		timestamp = os.time()
	end
	return os.date('%d/%m/%y', timestamp)
end

-- Resolves username. Returns ID of user if it was early stored in date base.
-- Argument username must begin with symbol @ (commercial 'at')
function _M:resolve_user(username)
	local db = self.db
	assert(username:byte(1) == string.byte('@'))
	username = username:lower()

	local stored_id = tonumber(db:hget('bot:usernames', username))
	if not stored_id then return false end

	local user_obj = api.getChat(stored_id)
	if not user_obj then
		return stored_id
	else
		if not user_obj.username then return stored_id end
	end

	-- Users could change their username
	if username ~= '@' .. user_obj.username:lower() then
		if user_obj.username then
			-- Update it if it exists
			db:hset('bot:usernames', '@'..user_obj.username:lower(), user_obj.id)
		end
		-- And return false because this user not the same that asked
		return false
	end

	assert(stored_id == user_obj.id)
	return user_obj.id
end

function _M:get_sm_error_string(err) -- luacheck: ignore 212
	local unknown_error = i18n("Text not valid: unknown formatting error")
	if not err or not err.error_code then
		return unknown_error
	end
	local code = err.error_code
	local hyperlinks_text = i18n('More info [here](https://telegram.me/GB_tutorials/12)')
	local descriptions = {
		[109] =
		i18n("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(hyperlinks_text),
		[141] =
		i18n("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(hyperlinks_text),
		[142] =
		i18n("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(hyperlinks_text),
		[112] = i18n("This text breaks the markdown.\n"
					.. "More info about a proper use of markdown "
					.. "[here](https://telegram.me/GB_tutorials/10) and [here](https://telegram.me/GB_tutorials/12)."),
		[118] = i18n('This message is too long. Max lenght allowed by Telegram: 4000 characters'),
		[146] =
		i18n('One of the URLs that should be placed in an inline button seems to be invalid (not an URL). Please check it'),
		[137] = i18n("One of the inline buttons you are trying to set is missing the URL"),
		[149] = i18n("One of the inline buttons you are trying to set doesn't have a name"),
		[115] = i18n("Please input a text")
	}

	return descriptions[code] or unknown_error
end

function _M:reply_markup_from_text(text) -- luacheck: ignore 212
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

function _M:demote(chat_id, user_id)
	local db = self.db
	chat_id, user_id = tonumber(chat_id), tonumber(user_id)

	db:del(('chat:%d:mod:%d'):format(chat_id, user_id))
	local removed = db:srem('chat:'..chat_id..':mods', user_id)

	return removed == 1
end

function _M:migrate_chat_info(old, new, on_request)
	local db = self.db
	if not old or not new then
		return false
	end

	for hash_name, _ in pairs(config.chat_settings) do
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
			db:sadd('chat:'..new..':'..config.chat_sets[i], unpack(old_t))
		end
	end

	if on_request then
		api.send_message(new, "Should be done")
	end
end

function _M:to_supergroup(msg)
	local old = msg.chat.id
	local new = msg.migrate_to_chat_id
	local done = self:migrate_chat_info(old, new, false)
	if done then
		self:remGroup(old, true, 'to supergroup')
		api.sendMessage(new, '(_service notification: migration of the group executed_)', 'Markdown')
	end
end

-- Return user mention for output a text
function _M:getname_final(user)
	return self:getname_link(user) or '<code>'..user.first_name:escape_html()..'</code>'
end

-- Return link to user profile or false, if they don't have login
function _M:getname_link(user) -- luacheck: ignore 212
	return ('<a href="%s">%s</a>'):format('tg://user?id='..user.id, user.first_name:escape_html())
end

function _M:bash(str) -- luacheck: ignore 212
	local cmd = io.popen(str)
	local result = cmd:read('*all')
	cmd:close()
	return result
end

function _M:telegram_file_link(res) -- luacheck: ignore 212
	--res = table returned by getFile()
	return "https://api.telegram.org/file/bot"..config.telegram.token.."/"..res.file_path
end

function _M:is_silentmode_on(chat_id)
	local db = self.db
	return db:hget("chat:"..chat_id..":settings", "Silent") == "on"
end

function _M:getRules(chat_id)
	local db = self.db
	local hash = 'chat:'..chat_id..':info'
	local rules = db:hget(hash, 'rules')
	if rules == null then
		return i18n("-*empty*-")
	end
	return rules
end

function _M:getAdminlist(chat_id) -- luacheck: ignore 212
	local list, code = api.getChatAdministrators(chat_id)
	if not list then
		return false, code
	end
	local creator = ''
	local adminlist = ''
	local count = 1
	for _, admin in pairs(list) do
		local name
		local s = ' ├ '
		if admin.status == 'administrator' then
			name = admin.user.first_name
			if admin.user.username then
				name = ('<a href="telegram.me/%s">%s</a>'):format(admin.user.username, name:escape_html())
			else
				name = name:escape_html()
			end
			if count + 1 == #list then s = ' └ ' end
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

	return i18n("<b>👤 Creator</b>\n└ %s\n\n<b>👥 Admins</b> (%d)\n%s"):format(creator, #list - 1, adminlist)
end

function _M:getExtraList(chat_id)
	local db = self.db
	local hash = 'chat:'..chat_id..':extra'
	local commands = db:hkeys(hash)
	if not next(commands) then
		return i18n("No commands set")
	end
	table.sort(commands)
	return i18n("List of custom commands:\n") .. table.concat(commands, '\n')
end

function _M:getSettings(chat_id)
	local db = self.db
	local hash = 'chat:'..chat_id..':settings'

	local lang = db:get('lang:'..chat_id) -- group language
	if lang == null then lang = config.lang end

	local message = i18n("Current settings for *the group*:\n\n")
			.. i18n("*Language*: %s\n"):format(config.available_languages[lang])

	--build the message
	local strings = {
		Welcome = i18n("Welcome message"),
		Goodbye = i18n("Goodbye message"),
		Extra = i18n("Extra"),
		Flood = i18n("Anti-flood"),
		Antibot = i18n("Ban bots"),
		Silent = i18n("Silent mode"),
		Rules = i18n("Rules"),
		Arab = i18n("Arab"),
		Rtl = i18n("RTL"),
		Reports = i18n("Reports"),
		Weldelchain = i18n("Delete last welcome message"),
		Welbut = i18n("Welcome button")
	}
	for key, default in pairs(config.chat_settings['settings']) do

		local off_icon, on_icon = '🚫', '✅'
		if self:is_info_message_key(key) then
			off_icon, on_icon = '👤', '👥'
		end

		local db_val = db:hget(hash, key)
		if db_val == null then db_val = default end

		if db_val == 'off' then
			message = message .. string.format('%s: %s\n', strings[key], off_icon)
		else
			message = message .. string.format('%s: %s\n', strings[key], on_icon)
		end
	end

	--build the char settings lines
	hash = 'chat:'..chat_id..':char'
	local off_icon, on_icon = '🚫', '✅'
	for key, default in pairs(config.chat_settings['char']) do
		local db_val = db:hget(hash, key)
		if db_val == null then db_val = default end
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
		message = message .. i18n("*Welcome type*: `GIF / sticker`\n")
	elseif type == 'custom' then
		message = message .. i18n("*Welcome type*: `custom message`\n")
	elseif type == 'no' then
		message = message .. i18n("*Welcome type*: `default message`\n")
	end

	local warnmax_std = db:hget('chat:'..chat_id..':warnsettings', 'max')
	if warnmax_std == null then warnmax_std = config.chat_settings['warnsettings']['max'] end

	local warnmax_media = db:hget('chat:'..chat_id..':warnsettings', 'mediamax')
	if warnmax_media == null then warnmax_media = config.chat_settings['warnsettings']['mediamax'] end

	return message .. i18n("Warns (`standard`): *%s*\n"):format(warnmax_std)
		.. i18n("Warns (`media`): *%s*\n\n"):format(warnmax_media)
		.. i18n("✅ = _enabled / allowed_\n")
		.. i18n("🚫 = _disabled / not allowed_\n")
		.. i18n("👥 = _sent in group (always for admins)_\n")
		.. i18n("👤 = _sent in private_")

end

function _M:changeSettingStatus(chat_id, field)
	local db = self.db
	local turned_off = {
		reports = i18n("@admin command disabled"),
		welcome = i18n("Welcome message won't be displayed from now"),
		goodbye = i18n("Goodbye message won't be displayed from now"),
		extra = i18n("#extra commands are now available only for administrators"),
		flood = i18n("Anti-flood is now off"),
		rules = i18n("/rules will reply in private (for users)"),
		silent = i18n("Silent mode is now off"),
		preview = i18n("Links preview disabled"),
		welbut = i18n("Welcome message without a button for the rules")
	}
	local turned_on = {
		reports = i18n("@admin command enabled"),
		welcome = i18n("Welcome message will be displayed"),
		goodbye = i18n("Goodbye message will be displayed"),
		extra = i18n("#extra commands are now available for all"),
		flood = i18n("Anti-flood is now on"),
		rules = i18n("/rules will reply in the group (with everyone)"),
		silent = i18n("Silent mode is now on"),
		preview = i18n("Links preview enabled"),
		welbut = i18n("The welcome message will have a button for the rules")
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
			if r and r > 50 then
				return i18n("This setting is enabled, but the goodbye message won't be displayed in large groups, "
					.. "because I can't see service messages about left members"), true
			end
		end
		return turned_on[field:lower()]
	end
end

function _M:sendStartMe(msg)
	local bot = self.bot
	local keyboard = {
		inline_keyboard = {{{text = i18n("Start me"), url = 'https://telegram.me/'..bot.username}}}
		}
	api.sendMessage(msg.chat.id, i18n("_Please message me first so I can message you_"), 'Markdown', nil, nil, nil,
		keyboard)
end

function _M:initGroup(chat_id)
	local db = self.db
	for set, setting in pairs(config.chat_settings) do
		local hash = 'chat:'..chat_id..':'..set
		for field, value in pairs(setting) do
			db:hset(hash, field, value)
		end
	end

	self:cache_adminlist(chat_id, api.getChatAdministrators(chat_id)) --init admin cache

	--save group id
	db:sadd('bot:groupsid', chat_id)
	--remove the group id from the list of dead groups
	db:srem('bot:groupsid:removed', chat_id)
end

local function empty_modlist(self, chat_id)
	local db = self.db
	local set = 'chat:'..chat_id..':mods'
	local mods = db:smembers(set)
	if next(mods) then
		for i=1, #mods do
			db:del(('chat:%d:mod:%d'):format(tonumber(chat_id), tonumber(mods[i])))
		end
	end

	db:del(set)
end

function _M:remGroup(chat_id, full)
	local db = self.db
	--remove group id
	db:srem('bot:groupsid', chat_id)
	--add to the removed groups list
	db:sadd('bot:groupsid:removed', chat_id)
	--remove the owner cached
	db:del('cache:chat:'..chat_id..':owner')

	for set, _ in pairs(config.chat_settings) do
		db:del('chat:'..chat_id..':'..set)
	end

	db:del('cache:chat:'..chat_id..':admins') --delete the cache
	db:hdel('bot:logchats', chat_id) --delete the associated log chat
	db:del('chat:'..chat_id..':pin') --delete the msg id of the (maybe) pinned message
	db:del('chat:'..chat_id..':userlast')
	db:del('chat:'..chat_id..':members')
	db:hdel('bot:chats:latsmsg', chat_id)
	db:hdel('bot:chatlogs', chat_id) --log channel

	if full then
		for i=1, #config.chat_hashes do
			db:del('chat:'..chat_id..':'..config.chat_hashes[i])
		end
		for i=1, #config.chat_sets do
			db:del('chat:'..chat_id..':'..config.chat_sets[i])
		end

		if db:exists('chat:'..chat_id..':mods') == 1 then
			empty_modlist(self, chat_id)
		end

		db:del('lang:'..chat_id)
	end
end

function _M:getnames_complete(msg)

	local admin, kicked

	admin = self:getname_link(msg.from)

	if msg.reply then
		kicked = self:getname_link(msg.reply.from)
	elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%s(@[%w_]+)%s?') then
		local username = msg.text:match('%s(@[%w_]+)')
		kicked = username
	elseif msg.mention_id then
		for _, entity in pairs(msg.entities) do
			if entity.user then
				kicked = self:getname_link(entity.user)
			end
		end
	elseif msg.text:match(config.cmd..'%w%w%w%w?%w?%s(%d+)') then
		local id = msg.text:match(config.cmd..'%w%w%w%w?%w?%s(%d+)')
		local res = api.getChatMember(msg.chat.id, id)
		if res then
			kicked = self:getname_final(res.user)
		end
	end

	-- TODO: Actually fix this
	if not kicked then kicked = i18n("Someone") end
	if not admin then admin = i18n("Someone") end
	return admin, kicked
end

function _M:get_user_id(msg, blocks)
	--if no user id: returns false and the msg id of the translation for the problem
	if not msg.reply and not blocks[2] then
		return false, i18n("Reply to a user or mention them")
	end

	if msg.reply then
		if msg.reply.new_chat_member then
			msg.reply.from = msg.reply.new_chat_member
		end
		return msg.reply.from.id
	end

	if blocks[2]:byte(1) == string.byte("@") then
		local id = self:resolve_user(blocks[2])
		if id then
			return id
		end
	end

	if msg.mention_id then
		return msg.mention_id
	end

	local id = blocks[2]:match("%d+")
	if id then
		return id
	end

	return false, i18n([[I've never seen this user before.
This command works by reply, username, user ID or text mention.
If you're using it by username and want to teach me who the user is, forward me one of their messages]])
end

function _M:logEvent(event, msg, extra)
	local bot = self.bot
	local db = self.db
	local log_id = db:hget('bot:chatlogs', msg.chat.id)
	-- self:dump(extra)

	if not log_id or log_id == null then return end
	local is_loggable = db:hget('chat:'..msg.chat.id..':tolog', event)
	if not is_loggable == 'yes' then return end

	local text, reply_markup

	local chat_info = i18n("<b>Chat</b>: %s [#chat%d]"):format(msg.chat.title:escape_html(), msg.chat.id * -1)
	local member = ("%s [@%s] [#id%d]"):format(msg.from.first_name:escape_html(), msg.from.username or '-', msg.from.id)

	local log_event = {
		mediawarn = function()
			--MEDIA WARN
			--warns n°: warns
			--warns max: warnmax
			--media type: media
			text = i18n("#%s (<code>%d/%d</code>), <i>%s</i>\n• %s\n• <b>User</b>: %s"):format(
				event:upper(), extra.warns, extra.warnmax, extra.media, chat_info, member)
		end,
		spamwarn = function()
			--SPAM WARN
			--warns n°: warns
			--warns max: warnmax
			--media type: spam_type
			text = i18n("#%s (<code>%d/%d</code>), <i>%s</i>\n• %s\n• <b>User</b>: %s"):format(
				event:upper(), extra.warns, extra.warnmax, extra.spam_type, chat_info, member)
		end,
		flood = function()
			--FLOOD
			--hammered?: hammered
			text = i18n("#%s\n• %s\n• <b>User</b>: %s"):format(event:upper(), chat_info, member)
		end,
		new_chat_photo = function()
			text = i18n('%s\n• %s\n• <b>By</b>: %s'):format('#NEWPHOTO', chat_info, member)
			reply_markup = {
				inline_keyboard = {{{
					text = i18n("Get the new photo"),
					url = ("telegram.me/%s?start=photo:%s"):format(bot.username,
					msg.new_chat_photo[#msg.new_chat_photo].file_id)
				}}}
			}
		end,
		delete_chat_photo = function()
			text = i18n('%s\n• %s\n• <b>By</b>: %s'):format('#PHOTOREMOVED', chat_info, member)
		end,
		new_chat_title = function()
			text = i18n('%s\n• %s\n• <b>By</b>: %s'):format('#NEWTITLE', chat_info, member)
		end,
		pinned_message = function()
			text = i18n('%s\n• %s\n• <b>By</b>: %s'):format('#PINNEDMSG', chat_info, member)
			msg.message_id = msg.pinned_message.message_id --because of the "go to the message" link. The normal msg.message_id brings to the service message
		end,
		report = function()
			text = i18n('%s\n• %s\n• <b>By</b>: %s\n• <i>Reported to %d admin(s)</i>'):format(
			event:upper(), chat_info, member, extra.n_admins)
		end,
		blockban = function()
			text = i18n('#%s\n• %s\n• <b>User</b>: %s [#id%d]'):format(event:upper(), chat_info, extra.name, extra.id)
		end,
		new_chat_member = function()
			local member2 = ("%s [@%s] [#id%d]"):format(msg.new_chat_member.first_name:escape_html(),
				msg.new_chat_member.username or '-', msg.new_chat_member.id)
			text = i18n('%s\n• %s\n• <b>User</b>: %s'):format('#NEW_MEMBER', chat_info, member2)
			if extra then --extra == msg.from
				text = text..i18n("\n• <b>Added by</b>: %s [#id%d]"):format(self:getname_final(extra), extra.id)
			end
		end,
		-- events that requires user + admin
		warn = function()
			--WARN
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			--warns n°: warns
			--warns max: warnmax
			--motivation: motivation
			text = i18n(
				'#%s\n• <b>Admin</b>: %s [#id%d]\n• %s\n• <b>User</b>: %s [#id%d]\n• <b>Count</b>: <code>%d/%d</code>'
			):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, extra.user_id, extra.warns, extra.warnmax)
		end,
		nowarn = function()
			--WARNS REMOVED
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			text = i18n('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]\n'..
				'• <b>Warns found</b>: <i>normal: %s, for media: %s, spamwarns: %s</i>'):format(
				'WARNS_RESET', extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id), extra.rem.normal,
			extra.rem.media, extra.rem.spam)
		end,
		block = function() -- or unblock
			text = i18n('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n'
			):format(event:upper(), self:getname_final(msg.from), msg.from.id, chat_info)
			if extra.n then
				text = text..i18n('• <i>Users involved: %d</i>'):format(extra.n)
			elseif extra.user then
				text = text..i18n('• <b>User</b>: %s [#id%d]'):format(extra.user, msg.reply.forward_from.id)
			end
		end,
		tempban = function()
			--TEMPBAN
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			--days: d
			--hours: h
			--motivation: motivation
			text = i18n(
			'#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]\n• <b>Duration</b>: %d days, %d hours'
			):format(event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id), extra.d, extra.h)
		end,
		ban = function() -- or kick or unban
			--BAN OR KICK OR UNBAN
			--admin name formatted: admin
			--user name formatted: user
			--user id: user_id
			--motivation: motivation
			text = i18n('#%s\n• <b>Admin</b>: %s [#id%s]\n• %s\n• <b>User</b>: %s [#id%s]'):format(
				event:upper(), extra.admin, msg.from.id, chat_info, extra.user, tostring(extra.user_id))
		end,
	} set_default(log_event, function()
			text = i18n('#%s\n• %s\n• <b>By</b>: %s'):format(event:upper(), chat_info, member)
	end)

	log_event.unblock = log_event.block
	log_event.kick    = log_event.ban
	log_event.unban   = log_event.ban

	log_event[event]()

	if event == 'ban' or event == 'tempban' then
		--logcb:unban:user_id:chat_id for ban, logcb:untempban:user_id:chat_id for tempban
		reply_markup = {
			inline_keyboard = {{{
				text = i18n("Unban"),
				callback_data = ("logcb:un%s:%d:%d"):format(event, extra.user_id, msg.chat.id)
			}}}
		}
	end

	if extra then
		if extra.hammered then
			text = text..i18n("\n• <b>Action</b>: #%s"):format(extra.hammered:upper())
		end
		if extra.motivation then
			text = text..i18n('\n• <b>Reason</b>: <i>%s</i>'):format(extra.motivation:escape_html())
		end
	end

	if msg.chat.username then
		text = text..
			('\n• <a href="telegram.me/%s/%d">%s</a>'):format(msg.chat.username, msg.message_id, i18n('Go to the message'))
	end

	local ok, err = api.send_message{
		chat_id = log_id,
		text = text,
		parse_mode = "html",
		disable_web_page_preview = true,
		reply_markup = reply_markup
	}
	if not ok and err.error_code == 117 then
		db:hdel('bot:chatlogs', msg.chat.id)
	end
end

function _M:is_info_message_key(key) -- luacheck: ignore 212
	if key == 'Extra' or key == 'Rules' then
		return true
	end
	return false
end

function _M:table2keyboard(t) -- luacheck: ignore 212
	local keyboard = {inline_keyboard = {}}
	for _, line in pairs(t) do
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

function _M:metric_incr(name)
	local db = self.db
	db:incr("bot:metrics:" .. name)
end

function _M:metric_set(name, value)
	local db = self.db
	db:set("bot:metrics:" .. name, value)
end

function _M:metric_get(name)
	local db = self.db
	return db:get("bot:metrics:" .. name)
end

function _M:time_hires() -- luacheck: ignore 212
	return time_hires()
end
return _M
