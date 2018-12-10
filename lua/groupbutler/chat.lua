local Chat = {}

local _p = setmetatable({}, {__mode = "k"}) -- weak table storing all private attributes

function Chat:new(obj, update_obj)
	_p[obj] = {
		api = update_obj.api,
		db = update_obj.db,
		u = update_obj.u,
	}
	setmetatable(obj, {__index = self})
	return obj
end

function Chat:cache()
	_p[self].db:cacheChat(self)
end

return Chat
