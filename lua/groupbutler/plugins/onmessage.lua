local config = require "groupbutler.config"
local null = require "groupbutler.null"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function max_reached(self, chat_id, user_id)
	local red = self.red
	local max = tonumber(red:hget('chat:'..chat_id..':warnsettings', 'mediamax'))
		or config.chat_settings.warnsettings.mediamax
	local n = tonumber(red:hincrby('chat:'..chat_id..':mediawarn', user_id, 1))
	if n >= max then
		return true, n, max
	end
	return false, n, max
end

local function is_ignored(self, chat_id, msg_type)
	local red = self.red
	local hash = 'chat:'..chat_id..':floodexceptions'
	local status = red:hget(hash, msg_type)
	if not status == 'yes' then
		return false
	end
	return true
end

local function is_flooding_funct(self, msg)
	local red = self.red
	if msg.media_group_id then
		-- albums should count as one message

		local media_group_id_key = 'mediagroupidkey:'..msg.from.chat.id
		if msg.media_group_id == red:get(media_group_id_key) then -- msg.media_group_id is a str
			-- photo/video is from an already processed sent album
			return false
		else
			-- save the ID of the albums as last processed album,
			-- so we can ignore all the following updates containing medias from that album
			red:setex(media_group_id_key, 600, msg.media_group_id)
		end
	end

	local spamkey = 'spam:'..msg.from.chat.id..':'..msg.from.user.id

	local msgs = tonumber(red:get(spamkey)) or 1

	local max_msgs = tonumber(red:hget('chat:'..msg.from.chat.id..':flood', 'MaxFlood')) or 5
	if msg.cb then max_msgs = 15 end

	local max_time = 5
	red:incr(spamkey)
	red:expire(spamkey, max_time)

	if msgs > max_msgs then
		return true, msgs, max_msgs
	end
		return false
end

local function is_whitelisted(self, chat_id, text)
	local red = self.red
	local set = ('chat:%d:whitelist'):format(chat_id)
	local links = red:smembers(set)
	if links and next(links) then
		for i=1, #links do
			if text:match(links[i]:gsub('%-', '%%-')) then
				--print('Whitelist:', links[i])
				return true
			end
		end
	end
end

