local user = {}

function user:new(user_obj, update_obj)
	user_obj.api = update_obj.api
	user_obj.u = update_obj.u
	user_obj.db = update_obj.db
	setmetatable(user_obj, {__index = self})
	user_obj:cache()
	return user_obj
end

function user:cache()
	self.db:cache_user(self)
end

return user
