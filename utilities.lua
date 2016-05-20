-- utilities.lua
-- Functions shared among plugins.

function get_word(s, i) -- get the indexed word in a string

	s = s or ''
	i = i or 1

	local t = {}
	for w in s:gmatch('%g+') do
		table.insert(t, w)
	end

	return t[i] or false

end

function string:input() -- Returns the string after the first space.
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

function string:mEscape() -- Remove the markdown.
	self = self:gsub('*', '\\*'):gsub('_', '\\_'):gsub('`', '\\`'):gsub('%]', '\\]'):gsub('%[', '\\[')
	return self
end

function string:mEscape_hard() -- Remove the markdown.
	self = self:gsub('*', ''):gsub('_', ''):gsub('`', ''):gsub('%[', ''):gsub('%]', '')
	return self
end

function is_admin(msg)
	local id
	if msg.adder and msg.adder.id then
		id = msg.adder.id
	else
		id = msg.from.id
	end
	if id and tonumber(id) == config.admin then
		return true
	end
	return false
end

function is_owner(msg)
	local var = false
	
	local hash = 'chat:'..msg.chat.id..':owner'
	local owner_list = db:hkeys(hash) --get the current owner id
	local owner = owner_list[1]
	
	if owner == tostring(msg.from.id) then
		var = true
	end
	
	if msg.from.id == config.admin then
		var = true
	end
	
	return var
end

function is_owner2(chat_id, user_id)
	local var = false
	
	local hash = 'chat:'..chat_id..':owner'
	local owner_list = db:hkeys(hash) --get the current owner id
	local owner = owner_list[1]
	
	if owner == tostring(user_id) then
		var = true
	end
	
	if user_id == config.admin then
		var = true
	end
	
	return var
end

function is_mod(msg)
	local var = false
	
	local hash = 'chat:'..msg.chat.id..':mod'
	local modlist = db:hkeys(hash) --get the list of ids
	
	for i=1, #modlist do
		if tostring(modlist[i]) == tostring(msg.from.id) then
			var = true
		end
	end

	if msg.from.id == config.admin then
		var = true
	end
	
	--no need to check if is owner: the owner id is already saved in the modlist
	
	return var
end

function is_mod2(chat_id, user_id)
	local var = false
	
	local hash = 'chat:'..chat_id..':mod'
	local modlist = db:hkeys(hash) --get the list of ids
	
	for i=1, #modlist do
		if tostring(modlist[i]) == tostring(user_id) then
			var = true
		end
	end

	if user_id == config.admin then
		var = true
	end
	
	--no need to check if is owner: the owner id is already saved in the modlist
	
	return var
end

function set_owner(chat_id, user_id, nick)
	db:hset('chat:'..chat_id..':mod', user_id, nick) --mod
	db:hset('chat:'..chat_id..':owner', user_id, nick) --owner
end

function is_blocked(id)
	if db:sismember('bot:blocked', id) then
		return true
	else
		return false
	end
end

function is_locked(msg, cmd)
  	local hash = 'chat:'..msg.chat.id..':settings'
  	local current = db:hget(hash, cmd)
  	if current == 'yes' then
  		return true
  	end
  	return false
end

function is_banned(chat_id, user_id)
	--useful only for normal groups
	local hash = 'chat:'..chat_id..':banned'
	local res = db:sismember(hash, user_id)
	if res then
		return true
	else
		return false
	end
end

function mystat(cmd)
	local hash = 'commands:stats'
	db:hincrby(hash, cmd, 1)
end	

function string:trim() -- Trims whitespace from a string.
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

function load_data(filename) -- Loads a JSON file as a table.

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data) -- Saves a table to a JSON file.

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

function clean_owner_modlist(chat)
	--clear the owner
	local hash = 'chat:'..chat..':owner'
	local owner_list = db:hkeys(hash) --get the current owner id
	local owner = owner_list[1]
	db:hdel(hash, owner)
	
	--clean the modlist
	hash = 'chat:'..chat..':mod'
	local mod_list = db:hkeys(hash) --get mods id
	for id,nick in pairs(mod_list) do
		if id then
			db:hdel(hash, id)
		else
			api.sendLog('#removed\nUnknown group\nId: '..chat)
		end
	end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function vtext(value)
  return serpent.block(value, {comment=false})
