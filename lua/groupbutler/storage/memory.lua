local MemoryStorage = {}
local storage = {}

local function set(entity, id, property, value)
	if type(storage[entity]) ~= "table" then
		storage[entity] = {}
	end
	if type(storage[entity][id]) ~= "table" then
		storage[entity][id] = {}
	end
	storage[entity][id][property] = value
end

local function get(entity, id, property)
	if  type(storage[entity]) == "table"
	and type(storage[entity][id]) == "table"
	and storage[entity][id][property] then
		return storage[entity][id][property]
	end
end

local function set_chat_user(entity, chat_id, user_id, property, value)
	if type(storage[entity]) ~= "table" then
		storage[entity] = {}
	end
	if type(storage[entity][chat_id]) ~= "table" then
		storage[entity][chat_id] = {}
	end
	if type(storage[entity][chat_id][user_id]) ~= "table" then
		storage[entity][chat_id][user_id] = {}
	end
	storage[entity][chat_id][user_id][property] = value
end

local function get_chat_user(entity, chat_id, user_id, property)
	if  type(storage[entity]) == "table"
	and type(storage[entity][chat_id]) == "table"
	and type(storage[entity][user_id]) == "table"
	and storage[entity][chat_id][user_id][property] then
		return storage[entity][chat_id][user_id][property]
	end
end

local function delete(entity, id)
	if  storage[entity]
	and storage[entity][id] then
		storage[entity][id] = nil
	end
end

function MemoryStorage:new()
	return setmetatable({}, {__index = self})
end

function MemoryStorage:cacheUser(user) -- luacheck: ignore 212
	for k,v in user do
		if k ~= "id" then
			set("user", user.id, k, v)
		end
	end
end

function MemoryStorage:cacheChat(chat) -- luacheck: ignore 212
	for k,v in chat do
		if k ~= "id" then
			set("chat", chat.id, k, v)
		end
	end
end

function MemoryStorage:cacheChatMember(member)
	for k,v in member do
		if k == "user" then
			self:cacheUser(member.user)
		elseif k == "chat" then
			self:cacheChat(member.chat)
		else
			set_chat_user("member", member.chat.id, member.user.id, k, v)
		end
	end
end

function MemoryStorage:cacheAdmins(chat, list) -- luacheck: ignore 212
	set("chat", chat.id, "adminlist", list)
end

function MemoryStorage:getUserProperty(user, property) -- luacheck: ignore 212
	return get("user", user.id, property)
end

function MemoryStorage:getChatProperty(chat, property) -- luacheck: ignore 212
	return get("chat", chat.id, property)
end

function MemoryStorage:getChatMemberProperty(member, property) -- luacheck: ignore 212
	return get_chat_user("member", member.chat.id, member.user.id, property)
end

function MemoryStorage:getUserId(username) -- luacheck: ignore 212
	for k,v in storage.user do
		if v and v.username == username then
			return k
		end
	end
end

function MemoryStorage:getChatAdministratorsCount(chat) -- luacheck: ignore 212
	return #get("chat", chat.id, "adminlist")
end

function MemoryStorage:getChatAdministratorsList(chat) -- luacheck: ignore 212
	local list = get("chat", chat.id, "adminlist")
	if type(list) ~= "table" then
		return
	end
	local retval = {}
	for i=1,#list do
		retval[i] = list[i].id
	end
	return retval
end

function MemoryStorage:deleteChat(chat) -- luacheck: ignore 212
	delete("chat", chat.id)
end

function MemoryStorage:set_keepalive() -- luacheck: ignore 212
end

function MemoryStorage:get_reused_times() -- luacheck: ignore 212
	return "Unknown"
end

return MemoryStorage
