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

-- Check table if val1 is in col1[] where col2 = val2. Akin to redis sismember
function database.is_in_array(table, col1, val1, col2, val2)
	local cur = assert (con:execute(string.format([[SELECT (%s=ANY(%s)) FROM %s AS result
	WHERE %s=%s]], val1, col1, table, col2, val2)))
	local row = cur:fetch ({}, "a")
	cur:close()
	if row then -- checks if array is not null
		return row['?column?'] == 't'
	else
		return false
	end
end

-- Returns the value in col1 where col2 = val2 from table. Akin to hget (?)
function database.getval(table, col1, col2, val2)
	local cur = assert (con:execute(string.format([[SELECT %s FROM %s
	WHERE %s=%s]], col1, table, col2, val2)))
	local row = cur:fetch ({}, "a")
	cur:close()
	if row then
		return row[col1]
	else
		return nil
	end
end

-- Accumulator
function database.acc(table, col, val, col2)
	res = assert (con:execute(string.format([[INSERT INTO %s (%s) values (%s)
	ON CONFLICT (%s) DO UPDATE SET %s = %s.%s + 1]], table, col, val, col, col2, table, col2)
	))
end

-- Add a new member to array
function database.put_in_array(table, col1, val1, col2, val2)
	res = assert (con:execute(string.format([[UPDATE %s SET %s = array_distinct(array_append(%s, %s))
	WHERE %s=%s]], table, col1, col1, val1, col2, val2)
	))
end

-- Insert into karma
function database.put_in_karma(col, val1, val2, val3)
	res = assert (con:execute(string.format([[INSERT INTO karma (id, %s) values ((%s, %s), %s)
	ON CONFLICT (id) DO UPDATE SET %s = %s]], col, val1, val2, val3, col, val3)
	))
end

-- Get from karma
function database.get_karma(col, val1, val2)
	local cur = assert (con:execute(string.format([[SELECT %s FROM karma
	WHERE id = (%s, %s)::chatuser]], col, val1, val2)))
	local row = cur:fetch ({}, "a")
	cur:close()
	if row then
		return row[col]
	else
		return nil
	end
end

return database
