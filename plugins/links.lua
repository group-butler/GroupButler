local action = function(msg, blocks)
    if msg.chat.type == 'private' then return end
	if not roles.is_admin_cached(msg) then return end
	
	local hash = 'chat:'..msg.chat.id..':links'
	local text
	
	if blocks[1] == 'link' then
		
		local key = 'link'
		local link = db:hget(hash, key)
		
		--check if link is nil or nul
		if not link then
			text = lang[msg.ln].links.no_link
		else
			local title = msg.chat.title:mEscape_hard()
			text = make_text(lang[msg.ln].links.link, title, link)
		end
		api.sendReply(msg, text, true)
	end
	
	if blocks[1] == 'setlink' then
		
		local link
		if msg.chat.username then
			link = 'https://telegram.me/'..msg.chat.username
		else
			if not blocks[2] then
				api.sendReply(msg, lang[msg.ln].links.link_no_input, true)
				return
			end
			--warn if the link has not the right lenght
			if string.len(blocks[2]) ~= 22 and blocks[2] ~= '-' then
				api.sendReply(msg, lang[msg.ln].links.link_invalid, true)
				return
			end
			link = 'https://telegram.me/joinchat/'..blocks[2]
		end
		
		local key = 'link'
		
		--set to nul the link, or update/set it
		if blocks[2] == '-' then
			db:hdel(hash, key)
			text = lang[msg.ln].links.link_unsetted
		else
			local succ = db:hset(hash, key, link)
			local title = msg.chat.title:mEscape_hard()
			if succ == false then
				text = make_text(lang[msg.ln].links.link_updated, title, link)
			else
				text = make_text(lang[msg.ln].links.link_setted, title, link)
			end
		end
		api.sendReply(msg, text, true)
	end
end

return {
	action = action,
	triggers = {
		config.cmd..'(link)$',
		config.cmd..'(setlink)$',
		config.cmd..'(setlink) https://telegram%.me/joinchat/(.*)',
		config.cmd..'(setlink) (-)'
	}
}