end

local function per_away(text)
	local text = tostring(text):gsub('%%', '£&£')
	return text
end

function make_text(text, par1, par2, par3, par4, par5)
	if par1 then text = text:gsub('&&&1', per_away(par1)) end
	if par2 then text = text:gsub('&&&2', per_away(par2)) end
	if par3 then text = text:gsub('&&&3', per_away(par3)) end
	if par4 then text = text:gsub('&&&4', per_away(par4)) end
	if par5 then text = text:gsub('&&&5', per_away(par5)) end
	text = text:gsub('£&£', '%%')
	return text
end

function write_file(path, text, mode)
	if not mode then
		mode = "w"
	end
	file = io.open(path, mode)
	if not file then
		return false --path uncorrect
	else
		file:write(text)
		file:close()
		return true
	end
end

local function create_folder(name)
	local cmd = io.popen('sudo mkdir '..name)
    cmd:read('*all')
    cmd = io.popen('sudo chmod -R 777 '..name)
    cmd:read('*all')
    cmd:close()
end

function save_log(action, arg1, arg2, arg3, arg4)
	if action == 'send_msg' then
		local text = os.date('[%A, %d %B %Y at %X]')..'\n'..arg1..'\n\n'
		local path = "./logs/msgs_errors.txt"
		local res = write_file(path, text, "a")
		if not res then
			create_folder('logs')
			write_file(path, text, "a")
		end
    elseif action == 'errors' then
    	--error, from, chat, text
    	local path = "./logs/errors.txt"
    	local text = os.date('[%A, %d %B %Y at %X]')..'\nERROR: '..arg1
    	if arg2 then
    		text = text..'\nFROM: '..arg2
    	end
 		if arg3 then
 			text = text..'\nCHAT: '..arg3
 		end
 		if arg4 then
 			text = text..'\nTEXT: '..arg4
 		end
 		text = text..'\n\n'
 		local res = write_file(path, text, "a")
    	if not res then
			create_folder('logs')
			write_file(path, text, "a")
		end
    elseif action == 'starts' then
    	local path = "./logs/starts.txt"
    	local text = 'Started: '..os.date('%A, %d %B %Y at %X')..'\n'
    	local res = write_file(path, text, "a")
    	if not res then
			create_folder('logs')
			write_file(path, text, "a")
		end
	elseif action == 'added' then
		local text = 'BOT ADDED ['..os.date('%A, %d %B %Y at %X')..'] to ['..arg1..'] ['..arg2..'] by ['..arg3..'] ['..arg4..']\n'
    	local path = "./logs/additions.txt"
    	local res = write_file(path, text, "a")
    	if not res then
			create_folder('logs')
			write_file(path, text, "a")
		end
    end
end

function clone_table(t) --doing "table1 = table2" in lua = create a pointer to table2
  local new_t = {}
  local i, v = next(t, nil)
  while i do
    new_t[i] = v
    i, v = next(t, i)
  end
  return new_t
end

function res_user(username)
	local hash = 'bot:usernames'
	local stored = db:hget(hash, username)
	if not stored then
		return false
	else
		return stored
	end
end

function res_user_group(username, chat_id)
	username = username:lower()
	local hash = 'bot:usernames:'..chat_id
	local stored = db:hget(hash, username)
	if stored then
		return stored
	else
		hash = 'bot:usernames'
		stored = db:hget(hash, username)
		if stored then
			return stored
		else
			return false
		end
	end
end

function is_lang_supported(code)
	for i=1,#config.available_languages do
		if code:lower() == config.available_languages[i] then
			return true
		end
	end
	return false
end

function get_media_type(msg)
	if msg.photo then
		return 'image'
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
			return 'file'
		end
	elseif msg.sticker then
		return 'sticker'
	elseif msg.contact then
		return 'contact'
	end
	return false
