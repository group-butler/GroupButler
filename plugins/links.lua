local triggers = {
	'^/(link)$',
	'^/(link)@groupbutler_bot$',
	'^/(setlink) https://telegram%.me/joinchat/(.*)',
	'^/(setlink) (no)',
	'^/(poll)$',
	'^/(setpoll) (.*) telegram%.me/PollBot%?start=(.*)',
	'^/(setpoll) (no)$'
}

local action = function(msg, blocks)
	
	--return nil if wrote in private
    if msg.chat.type == 'private' then
        print('PV links.lua, '..msg.from.first_name..' ['..msg.from.id..'] --> not valid')
        sendMessage(msg.from.id, 'This is a command available only in a group')
    	return nil
    end
	
	--initialize the hash
	local hash = 'chat:'..msg.chat.id..'links'
	local text
	
	if blocks[1] == 'link' then
		
		print('\n/link', msg.from.first_name..' ['..msg.from.id..']')
		
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			return
		end
		
		local key = 'link'
		local link = client:hget(hash, key)
		
		--check if link is nil or nul
		if link == 'no' or link == nil then
			text = '*No link* for this group. Ask the owner to generate one'
		else
			text = '['..msg.chat.title..']('..link..')'
		end
		
		mystat('link') --save stats
		sendReply(msg, text, true)
	end
	
	if blocks[1] == 'setlink' then
		
		print('\n/setlink', msg.from.first_name..' ['..msg.from.id..']')
		
		--ignore if not owner
		if not is_owner(msg) then
			print('\27[31mNil: not the owner\27[39m')
			return
		end
		
		--warn if the link has not the right lenght
		if string.len(blocks[2]) ~= 22 and blocks[2] ~= 'no' then
			print('\27[31mNil: wrong link\27[39m')
			sendReply(msg, 'This link is *not valid!*', true)
			return
		end
		
		local link = 'https://telegram.me/joinchat/'..blocks[2]
		local key = 'link'
		
		--set to nul the link, or update/set it
		if blocks[2] == 'no' then
			client:hset(hash, key, 'no')
			text = 'Link *unsetted*'
		else
			local succ = client:hset(hash, key, link)
			if succ == false then
				text = 'The link have been updated.\n*Here\'s the new link*: ['..msg.chat.title..']('..link..')'
			else
				text = 'The link have been setted.\n*Here\'s the link*: ['..msg.chat.title..']('..link..')'
			end
		end
			
		mystat('setlink') --save stats
		sendReply(msg, text, true)
	end
	
	if blocks[1] == 'setpoll' then
		
		print('\n/setpoll', msg.from.first_name..' ['..msg.from.id..']')
		
		--ignore if not owner
		if not is_mod(msg) then
			print('\27[31mNil: not a mod\27[39m')
			return
		end
		
		--warn if the link has not the right lenght
		if blocks[2] ~= 'no' and string.len(blocks[3]) ~= 36 then
			print('\27[31mNil: wrong link\27[39m')
			sendReply(msg, 'This link is *not valid!*', true)
			return
		end
		
		local key = 'poll'
		
		--set to nul the poll, or update/set it
		if blocks[2] == 'no' then
			client:hset(hash, key, 'no')
			text = 'Poll *unsetted*'
		else
			local link = 'telegram.me/PollBot?start='..blocks[3]
			local succ = client:hset(hash, key, link)
			local description = blocks[2]
			
			--save description of the poll in redis
			client:hset(hash, 'polldesc', description)
			if succ == false then
				text = 'The poll have been updated.\n*Vote here*: ['..description..']('..link..')'
			else
				text = 'The link have been setted.\n*Vote here*: ['..description..']('..link..')'
			end
		end
			
		mystat('setpoll') --save stats
		sendReply(msg, text, true)
		
end

	if blocks[1] == 'poll' then
		
		print('\n/poll', msg.from.first_name..' ['..msg.from.id..']')
		
		--ignore if not mod
		if not is_mod(msg) then
			print('\27[31mNil: not mod\27[39m')
			return
		end
		
		local key = 'poll'
		local link = client:hget(hash, key)
		local description = client:hget(hash, 'polldesc')
		
		--check if link is nil or nul
		if link == 'no' or link == nil then
			text = '*No active poll* for this group'
		else
			text = '*Vote here*: ['..description..']('..link..')'
		end
		
		mystat('poll') --save stats
		sendReply(msg, text, true)
		
	end
end

return {
	action = action,
	triggers = triggers
}