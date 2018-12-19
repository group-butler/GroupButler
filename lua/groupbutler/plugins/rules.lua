local config = require "groupbutler.config"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function send_in_group(self, chat_id)
	local red = self.red
	local res = red:hget('chat:'..chat_id..':settings', 'Rules')
	if res == 'on' then
		return true
	end
	return false
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n
	local api_err = self.api_err
	local u = self.u

	if msg.from.chat.type == 'private' then
		if blocks[1] == 'start' then
			msg.from.chat.id = tonumber(blocks[2])

			local res = api:getChat(msg.from.chat.id)
			if not res then
				api:sendMessage(msg.from.user.id, i18n("🚫 Unknown or non-existent group"))
				return
			end
			-- Private chats have no username
			local private = not res.username

			res = api:getChatMember(msg.from.chat.id, msg.from.user.id)
			if not res or (res.status == 'left' or res.status == 'kicked') and private then
				api:sendMessage(msg.from.user.id, i18n("🚷 You are not a member of this chat. " ..
					"You can't read the rules of a private group."))
				return
			end
		else
			return
		end
	end

	local hash = 'chat:'..msg.from.chat.id..':info'
	if blocks[1] == 'rules' or blocks[1] == 'start' then
		local rules = u:getRules(msg.from.chat.id)
		local reply_markup

		reply_markup, rules = u:reply_markup_from_text(rules)

		local link_preview = rules:find('telegra%.ph/') == nil
		if msg.from.chat.type == 'private' or (not send_in_group(self, msg.from.chat.id) and not msg.from:isAdmin()) then
			api:sendMessage(msg.from.user.id, rules, "Markdown", link_preview, nil, nil, reply_markup)
		else
			msg:send_reply(rules, "Markdown", link_preview, nil, nil, reply_markup)
		end
	end

	if not u:is_allowed('texts', msg.from.chat.id, msg.from.user) then return end

	if blocks[1] == 'setrules' then
		local rules = blocks[2]
		--ignore if not input text
		if not rules then
			msg:send_reply(i18n("Please write something next `/setrules`"), "Markdown")
			return
		end
		--check if an admin want to clean the rules
		if rules == '-' then
			red:hdel(hash, 'rules')
			msg:send_reply(i18n("Rules has been deleted."))
			return
		end

		local reply_markup, test_text = u:reply_markup_from_text(rules)

		--set the new rules
		local ok, err = msg:send_reply(test_text, "Markdown", nil, nil, reply_markup)
		if not ok then
			api:sendMessage(msg.from.chat.id, api_err:trans(err), "Markdown")
		else
			red:hset(hash, 'rules', rules)
			local id = ok.message_id
			api:editMessageText(msg.from.chat.id, id, nil, i18n("New rules *saved successfully*!"), "Markdown")
		end
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(setrules)$',
		config.cmd..'(setrules) (.*)',
		config.cmd..'(rules)$',
		'^/(start) (-?%d+)_rules$'
	}
}

return _M