end

function group_table(chat_id)
	local group = {
		id = chat_id
		}
	
	local redis = {
		hgetall = {
			mods = 'chat:'..chat_id..':mod',
			owner = 'chat:'..chat_id..':owner',
			settings = 'chat:'..chat_id..':settings',
			mediasettings = 'chat:'..chat_id..':media',
			flood = 'chat:'..chat_id..':flood',
			extra = 'chat:'..chat_id..':extra',
			welcome = 'chat:'..chat_id..':welcome'
		},
		get = {
			about = 'chat:'..chat_id..':about',
			rules = 'chat:'..chat_id..':rules'
		},
		smembers = {
			admblock = 'chat:'..chat_id..':reportblocked'
		}
	}
	
	for k,v in pairs(redis.hgetall) do
		local tab = db:hgetall(v)
		group[k] = tab
	end
	for k,v in pairs(redis.get) do
		local tab = db:get(v)
		group[k] = tab
	end
	for k,v in pairs(redis.smembers) do
		local tab = db:smembers(v)
		group[k] = tab
	end
	
	return group
end

voice_updated = 0
voice_succ = 0

function give_result(res)
	--doesn't handle a nil "res"
	if res == 1 then
		voice_succ = voice_succ + 1
		return ' done (res: 1)'
	else
		voice_updated = voice_updated + 1
		return ' updated (res: 0)'
	end
end

function migrate_table(t, hash)
	if not next(t) then
		return '[empty table]\n'
	end
	local txt = ''
	for k,v in pairs(t) do
		txt = txt..k..' ('..v..') [migration:'
		local res = db:hset(hash, k, v)
		txt = txt..give_result(res)..']\n'
	end
	return txt
end

function migrate_chat_info(old, new, on_request)
	if not old or not new then
		print('A group id is missing')
		return false
	end
	local mods = db:hgetall('chat:'..old..':mod')
	local owner_id = db:hkeys('chat:'..old..':owner')
	local owner_name = db:hvals('chat:'..old..':owner')
	local settings = db:hgetall('chat:'..old..':settings')
	local media = db:hgetall('chat:'..old..':media')
	local flood = db:hgetall('chat:'..old..':flood')
	local about = db:get('chat:'..old..':about')
	local rules = db:get('chat:'..old..':rules')
	local extra = db:hgetall('chat:'..old..':extra')
	local admblock = db:smembers('chat:'..old..':reportblocked')
	local logtxt = 'FROM ['..old..'] TO ['..new..']\n'
	
	--migrate mods
	logtxt = logtxt..'Migrating moderators (#'..#mods..')...\n'
	logtxt = logtxt..migrate_table(mods, 'chat:'..new..':mod')
	
	--migrate owner
	logtxt = logtxt..'Migrating owner...'
	if next(owner_id) and next(owner_name) then
		local res = db:hset('chat:'..new..':owner', owner_id[1], owner_name[1])
		logtxt = logtxt..give_result(res)..'\n'
	else logtxt = logtxt..' empty\n' end
	
	--migrate about
	logtxt = logtxt..'Migrating about...'
	if about then
		res = db:set('chat:'..new..':about', about)
		logtxt = logtxt..give_result(res)..'\n'
	else logtxt = logtxt..' empty\n' end
	
	--migrate rules
	logtxt = logtxt..'Migrating rules...'
	if rules then
		res = db:set('chat:'..new..':rules', rules)
		logtxt = logtxt..give_result(res)..'\n'
	else logtxt = logtxt..' empty\n' end
	
	--migrate settings
	logtxt = logtxt..'Migrating settings...\n'
	logtxt = logtxt..migrate_table(settings, 'chat:'..new..':settings')
	
	--migrate media settings
	logtxt = logtxt..'Migrating media settings...\n'
	logtxt = logtxt..migrate_table(media, 'chat:'..new..':media')
	
	--migrate extra
	logtxt = logtxt..'Migrating extra...\n'
	logtxt = logtxt..migrate_table(extra, 'chat:'..new..':extra')
	
	--migrate flood settings
	logtxt = logtxt..'Migrating flood settings...\n'
	logtxt = logtxt..migrate_table(flood, 'chat:'..new..':flood')
	
	--migrate adminblocked list
	logtxt = logtxt..'Migrating admin-blocked...\n'
	if admblocked and next(admblocked) then
		for k,v in pairs(admblock) do
			logtxt = logtxt..v..' migration: '
			local res = db:sadd('chat:'..new..':reportblocked')
			logtxt = logtxt..give_result(res)..'\n'
		end
	else
		logtxt = logtxt..'List empty\n'
	end
	
	--flood
	print(logtxt)
	local log_path = "./logs/migration_from["..tostring(old):gsub('-', '').."]to["..tostring(new):gsub('-', '').."].txt"
	file = io.open(log_path, "w")
	file:write(logtxt)
    file:close()
	if on_request then
		api.sendDocument(config.admin, log_path)
	end
