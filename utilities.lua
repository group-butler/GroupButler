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

function string:sec2() -- Returns the string after the first space.
	if not self:find(' ') then
		return false
	end
	t = self:sub(self:find(' ')+1)
	if not t:find(' ') then
		return nil
	end
	return t:sub(t:find(' ')+1)
end

function is_owner(msg)
	local var = false
	
	local hash = 'bot:'..msg.chat.id..':owner'
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

function is_mod(msg)
	local var = false
	
	local hash = 'bot:'..msg.chat.id..':mod'
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

-------------JSON--------------
function is_owner_data(msg)
	local var = false
  	local groups = load_data('groups.json')
  
    if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
        var = true
    end
    
    if msg.from.id == config.admin then
		var = true
	end
  	
  	return var
end

function is_mod_data(msg)
	local var = false
  	local groups = load_data('groups.json')
  	
  	if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
        var = true
    end
    
    if groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
    	var = true
    end
     
    if msg.from.id == config.admin then
		var = true
	end
  	
    return var
end
------------JSON------------

function is_locked(msg, cmd)
	local var = false
  	local hash = 'chat:'..msg.chat.id..':settings'
  	local current = client:hget(hash, cmd)
  	if current == 'yes' then
  		var = true
  	end
  	return var
end

function mystat(cmd)
	
	local hash = 'commands:stats'
	local final = client:hincrby(hash, cmd, 1)
	--stat = load_data('statsbot.json')
	--n = stat[tostring(cmd)]
	--n = n+1
	--stat[tostring(cmd)] = tonumber(n)
	--save_data('statsbot.json', stat)
	print('Stats saved', cmd..': '..final)
end	

 -- I swear, I copied this from PIL, not yago! :)
function string:trim() -- Trims whitespace from a string.
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

local lc_list = {
-- Latin = 'Cyrillic'
	['A'] = 'А',
	['B'] = 'В',
	['C'] = 'С',
	['E'] = 'Е',
	['I'] = 'І',
	['J'] = 'Ј',
	['K'] = 'К',
	['M'] = 'М',
	['H'] = 'Н',
	['O'] = 'О',
	['P'] = 'Р',
	['S'] = 'Ѕ',
	['T'] = 'Т',
	['X'] = 'Х',
	['Y'] = 'Ү',
	['a'] = 'а',
	['c'] = 'с',
	['e'] = 'е',
	['i'] = 'і',
	['j'] = 'ј',
	['o'] = 'о',
	['s'] = 'ѕ',
	['x'] = 'х',
	['y'] = 'у',
	['!'] = 'ǃ'
}

function latcyr(str) -- Replaces letters with corresponding Cyrillic characters.
	for k,v in pairs(lc_list) do
		str = string.gsub(str, k, v)
	end
	return str
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

 -- Gets coordinates for a location. Used by gMaps.lua, time.lua, weather.lua.
function get_coords(input)

	local url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		return config.errors.connection
	end

	local jdat = JSON.decode(jstr)
	if jdat.status == 'ZERO_RESULTS' then
		return config.errors.results
	end

	return {
		lat = jdat.results[1].geometry.location.lat,
		lon = jdat.results[1].geometry.location.lng
	}

end

function match_pattern(pattern, text, lower_case)
  if text then
    local matches = {}
    if lower_case then
      matches = { string.match(text:lower(), pattern) }
    else
      matches = { string.match(text, pattern) }
    end
      if next(matches) then
      	if matches[1] ~= '' then
      		--print('----------------------------------------------------------------')
      		--for i=1, #matches do
      	 		--print('matches['..i..']', matches[i])
      		--end
      	end
        return matches
      end
  end
  -- nil
end

function clean_owner_modlist(chat)
	--clear the owner
	local hash = 'bot:'..chat..':owner'
	local owner_list = client:hkeys(hash) --get the current owner id
	local owner = owner_list[1]
	client:hdel(hash, owner)
	
	--clean the modlist
	hash = 'bot:'..chat..':mod'
	local mod_list = client:hkeys(hash) --get mods id
	for i=1, #mod_list do
		client:hdel(hash, mod_list[i])
	end
end

--function vardump(value)
  --print(serpent.block(value, {comment=false}))
--end

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

function save_owned_group(owner, chat, title)
	--save each time a user is promoted as owner
	local hash = owner..':groups'
	local key = chat
	local val = title
	client:hset(hash, key, val)
end

function del_owned_group(owner, chat, title)
	--each time owner changes
	local hash = owner..':groups'
	local key = chat
	client:hdel(hash, key)
end

function get_owned_groups(owner)
	local hash = owner..':groups'
	local vals = client:hvals(hash)
	local text = 'Owned groups:\n'
	for i=1, #vals do
		text = text..i..'- '..vals[i]..'\n'
	end
	return text
end

function get_id_owned_group(owner, number)
	local hash = owner..':groups'
	local keys = client:hkeys(hash)
	for i=1, #keys do
		if i == tonumber(num) then
			return keys[i]
		end
	end
	
	return false
end

function make_text(base, par1, par2, par3, par4, par5, par6)
	local text = base
	if par1 then text = text:gsub('&&&1', par1) end
	if par2 then text = text:gsub('&&&2', par2) end
	if par3 then text = text:gsub('&&&3', par3) end
	if par4 then text = text:gsub('&&&4', par4) end
	if par5 then text = text:gsub('&&&5', par5) end
	if par5 then text = text:gsub('&&&6', par6) end
	--if breaks_markdown(text) then
		--print('Markdown issue with:\n\n'..text)
  		--sendMessage(config.admin, 'Markdown issue, check the log')
	--end
	return text
end

local function create_folder(name)
	local cmd = io.popen('sudo mkdir '..name)
    cmd:read('*all')
    cmd = io.popen('sudo chmod -R 777 '..name)
    cmd:read('*all')
    cmd:close()
end

function save_log(action, arg1, arg2, arg3, arg4)
	local file
	if action == 'send_msg' then
		file = io.open("./logs/msgs_errors.txt", "a")
		if not file then
			create_folder('logs')
			file = io.open("./logs/msgs_errors.txt", "a")
		end
		local text = os.date('[%A, %d %B %Y at %X]')..' --> '..arg1..'\n\n'
		file:write(text)
        file:close()
    elseif action == 'errors' then
    	--error, from, chat, text
    	file = io.open("./logs/errors.txt", "a")
    	if not file then
			create_folder('logs')
			file = io.open("./logs/errors.txt", "a")
		end
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
    	file:write(text)
        file:close()
    elseif action == 'starts' then
    	file = io.open("./logs/starts.txt", "a")
    	if not file then
			create_folder('logs')
			file = io.open("./logs/starts.txt", "a")
		end
		local text = 'Started: '..os.date('%A, %d %B %Y at %X')..'\n'
		file:write(text)
        file:close()
    end
end
		