 -- Actually the simplest plugin ever!

local triggers = {
	'^/(info)@groupbutler_bot',
	'^/(info)'
}

local action = function(msg, blocks, ln)
	
	print('\n/info', msg.from.first_name..' ['..msg.from.id..']')
	
	local out = make_text(lang[ln].credits)
	mystat('info')
	sendMessage(msg.from.id, out, true, false, true)
end

return {
	action = action,
	triggers = triggers
}
