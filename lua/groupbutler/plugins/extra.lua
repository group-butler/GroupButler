local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local locale = require "groupbutler.languages"
local i18n = locale.translate
local null = require "groupbutler.null"

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

local function is_locked(self, chat_id)
	local db = self.db
		local hash = 'chat:'..chat_id..':settings'
		local current = db:hget(hash, 'Extra')
	if current == 'on' then
			return true
	end
			return false
		end

local function set_default(t, d)
  local mt = {__index = function() return d end}
  setmetatable(t, mt)
end

local function sendMedia(chat_id, file_id, media, reply_to_message_id, caption)
	if not media then
		return false, "Media passed is not voice/video/photo"
	end
	local body = {
		chat_id = chat_id,
		[media] = file_id,
		caption = caption,
		reply_to_message_id = reply_to_message_id
	}
	local action = {
		audio = api.send_audio,
		voice = api.send_voice,
		video = api.send_video,
		photo = api.send_photo
	}
	set_default(action, function()
		return false, "Media passed is not voice/video/photo"
	end)
	return action[media](body)
end

function _M:onTextMessage(msg, blocks)
	local u = self.u
	local db = self.db
	if msg.chat.type == 'private' and not(blocks[1] == 'start') then return end

	if blocks[1] == 'extra' then
		if not msg.from.admin then return end
		if not blocks[2] then return end
		if not blocks[3] and not msg.reply then return end

			if msg.reply and not blocks[3] then
			local file_id, media_with_special_method = u:get_media_id(msg.reply)
				if not file_id then
					return
				else
					local to_save
					if media_with_special_method then --photo, voices, video need their method to be sent by file_id
						to_save = '###file_id!'..media_with_special_method..'###:'..file_id
					else
						to_save = '###file_id###:'..file_id
					end
					db:hset('chat:'..msg.chat.id..':extra', blocks[2], to_save)
				u:sendReply(msg, i18n("This media has been saved as a response to %s"):format(blocks[2]))
				end
		else
				local hash = 'chat:'..msg.chat.id..':extra'
				local new_extra = blocks[3]
			local reply_markup, test_text = u:reply_markup_from_text(new_extra)
				test_text = test_text:gsub('\n', '')

			local res, code = u:sendReply(msg, test_text:replaceholders(msg), "Markdown", reply_markup)
				if not res then
				api.sendMessage(msg.chat.id, u:get_sm_error_string(code), "Markdown")
				else
					db:hset(hash, blocks[2]:lower(), new_extra)
				local msg_id = res.message_id
				api.editMessageText(msg.chat.id, msg_id, nil, i18n("Command '%s' saved!"):format(blocks[2]))
				end
			end
	elseif blocks[1] == 'extra list' then
		local text = u:getExtraList(msg.chat.id)
		if not msg.from.admin and not is_locked(self, msg.chat.id) then
			api.sendMessage(msg.from.id, text)
		else
			u:sendReply(msg, text)
		end
		elseif blocks[1] == 'extra del' then
				if not msg.from.admin then return end
			local deleted, not_found, found = {}, {}
			local hash = 'chat:'..msg.chat.id..':extra'
			for extra in blocks[2]:gmatch('(#[%w_]+)') do
				found = db:hdel(hash, extra)
				if found == 1 then
					deleted[#deleted + 1] = extra
				else
					not_found[#not_found + 1] = extra
				end
			end
			if not next(deleted) then deleted[1] = '-' end
			local text = i18n("Commands deleted: `%s`"):format(table.concat(deleted, '`, `'))
			if next(not_found) then
				text = text..i18n('\nCommands not found: `%s`'):format(table.concat(not_found, '`, `'))
			end
		u:sendReply(msg, text, "Markdown")
	else
		local chat_id = blocks[1] == 'start' and tonumber(blocks[2]) or msg.chat.id
		local extra = blocks[1] == 'start' and '#'..blocks[3] or blocks[1]
		--print(chat_id, extra)
			local hash = 'chat:'..chat_id..':extra'
		local text = db:hget(hash, extra:lower())
		if text == null then text = db:hget(hash, extra) end

		if text == null then return true end -- continue to match plugins

				local file_id = text:match('^###.+###:(.*)')
		local special_method = text:match('^###file_id!(.*)###') -- photo, voices, video need their method to be sent by file_id
		local link_preview = text:find('telegra%.ph/') == nil
		local _, err

		if msg.chat.id > 0 or (is_locked(self, msg.chat.id) and not msg.from.admin) then -- send it in private
					if not file_id then
				local reply_markup, clean_text = u:reply_markup_from_text(text)
				_, err = api.sendMessage(msg.from.id, clean_text:replaceholders(msg.reply or msg), "Markdown",
					link_preview, nil, nil, reply_markup)
			elseif special_method then
				_, err = sendMedia(msg.from.id, file_id, special_method) -- photo, voices, video need their method to be sent by file_id
						else
				_, err = api.sendDocument(msg.from.id, file_id)
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
					sendMedia(msg.chat.id, file_id, special_method, msg_to_reply) -- photo, voices, video need their method to be sent by file_id
						else
					api.sendDocument(msg.chat.id, file_id, nil, nil, msg_to_reply)
						end
				else
				local reply_markup, clean_text = u:reply_markup_from_text(text)
				api.sendMessage(msg.chat.id, clean_text:replaceholders(msg.reply or msg), "Markdown", link_preview, nil, msg_to_reply, reply_markup) -- if the admin replies to an user, the bot will reply to the user too
					end
			end

		if err and err.error_code == 403 and msg.chat.id < 0 and not u:is_silentmode_on(msg.chat.id) then -- if the user haven't started the bot and silent mode is off
			u:sendReply(msg, i18n("_Please_ [start me](%s) _so I can send you the answer_")
				:format(u:deeplink_constructor(msg.chat.id, extra:sub(2, -1))), "Markdown")
				end
		end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(extra)$',
		config.cmd..'(extra) (#[%w_]*) (.*)$',
		config.cmd..'(extra) (#[%w_]*)',
		config.cmd..'(extra del) (.+)$',
		config.cmd..'(extra list)$',
		'^/(start) (-?%d+)_([%w_]+)$',
		'^(#[%w_]+)$'
	}
}

return _M
