local User = {}

local _p = setmetatable({}, {__mode = "k"}) -- weak table storing all private attributes

function User:new(obj, update_obj)
	_p[obj] = {
		api = update_obj.api,
		db = update_obj.db,
		u = update_obj.u,
	}
	setmetatable(obj, {__index = self})
	return obj
end

function User:cache()
	_p[self].db:cache_user(self)
end

return User
