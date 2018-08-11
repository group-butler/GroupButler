local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local locale = require "groupbutler.languages"
local i18n = locale.translate

local _M = {}

_M.__index = _M

setmetatable(_M, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function _M.new(main)
	local self = setmetatable({}, _M)
	self.update = main.update
	self.u = main.u
	self.db = main.db
	return self
end

local function send_in_group(self, chat_id)
	local db = self.db
	local res = db:hget('chat:'..chat_id..':settings', 'Rules')
	if res == 'on' then
		return true
	end
	return false
end

function _M:onTextMessage(msg, blocks)
	local db = self.db
	local u = self.u

	if msg.chat.type == 'private' then
		if blocks[1] == 'start' then
			msg.chat.id = tonumber(blocks[2])

			local res = api.getChat(msg.chat.id)
			if not res then
				api.sendMessage(msg.from.id, i18n("🚫 Unknown or non-existent group"))
				return
			end
			-- Private chats have no an username
			local private = not res.username

			res = api.getChatMember(msg.chat.id, msg.from.id)
			if not res or (res.status == 'left' or res.status == 'kicked') and private then
				api.sendMessage(msg.from.id, i18n("🚷 You are not a member of this chat. " ..
					"You can't read the rules of a private group."))
				return
			end
		else
			return
		end
	end

	local hash = 'chat:'..msg.chat.id..':info'
	if blocks[1] == 'rules' or blocks[1] == 'start' then
		local rules = u:getRules(msg.chat.id)
		local reply_markup

		reply_markup, rules = u:reply_markup_from_text(rules)

		local link_preview = rules:find('telegra%.ph/') == nil
		if msg.chat.type == 'private' or (not msg.from.admin and not send_in_group(self, msg.chat.id)) then
			api.sendMessage(msg.from.id, rules, "Markdown", link_preview, nil, nil, reply_markup)
		else
			u:sendReply(msg, rules, "Markdown", link_preview, nil, nil, reply_markup)
		end
	end

	if not u:is_allowed('texts', msg.chat.id, msg.from) then return end

	if blocks[1] == 'setrules' then
		local rules = blocks[2]
		--ignore if not input text
		if not rules then
			u:sendReply(msg, i18n("Please write something next `/setrules`"), "Markdown")
			return
		end
		--check if an admin want to clean the rules
		if rules == '-' then
			db:hdel(hash, 'rules')
			u:sendReply(msg, i18n("Rules has been deleted."))
			return
		end

		local reply_markup, test_text = u:reply_markup_from_text(rules)

		--set the new rules
		local ok, err = u:sendReply(msg, test_text, "Markdown", nil, nil, reply_markup)
		if not ok then
			api.sendMessage(msg.chat.id, u:get_sm_error_string(err), "Markdown")
		else
			db:hset(hash, 'rules', rules)
			local id = ok.message_id
			api.editMessageText(msg.chat.id, id, nil, i18n("New rules *saved successfully*!"), "Markdown")
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
