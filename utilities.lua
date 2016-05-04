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
	self = self:gsub('*', ''):gsub('_', ''):gsub('`', ''):gsub('%]', ''):gsub('%[', '')
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
	local owner_list = client:hkeys(hash) --get the current owner id
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
	local owner_list = client:hkeys(hash) --get the current owner id
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
	local modlist = client:hkeys(hash) --get the list of ids
	
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
	local modlist = client:hkeys(hash) --get the list of ids
	
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

function is_blocked(id)
	if client:sismember('bot:blocked', id) then
		return true
	else
		return false
	end
end

function is_locked(msg, cmd)
  	local hash = 'chat:'..msg.chat.id..':settings'
  	local current = client:hget(hash, cmd)
  	if current == 'yes' then
  		return true
  	end
  	return false
end

function is_banned(chat_id, user_id)
	--useful only for normal groups
	local hash = 'chat:'..chat_id..':banned'
	local res = client:sismember(hash, user_id)
	if res then
		return true
	else
		return false
	end
end

function mystat(cmd)
	local hash = 'commands:stats'
	local final = client:hincrby(hash, cmd, 1)
	print('Stats saved', colors('%{green bright}'..cmd..': '..final))
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

function match_pattern(pattern, text)
  if text then
    local matches = {}
    matches = { string.match(text, pattern) }
    if next(matches) then
    	return matches
    end
  end
end

function clean_owner_modlist(chat)
	--clear the owner
	local hash = 'chat:'..chat..':owner'
	local owner_list = client:hkeys(hash) --get the current owner id
	local owner = owner_list[1]
	client:hdel(hash, owner)
	
	--clean the modlist
	hash = 'chat:'..chat..':mod'
	local mod_list = client:hkeys(hash) --get mods id
	for i=1, #mod_list do
		client:hdel(hash, mod_list[i])
	end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function vtext(value)
  return serpent.block(value, {comment=false})
end

function breaks_markdown(text)
	local i = 0
	for word in string.gmatch(text, '%*') do
		i = i+1	
	end
	local rest = i%2
	if rest == 1 then
		print('Wrong markdown *', i)
		return true
	end
	
	i = 0
	for word in string.gmatch(text, '_') do
		i = i+1	
	end
	local rest = i%2
	if rest == 1 then
		print('Wrong markdown _', i)
		return true
	end
	
	i = 0
	for word in string.gmatch(text, '`') do
		i = i+1	
	end
	local rest = i%2
	if rest == 1 then
		print('Wrong markdown `', i)
		return true
	end
	
	return false
end

local function per_away(text)
	local text = tostring(text):gsub('%%', '£&£')
	return text
end

function make_text(text, par1, par2, par3, par4, par5, par6)
	if par1 then text = text:gsub('&&&1', per_away(par1)) end
	if par2 then text = text:gsub('&&&2', per_away(par2)) end
	if par3 then text = text:gsub('&&&3', per_away(par3)) end
	if par4 then text = text:gsub('&&&4', per_away(par4)) end
	if par5 then text = text:gsub('&&&5', per_away(par5)) end
	if par6 then text = text:gsub('&&&6', per_away(par6)) end
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

function clone_table(t) --doing "shit = table" in lua is create a pointer
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
	local stored = client:hget(hash, username)
	if not stored then
		return false
	else
		return stored
	end
end

function res_type(string)
	if string:match('(%d+)') then
		return 1
	elseif string:match('(@[%w_]+)') then
		return 2
	elseif string:match('') or not string then
		return 3
	else
		return 0
	end
end

function res_type_id(msg, string)
	if string:match('(%d+)') then
		return string
	elseif string:match('(@[%w_]+)') then
		return res_user(string)
	elseif string:match('') or not string then
		return msg.reply.from.id
	else
		return false
	end
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
			extra = 'chat:'..chat_id..':extra'
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
		local tab = client:hgetall(v)
		group[k] = tab
	end
	for k,v in pairs(redis.get) do
		local tab = client:get(v)
		group[k] = tab
	end
	for k,v in pairs(redis.smembers) do
		local tab = client:smembers(v)
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
		local res = client:hset(hash, k, v)
		txt = txt..give_result(res)..']\n'
	end
	return txt
end

