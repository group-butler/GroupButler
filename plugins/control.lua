local triggers = {
	'^/(reload)@groupbutler_bot',
	'^/(halt)@groupbutler_bot',
	'^/(reload)$',
	'^/(halt)$'
}

local action = function(msg, blocks, ln)
	
	if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end
	
	if msg.text:match('^/reload') then
		--client:bgsave()
		bot_init(true)
		
		local out = make_text(lang[ln].control.reload)
		sendReply(msg, out, true)
		mystat('reload') --save stat
	elseif msg.text:match('^/halt') then
		client:bgsave()
		is_started = false
		
		local out = make_text(lang[ln].control.stop)
		sendReply(msg, out, true)
		mystat('halt') --save stat
	end

end

return {
	action = action,
	triggers = triggers
}

