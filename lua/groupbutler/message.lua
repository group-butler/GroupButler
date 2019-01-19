local User = require("groupbutler.user")
local ChatMember = require("groupbutler.chatmember")

local Message = {}
local message = Message

local function p(self)
	return getmetatable(self).__private
end

function Message:new(obj, private)
	assert(private.api, "Message: Missing private.api")
	assert(private.i18n, "Message: Missing private.i18n")
	setmetatable(obj, {
		__index = self,
		__private = private,
	})
	return obj
end

local function msg_type(self)
	-- TODO: update database to use "animation" instead of "gif"
	if self.animation then
		return "gif"
	end
	local media_types = {
		"audio", --[["animation",]] "contact", "document", "game", "location", "photo", "sticker", "venue", "video",
		"video_note", "voice",
	}
	for _, v in pairs(media_types) do
		if self[v] then
			return v
		end
	end
	if self.entities then
		for _, entity in pairs(self.entities) do
			if entity.type == "url" or entity.type == "text_link" then
				return "link"
			end
		end
	end
	return "text"
end

function message:type()
	if self._cached_type == nil then
		self._cached_type = msg_type(self)
	end
	return self._cached_type
end

local function get_file_id(self)
	if self.animation then -- TODO: remove this once db migration for gif messages has been completed
		return self.animation.file_id
	end
	if self.photo then
		return self.photo[#self.photo].file_id
	end
	if self[self:type()] and self[self:type()].file_id then
		return self[self:type()].file_id
	end
	return false -- The message has no media file_id
end

function message:get_file_id()
	if self._cached_get_file_id == nil then
		self._cached_get_file_id = get_file_id(self)
	end
	return self._cached_get_file_id
end

function message:send_reply(text, parse_mode, disable_web_page_preview, disable_notification, reply_markup)
	return p(self).api:sendMessage(self.chat.id, text, parse_mode, disable_web_page_preview, disable_notification,
		self.message_id, reply_markup)
end

function Message:getTargetMember(blocks) -- TODO: extract username/id from self.text or move blocks{} into self
	if   not self.reply_to_message
	and (not blocks or not blocks[2]) then
		return false, p(self).i18n("Reply to a user or mention them")
	end

	local user_not_found = p(self).i18n([[I've never seen this user before.
This command works by reply, username, user ID or text mention.
If you're using it by username and want to teach me who the user is, forward me one of their messages]])

	if self.reply_to_message then
		if self.reply_to_message.new_chat_member then
			return ChatMember:new({
				user = self.reply_to_message.new_chat_member,
				chat = self.from.chat,
			}, p(self))
		end
		return self.reply_to_message.from
	end

	if blocks[2]:byte(1) == string.byte("@") then
		local user = User:new({username = blocks[2]}, p(self))
		if not user then
			return false, user_not_found
		end
		return ChatMember:new({
			user = user,
			chat = self.from.chat,
		}, p(self))
	end

	if self.mention_id then
		return ChatMember:new({
			user = User:new({id=self.mention_id}, p(self)),
			chat = self.from.chat,
		}, p(self))
	end

	local id = blocks[2]:match("%d+")
	if id then
		return ChatMember:new({
			user = User:new({id=id}, p(self)),
			chat = self.from.chat,
		}, p(self))
	end

	return false, user_not_found
end

return Message
