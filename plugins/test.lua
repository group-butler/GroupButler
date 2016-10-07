--Simple test plugin. If it triggers /test it will run your function. Please add it, before trying :)
local triggers = {
	'^/test'
}

local function onmessage(msg)
	return true
end

local action = function(msg, blocks)
	--test your stuffs here
end

return {
	action = action,
	triggers = triggers,
	onmessage = false,
}
