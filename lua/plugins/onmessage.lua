local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local db = require 'database'
local locale = require 'languages'
local i18n = locale.translate

local plugin = {}

local function max_reached(chat_id, user_id)
	local max = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'mediamax'))
		or config.chat_settings.warnsettings.mediamax
	local n = tonumber(db:hincrby('chat:'..chat_id..':mediawarn', user_id, 1))
	if n >= max then
		return true, n, max
	else
		return false, n, max
	end
end

local function is_ignored(chat_id, msg_type)
	local hash = 'chat:'..chat_id..':floodexceptions'
	local status = (db:hget(hash, msg_type)) or 'no'
	if status == 'yes' then
		return true
	elseif status == 'no' then
		return false
	end
end

local function is_flooding_funct(msg)
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
	db:setex(spamkey, max_time, msgs+1)

	if msgs > max_msgs then
		return true, msgs, max_msgs
	else
		return false
	end
end

local function is_blocked(id)
	if db:sismember('bot:blocked', id) then
		return true
	else
		return false
	end
end

local function is_whitelisted(chat_id, text)
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

function plugin.onEveryMessage(msg)

	if not msg.inline then

	local msg_type = 'text'
	if msg.forward_from or msg.forward_from_chat then msg_type = 'forward' end
	if msg.media_type then msg_type = msg.media_type end
	if not is_ignored(msg.chat.id, msg_type) and not msg.edited and not msg.new_chat_members then
		local is_flooding, msgs_sent, msgs_max = is_flooding_funct(msg)
		if is_flooding then
			local status = (db:hget('chat:'..msg.chat.id..':settings', 'Flood')) or config.chat_settings['settings']['Flood']
			if status == 'on' and not msg.cb and not msg.from.admin then --if the status is on, and the user is not an admin, and the message is not a callback, then:
				local action = db:hget('chat:'..msg.chat.id..':flood', 'ActionFlood')
				local name = u.getname_final(msg.from)
				local res, message
				--try to kick or ban
				if action == 'ban' then
					res = api.banUser(msg.chat.id, msg.from.id)
				elseif action == 'kick' then
					res = api.kickUser(msg.chat.id, msg.from.id)
				elseif action == 'mute' then
					res = api.muteUser(msg.chat.id, msg.from.id)
				end
				--if kicked/banned, send a message
				if res then
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
						u.logEvent('flood', msg, {hammered = log_hammered})
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
			local media_status = (db:hget(hash, media)) or config.chat_settings.media[media]
			if media_status ~= 'ok' then
				local whitelisted
				if media == 'link' then
					whitelisted = is_whitelisted(msg.chat.id, msg.text)
				end

				if not whitelisted then
					local status
					local name = u.getname_final(msg.from)
					local max_reached_var, n, max = max_reached(msg.chat.id, msg.from.id)
					if max_reached_var then --max num reached. Kick/ban the user
						status = (db:hget('chat:'..msg.chat.id..':warnsettings', 'mediatype'))
							or config.chat_settings['warnsettings']['mediatype']
						--try to kick/ban
						local res, punishment
						if status == 'kick' then
							res = api.kickUser(msg.chat.id, msg.from.id)
							punishment = i18n('kicked')
						elseif status == 'ban' then
							res = api.banUser(msg.chat.id, msg.from.id)
							punishment = i18n('banned')
						elseif status == 'mute' then
							res = api.muteUser(msg.chat.id, msg.from.id)
							punishment = i18n('muted')
						end
						if res then --kick worked
							db:hdel('chat:'..msg.chat.id..':mediawarn', msg.from.id) --remove media warns
							local message =
								i18n([[%s <b>%s</b>: media sent not allowed!
❗ <code>%d/%d</code>]]):format(name, punishment, n, max)
							api.sendMessage(msg.chat.id, message, 'html')
						end

						if media_status == 'del' then --do not forget to delete the message
							api.deleteMessage(msg.chat.id, msg.message_id)
						end
					else --max num not reached -> warn or delete
						if media_status ~= 'del' then
							local message =
							i18n([[%s, this type of media is <b>not allowed</b> in this chat.
(<code>%d/%d</code>)]]):format(name, n, max)
							api.sendReply(msg, message, 'html')
						elseif media_status == 'del' and n + 1 >= max then
							api.deleteMessage(msg.chat.id, msg.message_id)
							local message = i18n([[%s, this type of media is <b>not allowed</b> in this chat.
<i>Next time you will be banned, kicked, or muted.</i>]]):format(name)
							api.sendMessage(msg.chat.id, message, 'html')
						elseif media_status == 'del' then
							api.deleteMessage(msg.chat.id, msg.message_id)
						end
					end
					u.logEvent('mediawarn', msg, {warns = n, warnmax = max, media = i18n(media), hammered = status})
				end
			end
		end


		local rtl_status = (db:hget('chat:'..msg.chat.id..':char', 'Rtl')) or config.chat_settings.char.Rtl
		if rtl_status ~= 'allowed' then
			local rtl = '‮'
			local last_name = 'x'
			if msg.from.last_name then last_name = msg.from.last_name end
			local check = msg.text:find(rtl..'+') or msg.from.first_name:find(rtl..'+') or last_name:find(rtl..'+')
			if check ~= nil then
				local res, message
				if rtl_status == 'kick' then
					res = api.kickUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>kicked</b>: RTL characters in names/messages are not allowed!")
				elseif rtl_status == 'ban' then
					res = api.banUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>banned</b>: RTL characters in names/messages are not allowed!")
				elseif rtl_status == 'mute' then
					res = api.muteUser(msg.chat.id, msg.from.id)
					message = i18n("%s <b>muted</b>: RTL characters in names/messages are not allowed!")
				end
				if res then
					local name = u.getname_final(msg.from)
					api.sendMessage(msg.chat.id, message:format(name), 'html')
					return false
				end
			end
		end

		if msg.text and msg.text:find('([\216-\219][\128-\191])') then
			local arab_status = (db:hget('chat:'..msg.chat.id..':char', 'Arab')) or config.chat_settings.char.Arab
			if arab_status ~= 'allowed' then
				local res, message
				if arab_status == 'kick' then
					res = api.kickUser(msg.chat.id, msg.from.id)
					message = i18n("%s has been <b>kicked</b>: Arabic/Persian message detected!")
				elseif arab_status == 'ban' then
					res = api.banUser(msg.chat.id, msg.from.id)
					message = i18n("%s has been <b>banned</b>: Arabic/Persian message detected!")
				elseif arab_status == 'mute' then
					res = api.muteUser(msg.chat.id, msg.from.id)
					message = i18n("%s has been <b>muted</b>: Arabic/Persian message detected!")
				end
				if res then
					local name = u.getname_final(msg.from)
					api.sendMessage(msg.chat.id, message:format(name), 'html')
					return false
				end
			end
		end
	end

	end --if not msg.inline then [if statement closed]

	if is_blocked(msg.from.id) then --ignore blocked users
		return false --if an user is blocked, don't go through plugins
	end

	--don't return false for edited messages: the antispam needs to process them

	return true
end

return plugin