end

function div()
	print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
	print('XXXXXXXXXXXXXXXXXX BREAK XXXXXXXXXXXXXXXXXXX')
	print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
end

local function migrate_ban_list(old, new)
	local hash = 'chat:'..old..':banned'
	local banned = db:smembers(hash)
	if next(banned) then
		for i=1, #banned do
			api.kickChatMember(new, banned[i])
		end
	end
end	

function to_supergroup(msg)
	local old = msg.chat.id
	local new = msg.migrate_to_chat_id
	migrate_chat_info(old, new, false)
	migrate_ban_list(old, new)
	api.sendMessage(new, '(_service notification: migration of the group executed_)', true)
end

function getname(msg)
    local name = msg.from.first_name
	if msg.from.username then name = name..' (@'..msg.from.username..')' end
    return name
end

function change_one_header(id)
	voice_succ = 0
	voice_updated = 0
	logtxt = ''
	logtxt = logtxt..'\n-----------------------------------------------------\nGROUP ID: '..id..'\n'
	print('Group:', id) --first: print this, once the for is done, print logtxt
		
	logtxt = logtxt..'---> PORTING MODS...\n'
	local mods = db:hgetall('bot:'..id..':mod')
	logtxt = logtxt..migrate_table(mods, 'chat:'..id..':mod')
		
	logtxt = logtxt..'---> PORTING OWNER...\n'
	local owner_id = db:hkeys('bot:'..id..':owner')
	local owner_name = db:hvals('bot:'..id..':owner')
	if not next(owner_id) or not next(owner_name) then
		logtxt = logtxt..'No owner!\n'
	else
		logtxt = logtxt..'Owner info: '..owner_id[1]..', '..owner_name[1]..' [migration:'
		local res = db:hset('chat:'..id..':owner', owner_id[1], owner_name[1])
		logtxt = logtxt..give_result(res)..'\n'
	end
		
	logtxt = logtxt..'---> PORTING MEDIA SETTINGS...\n'
	local media = db:hgetall('media:'..id)
	logtxt = logtxt..migrate_table(media, 'chat:'..id..':media')
		
	logtxt = logtxt..'---> PORTING ABOUT...\n'
	local about = db:get('bot:'..id..':about')
	if not about then
		logtxt = logtxt..'No about!\n'
	else
		logtxt = logtxt..'About found! [migration:'
		local res = db:set('chat:'..id..':about', about)
		logtxt = logtxt..give_result(res)..']\n'
	end
		
	logtxt = logtxt..'---> PORTING RULES...\n'
	local rules = db:get('bot:'..id..':rules')
	if not rules then
		logtxt = logtxt..'No rules!\n'
	else
		logtxt = logtxt..'Rules found!  [migration:'
		local res = db:set('chat:'..id..':rules', rules)
		logtxt = logtxt..give_result(res)..']\n'
	end
		
	logtxt = logtxt..'---> PORTING EXTRA...\n'
	local extra = db:hgetall('extra:'..id)
	logtxt = logtxt..migrate_table(extra, 'chat:'..id..':extra')
	print('\n\n\n')
	logtxt = 'Successful: '..voice_succ..'\nUpdated: '..voice_updated..'\n\n'..logtxt
	print(logtxt)
	local log_path = "./logs/changehashes"..id..".txt"
	file = io.open(log_path, "w")
	file:write(logtxt)
    file:close()
	api.sendDocument(config.admin, log_path)
