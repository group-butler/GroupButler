local triggers = {
	'^/(hash) (.*)$',
	'^/(hash) (help)$',
}

local action = function(msg, blocks)
	
	print('\n/hash', msg.from.first_name..' ['..msg.from.id..']')
	
	--ignore if not admin
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		mystat('hash') --save stats
		return nil
	end
	
	--return help
	if blocks[2] == 'help' then
		sendMessage(msg.from.id, '*Default hash*:\n\nbot:general\nbot:`chatid`:owner\nbot:`chatid`:mod\nchat:`chatid`:settings\nchat:`chatid`:welcome\n', true, false, true)
		return nil
	end
	
	local hash = blocks[2]
	local success = client:hgetall(hash)
	
	local keys = client:hkeys(hash)
	local vals = client:hvals(hash)
	local message = 'Info about the hash:\n\n'
	for i=1, #keys do
		message = message..keys[i]..': '..vals[i]..'\n'
	end
	
	sendMessage(msg.from.id, message)
	mystat('hash') --save stats
end

return {
	action = action,
	triggers = triggers
}