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
		__tostring = self.__tostring,
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

function User:__tostring()
	if self.first_name then
		local name = self.first_name
		if self.last_name then
			name = name.." "..self.last_name
		end
		return name
	end
	if self.username then
		return self.username
	end
	return self.id
end

function User:cache()
	p(self).db:cacheUser(self)
end

function User:getLink()
	return ('<a href="%s">%s</a>'):format("tg://user?id="..self.id, self)
		or  ("<code>"..self:escape_html().."</code>")
end

return User
