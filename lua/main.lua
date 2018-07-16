local api = require 'methods'
local clr = require 'term.colors'
local u = require 'utilities'
local config = require 'config'
local db = require 'database'
local plugins = require 'plugins'
local locale = require 'languages'
local i18n = locale.translate

local _M = {}

local function extract_usernames(msg, dbp)
	if msg.from then
		if msg.from.username then
			dbp:hset('bot:usernames', '@'..msg.from.username:lower(), msg.from.id)
		end
	end
	if msg.forward_from and msg.forward_from.username then
		dbp:hset('bot:usernames', '@'..msg.forward_from.username:lower(), msg.forward_from.id)
	end
	if msg.new_chat_member then
		if msg.new_chat_member.username then
			dbp:hset('bot:usernames', '@'..msg.new_chat_member.username:lower(), msg.new_chat_member.id)
		end
		dbp:sadd(string.format('chat:%d:members', msg.chat.id), msg.new_chat_member.id)
	end
	if msg.left_chat_member then
		if msg.left_chat_member.username then
			dbp:hset('bot:usernames', '@'..msg.left_chat_member.username:lower(), msg.left_chat_member.id)
		end
		dbp:srem(string.format('chat:%d:members', msg.chat.id), msg.left_chat_member.id)
	end
	if msg.reply_to_message then
		extract_usernames(msg.reply_to_message)
	end
	if msg.pinned_message then
		extract_usernames(msg.pinned_message)
	end
end

local function collect_stats(msg, dbp)
	-- note that we have seen this user and collect their username
	-- This is pipelined for speed
	extract_usernames(msg, dbp)
	if msg.chat.type ~= 'private' and msg.chat.type ~= 'inline' and msg.from then
		dbp:hset('chat:'..msg.chat.id..':userlast', msg.from.id, os.time()) --last message for each user
		dbp:hset('bot:chats:latsmsg', msg.chat.id, os.time()) --last message in the group
	end
end

local function match_triggers(triggers, text)
	if text and triggers then
		text = text:gsub('^(/[%w_]+)@'..bot.username, '%1')
		for _, trigger in pairs(triggers) do
			local matches = { string.match(text, trigger) }
			if next(matches) then
				return matches, trigger
			end
		end
	end
end

