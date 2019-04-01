local log = require("groupbutler.logging")
local User = require("groupbutler.user")
local StorageUtil = require("groupbutler.storage.util")

local ChatMember = {}

local function p(self)
	return getmetatable(self).__private
end

function ChatMember:new(obj, private)
	assert(obj.chat, "ChatMember: Missing obj.chat")
	assert(obj.user, "ChatMember: Missing obj.user")
	assert(private.db, "ChatMember: Missing private.db")
	assert(private.api, "ChatMember: Missing private.api")
	setmetatable(obj, {
		__index = function(s, index)
			if self[index] then
				return self[index]
			end
			return s:getProperty(index)
		end,
		__private = private,
	})
	return obj
end

function ChatMember:getProperty(index)
	if not StorageUtil.isChatMemberProperty[index] then
		log.warn("Tried to get invalid chatmember property {property}", {property=index})
		return nil
	end
	local property = rawget(self, index)
	if property == nil then
		property = p(self).db:getChatMemberProperty(self, index)
		if property == nil then
			local ok = p(self).api:getChatMember(self.chat.id, self.user.id)
			if not ok then
				log.warn("ChatMember: Failed to get {property} for {chat_id}, {user_id}", {
					property = index,
					chat_id = self.chat.id,
					user_id = self.user.id,
				})
				return nil
			end
			for k,v in pairs(ok) do
				self[k] = v
				if k == "user" then
					User:new(self.user, p(self))
				end
			end
			self:cache()
			property = rawget(self, index)
		end
		self[index] = property
	end
	return property
end

function ChatMember:cache()
	p(self).db:cacheChatMember(self)
end

function ChatMember:isAdmin()
	if self.chat.type == "private" then -- This should never happen but...
		return false
	end
	return self.status == "creator" or self.status == "administrator"
end

function ChatMember:can(permission)
	if self.chat.type == "private" then -- This should never happen but...
		return false
	end
	if self.status == "creator"
	or (self.status == "administrator" and self[permission]) then
		return true
	end
	return false
end

function ChatMember:ban(until_date)
	local ok, err = p(self).api:kickChatMember(self.chat.id, self.user.id, until_date)
	if not ok then
		return nil, p(self).api_err:trans(err)
	end
	return ok
end

function ChatMember:kick()
	local ok, err = p(self).api:kickChatMember(self.chat.id, self.user.id)
	if not ok then
		return nil, p(self).api_err:trans(err)
	end
	p(self).api:unbanChatMember(self.chat.id, self.user.id)
	return ok
end

function ChatMember:mute(until_date)
	local ok, err = p(self).api:restrictChatMember({
		chat_id = self.chat.id,
		user_id = self.user.id,
		until_date = until_date,
		can_send_messages = false,
	})
	if not ok then
		return nil, p(self).api_err:trans(err)
	end
	return ok
end

return ChatMember
