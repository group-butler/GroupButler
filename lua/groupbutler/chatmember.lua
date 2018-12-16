local log = require("groupbutler.logging")

local ChatMember = {}

local _p = setmetatable({}, {__mode = "k"}) -- weak table storing all private attributes

function ChatMember:new(obj, private)
	assert(obj.chat, "ChatMember: Missing obj.chat")
	assert(obj.user, "ChatMember: Missing obj.user")
	assert(private.db, "ChatMember: Missing private.db")
	assert(private.api, "ChatMember: Missing private.api")
	_p[obj] = private
	setmetatable(obj, {
		__index = function(s, index)
			if self[index] then
				return self[index]
			end
			return s:getProperty(index)
		end
	})
	return obj
end

function ChatMember:getProperty(index)
	local property = rawget(self, index)
	if property == nil then
		property = _p[self].db:getChatMemberProperty(self, index)
		if property == nil then
			local ok = _p[self].api:getChatMember(self.chat.id, self.user.id)
			if not ok then
				log.warn("ChatMember: Failed to get {property} for {chat_id}, {user_id}", {
					property = index,
					chat_id = self.chat.id,
					user_id = self.user.id,
				})
				return nil
			end
			self = ok
			self:cache()
			property = rawget(self, index)
		end
		self[index] = property
	end
	return property
end

function ChatMember:cache()
	_p[self].db:cacheChatMember(self)
end

return ChatMember
