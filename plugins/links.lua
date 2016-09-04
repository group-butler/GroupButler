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
			text = _("*No link* for this group. Ask the owner to generate one")
		else
			local title = msg.chat.title:mEscape_hard()
			text = string.format('[%s](%s)', title, link)
		end
		api.sendReply(msg, text, true)
	end
	
	if blocks[1] == 'setlink' then
		
		local link
		if msg.chat.username then
			link = 'https://telegram.me/'..msg.chat.username
		else
			if not blocks[2] then
				local text = _("This is not a *public supergroup*, so you need to write the link near /setlink")
				api.sendReply(msg, text, true)
				return
			end
			--warn if the link has not the right lenght
			if string.len(blocks[2]) ~= 22 and blocks[2] ~= '-' then
				api.sendReply(msg, _("This link is *not valid!*"), true)
				return
			end
			link = 'https://telegram.me/joinchat/'..blocks[2]
		end
		
		local key = 'link'
		
		--set to nul the link, or update/set it
		if blocks[2] == '-' then
			db:hdel(hash, key)
			text = _("Link *unsetted*")
		else
			local succ = db:hset(hash, key, link)
			local title = msg.chat.title:mEscape_hard()
			local substitution = string.format('[%s](%s)', title, link)
			if succ == false then
				text = _("The link has been updated.\n*Here's the new link*: %s"):format(substitution)
			else
				text = _("The link has been setted.\n*Here's the link*: %s"):format(substitution)
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
