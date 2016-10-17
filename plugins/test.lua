--Simple test plugin. If it triggers /test it will run your function. Please add it, before trying :)
local triggers = {
	'^/test'
}

local function onmessage(msg)
	return true
end

local action = function(msg, blocks)
	--test your stuffs here
	local continue = true
	local i = 0
	--local res = api.sendReply(msg, 'Initial')
	local users = {278941742, 23646077}
	while continue do
		i = i + 1
		local res, code = api.getChatMember(msg.chat.id, users[math.random(2)])
		if not res then
			continue = false
			vardump(code)
			vardump(res)
		else
			print('Attempt n° '..i..':', res.result.status, 'Unix time: '..os.time())
		end
	end
end

return {
	action = action,
	triggers = triggers,
	onmessage = false,
}
