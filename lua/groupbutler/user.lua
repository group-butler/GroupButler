local log = require("groupbutler.logging")

local User = {}

local function p(self)
	return getmetatable(self).__private
end

function User:new(obj, private)
	assert(obj.id or obj.username, "User: Missing obj.id or obj.username")
	assert(private.api, "User: Missing private.api")
	assert(private.db, "User: Missing private.db")
	setmetatable(obj, {
		__index = function(s, index)
			if self[index] then
				return self[index]
			end
			return s:getProperty(index)
		end,
		__private = private,
	})
	if not obj:checkId() then
		return nil, "Username not found"
	end
	return obj
end

function User:checkId()
	local id = rawget(self, "id")
	if not id then
		id = p(self).db:getUserId(self.username)
		if not id then
			return false
		end
		self.id = id
	end
	return true
end

function User:getProperty(index)
	local property = rawget(self, index)
	if property == nil then
		property = p(self).db:getUserProperty(self, index)
		if property == nil then
			local ok = p(self).api:getChat(self.id)
			if not ok then
				log.warn("User: Failed to get {property} for {id}", {
					property = index,
					id = self.id,
				})
				return nil
			end
			for k,v in pairs(ok) do
				self[k] = v
			end
			self:cache()
			property = rawget(self, index)
		end
		self[index] = property
	end
	return property
end

function User:cache()
	p(self).db:cacheUser(self)
end

return User
