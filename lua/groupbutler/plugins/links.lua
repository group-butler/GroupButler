local config = require "groupbutler.config"
local locale = require "groupbutler.languages"
local i18n = locale.translate
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
	local u = self.u
	local db = self.db
	if msg.chat.type == 'private' then return end
	if not u:is_allowed('texts', msg.chat.id, msg.from) then return end

	local hash = 'chat:'..msg.chat.id..':links'
	local text

	if blocks[1] == 'link' then
		if msg.chat.username then
			db:sadd('chat:'..msg.chat.id..':whitelist', 'telegram.me/'..msg.chat.username)
			local title = msg.chat.title:escape_hard('link')
			u:sendReply(msg, string.format('[%s](telegram.me/%s)', title, msg.chat.username), "Markdown")
		else
			local link = db:hget(hash, 'link')
			if link == null then
				text = i18n("*No link* for this group. Ask the owner to save it with `/setlink [group link]`")
			else
				local title = msg.chat.title:escape_hard('link')
				text = string.format('[%s](%s)', title, link)
			end
			u:sendReply(msg, text, "Markdown")
		end
	end
	if blocks[1] == 'setlink' then
		if blocks[2] and blocks[2] == '-' then
			db:hdel(hash, 'link')
			text = i18n("Link *unset*")
		else
			local link
			if msg.chat.username then
				link = 'https://telegram.me/'..msg.chat.username
				local substitution = '['..msg.chat.title:escape_hard('link')..']('..link..')'
				text = i18n("The link has been set.\n*Here's the link*: %s"):format(substitution)
			else
				if not blocks[2] then
					text = i18n("This is not a *public supergroup*, so you need to write the link near `/setlink`")
				else
					if string.len(blocks[2]) ~= 22 and blocks[2] ~= '-' then
						text = i18n("This link is *not valid!*")
					else
						link = 'https://telegram.me/joinchat/'..blocks[2]
						db:sadd('chat:'..msg.chat.id..':whitelist', link:gsub('https://', '')) --save the link in the whitelist

						local succ = db:hset(hash, 'link', link)
						local title = msg.chat.title:escape_hard('link')
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
		u:sendReply(msg, text, "Markdown")
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
