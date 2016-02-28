local triggers = {
	'^/(reload)',
	'^/(halt)'
}

local action = function(msg)
	
	print('\n/reload or /halt', msg.from.first_name..' ['..msg.from.id..']')
	
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end
	
	if msg.text:match('^/reload') then
		--client:bgsave()
		bot_init()
		sendReply(msg, 'Bot reloaded!')
		mystat('reload') --save stat
	elseif msg.text:match('^/halt') then
		client:bgsave()
		is_started = false
		sendReply(msg, 'Stopping bot!')
		mystat('halt') --save stat
	end

end

return {
	action = action,
	triggers = triggers
}

