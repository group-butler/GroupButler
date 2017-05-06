-- Database helper functions
local database = {}

-- Debug: dump lua table to console
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Init database connection
local function connect()
	pg = pgmoon.new({
		host = config.db_host,
		port = config.db_port,
		user = config.db_user,
		database = config.db_db,
		password =  config.db_pass
	})
	assert(pg:connect())
end

-- Generic functions
function database.setval(table, col, val, col2, val2)
	connect()
	local res = pg:query('INSERT INTO '..table..' ('..col..', '..col2..') values ('..val..', '..val2..') ON CONFLICT ('..col..') DO UPDATE SET '..col2..' = '..val2)
end

function database.getval(table, col, col2, val)
	connect()
	local res = pg:query('SELECT '..col..' FROM '..table..' WHERE '..col2..'='..val)
	if res then
		if res[1] then
			return res[1][col1]
		end
	else
		return nil
	end
end

function database.acc(table, col, val, col2)
	connect()
	local res = pg:query('INSERT INTO '..table..' ('..col..') values ('..val..') ON CONFLICT ('..col..') DO UPDATE SET '..col2..' = '..table..'.'..col2..' + 1')
end

-- Dedicated functions
function database.setvusers(user_id, col, val)
	connect()
	database.setval('users', 'userid', user_id, col, val)
end
function database.getvusers(user_id, col)
	connect()
	return database.getval('users', 'userid', col, user_id)
end

function database.setvchat(chat_id, col, val)
	connect()
	database.setval('chat', 'chatid', chat_id, col, val)
end
function database.getvchat(chat_id, col)
	connect()
	return database.getval('chat', 'chatid', col, chat_id)
end

function database.setvkarma(chat_id, user_id, col, val)
	connect()
	local res = pg:query('INSERT INTO karma (id, '..col..') values (('..chat_id..', '..user_id..'), '..val..') ON CONFLICT (id) DO UPDATE SET '..col..' = '..val)
	return res.affected_rows
end
function database.getvkarma(chat_id, user_id, col)
	connect()
	local res = pg:query('SELECT '..col..'FROM karma WHERE id = ('..chat_id..', '..user_id..')::chatuser')
	if res then
		return res[1][col]
	else
		return nil
	end
end

-- Check table if val1 is in col1[] where col2 = val2. Akin to redis sismember
-- function database.is_in_array(table, col1, val1, col2, val2)
-- 	local cur = assert(con:execute(string.format([[SELECT (%s=ANY(%s)) FROM %s AS result
-- 	WHERE %s=%s]], val1, col1, table, col2, val2)))
-- 	local row = cur:fetch ({}, "a")
-- 	cur:close()
-- 	if row then -- checks if array is not null
-- 		return row['?column?'] == 't'
-- 	else
-- 		return false
-- 	end
-- end

-- Add a new member to array
-- function database.put_in_array(table, col1, val1, col2, val2)
-- 	local res = assert(con:execute(string.format([[UPDATE %s SET %s = array_distinct(array_append(%s, %s))
-- 	WHERE %s=%s]], table, col1, col1, val1, col2, val2)))
-- end

--
-- function database.getarray(table, col, col2, val)
-- 	local cur = assert(con:execute(string.format([[SELECT %s FROM %s AS result
-- 	WHERE %s=%s]], col, table, col2, val)))
-- 	local row = cur:fetch ({}, "a")
-- 	cur:close()
-- 	if row then -- checks if array is not null
-- 		return row
-- 	else
-- 		return nil
-- 	end
-- end

return database
