local pgmoon = require 'pgmoon' -- Load postgres client

local db = {} -- Database abstraction module

-- Private functions
local function connect() -- Init database connection
	local pg = pgmoon.new({
		host = config.db_host,
		port = config.db_port,
		user = config.db_user,
		database = config.db_db,
		password =  config.db_pass
	})
	pg:settimeout(config.db_timeout)
	assert(pg:connect())
	return pg
end

local function acc(table, col, val, col2) -- Accumulator
	local pg = connect()
	local res = pg:query('INSERT INTO '..table..' ('..col..') values ('..val..') ON CONFLICT ('..col..') DO UPDATE SET '..col2..' = '..table..'.'..col2..' + 1')
end

local function delrow(table, col, val, col2, val2)
	local pg = connect()
	local res
	if col2 then
		res = pg:query('DELETE FROM '..table..' WHERE ('..col..', '..col2..') = ('..val..', '..val2..')')
	else
		res = pg:query('DELETE FROM '..table..' WHERE '..col..' = '..val)
	end
	if res.affected_rows then
		return res.affected_rows
	else
		return 0
	end
end

local function getval(table, col, col2, val)
	local pg = connect()
	local res = pg:query('SELECT '..col..' FROM '..table..' WHERE '..col2..'='..val)
	if res then
		if res[1] then
			return res[1][col1]
		end
	else
		return nil
	end
end

local function setval(table, col, val, col2, val2)
	local pg = connect()
	local res = pg:query('INSERT INTO '..table..' ('..col..', '..col2..') values ('..val..', '..val2..') ON CONFLICT ('..col..') DO UPDATE SET '..col2..' = '..val2)
end

local function getval2(table, col, val, col2, val2, col3)
	local pg = connect()
	local res = pg:query('SELECT '..col3..' FROM '..table..' WHERE ('..col..', '..col2..') = ('..val..', '..val2..')')
	if res then
		if res[1] then
			if res[1][col3] then
				return res[1][col3]
			end
		end
	else
		return nil
	end
end

local function setval2(table, col, val, col2, val2, col3, val3)
	local pg = connect()
	local res = pg:query('INSERT INTO '..table..' ('..col..', '..col2..', '..col3..') values ('..val..', '..val2..', '..val3..') ON CONFLICT ('..col..', '..col2..') DO UPDATE SET '..col3..' = '..val3)
	if res then
		return res.affected_rows
	else
		return 0
	end
end

-- Public functions
function db.accchat(chat_id, col)
	acc('chat', 'chat_id', chat_id, col)
end
function db.getvchat(chat_id, col)
	return getval('chat', col, 'chat_id', chat_id)
end
function db.setvchat(chat_id, col, val)
	setval('chat', 'chat_id', chat_id, col, val)
end

-- ce = chat_extra
function db.delce(chat_id, extra_id)
	return delrow('chat_extra', 'chat_id', chat_id, 'extra_id', "'"..extra_id.."'")
end
function db.getvce(chat_id, extra_id, col)
	return getval2('chat_extra', 'chat_id', chat_id, 'extra_id', "'"..extra_id.."'", col)
end
function db.listce(chat_id, extra_id)
	-- TODO
end
function db.setvce(chat_id, extra_id, col, val)
	setval2('chat_extra', 'chat_id', chat_id, 'extra_id', "'"..extra_id.."'", col, "'"..val.."'")
end

function db.initgroup(chat_id)
	local pg = connect()
	local res = pg:query('INSERT INTO chat (chat_id) values ('..chat_id..') ON CONFLICT DO NOTHING')
end

-- cu = chat_users
function db.acccu(chat_id, user_id, col)
	-- TODO
end
function db.getvcu(chat_id, user_id, col)
	return getval2('chat_users', 'chat_id', chat_id, 'user_id', user_id, col)
end
function db.setvcu(chat_id, user_id, col, val)
	setval2('chat_users', 'chat_id', chat_id, 'user_id', user_id, col, val)
end

function db.accusers(user_id, col)
	acc('users', 'user_id', user_id, col)
end
function db.getvusers(user_id, col)
	return getval('users', col, 'user_id', user_id)
end
function db.setvusers(user_id, col, val)
	setval('users', 'user_id', user_id, col, val)
end

return db
