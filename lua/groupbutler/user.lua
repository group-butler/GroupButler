local User = {}

local function p(self)
	return getmetatable(self).__private
end

function User:new(obj, private)
	assert(private.db, "User: Missing private.db")
	setmetatable(obj, {
		__index = self,
		__private = private,
	})
	return obj
end

function User:cache()
	p(self).db:cache_user(self)
end

return User
