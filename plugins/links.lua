local action = function(msg, blocks, ln)
	
	--return nil if wrote in private
    if msg.chat.type == 'private' then
        local out = make_text(lang[ln].pv)
        api.sendMessage(msg.from.id, out)
    	return nil
    end
	
	--initialize the hash
	local hash = 'chat:'..msg.chat.id..'links'
	local text
	
	if blocks[1] == 'link' then
		--ignore if not mod
		if not is_mod(msg) then
			return
		end
		
		local key = 'link'
		local link = client:hget(hash, key)
		
		--check if link is nil or nul
		if link == 'no' or link == nil then
			text = make_text(lang[ln].links.no_link)
		else
			text = make_text(lang[ln].links.link, msg.chat.title, link)
		end
		api.sendReply(msg, text, true)
		mystat('/link')
	end
	
	if blocks[1] == 'setlink' then
		--ignore if not owner
		if not is_owner(msg) then
			return
		end
		
		--warn if the link has not the right lenght
		if string.len(blocks[2]) ~= 22 and blocks[2] ~= 'no' then
			local out = make_text(lang[ln].links.link_invalid)
			api.sendReply(msg, out, true)
			return
		end
		
		local link = 'https://telegram.me/joinchat/'..blocks[2]
		local key = 'link'
		
		--set to nul the link, or update/set it
		if blocks[2] == 'no' then
			client:hset(hash, key, 'no')
			text = make_text(lang[ln].links.link_unsetted)
		else
			local succ = client:hset(hash, key, link)
			local title = msg.chat.title:neat():gsub('%]', ''):gsub('%[', '')
			if succ == false then
				text = make_text(lang[ln].links.link_updated, title, link)
			else
				text = make_text(lang[ln].links.link_setted, title, link)
			end
		end
		api.sendReply(msg, text, true)
		mystat('/setlink')
	end
	
	if blocks[1] == 'setpoll' then
		--ignore if not owner
		if not is_mod(msg) then
			return
		end
		
		--warn if the link has not the right lenght
		if blocks[2] ~= 'no' and string.len(blocks[3]) ~= 36 then
			local out = make_text(lang[ln].links.link_invalid)
			sendReply(msg, out, true)
			return
		end
		
		local key = 'poll'
		
		--set to nul the poll, or update/set it
		if blocks[2] == 'no' then
			client:hset(hash, key, 'no')
			text = make_text(lang[ln].links.poll_unsetted)
		else
			local link = 'telegram.me/PollBot?start='..blocks[3]
			local succ = client:hset(hash, key, link)
			local description = blocks[2]
			
			--save description of the poll in redis
			client:hset(hash, 'polldesc', description)
			if succ == false then
				text = make_text(lang[ln].links.poll_updated, description, link)
			else
				text = make_text(lang[ln].links.poll_setted, description, link)
			end
		end
		api.sendReply(msg, text, true)
		mystat('/setpoll')
	end

	if blocks[1] == 'poll' then
		--ignore if not mod
		if not is_mod(msg) then
			return
		end
		
		local key = 'poll'
		local link = client:hget(hash, key)
		local description = client:hget(hash, 'polldesc')
		
		--check if link is nil or nul
		if link == 'no' or link == nil then
			text = make_text(lang[ln].links.no_poll)
		else
			text = make_text(lang[ln].links.poll, description, link)
		end
		api.sendReply(msg, text, true)
		mystat('/poll')
	end
end

return {
	action = action,
	triggers = {
		'^/(link)$',
		'^/(link)@groupbutler_bot$',
		'^/(setlink) https://telegram%.me/joinchat/(.*)',
		'^/(setlink) (no)',
		'^/(poll)$',
		'^/(setpoll) (.*) telegram%.me/PollBot%?start=(.*)',
		'^/(setpoll) (no)$'
	}
}