local function on_msg_receive(msg, callback) -- The fn run whenever a message is received.
	--u.dump('PARSED', msg)
	if not msg then
		return
	end

	if msg.chat.type ~= 'group' then --do not process messages from normal groups
		-- os.time(os.date("!*t")) is used so that the timestamp is returned from UTC, not the current timezone.
		-- the ! indicates UTC - https://www.lua.org/manual/5.1/manual.html#pdf-os.date
		local now = os.time(os.date("*t"))
		if msg.date < now - config.bot_settings.old_update then -- Do not process old messages.
			print(os.date('[%H:%M:%S]', now), 'Old update skipped: ', os.date('%H:%M:%S', msg.date), now-msg.date)
			return
		end

		if not msg.text then msg.text = msg.caption or '' end

		locale.language = db:get('lang:'..msg.chat.id) or config.lang --group language
		if not config.available_languages[locale.language] then
			locale.language = config.lang
		end

		db:pipeline(function(p)
			collect_stats(msg, p)
			-- since we have a pipeline here anyway, (ab)use this for stats
			-- FIXME: properly use the metrics utilities for this (those don't
			-- support pipelines right now)
			-- test
			p:incr("bot:metrics:messages_processed_count")
			p:set("bot:metrics:message_timestamp_distance_sec", now - msg.date)
		end)

		local continue = true
		local onm_success
		for i=1, #plugins do
			if plugins[i].onEveryMessage then
				onm_success, continue = pcall(plugins[i].onEveryMessage, msg)
				if not onm_success then
					api.sendAdmin('An #error occurred (preprocess).\n'..tostring(continue)..'\n'..locale.language..'\n'..msg.text)
				end
			end
			if not continue then return end
		end

		for i=1, #plugins do
			if plugins[i].triggers then
				local blocks, trigger = match_triggers(plugins[i].triggers[callback], msg.text)
				if blocks then

					if msg.chat.id < 0 and msg.chat.type ~= 'inline'and not db:exists('chat:'..msg.chat.id..':settings') and not msg.service then --init agroup if the bot wasn't aware to be in
						u.initGroup(msg.chat.id)
					end

					if config.bot_settings.stream_commands then --print some info in the terminal
						print(clr.reset..clr.blue..'['..os.date('%X')..']'..clr.red..' '..trigger..clr.reset..' '..
							msg.from.first_name..' ['..msg.from.id..'] -> ['..msg.chat.id..']')
					end

					--if not check_callback(msg, callback) then goto searchaction end
					local success, result = xpcall((function() return plugins[i][callback](msg, blocks) end), debug.traceback) --execute the main function of the plugin triggered

					if not success then --if a bug happens
						print(result)
						if config.bot_settings.notify_bug then
							api.sendReply(msg, i18n("🐞 Sorry, a *bug* occurred"), true)
						end
						api.sendAdmin('An #error occurred.\n'..result..'\n'..locale.language..'\n'..msg.text)
						return
					end

					if not result then --if the action returns true, then don't stop the loop of the plugin's actions
						return
					end
				end

			end
		end
	else
		if msg.group_chat_created or (msg.new_chat_member and msg.new_chat_member.id == bot.id) then
			-- set the language
			--[[locale.language = db:get(string.format('lang:%d', msg.from.id)) or 'en'
			if not config.available_languages[locale.language] then
				locale.language = 'en'
			end]]

			-- send disclamer
			api.sendMessage(msg.chat.id, i18n([[
Hello everyone!
My name is %s, and I'm a bot made to help administrators in their hard work.
Unfortunately I can't work in normal groups. If you need me, please ask the creator to convert this group to a supergroup and then add me again.
]]):format(bot.first_name))

			api.leaveChat(msg.chat.id)

			-- log this event
			if config.bot_settings.stream_commands then
				print(clr.blue..'['..os.date('%X')..']'..clr.yellow..' Bot was added to a normal group'
					..clr.reset..''..msg.from.first_name..' ['..msg.from.id..'] -> ['..msg.chat.id..']')
			end
		end
	end
end

