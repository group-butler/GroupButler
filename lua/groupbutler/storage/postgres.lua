local config = require("groupbutler.config")
local pgmoon = require("pgmoon")
local null = require("groupbutler.null")
local log = require("groupbutler.logging")
local Util = require("groupbutler.util")
local StorageUtil = require("groupbutler.storage.util")

local PostgresStorage = {}

local chat_type = Util.enum({
	-- private = 0, -- Not supported
	-- group = 1, -- Not supported
	supergroup = 2,
	channel = 3,
})

local chat_member_status = Util.enum({
	creator = 0,
	administrator = 1,
	member = 2,
	restricted = 3,
	left = 4,
	kicked = 5,
})

local function interpolate(s, tab)
	return s:gsub('(%b{})', function(w)
		local v = tab[w:sub(2, -2)]
		if v == false then
			return "false"
		end
		if v == true then
			return "true"
		end
		if v == nil or v == null then
			return "NULL"
		end
		return v
	end)
end

function PostgresStorage:new()
	local obj = setmetatable({}, {__index = self})
	obj.pg = pgmoon.new(config.postgres)
	assert(obj.pg:connect())
	return obj
end

function PostgresStorage:cacheUser(user)
	local row = {
		id = user.id,
		first_name = self.pg:escape_literal(user.first_name)
	}
	for k, _ in pairs(user) do
		if StorageUtil.isUserPropertyOptional[k] then
			row[k] = self.pg:escape_literal(user[k])
		end
	end
	local username = ""
	if rawget(user, "username") then
		username = 'UPDATE "user" SET username = NULL WHERE lower(username) = lower({username});\n'
	end
	local insert = 'INSERT INTO "user" (id, first_name'
	local values = ") VALUES ({id}, {first_name}"
	local on_conflict = " ON CONFLICT (id) DO UPDATE SET first_name = {first_name}"
	for k, _ in pairs(row) do
		if StorageUtil.isUserPropertyOptional[k] then
			insert = insert..", "..k
			values = values..", {"..k.."}"
			on_conflict = on_conflict..", "..k.." = {"..k.."}"
		end
	end
	values = values..")"
	local query = interpolate(username..insert..values..on_conflict, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
	end
	return true
end

function PostgresStorage:getUserId(username)
	if username:byte(1) == string.byte("@") then
		username = username:sub(2)
	end
	local query = interpolate('SELECT id FROM "user" WHERE lower(username) = lower({username})',
		{username = self.pg:escape_literal(username)})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].id then
		return false
	end
	return ok[1].id
end

function PostgresStorage:getUserProperty(user, property)
	local query = interpolate('SELECT {property} FROM "user" WHERE id = {id}', {
		id = user.id,
		property = property,
	})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1][property] then
		return nil
	end
	return ok[1][property]
end

function PostgresStorage:getChatProperty(chat, property)
	local query = interpolate('SELECT {property} FROM "chat" WHERE id = {id}', {
		id = chat.id,
		property = property,
	})
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1][property] then
		return nil
	end
	if property == "type" then
		return chat_type[ok[1][property]]
	end
	return ok[1][property]
end

function PostgresStorage:getChatMemberProperty(member, property)
	local query = {
		chat_id = member.chat.id,
		user_id = member.user.id,
		property = property,
	}
	if property == "until_date" then
		query.property = "date_part('epoch',until_date)::int"
	end
	local ok = self.pg:query(interpolate(
		'SELECT {property} FROM "chat_user" WHERE chat_id = {chat_id} AND user_id = {user_id}', query))
	if not ok or not ok[1] then
		return nil
	end
	if property == "until_date"
	and ok[1].date_part then
		return ok[1].date_part
	end
	if not ok[1][property] then
		return nil
	end
	if property == "status" then
		return chat_member_status[ok[1][property]]
	end
	return ok[1][property]
end