function migrate_chat_info(old, new, on_request)
	if not old or not new then
		print('A group id is missing')
		return false
	end
	local mods = client:hgetall('chat:'..old..':mod')
	local owner_id = client:hkeys('chat:'..old..':owner')
	local owner_name = client:hvals('chat:'..old..':owner')
	local settings = client:hgetall('chat:'..old..':settings')
	local media = client:hgetall('chat:'..old..':media')
	local flood = client:hgetall('chat:'..old..':flood')
	local about = client:get('chat:'..old..':about')
	local rules = client:get('chat:'..old..':rules')
	local extra = client:hgetall('chat:'..old..':extra')
	local admblock = client:smembers('chat:'..old..':reportblocked')
	local logtxt = 'FROM ['..old..'] TO ['..new..']\n'
	
	--migrate mods
	logtxt = logtxt..'Migrating moderators (#'..#mods..')...\n'
	logtxt = logtxt..migrate_table(mods, 'chat:'..new..':mod')
	
	--migrate owner
	logtxt = logtxt..'Migrating owner...'
	if next(owner_id) and next(owner_name) then
		local res = client:hset('chat:'..new..':owner', owner_id[1], owner_name[1])
		logtxt = logtxt..give_result(res)..'\n'
	else logtxt = logtxt..' empty\n' end
	
	--migrate about
	logtxt = logtxt..'Migrating about...'
	if about then
		res = client:set('chat:'..new..':about', about)
		logtxt = logtxt..give_result(res)..'\n'
	else logtxt = logtxt..' empty\n' end
	
	--migrate rules
	logtxt = logtxt..'Migrating rules...'
	if rules then
		res = client:set('chat:'..new..':rules', rules)
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
			local res = client:sadd('chat:'..new..':reportblocked')
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
		api.sendDocument(old, log_path)
	end
end

function div()
	print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
	print('XXXXXXXXXXXXXXXXXX BREAK XXXXXXXXXXXXXXXXXXX')
	print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
end

local function migrate_ban_list(old, new)
	local hash = 'chat:'..old..':banned'
	local banned = client:smembers(hash)
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
	--migrate_ban_list(old, new)
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
	local mods = client:hgetall('bot:'..id..':mod')
	logtxt = logtxt..migrate_table(mods, 'chat:'..id..':mod')
		
	logtxt = logtxt..'---> PORTING OWNER...\n'
	local owner_id = client:hkeys('bot:'..id..':owner')
	local owner_name = client:hvals('bot:'..id..':owner')
	if not next(owner_id) or not next(owner_name) then
		logtxt = logtxt..'No owner!\n'
	else
		logtxt = logtxt..'Owner info: '..owner_id[1]..', '..owner_name[1]..' [migration:'
		local res = client:hset('chat:'..id..':owner', owner_id[1], owner_name[1])
		logtxt = logtxt..give_result(res)..'\n'
	end
		
	logtxt = logtxt..'---> PORTING MEDIA SETTINGS...\n'
	local media = client:hgetall('media:'..id)
	logtxt = logtxt..migrate_table(media, 'chat:'..id..':media')
		
	logtxt = logtxt..'---> PORTING ABOUT...\n'
	local about = client:get('bot:'..id..':about')
	if not about then
		logtxt = logtxt..'No about!\n'
	else
		logtxt = logtxt..'About found! [migration:'
		local res = client:set('chat:'..id..':about', about)
		logtxt = logtxt..give_result(res)..']\n'
	end
		
	logtxt = logtxt..'---> PORTING RULES...\n'
	local rules = client:get('bot:'..id..':rules')
	if not rules then
		logtxt = logtxt..'No rules!\n'
	else
		logtxt = logtxt..'Rules found!  [migration:'
		local res = client:set('chat:'..id..':rules', rules)
		logtxt = logtxt..give_result(res)..']\n'
	end
		
	logtxt = logtxt..'---> PORTING EXTRA...\n'
	local extra = client:hgetall('extra:'..id)
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
	local extra = client:hgetall('extra:'..id)
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

----------------------- specific cross-plugins functions---------------------

local function getAbout(chat_id, ln)
	local hash = 'chat:'..chat_id..':about'
	local about = client:get(hash)
    if not about then
        return lang[ln].setabout.no_bio
    else
       	return make_text(lang[ln].setabout.bio, about)
    end
end

local function getRules(chat_id, ln)
	local hash = 'chat:'..chat_id..':rules'
	local rules = client:get(hash)
    if not rules then
        return lang[ln].setrules.no_rules
    else
       	return make_text(lang[ln].setrules.rules, rules)
    end
end