function _M.parseMessageFunction(update)

	u.metric_incr("messages_count")

	local msg, function_key
	local start_time = u.time_hires()

	if update.message or update.edited_message then

		function_key = 'onTextMessage'

		if update.edited_message then
			update.edited_message.edited = true
			update.edited_message.original_date = update.edited_message.date
			update.edited_message.date = update.edited_message.edit_date
			function_key = 'onEditedMessage'
		end

		msg = update.message or update.edited_message

		if msg.text then
			msg.text = msg.text -- Just so that luacheck stops complaining about empty if branch
		elseif msg.photo then
			msg.media = true
			msg.media_type = 'photo'
		elseif msg.audio then
			msg.media = true
			msg.media_type = 'audio'
		elseif msg.document then
			msg.media = true
			msg.media_type = 'document'
			if msg.document.mime_type == 'video/mp4' then
				msg.media_type = 'gif'
			end
		elseif msg.sticker then
			msg.media = true
			msg.media_type = 'sticker'
		elseif msg.video then
			msg.media = true
			msg.media_type = 'video'
		elseif msg.video_note then
			msg.media = true
			msg.media_type = 'video_note'
		elseif msg.voice then
			msg.media = true
			msg.media_type = 'voice'
		elseif msg.contact then
			msg.media = true
			msg.media_type = 'contact'
		elseif msg.venue then
			msg.media = true
			msg.media_type = 'venue'
		elseif msg.location then
			msg.media = true
			msg.media_type = 'location'
		elseif msg.game then
			msg.media = true
			msg.media_type = 'game'
		elseif msg.left_chat_member then
			msg.service = true
			if msg.left_chat_member.id == bot.id then
				msg.text = '###left_chat_member:bot'
			else
				msg.text = '###left_chat_member'
			end
		elseif msg.new_chat_member then
			msg.service = true
			if msg.new_chat_member.id == bot.id then
				msg.text = '###new_chat_member:bot'
			else
				msg.text = '###new_chat_member'
			end
		elseif msg.new_chat_photo then
			msg.service = true
			msg.text = '###new_chat_photo'
		elseif msg.delete_chat_photo then
			msg.service = true
			msg.text = '###delete_chat_photo'
		elseif msg.group_chat_created then
			msg.service = true
			msg.text = '###group_chat_created'
		elseif msg.supergroup_chat_created then
			msg.service = true
			msg.text = '###supergroup_chat_created'
		elseif msg.channel_chat_created then
			msg.service = true
			msg.text = '###channel_chat_created'
		elseif msg.migrate_to_chat_id then
			msg.service = true
			msg.text = '###migrate_to_chat_id'
		elseif msg.migrate_from_chat_id then
			msg.service = true
			msg.text = '###migrate_from_chat_id'
		elseif msg.new_chat_title then
			msg.service = true
			msg.text = '###new_chat_title'
		elseif msg.pinned_message then
			msg.service = true
			msg.text = '###pinned_message'
		else
			--callback = 'onUnknownType'
			print('Unknown update type') return
		end

		if msg.forward_from_chat then
			if msg.forward_from_chat.type == 'channel' then
				msg.spam = 'forwards'
			end
		end
		if msg.caption then
			local caption_lower = msg.caption:lower()
			if caption_lower:match('telegram%.me') or caption_lower:match('telegram%.dog') or caption_lower:match('t%.me') then
				msg.spam = 'links'
			end
		end
		if msg.entities then
			for _, entity in pairs(msg.entities) do
				if entity.type == 'text_mention' then
					msg.mention_id = entity.user.id
				end
				if entity.type == 'url' or entity.type == 'text_link' then
					local text_lower = msg.text or msg.caption
					text_lower = entity.url and text_lower..entity.url or text_lower
					text_lower = text_lower:lower()
					if text_lower:match('telegram%.me') or
						text_lower:match('telegram%.dog') or
						text_lower:match('t%.me') then
						msg.spam = 'links'
					else
						msg.media_type = 'link'
						msg.media = true
					end
				end
			end
		end
		if msg.reply_to_message then
			msg.reply = msg.reply_to_message
			if msg.reply.caption then
				msg.reply.text = msg.reply.caption
			end
		end
	elseif update.callback_query then
		msg = update.callback_query
		msg.cb = true
		msg.text = '###cb:'..msg.data
		if msg.message then
			msg.original_text = msg.message.text
			msg.original_date = msg.message.date
			msg.message_id = msg.message.message_id
			msg.chat = msg.message.chat
		else --when the inline keyboard is sent via the inline mode
			msg.chat = {type = 'inline', id = msg.from.id, title = msg.from.first_name}
			msg.message_id = msg.inline_message_id
		end
		msg.date = os.time()
		msg.cb_id = msg.id
		msg.message = nil
		msg.target_id = msg.data:match('(-%d+)$') --callback datas often ship IDs
		function_key = 'onCallbackQuery'
	else
		--function_key = 'onUnknownType'
		print('Unknown update type') return
	end

	if (msg.chat.id < 0 or msg.target_id) and msg.from then
		msg.from.admin = u.is_admin(msg.target_id or msg.chat.id, msg.from.id)
	end

	-- print('Admin:', msg.from.admin)
	local retval = on_msg_receive(msg, function_key)
	u.metric_set("msg_request_duration_sec", u.time_hires() - start_time)
	return retval
end

return _M
