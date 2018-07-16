local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)
local i18n = require "groupbutler.languages".translate
local null = ngx.null

local _M = {}

_M.__index = _M

setmetatable(_M, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function _M.new(main)
	local self = setmetatable({}, _M)
	self.update = main.update
	self.u = main.u
	self.db = main.db
	return self
end

local function max_reached(self, chat_id, user_id)
	local db = self.db
	local max = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'mediamax'))
		or config.chat_settings.warnsettings.mediamax
	local n = tonumber(db:hincrby('chat:'..chat_id..':mediawarn', user_id, 1))
	if n >= max then
		return true, n, max
	end
		return false, n, max
end

local function is_ignored(self, chat_id, msg_type)
	local db = self.db
	local hash = 'chat:'..chat_id..':floodexceptions'
	local status = db:hget(hash, msg_type)
	if status == 'yes' then
		return true
	end
		return false
	end

local function is_flooding_funct(self, msg)
	local db = self.db
	if msg.media_group_id then
		-- albums should count as one message

		local media_group_id_key = 'mediagroupidkey:'..msg.chat.id
		if msg.media_group_id == db:get(media_group_id_key) then -- msg.media_group_id is a str
			-- photo/video is from an already processed sent album
			return false
		else
			-- save the ID of the albums as last processed album,
			-- so we can ignore all the following updates containing medias from that album
			db:setex(media_group_id_key, 600, msg.media_group_id)
		end
	end

	local spamkey = 'spam:'..msg.chat.id..':'..msg.from.id

	local msgs = tonumber(db:get(spamkey)) or 1

	local max_msgs = tonumber(db:hget('chat:'..msg.chat.id..':flood', 'MaxFlood')) or 5
	if msg.cb then max_msgs = 15 end

	local max_time = 5
	db:incr(spamkey)
	db:expire(spamkey, max_time)

	if msgs > max_msgs then
		return true, msgs, max_msgs
	end
		return false
end

local function is_whitelisted(self, chat_id, text)
	local db = self.db
	local set = ('chat:%d:whitelist'):format(chat_id)
	local links = db:smembers(set)
	if links and next(links) then
		for i=1, #links do
			if text:match(links[i]:gsub('%-', '%%-')) then
				--print('Whitelist:', links[i])
				return true
			end
		end
	end
end