end

function change_extra_header(id)
	voice_succ = 0
	voice_updated = 0
	logtxt = ''
	logtxt = logtxt..'\n-----------------------------------------------------\nGROUP ID: '..id..'\n'
	print('Group:', id) --first: print this, once the for is done, print logtxt
		
	logtxt = logtxt..'---> PORTING EXTRA...\n'
	local extra = db:hgetall('extra:'..id)
	logtxt = logtxt..migrate_table(extra, 'chat:'..id..':extra')
	
	print('\n\n\n')
	
	logtxt = 'Successful: '..voice_succ..'\nUpdated: '..voice_updated..'\n\n'..logtxt
	print(logtxt)
	local log_path = "./logs/changehashesEXTRA"..id..".txt"
	file = io.open(log_path, "w")
	file:write(logtxt)
    file:close()
	api.sendDocument(config.admin, log_path)
end

function download_to_file(url, file_path)--https://github.com/yagop/telegram-bot/blob/master/bot/utils.lua
  print("url to download: "..url)

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

  print("Saved to: "..file_path)

  file = io.open(file_path, "w+")
  file:write(table.concat(respbody))
  file:close()
  return file_path, code
end

function telegram_file_link(res)
	--res = table returned by getFile()
	return "https://api.telegram.org/file/bot"..config.bot_api_key.."/"..res.result.file_path
end

----------------------- specific cross-plugins functions---------------------

local function getAbout(chat_id, ln)
	local hash = 'chat:'..chat_id..':about'
	local about = db:get(hash)
    if not about then
        return lang[ln].setabout.no_bio
    else
       	return about
    end
end

local function getRules(chat_id, ln)
	local hash = 'chat:'..chat_id..':rules'
	local rules = db:get(hash)
    if not rules then
        return lang[ln].setrules.no_rules
    else
       	return rules
    end
end

local function getModlist(chat_id)
	local hash = 'chat:'..chat_id..':mod'
	local mlist = db:hvals(hash) --the array can't be empty: there is always the owner in
    local message = ''
    --build the list
    for i=1, #mlist do
        message = message..i..' - '..mlist[i]..'\n'
    end
    if message == '' then
    	return '()'
    else
    	return message
    end
end

local function getExtraList(chat_id, ln)
	local hash = 'chat:'..chat_id..':extra'
	local commands = db:hkeys(hash)
	local text = ''
	if commands[1] == nil then
		return make_text(lang[ln].extra.no_commands)
	else
	    for k,v in pairs(commands) do
	    	text = text..v..'\n'
	    end
	    return make_text(lang[ln].extra.commands_list, text)
	end
end

