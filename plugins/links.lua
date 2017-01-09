local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type == 'private' then return end
	if not u.is_allowed('texts', msg.chat.id, msg.from) then return end
	
	local hash = 'chat:'..msg.chat.id..':links'
	local text
	
	if blocks[1] == 'link' then
		if msg.chat.username then
			db:sadd('chat:'..msg.chat.id..':whitelist', 'telegram.me/'..msg.chat.username)
			local title = msg.chat.title:escape_hard('link')
			api.sendReply(msg, string.format('[%s](telegram.me/%s)', title, msg.chat.username), true)
		else
			local link = db:hget(hash, 'link')
			if not link then
				text = _("*No link* for this group. Ask the owner to save it with `/setlink [group link]`")
			else
				local title = msg.chat.title:escape_hard('link')
				text = string.format('[%s](%s)', title, link)
			end
			api.sendReply(msg, text, true)
		end
	end
	if blocks[1] == 'setlink' then
		if blocks[2] and blocks[2] == '-' then
			db:hdel(hash, 'link')
			text = _("Link *unset*")
		else
			local link
			if msg.chat.username then
				link = 'https://telegram.me/'..msg.chat.username
				local substitution = '['..msg.chat.title:escape_hard('link')..']('..link..')'
				text = _("The link has been set.\n*Here's the link*: %s"):format(substitution)
			else
				if not blocks[2] then
					text = _("This is not a *public supergroup*, so you need to write the link near `/setlink`")
				else
					if string.len(blocks[2]) ~= 22 and blocks[2] ~= '-' then
						text = _("This link is *not valid!*")
					else
						link = 'https://telegram.me/joinchat/'..blocks[2]
						db:sadd('chat:'..msg.chat.id..':whitelist', link:gsub('https://', '')) --save the link in the whitelist
						
						local succ = db:hset(hash, 'link', link)
						local title = msg.chat.title:escape_hard('link')
						local substitution = '['..title..']('..link..')'
						if not succ then
							text = _("The link has been updated.\n*Here's the new link*: %s"):format(substitution)
						else
							text = _("The link has been set.\n*Here's the link*: %s"):format(substitution)
						end
					end
				end				
			end
		end
		api.sendReply(msg, text, true)
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(link)$',
		config.cmd..'(setlink)$',
		config.cmd..'(setlink) https://telegram%.me/joinchat/(.*)',
		config.cmd..'(setlink) https://t%.me/joinchat/(.*)',
		config.cmd..'(setlink) (-)'
	}
}

return plugin
