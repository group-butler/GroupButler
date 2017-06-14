local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function is_allowed(chat_id)
	return db.getvchat(chat_id, 'extra')
end

function plugin.onTextMessage(msg, blocks)

	if msg.chat.type == 'private' then return end

	if blocks[1] == 'extra' then
		if not u.is_allowed('texts', msg.chat.id, msg.from) then return end
		if not blocks[2] then return end
		if not blocks[3] and not msg.reply then return end

		if msg.reply and not blocks[3] then
			local file_id, media_with_special_method = u.get_media_id(msg.reply)
			if not file_id then
				return
			else
				local to_save
				if media_with_special_method then --photo, voices, video need their method to be sent by file_id
					to_save = '###file_id!'..media_with_special_method..'###:'..file_id
				else
					to_save = '###file_id###:'..file_id
				end
				db.setvce(msg.chat.id, blocks[2], 'response', to_save)
				db.setvce(msg.chat.id, blocks[2], 'kind', "'media'")
				api.sendReply(msg, ("This media has been saved as a response to %s"):format(blocks[2]))
			end
		else
			local hash = 'chat:'..msg.chat.id..':extra'
			local new_extra = blocks[3]
			local reply_markup, test_text = u.reply_markup_from_text(new_extra)
			test_text = test_text:gsub('\n', '')

			local res, code = api.sendReply(msg, test_text:replaceholders(msg), true, reply_markup)
			if not res then
				api.sendMessage(msg.chat.id, u.get_sm_error_string(code), true)
			else
				db.setvce(msg.chat.id, blocks[2], 'response', new_extra)
				local msg_id = res.result.message_id
				api.editMessageText(msg.chat.id, msg_id, ("Command '%s' saved!"):format(blocks[2]))
			end
		end
	elseif blocks[1] == 'extra list' then
		local text = u.getExtraList(msg.chat.id)
		if not msg.from.mod and is_allowed(msg.chat.id) then
			api.sendMessage(msg.from.id, text, true)
		else
			api.sendReply(msg, text, true)
		end
	elseif blocks[1] == 'extra del' then
		if not u.is_allowed('texts', msg.chat.id, msg.from) then return end

		local res = db.delce(msg.chat.id, blocks[2])
		local out
		if res > 0 then
			out = ("The command '%s' has been deleted!"):format(blocks[2])
		else
			out = ("The command '%s' does not exist!"):format(blocks[2])
		end
		api.sendReply(msg, out)
	else
		local text = db.getvce(msg.chat.id, blocks[1], 'response')
		if not text then return true end --continue to match plugins
		local file_id = text:match('^###.+###:(.*)')
		local special_method = text:match('^###file_id!(.*)###') --photo, voices, video need their method to be sent by file_id
		local link_preview = text:find('telegra%.ph/') ~= nil
		if not is_allowed(msg.chat.id) and not msg.from.mod then --send it in private
			if not file_id then
				local reply_markup, clean_text = u.reply_markup_from_text(text)
				api.sendMessage(msg.from.id, clean_text:replaceholders(msg.reply or msg), true, reply_markup, nil, link_preview)
			else
				if special_method then
					api.sendMediaId(msg.from.id, file_id, special_method) --photo, voices, video need their method to be sent by file_id
				else
					api.sendDocumentId(msg.from.id, file_id)
				end
			end
		else
			local msg_to_reply
			if msg.reply then
				msg_to_reply = msg.reply.message_id
			else
				msg_to_reply = msg.message_id
			end
			if file_id then
				if special_method then
					api.sendMediaId(msg.chat.id, file_id, special_method, msg_to_reply) --photo, voices, video need their method to be sent by file_id
				else
					api.sendDocumentId(msg.chat.id, file_id, msg_to_reply)
				end
			else
				local reply_markup, clean_text = u.reply_markup_from_text(text)
				api.sendMessage(msg.chat.id, clean_text:replaceholders(msg.reply or msg), true, reply_markup, msg_to_reply, link_preview) --if the mod replies to an user, the bot will reply to the user too
			end
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(extra)$',
		config.cmd..'(extra) (#[%w_]*) (.*)$',
		config.cmd..'(extra) (#[%w_]*)',
		config.cmd..'(extra del) (#[%w_]*)$',
		config.cmd..'(extra list)$',
		'^(#[%w_]*)$'
	}
}

return plugin
