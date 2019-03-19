local config = require "groupbutler.config"
local null = require "groupbutler.null"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

function _M:onTextMessage(blocks)
	local msg = self.message
	local red = self.red
	local i18n = self.i18n

	if msg.from.chat.type == "private"
	or not msg.from:isAdmin() then
		return
	end

	local hash = 'chat:'..msg.from.chat.id..':links'
	local text

	if blocks[1] == 'link' then
		if msg.from.chat.username then
			red:sadd('chat:'..msg.from.chat.id..':whitelist', 'telegram.me/'..msg.from.chat.username)
			local title = msg.from.chat.title:escape_hard('link')
			msg:send_reply(string.format('[%s](telegram.me/%s)', title, msg.from.chat.username), "Markdown")
		else
			local link = red:hget(hash, 'link')
			if link == null then
				text = i18n("*No link* for this group. Ask the owner to save it with `/setlink [group link]`")
			else
				local title = msg.from.chat.title:escape_hard('link')
				text = string.format('[%s](%s)', title, link)
			end
			msg:send_reply(text, "Markdown")
		end
	end
	if blocks[1] == 'setlink' then
		if blocks[2] and blocks[2] == '-' then
			red:hdel(hash, 'link')
			text = i18n("Link *unset*")
		else
			local link
			if msg.from.chat.username then
				link = 'https://telegram.me/'..msg.from.chat.username
				local substitution = '['..msg.from.chat.title:escape_hard('link')..']('..link..')'
				text = i18n("The link has been set.\n*Here's the link*: %s"):format(substitution)
			else
				if not blocks[2] then
					text = i18n("This is not a *public supergroup*, so you need to write the link near `/setlink`")
				else
					if string.len(blocks[2]) ~= 22 and blocks[2] ~= '-' then
						text = i18n("This link is *not valid!*")
					else
						link = 'https://telegram.me/joinchat/'..blocks[2]
						red:sadd('chat:'..msg.from.chat.id..':whitelist', link:gsub('https://', '')) --save the link in the whitelist

						local succ = red:hset(hash, 'link', link)
						local title = msg.from.chat.title:escape_hard('link')
						local substitution = '['..title..']('..link..')'
						if not succ then
							text = i18n("The link has been updated.\n*Here's the new link*: %s"):format(substitution)
						else
							text = i18n("The link has been set.\n*Here's the link*: %s"):format(substitution)
						end
					end
				end
			end
		end
		msg:send_reply(text, "Markdown")
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(link)$',
		config.cmd..'(setlink)$',
		config.cmd..'(setlink) https://telegram%.me/joinchat/(.*)',
		config.cmd..'(setlink) https://t%.me/joinchat/(.*)',
		config.cmd..'(setlink) (-)'
	}
}

return _M
