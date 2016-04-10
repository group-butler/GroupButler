local triggers = {
	'^/(moderation backup)$'
}

local action = function(msg, blocks, ln)
	
	print('\n/redis backup', msg.from.first_name..' ['..msg.from.id..']')
	
	 --ignore if not admin
    if msg.from.id ~= config.admin then
        print('\27[31mNil: not admin\27[39m')
		return nil
	end
	
	local rb = load_data("redisbackup.json")
	rb = {}
	
	local groups = load_data("groups.json")
	
	for k, v in pairs(groups) do
		rb[tostring(k)] = {mods = {}, owner = {}}
		local hash = 'bot:'..k..':mod'
		local modlist_id = client:hkeys(hash)
		local modlist_name = client:hvals(hash)
		for i=1, #modlist_id do
			rb[tostring(k)]['mods'][tostring(modlist_id[i])] = modlist_name[i]
		end
		hash = 'bot:'..k..':owner'
		local ownerlist = client:hkeys(hash)
		local owner_id = ownerlist[1]
		ownerlist = client:hvals(hash)
		local owner_name = ownerlist[1]
		rb[tostring(k)]['owner'][tostring(owner_id)] = owner_name
	end
		
	save_data("redisbackup.json", rb)
		
	mystat('redisbackup') --save stats
	sendMessage(msg.chat.id, make_text(lang[ln].redisbackup), true, false, true)
end

return {
	action = action,
	triggers = triggers
}