function PostgresStorage:cacheChat(chat)
	if chat.type ~= "supergroup" then -- don't cache private chats, channels, etc.
		return
	end
	local row = {
		id = chat.id,
		type = chat_type[chat.type],
		title = self.pg:escape_literal(chat.title)
	}
	for k, _ in pairs(chat) do
		if StorageUtil.isChatPropertyOptional[k] then
			row[k] = self.pg:escape_literal(chat[k])
		end
	end
	local insert = 'INSERT INTO "chat" (id, type, title'
	local values = ") VALUES ({id}, '{type}', {title}"
	local on_conflict = ") ON CONFLICT (id) DO UPDATE SET title = {title}"
	for k, _ in pairs(row) do
		if StorageUtil.isChatPropertyOptional[k] then
			insert = insert..", "..k
			values = values..", {"..k.."}"
			on_conflict = on_conflict..", "..k.." = {"..k.."}"
		end
	end
	local query = interpolate(insert..values..on_conflict, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
	end
	return true
end

function PostgresStorage:getChatAdministratorsCount(chat)
	local row = {
		chat_id = chat.id,
		administrator = chat_member_status["administrator"],
	}
	local query = interpolate(
		'SELECT count(*) FROM "chat_user" WHERE chat_id = {chat_id} AND status = {administrator}', row)
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].count then
		return 0
	end
	return ok[1].count
end

function PostgresStorage:getChatAdministratorsList(chat)
	local row = {
		chat_id = chat.id,
		creator = chat_member_status["creator"],
		administrator = chat_member_status["administrator"],
	}
	local query = interpolate('SELECT user_id FROM "chat_user" WHERE chat_id = {chat_id}'..
		'AND (status = {creator} OR status = {administrator})', row)
	local ok = self.pg:query(query)
	if not ok or not ok[1] or not ok[1].user_id then
		return nil
	end
	local retval = {}
	for _,v in pairs(ok) do
		table.insert(retval, v.user_id)
	end
	return retval
end

function PostgresStorage:deleteChat(chat)
	local query = interpolate('DELETE FROM "chat" WHERE id = {id}', chat)
	self.pg:query(query)
	return true
end

function PostgresStorage:cacheChatMember(member)
	if member.chat.type ~= "supergroup" then -- don't cache private chats, channels, etc.
		return
	end
	do
		local ok = self:cacheChat(member.chat)
		if not ok then
			return false
		end
	end
	do
		local ok = self:cacheUser(member.user)
		if not ok then
			return false
		end
	end
	if not rawget(member, "status") then
		log.warn("Tried to cache member without status {chat_id}, {user_id}", {
			chat_id = member.chat.id,
			user_id = member.user.id,
		})
		return false
	end
	local row = {
		chat_id = member.chat.id,
		user_id = member.user.id,
		status = chat_member_status[member.status],
	}
	local insert = 'INSERT INTO "chat_user" (chat_id, user_id, status'
	local values = ") VALUES ({chat_id}, {user_id}, {status}"
	local on_conflict = ") ON CONFLICT (chat_id, user_id) DO UPDATE SET status = {status}"
	for k, v in pairs(member) do
		if (member.status == "administrator" and StorageUtil.isAdminPermission[k])
		or (member.status == "restricted" and StorageUtil.isRestrictedMemberProperty[k]) then
			row[k] = v
			insert = insert..", "..k
			values = values..", {"..k.."}"
			on_conflict = on_conflict..", "..k.." = {"..k.."}"
		end
	end
	if rawget(member, "until_date") then
		row.until_date = "to_timestamp("..member.until_date..")"
	end
	local query = interpolate(insert..values..on_conflict, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
	end
	return true
end

function PostgresStorage:wipeAdmins(chat)
	local row = {
		chat_id = chat.id,
		member = chat_member_status["member"],
		administrator = chat_member_status["administrator"],
	}
	local set = 'UPDATE "chat_user" SET status = {member}'
	local where = ' WHERE chat_id = {chat_id} AND status = {administrator}'
	for k, _ in pairs(StorageUtil.isAdminPermission) do
		row[k] = false
		set = set..", "..k.." = {"..k.."}"
	end
	local query = interpolate(set..where, row)
	local ok, err = self.pg:query(query)
	if not ok then
		log.err("Query {query} failed: {err}", {query=query, err=err})
		return false
	end
	return true
end

function PostgresStorage:cacheAdmins(chat, list)
	do
		local ok = self:wipeAdmins(chat)
		if not ok then
			return false
		end
	end
	for _, admin in pairs(list) do
		admin.chat = chat
		do
			local ok = self:cacheChatMember(admin)
			if not ok then
				return false
			end
		end
	end
	return true
end

function PostgresStorage:set_keepalive()
	return self.pg:keepalive()
end

function PostgresStorage:get_reused_times() -- luacheck: ignore 212
	return "Unknown"
end

return PostgresStorage