local function getModlist(chat_id)
	local hash = 'chat:'..chat_id..':mod'
	local mlist = client:hvals(hash) --the array can't be empty: there is always the owner in
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
	local commands = client:hkeys(hash)
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
    local settings_key = client:hkeys(hash)
    local settings_val = client:hvals(hash)
    local key
    local val
        
    message = make_text(lang[ln].bonus.settings_header, ln)
        
    --build the message
    for i=1, #settings_key do
        key = settings_key[i]
        val = settings_val[i]
            
        local text
        if val == 'yes' then
            text = make_text(lang[ln].settings[key])..': 🔒\n'
        else
            text = '*'..make_text(lang[ln].settings[key])..'*: 🔓\n'
        end
        message = message..text --concatenete the text
        if key == 'Flood' then
            local max_msgs = client:hget('chat:'..chat_id..':flood', 'MaxFlood') or 5
            local action = client:hget('chat:'..chat_id..':flood', 'ActionFlood')
            message = message..make_text(lang[ln].settings.resume.flood_info, max_msgs, action)
        end
    end
        
    --build the "welcome" line
    hash = 'chat:'..chat_id..':welcome'
    local wel = client:hget(hash, 'wel')
    if wel == 'a' then
         message = message..make_text(lang[ln].settings.resume.w_a)
    elseif wel == 'r' then
        message = message..make_text(lang[ln].settings.resume.w_r)
    elseif wel == 'm' then
        message = message..make_text(lang[ln].settings.resume.w_m)
    elseif wel == 'ra' then
        message = message..make_text(lang[ln].settings.resume.w_ra)
    elseif wel == 'rm' then
        message = message..make_text(lang[ln].settings.resume.w_rm)
    elseif wel == 'am' then
        message = message..make_text(lang[ln].settings.resume.w_am)
    elseif wel == 'ram' then
        message = message..make_text(lang[ln].settings.resume.w_ram)
    elseif wel == 'no' then
        message = message..make_text(lang[ln].settings.resume.w_no)
    end
    
    return message
end

local function enableSetting(chat_id, field, ln)
	local hash = 'chat:'..chat_id..':settings'
    local field_lower = field:lower()
    local now = client:hget(hash, field)
    if now == 'no' then
        return lang[ln].settings.enable[field_lower..'_already']
    else
        client:hset(hash, field, 'no')
        return lang[ln].settings.enable[field_lower..'_unlocked']
    end
end

local function disableSetting(chat_id, field, ln)
	local hash = 'chat:'..chat_id..':settings'
    local field_lower = field:lower()
    local now = client:hget(hash, field)
    if now == 'yes' then
        return lang[ln].settings.disable[field_lower..'_already']
    else
        client:hset(hash, field, 'yes')
        return lang[ln].settings.disable[field_lower..'_locked']
    end
end

local function changeSettingStatus(chat_id, field, ln)
	local hash = 'chat:'..chat_id..':settings'
	local field_lower = field:lower()
	local now = client:hget(hash, field)
	if now == 'no' then
		client:hset(hash, field, 'yes')
		return lang[ln].settings.disable[field_lower..'_locked']
	else
		client:hset(hash, field, 'no')
		return lang[ln].settings.enable[field_lower..'_unlocked']
	end
end

local function changeFloodSettings(chat_id, screm, ln)
	local hash = 'chat:'..chat_id..':flood'
	if type(screm) == 'string' then
		if screm == 'kick' then
			client:hset(hash, 'ActionFlood', 'ban')
        	return lang[ln].floodmanager.ban
        elseif screm == 'ban' then
        	client:hset(hash, 'ActionFlood', 'kick')
        	return lang[ln].floodmanager.kick
        end
    elseif type(screm) == 'number' then
    	local old = tonumber(client:hget(hash, 'MaxFlood')) or 5
    	local new
    	if screm > 0 then
    		new = client:hincrby(hash, 'MaxFlood', 1)
    		if new > 25 then
    			client:hincrby(hash, 'MaxFlood', -1)
    			return make_text(lang[ln].floodmanager.number_invalid, new)
    		end
    	elseif screm < 0 then
    		new = client:hincrby(hash, 'MaxFlood', -1)
    		if new < 4 then
    			client:hincrby(hash, 'MaxFlood', 1)
    			return make_text(lang[ln].floodmanager.number_invalid, new)
    		end
    	end
    	return make_text(lang[ln].floodmanager.changed, old, new)
    end 	
end

return {
	getAbout = getAbout,
	getRules = getRules,
	getModlist = getModlist,
	getExtraList = getExtraList,
	getSettings = getSettings,
	enableSetting = enableSetting,
	enableSetting = enableSetting,
	changeSettingStatus = changeSettingStatus,
	changeFloodSettings = changeFloodSettings
}