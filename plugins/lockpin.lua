local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

function plugin.onTextMessage(msg, blocks)
	if u.is_allowed('texts', msg.chat.id, msg.from) then
		if blocks[1] == 'pinmsg' then
			local text
			if u.bot_is_admin(msg.from.id) then
				if msg.reply then
					local hash = 'chat:'..msg.chat.id..':settings'
					local status = db:hget(hash, 'Pin')
					if status == 'on' then
						if u.is_owner(msg.chat.id, msg.from.id) then
							local try = api.pinChatMessage(msg.chat.id, msg.reply.message_id)
							if not try then
								text = _("I can't pin your message!.")
							else
								text = _("Your message pinned successfully.")
								db:set('chat:'..msg.chat.id..':pin_id', msg.reply.message_id)
							end
						else
							text = _("*You can't pin a message!*")
						end
					end
				else
					text = _("You should *reply to a message*! Then I can pin your message.")
				end
			end
			api.sendReply(msg, text, true)
		end
		if blocks[1] == 'repin' then
			local last_pin = db:set('chat:'..msg.chat.id..':pin_id')
			if last_pin then
				api.pinChatMessage(msg.chat.id, last_pin, true) -- disabled notification
			else
				api.sendReply(msg, 'I cannot *find* the last pin message.', true)
			end
		end
		if blocks[1] == 'pinned_message' then
			local hash = 'chat:'..msg.chat.id..':settings'
			local status = db:hget(hash, 'Pin')
			if status == 'on' then
				if u.is_owner(msg.chat.id, msg.from.id) then
					db:set('chat:'..msg.chat.id..':pin_id', msg.message_id)
				else
					local text = _("You're *not allowed* to pin message!")
					api.sendReply(msg, text, true)
					api.unpinChatMessage(msg.chat.id)
					local last_pin = db:set('chat:'..msg.chat.id..':pin_id')
					if last_pin then
						api.pinChatMessage(msg.chat.id, last_pin, true) -- disabled notification
					end
				end
			end
		end
		if blocks[1] == 'unpin' then
			api.unpinChatMessage(msg.chat.id)
			api.sendReply(msg, 'The pin message has been unpinned!')
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(pinmsg)$',
        config.cmd..'(repin)$',
		config.cmd..'(unpin)$',
		'###(pinned_message)$'
	}
}
