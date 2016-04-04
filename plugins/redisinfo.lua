local triggers = {
	'^/(hash) (.*)$',
	'^/(hash) (help)$',
	'^/(is) (%d+)$'
}

local action = function(msg, blocks)
	
	--ignore if not admin
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		mystat('hash') --save stats
		return nil
	end
	
	if blocks[1] == 'hash' then
		
		print('\n/hash', msg.from.first_name..' ['..msg.from.id..']')
	
		--return help
		if blocks[2] == 'help' then
			sendMessage(msg.from.id, '*Default hash*:\n\nbot:general\nbot:users\nbot:`chatid`:owner\nbot:`chatid`:mod\nchat:`chatid`:settings\nchat:`chatid`:welcome\n', true, false, true)
			return nil
		end
	
		local hash = blocks[2]
		local success = client:hgetall(hash)
	
		local keys = client:hkeys(hash)
		local vals = client:hvals(hash)
		local message = 'Info about the hash:\n\n'
		for i=1, #keys do
			message = message..keys[i]..' : '..vals[i]..'\n'
		end
	
		sendMessage(msg.chat.id, message)
		mystat('hash') --save stats
	end
	
	--check if an id have ever used the bot
	if blocks[1] == 'is' then
	
		print('\n/is', msg.from.first_name..' ['..msg.from.id..']')
	
		local hash = 'bot:users'
		local keys = client:hkeys(hash)
		for i=1, #keys do
			if keys[i] == tostring(blocks[2]) then
				sendMessage(msg.chat.id, 'User found')
			end
		end
		mystat('is') --save stats
	end
end

return {
	action = action,
	triggers = triggers
}
