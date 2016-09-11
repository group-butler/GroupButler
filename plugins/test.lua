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
