local triggers = {
	'^/(t) (.*)$'
}

local function on_each_msg(msg, ln)
	return msg
end

local action = function(msg, blocks, ln)
	--try your crap here
	local test = 'bcdgcv*'
	local t = test:neat()
	t = '*'..t..'*'
	api.sendMessage(msg.chat.id, t, true)
end

return {
	action = action,
	triggers = triggers,
	--on_each_msg = on_each_msg
}