local RedisStorage = require("groupbutler.storage.redis")
local _, PostgresStorage = pcall(function() return require("groupbutler.storage.postgres") end)

local MixedStorage = {}

function MixedStorage:new(redis_db)
	setmetatable(self, {__index = RedisStorage}) -- Any unimplemented method falls back to redis
	local obj = setmetatable({}, {__index = self})
	obj.redis = redis_db
	obj.redis_storage = RedisStorage:new(redis_db)
	_, obj.postgres_storage = pcall(function() return PostgresStorage:new() end)
	return obj
end

function MixedStorage:cacheUser(user)
	local res, ok = pcall(function() return self.postgres_storage:cacheUser(user) end)
	if not res or not ok then
		self.redis_storage:cacheUser(user)
	end
end

function MixedStorage:getUserId(username)
	local ok, id = pcall(function() return self.postgres_storage:getUserId(username) end)
	if not ok or not id then
		return self.redis_storage:getUserId(username)
	end
	return id
end

function MixedStorage:getUserProperty(user, property)
	local ok, retval = pcall(function() return self.postgres_storage:getUserProperty(user, property) end)
	if not ok or not retval then
		return self.redis_storage:getUserProperty(user, property)
	end
	return retval
end

function MixedStorage:getChatProperty(chat, property)
	local ok, retval = pcall(function() return self.postgres_storage:getChatProperty(chat, property) end)
	if not ok or not retval then
		return self.redis_storage:getChatProperty(chat, property)
	end
	return retval
end

function MixedStorage:getChatMemberProperty(member, property)
	local ok, retval = pcall(function() return self.postgres_storage:getChatMemberProperty(member, property) end)
	if not ok or not retval then
		return self.redis_storage:getChatMemberProperty(member, property)
	end
	return retval
end

function MixedStorage:cacheChat(chat)
	local res, ok = pcall(function() return self.postgres_storage:cacheChat(chat) end)
	if not res or not ok then
		self.redis_storage:cacheChat(chat)
	end
end

function MixedStorage:getChatAdministratorsCount(chat)
	local ok, title = pcall(function() return self.postgres_storage:getChatAdministratorsCount(chat) end)
	if not ok or not title then
		return self.redis_storage:getChatAdministratorsCount(chat)
	end
	return title
end

function MixedStorage:getChatAdministratorsList(chat)
	local ok, title = pcall(function() return self.postgres_storage:getChatAdministratorsList(chat) end)
	if not ok or not title then
		return self.redis_storage:getChatAdministratorsList(chat)
	end
	return title
end

function MixedStorage:deleteChat(chat)
	pcall(function() return self.postgres_storage:deleteChat(chat) end)
	self.redis_storage:deleteChat(chat)
end

function MixedStorage:cacheChatMember(member)
	pcall(function() return self.postgres_storage:cacheChatMember(member) end)
end

function MixedStorage:cacheAdmins(chat, list)
	local res, ok = pcall(function() return self.postgres_storage:cacheAdmins(chat, list) end)
	if not res or not ok then
		self.redis_storage:cacheAdmins(chat, list)
	end
end

function MixedStorage:set_keepalive()
	pcall(function() return self.postgres_storage:set_keepalive() end)
	self.redis_storage:set_keepalive()
end

function MixedStorage:get_reused_times()
	local redis = self.redis_storage:get_reused_times()
	local ok, postgres = pcall(function() return self.postgres_storage:get_reused_times() end)
	local str = "Redis: "..redis
	-- pgmoon does not currently implement this so it will always return "Unknown"
	if ok and postgres then
		str = str.."\nPostgres: "..postgres
	end
	return str
end

return MixedStorage
