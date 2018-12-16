local log = require("groupbutler.logging")

local Chat = {}

local function p(self)
	return getmetatable(self).__private
end

function Chat:new(obj, private)
	assert(obj.id, "Chat: Missing obj.id")
	assert(private.api, "Chat: Missing private.api")
	assert(private.db, "Chat: Missing private.db")
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

function Chat:getProperty(index)
	local property = rawget(self, index)
	if property == nil then
		property = p(self).db:getChatProperty(self, index)
		if property == nil then
			local ok = p(self).api:getChat(self.id)
			if not ok then
				log.warn("Chat: Failed to get {property} for {id}", {
					property = index,
					id = self.id,
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

function Chat:cache()
	p(self).db:cacheChat(self)
end

return Chat