function _M:on_message()
	local api = self.api
	local msg = self.message
	local u = self.u
	local red = self.red
	local i18n = self.i18n

	if not msg.inline then
	local msg_type = msg:type()
	if msg.forward_from or msg.forward_from_chat then msg_type = 'forward' end

		if not is_ignored(self, msg.from.chat.id, msg_type) and not msg.edited then
			local is_flooding, msgs_sent, msgs_max = is_flooding_funct(self, msg)
		if is_flooding then
				local status = red:hget('chat:'..msg.from.chat.id..':settings', 'Flood')
				if status == null then status = config.chat_settings['settings']['Flood'] end

			if status == 'on' and not msg.cb and not msg.from:isAdmin() then --if the status is on, and the user is not an admin, and the message is not a callback, then:
				local action = red:hget('chat:'..msg.from.chat.id..':flood', 'ActionFlood')
					local name = msg.from.user:getLink()
					local ok, message
				--try to kick or ban
				if action == 'ban' then
					ok = msg.from:ban()
				elseif action == 'kick' then
					ok = msg.from:kick()
				elseif action == 'mute' then
					ok = msg.from:mute()
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
						api:sendMessage(msg.from.chat.id, message, 'html')
							u:logEvent('flood', msg, {hammered = log_hammered})
					end
				end
			end

			-- if msg.cb then
			-- 	api:answerCallbackQuery(msg.cb_id, i18n("‼️ Please don't abuse the keyboard, requests will be ignored")) -- avoid to hit the limits with answerCallbackQuery
			-- end
			return false --if a user is spamming, don't go through plugins
		end
	end

	if msg_type ~= "text" and not msg.cb and not msg.edited then
			local hash = 'chat:'..msg.from.chat.id..':media'
		local media_status = (red:hget(hash, msg_type))
		if media_status == null then media_status = config.chat_settings.media[msg_type] end

			if media_status ~= 'ok' then
				local whitelisted
			if msg_type == 'link' then
						whitelisted = is_whitelisted(self, msg.from.chat.id, msg.text)
				end

			if not whitelisted and not msg.from:isAdmin() then -- Postpone admin check to avoid hitting API limits
					local status
					local name = msg.from.user:getLink()
					local max_reached_var, n, max = max_reached(self, msg.from.chat.id, msg.from.user.id)
					if max_reached_var then --max num reached. Kick/ban the user
						status = red:hget('chat:'..msg.from.chat.id..':warnsettings', 'mediatype')
						if status == null then status = config.chat_settings['warnsettings']['mediatype'] end

						--try to kick/ban
						local ok, punishment
						if status == 'kick' then
							ok = msg.from:kick()
							punishment = i18n('kicked')
						elseif status == 'ban' then
							ok = msg.from:ban()
							punishment = i18n('banned')
						elseif status == 'mute' then
							ok = msg.from:mute()
							punishment = i18n('muted')
						end
						if ok then --kick worked
							red:hdel('chat:'..msg.from.chat.id..':mediawarn', msg.from.user.id) --remove media warns
							local message =
								i18n('%s <b>%s</b>: media sent not allowed!\n❗️ <code>%d/%d</code>'):format(name, punishment, n, max)
							api:sendMessage(msg.from.chat.id, message, 'html')
						end

						if media_status == 'del' then --do not forget to delete the message
							api:deleteMessage(msg.from.chat.id, msg.message_id)
						end
					else --max num not reached -> warn or delete
						if media_status ~= 'del' then
							local message =
							i18n('%s, this type of media is <b>not allowed</b> in this chat.\n(<code>%d/%d</code>)'):format(name, n, max)
								msg:send_reply(message, 'html')
						elseif media_status == 'del' and n + 1 >= max then
							api:deleteMessage(msg.from.chat.id, msg.message_id)
							local message =
							i18n([[%s, this type of media is <b>not allowed</b> in this chat.
<i>The next time you will be banned/kicked/muted</i>
]]):format(name)
							api:sendMessage(msg.from.chat.id, message, 'html')
						elseif media_status == 'del' then
							api:deleteMessage(msg.from.chat.id, msg.message_id)
						end
					end
					u:logEvent('mediawarn', msg, {warns = n, warnmax = max, media = msg_type, hammered = status})
				end
			end
		end

			local rtl_status = red:hget('chat:'..msg.from.chat.id..':char', 'Rtl')
			if rtl_status == null then rtl_status = config.chat_settings.char.Rtl end

		if rtl_status ~= 'allowed' then
			local rtl = '‮'
			local last_name = 'x'
			if msg.from.user.last_name then last_name = msg.from.user.last_name end
			local check = msg.text:find(rtl..'+') or msg.from.user.first_name:find(rtl..'+') or last_name:find(rtl..'+')
			if check ~= nil then
					local ok, message
				if rtl_status == 'kick' then
					ok = msg.from:kick()
					message = i18n("%s <b>kicked</b>: RTL character in names/messages are not allowed!")
				elseif rtl_status == 'ban' then
					ok = msg.from:ban()
					message = i18n("%s <b>banned</b>: RTL character in names/messages are not allowed!")
				elseif rtl_status == 'mute' then
					ok = msg.from:mute()
					message = i18n("%s <b>muted</b>: RTL character in names/messages are not allowed!")
				end
					if ok then
						local name = msg.from.user:getLink()
					api:sendMessage(msg.from.chat.id, message:format(name), 'html')
					return false
				end
			end
		end

		if msg.text and msg.text:find('([\216-\219][\128-\191])') then
				local arab_status = red:hget('chat:'..msg.from.chat.id..':char', 'Arab')
				if arab_status == null then arab_status = config.chat_settings.char.Arab end

			if arab_status ~= 'allowed' then
					local ok, message
				if arab_status == 'kick' then
					ok = msg.from:kick()
					message = i18n("%s <b>kicked</b>: arab/persian message detected!")
				elseif arab_status == 'ban' then
					ok = msg.from:ban()
					message = i18n("%s <b>banned</b>: arab/persian message detected!")
				elseif arab_status == 'mute' then
					ok = msg.from:mute()
					message = i18n("%s <b>muted</b>: arab/persian message detected!")
				end
					if ok then
						local name = msg.from.user:getLink()
					api:sendMessage(msg.from.chat.id, message:format(name), 'html')
					return false
					end
				end
			end
		end

	if u:is_blocked_global(msg.from.user.id) then --ignore blocked users
		return false -- if a user is blocked, don't go through plugins
	end

		return true -- don't return false for edited messages: the antispam needs to process them
end

return _M