local function getSettings(chat_id, ln)
	--get settings from redis
    local hash = 'chat:'..chat_id..':settings'
    local settings_key = db:hkeys(hash)
    local settings_val = db:hvals(hash)
    local key
    local val
        
    message = make_text(lang[ln].bonus.settings_header, ln)
        
    --build the message
    for i=1, #settings_key do
        key = settings_key[i]
        val = settings_val[i]
            
        local text
        if val == 'yes' then
            text = make_text(lang[ln].settings[key])..': 🚫\n'
        else
            text = '*'..make_text(lang[ln].settings[key])..'*: ✅\n'
        end
        message = message..text --concatenete the text
        if key == 'Flood' then
            local max_msgs = db:hget('chat:'..chat_id..':flood', 'MaxFlood') or 5
            local action = db:hget('chat:'..chat_id..':flood', 'ActionFlood')
            message = message..make_text(lang[ln].settings.resume.flood_info, max_msgs, action)
        end
    end
        
    --build the "welcome" line
    hash = 'chat:'..chat_id..':welcome'
    local type = db:hget(hash, 'type')
    if type == 'composed' then
    	local wel = db:hget(hash, 'content')
    	if wel == 'a' then
    	    message = message..lang[ln].settings.resume.w_a
    	elseif wel == 'r' then
    	    message = message..lang[ln].settings.resume.w_r
    	elseif wel == 'm' then
    	    message = message..lang[ln].settings.resume.w_m
    	elseif wel == 'ra' then
    	    message = message..lang[ln].settings.resume.w_ra
    	elseif wel == 'rm' then
    	    message = message..lang[ln].settings.resume.w_rm
    	elseif wel == 'am' then
    	    message = message..lang[ln].settings.resume.w_am
    	elseif wel == 'ram' then
    	    message = message..lang[ln].settings.resume.w_ram
    	elseif wel == 'no' then
    	    message = message..lang[ln].settings.resume.w_no
    	end
	elseif type == 'media' then
		message = message..lang[ln].settings.resume.w_media
	elseif type == 'custom' then
		message = message..lang[ln].settings.resume.w_custom
	end
    
    return message
end

local function enableSetting(chat_id, field, ln)
	local hash = 'chat:'..chat_id..':settings'
    local field_lower = field:lower()
    local now = db:hget(hash, field)
    if now == 'no' then
        return lang[ln].settings.enable[field_lower..'_already']
    else
        db:hset(hash, field, 'no')
        return lang[ln].settings.enable[field_lower..'_unlocked']
    end
end

local function disableSetting(chat_id, field, ln)
	local hash = 'chat:'..chat_id..':settings'
    local field_lower = field:lower()
    local now = db:hget(hash, field)
    if now == 'yes' then
        return lang[ln].settings.disable[field_lower..'_already']
    else
        db:hset(hash, field, 'yes')
        return lang[ln].settings.disable[field_lower..'_locked']
    end
end

local function changeSettingStatus(chat_id, field, ln)
	local hash = 'chat:'..chat_id..':settings'
	local field_lower = field:lower()
	local now = db:hget(hash, field)
	if now == 'no' then
		db:hset(hash, field, 'yes')
		return lang[ln].settings.disable[field_lower..'_locked']
	else
		db:hset(hash, field, 'no')
		return lang[ln].settings.enable[field_lower..'_unlocked']
	end
end

local function changeFloodSettings(chat_id, screm, ln)
	local hash = 'chat:'..chat_id..':flood'
	if type(screm) == 'string' then
		if screm == 'kick' then
			db:hset(hash, 'ActionFlood', 'ban')
        	return lang[ln].floodmanager.ban
        elseif screm == 'ban' then
        	db:hset(hash, 'ActionFlood', 'kick')
        	return lang[ln].floodmanager.kick
        end
    elseif type(screm) == 'number' then
    	local old = tonumber(db:hget(hash, 'MaxFlood')) or 5
    	local new
    	if screm > 0 then
    		new = db:hincrby(hash, 'MaxFlood', 1)
    		if new > 25 then
    			db:hincrby(hash, 'MaxFlood', -1)
    			return make_text(lang[ln].floodmanager.number_invalid, new)
    		end
    	elseif screm < 0 then
    		new = db:hincrby(hash, 'MaxFlood', -1)
    		if new < 4 then
    			db:hincrby(hash, 'MaxFlood', 1)
    			return make_text(lang[ln].floodmanager.number_invalid, new)
    		end
    	end
    	return make_text(lang[ln].floodmanager.changed, old, new)
    end 	
end

local function changeMediaStatus(chat_id, media, new_status, ln)
	local old_status = db:hget('chat:'..chat_id..':media', media)
	if new_status == 'next' then
		if not old_status then
			new_status = 'kick'
		elseif old_status == 'kick' then
			new_status = 'ban'
		elseif old_status == 'ban' then
			new_status = 'allowed'
		elseif old_status == 'allowed' then
			new_status = 'kick'
		end
	end
	if new_status == 'allow' then
		new_status = 'allowed'
	end
	if old_status == new_status then
		return make_text(lang[ln].mediasettings.already, media, new_status), false
	else
		db:hset('chat:'..chat_id..':media', media, new_status)
		return make_text(lang[ln].mediasettings.changed, media, new_status), true
	end
