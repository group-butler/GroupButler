local triggers = {
	'^/test'
}

local function on_each_msg(msg)
	return msg
end

local action = function(msg, blocks)
	--test your stuffs here
end

return {
	action = action,
	triggers = triggers,
	test = true
}
