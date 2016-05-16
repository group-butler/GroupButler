local triggers = {
	'^/(import)',
	'^/(export)',
	'^/(exportlang)',
}

local function on_each_msg(msg, ln)
	return msg
end

local function sort_table(t)
    local keys = {}
    for k,v in ipairs(t) do
        table.insert(keys, v)
    end
    table.sort(keys)
    local new = {}
    for k,v in ipairs(keys) do
        new[v] = t[v]
    end
    return new
end

local action = function(msg, blocks, ln)
	--test your stuffs here
end

return {
	action = action,
	triggers = triggers,
	--on_each_msg = on_each_msg
}