end

local function sendStartMe(msg, ln)
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Start me', url = 'https://telegram.me/'..bot.username}
	    }
    }
	api.sendKeyboard(msg.chat.id, lang[ln].help.group_not_success, keyboard, true)
end

local function initGroup(chat_id, owner_id, nick)
	
	--add owner as moderator
	local hash = 'chat:'..chat_id..':mod'
    db:hset(hash, owner_id, nick)
    
    --add owner as owner
    hash = 'chat:'..chat_id..':owner'
    db:hset(hash, owner_id, nick)
	
	--default settings
	hash = 'chat:'..chat_id..':settings'
	--disabled for users:yes / disabled for users:no
	db:hset(hash, 'Rules', 'no')
	db:hset(hash, 'About', 'no')
	db:hset(hash, 'Modlist', 'no')
	db:hset(hash, 'Report', 'yes')
	db:hset(hash, 'Welcome', 'no')
	db:hset(hash, 'Extra', 'no')
	db:hset(hash, 'Rtl', 'no')
	db:hset(hash, 'Arab', 'no')
	db:hset(hash, 'Flood', 'no')
	
	--flood
	hash = 'chat:'..chat_id..':flood'
	db:hset(hash, 'MaxFlood', 5)
	db:hset(hash, 'ActionFlood', 'kick')
	
	--warn
	db:set('chat:'..chat_id..':max', 5)
	db:set('chat:'..chat_id..':warntype', 'ban')
	
	--set media values
	local list = {'image', 'audio', 'video', 'sticker', 'gif', 'voice', 'contact', 'file'}
	hash = 'chat:'..chat_id..':media'
	for i=1,#list do
		db:hset(hash, list[i], 'allowed')
	end
	
	--set the default welcome type
	hash = 'chat:'..chat_id..':welcome'
	db:hset(hash, 'type', 'composed')
	db:hset(hash, 'content', 'no')
	
	--save group id
	db:sadd('bot:groupsid', chat_id)
	
	--save stats
	hash = 'bot:general'
    local num = db:hincrby(hash, 'groups', 1)
    print('Stats saved', 'Groups: '..num)
end

local function addBanList(chat_id, user_id, nick, why)
    local hash = 'chat:'..chat_id..':bannedlist'
    local res, is_id_added = rdb.set(hash, user_id, 'nick', nick)
    if why and not(why == '') then
        rdb.set(hash, user_id, 'why', why)
    end
    return is_id_added
end

local function remBanList(chat_id, user_id)
	if not chat_id or not user_id then return false end
    local hash = 'chat:'..chat_id..':bannedlist'
    local res, des = rdb.rem(hash, user_id)
    return res
end

-----------------------redis shorcuts---------------------------------------

--[[

------------|---------------------------|
IDS SET     | SUB-HASH WITH SUB-KEY/VAL |
------------|---------------------------|
hash        | hash:id[n]                |
------------|---------------------------|
------------|---------------------------|
            |             |
id[1] ----->| key1 = val1 |
            | key2 = val2 |
            | key3 = val3 |
            | key4 = val4 |
------------|-------------|
id[2] ----->| key1 = val1 |
            | key2 = val2 |
            | key3 = val3 |
            | key4 = val4 |
            | key5 = val5 |
------------|-------------|

extSet(hash, id, key, val)
extGet(hash{, id{, key}})
extSetTable(hash, table)
extRem(hash{, id{, key}})
]]

local function extSet(hash, id, key, val)
    
    --returns false if an argument is missing
    --else, returns true, true if the id has been added to the ids set or false if it hasn't, 0 the sub-key/val has been setted or 1 if only updated, 
    
    if not val then
        return false, 'Missing field(s)'
    else
        local res_sadd = db:sadd(hash, id)
		if res_sadd > 0 then res_sadd = false else res_sadd = true end
        local res_hset = db:hset(hash..':'..id, key, val)
        if res_hset then --or res_set == 1
            return true, res_sadd, 1
        else
            return true, res_sadd, 0
        end
    end