function _M:onEveryMessage(msg)
	local u = self.u
	local db = self.db
	if not msg.inline then
	local msg_type = 'text'
	if msg.forward_from or msg.forward_from_chat then msg_type = 'forward' end
	if msg.media_type then msg_type = msg.media_type end
		if not is_ignored(self, msg.chat.id, msg_type) and not msg.edited then
			local is_flooding, msgs_sent, msgs_max = is_flooding_funct(self, msg)
		if is_flooding then
				local status = db:hget('chat:'..msg.chat.id..':settings', 'Flood')
				if status == null then status = config.chat_settings['settings']['Flood'] end

			if status == 'on' and not msg.cb and not msg.from.admin then --if the status is on, and the user is not an admin, and the message is not a callback, then:
				local action = db:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
					local name = u:getname_final(msg.from)
					local ok, message
				--try to kick or ban
				if action == 'ban' then
						ok = u:banUser(msg.chat.id, msg.from.id)
				elseif action == 'kick' then
						ok = u:kickUser(msg.chat.id, msg.from.id)
				elseif action == 'mute' then
						ok = u:muteUser(msg.chat.id, msg.from.id)
				end
				--if kicked/banned, send a message
					if ok then
					local log_hammered = action
					if msgs_sent == (msgs_max + 1) then --send the message only if it's the message after the first message flood. Repeat after 5
						if action == 'ban' then
							message = i18n("%s <b>banned</b> for flood!"):format(name)
						elseif action == 'kick' then
							message = i18n("%s <b>kicked</b> for flood!"):format(name)
						elseif action == 'mute' then
							message = i18n("%s <b>muted</b> for flood!"):format(name)
						end
						api.sendMessage(msg.chat.id, message, 'html')
							u:logEvent('flood', msg, {hammered = log_hammered})
					end
				end
			end

			-- if msg.cb then
			-- 	api.answerCallbackQuery(msg.cb_id, i18n("‼️ Please don't abuse the keyboard, requests will be ignored")) -- avoid to hit the limits with answerCallbackQuery
			-- end
			return false --if an user is spamming, don't go through plugins
		end
	end

	if not msg.from.admin then
		if msg.media and msg.chat.type ~= 'private' and not msg.cb and not msg.edited then
			local media = msg.media_type
			local hash = 'chat:'..msg.chat.id..':media'
				local media_status = (db:hget(hash, media))
				if media_status == null then media_status = config.chat_settings.media[media] end

			if media_status ~= 'ok' then
				local whitelisted
				if media == 'link' then
						whitelisted = is_whitelisted(self, msg.chat.id, msg.text)
				end

				if not whitelisted then
					local status
						local name = u:getname_final(msg.from)
						local max_reached_var, n, max = max_reached(self, msg.chat.id, msg.from.id)
					if max_reached_var then --max num reached. Kick/ban the user
							status = db:hget('chat:'..msg.chat.id..':warnsettings', 'mediatype')
							if status == null then status = config.chat_settings['warnsettings']['mediatype'] end

						--try to kick/ban
							local ok, punishment
						if status == 'kick' then
								ok = u:kickUser(msg.chat.id, msg.from.id)
							punishment = i18n('kicked')
						elseif status == 'ban' then
								ok = u:banUser(msg.chat.id, msg.from.id)
							punishment = i18n('banned')
						elseif status == 'mute' then
								ok = u:muteUser(msg.chat.id, msg.from.id)
							punishment = i18n('muted')
						end
							if ok then --kick worked
							db:hdel('chat:'..msg.chat.id..':mediawarn', msg.from.id) --remove media warns
							local message =
								i18n('%s <b>%s</b>: media sent not allowed!\n❗️ <code>%d/%d</code>'):format(name, punishment, n, max)
							api.sendMessage(msg.chat.id, message, 'html')
						end

						if media_status == 'del' then --do not forget to delete the message
							api.deleteMessage(msg.chat.id, msg.message_id)
						end
					else --max num not reached -> warn or delete
						if media_status ~= 'del' then
							local message =
							i18n('%s, this type of media is <b>not allowed</b> in this chat.\n(<code>%d/%d</code>)'):format(name, n, max)
								u:sendReply(msg, message, 'html')
						elseif media_status == 'del' and n + 1 >= max then
							api.deleteMessage(msg.chat.id, msg.message_id)
							local message =
							i18n([[%s, this type of media is <b>not allowed</b> in this chat.
<i>The next time you will be banned/kicked/muted</i>
]]):format(name)
							api.sendMessage(msg.chat.id, message, 'html')
						elseif media_status == 'del' then
							api.deleteMessage(msg.chat.id, msg.message_id)
						end
					end
						u:logEvent('mediawarn', msg, {warns = n, warnmax = max, media = i18n(media), hammered = status})
				end
			end
		end

			local rtl_status = db:hget('chat:'..msg.chat.id..':char', 'Rtl')
			if rtl_status == null then rtl_status = config.chat_settings.char.Rtl end

		if rtl_status ~= 'allowed' then
			local rtl = '‮'
			local last_name = 'x'
			if msg.from.last_name then last_name = msg.from.last_name end
			local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+') or last_name:find(rtl..'+')
			if check ~= nil then
					local ok, message
				if rtl_status == 'kick' then
						ok = u:kickUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>kicked</b>: RTL character in names/messages are not allowed!")
				elseif rtl_status == 'ban' then
						ok = u:banUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>banned</b>: RTL character in names/messages are not allowed!")
				elseif rtl_status == 'mute' then
						ok = u:muteUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>muted</b>: RTL character in names/messages are not allowed!")
				end
					if ok then
						local name = u:getname_final(msg.from)
					api.sendMessage(msg.chat.id, message:format(name), 'html')
					return false
				end
			end
		end

		if msg.text and msg.text:find('([\216-\219][\128-\191])') then
				local arab_status = db:hget('chat:'..msg.chat.id..':char', 'Arab')
				if arab_status == null then arab_status = config.chat_settings.char.Arab end

			if arab_status ~= 'allowed' then
					local ok, message
				if arab_status == 'kick' then
						ok = u:kickUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>kicked</b>: arab/persian message detected!")
				elseif arab_status == 'ban' then
						ok = u:banUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>banned</b>: arab/persian message detected!")
				elseif arab_status == 'mute' then
						ok = u:muteUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>muted</b>: arab/persian message detected!")
				end
					if ok then
						local name = u:getname_final(msg.from)
					api.sendMessage(msg.chat.id, message:format(name), 'html')
					return false
					end
				end
			end
		end
	end

	if u:is_blocked_global(msg.from.id) then --ignore blocked users
		return false -- if an user is blocked, don't go through plugins
	else
		return true -- don't return false for edited messages: the antispam needs to process them
	end
end

return _M
