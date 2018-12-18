local Chat = {}

local function p(self)
	return getmetatable(self).__private
end

function Chat:new(obj, private)
	assert(private.db, "Chat: Missing private.db")
	setmetatable(obj, {
		__index = self,
		__private = private,
	})
	return obj
end

function Chat:cache()
	p(self).db:cacheChat(self)
end

return Chat