end

local function extGet(hash, id, key)
    
    --returns false when the hash/id is not found or when the sub-hash/the ids set is empty, plus the descritption
    --returns nil when the key passed does not exists
    --else, returns the table/value
    
    local res = {}
    local hash_exists = db:exists(hash)
    if not hash_exists then
        return false, 'hash does not exists'
    else
        if key then
            return db:hegt(hahs..':'..id, key)
        else
            if id then
                local hgetall_res = db:hgetall(hash..':'..id)
                if not next(hgetall_res) then
                    return false, 'empty sub-hash'
                else
                    return hgetall_res
                end
            else
                local ids = db:smembers(hash)
                if not next(ids) then
                    return false, 'empty ids set'
                else
                    for i=1,#ids do
                        local hgetall_res = db:hgetall(hash..':'..ids[i])
                        if next(hgetall_res) then
                            res[ids[i]] = hgetall_res
                        end
                    end
                    return res
                end
            end
        end
    end
end

local function extSetTable(hash, table)
    
    --returns false if "table" argument is not a table, and the descriprion of the error
    --else, returns true, the number of ids setted in the ids set, and the number of key/vals setted
    
    if not(type(table) == 'table') then
        return false, 'the second argument is not a table'
    else
        local reset_res = rdb.rem(hash)
        local id_setted = 0
        local kv_setted = 0
        for id,sub_table in pairs(table) do
            id_setted = id_setted + 1
            db:sadd(hash, id)
            for key,val in pairs(sub_table) do
                db:hset(hash..':'..id, key, val)
                kv_setted = kv_setted + 1
            end
        end
        return true, id_setted, kv_setted
    end
end

local function extRem(hash, id, key)
    
    --if the hash/id/key is not found, returns false and a description of the error
    --if the key/id/hash has been successfully removed, returns true with the number of sub-keys removed
    
    local hash_exists = db:exists(hash)
    if not hash_exists then
        return false, 'hash does not exists'
    else
        local ids = db:smembers(hash)
        if next(ids) then --if the set is not empty
            if not id then --if id and key are not provided, delete the whole hash
                local subhash_removed = 0
                for i,id in pairs(ids) do --delete each sub-hash, before delete the ids set
                    db:del(hash..':'..id) --remove directly the entire sub-hash
                    subhash_removed = subhash_removed + 1
                end
                db:del(hash) --remove the set of ids
                return true, subhash_removed
            else --else, if id is provided then
                local id_exists = db:sismember(hash, id)
                if not id_exists then
                    return false, 'id does not exists'
                else
                    if key then --if the key is provided, then delete only the key
                        local res_key = db:hdel(hash..':'..id, key)
                        if res_key == 0 then --if the key does not exists then
                            return false, 'key does not exists'
                        else
                            return true
                        end
                    else --if the key is not provided, then delete only id provided from the ids set, and the associated sub-hash
                        db:del(hash..':'..id) --delete the whole sub-hash
                        db:srem(hash, id) --remove the id from the set of ids
                        return true, 1
                    end
                end
            end
        else
            return false, 'id set is empty'
        end
    end
end

local cross = {
	getAbout = getAbout,
	getRules = getRules,
	getModlist = getModlist,
	getExtraList = getExtraList,
	getSettings = getSettings,
	enableSetting = enableSetting,
	disableSetting = disableSetting,
	changeSettingStatus = changeSettingStatus,
	changeFloodSettings = changeFloodSettings,
	changeMediaStatus = changeMediaStatus,
	sendStartMe = sendStartMe,
	initGroup = initGroup,
	addBanList= addBanList,
	remBanList = remBanList
}

local rdb = {
	set = extSet,
	get = extGet,
	rem = extRem,
	setTable = extSetTable,
}

return cross, rdb