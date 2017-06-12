db = dofile('lua/database.lua') -- Load database abstraction layer
local u = dofile('lua/utilities.lua') -- Load miscellaneous and cross-plugin functions

-- Make telegram aware the update was received
ngx.status = ngx.HTTP_OK
ngx.say('{ }')

-- Init redis connection
red = redis:new()
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(config.redis_host, config.redis_port)
if not ok then
	ngx.log(ngx.CRIT, 'redis connection failed: ', err)
	return
end
red:select(config.redis_db) -- Select the redis db

-- Decode the update
ngx.req.read_body()
local body = ngx.req.get_body_data()
local msg = assert(json.decode(body))

-- TODO: move this to init
bot = api.getMe().result

local function extract_usernames(msg)
	local username, userid
	if msg.from then
		if msg.from.username then
			username = msg.from.username:lower()
			userid = msg.from.id
		end
	end
	if msg.forward_from and msg.forward_from.username then
		username = msg.forward_from.username:lower()
		userid = msg.forward_from.id
	end
	if msg.new_chat_member then
		if msg.new_chat_member.username then
			username = msg.new_chat_member.username:lower()
			userid = msg.new_chat_member.id
		end
		db.setvcu(msg.chat.id, msg.new_chat_member.id, 'membership', 'true') -- Enable membership of/create entry for this chat user
	end
	if msg.left_chat_member then
		if msg.left_chat_member.username then
			username = msg.left_chat_member.username:lower()
			userid = msg.left_chat_member.id
		end
		db.setvcu(msg.chat.id, msg.new_chat_member.id, 'membership', 'false') -- Disable the membership of this chat user
	end
	if msg.reply_to_message then
		extract_usernames(msg.reply_to_message)
	end
	if msg.pinned_message then
		extract_usernames(msg.pinned_message)
	end
	db.setvusers(userid, 'username', "'"..username.."'") -- Save or update usernames
end

local function collect_stats(msg)
	extract_usernames(msg)

	if msg.chat.type ~= 'inline' and msg.from then
		-- TODO: use timestamp from message instead of now()
		db.setvcu(msg.chat.id, msg.from.id, 'lastmsg', 'now()') -- Timestamp of the last message for each user
		db.setvchat(msg.chat.id, 'lastmsg', 'now()') -- Timestamp of the last message for each chat
	end
end

local function match_triggers(triggers, text)
		if text and triggers then
		text = text:gsub('^(/[%w_]+)@'..bot.username, '%1')
		for i, trigger in pairs(triggers) do
			local matches = {}
				matches = { string.match(text, trigger) }
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

	-- Define chat language
	i18n.setLocale(db.getvchat(msg.chat.id, 'lang') or config.lang)

	if msg.chat.type ~= 'group' then --do not process messages from normal groups

		if msg.date < os.time() - config.old_message then print('Old update skipped') return end -- Do not process old messages.
		if not msg.text then msg.text = msg.caption or '' end

		collect_stats(msg)

		local continue = true
		local onm_success
		for i, plugin in pairs(plugins) do
			if plugin.onEveryMessage then
				onm_success, continue = pcall(plugin.onEveryMessage, msg)
				if not onm_success then
					api.sendAdmin('An #error occurred (preprocess).\n'..tostring(continue)..'\n'..'\n'..msg.text)
				end
			end
			if not continue then return end
		end

		for i,plugin in pairs(plugins) do
			if plugin.triggers then
				local blocks, trigger = match_triggers(plugin.triggers[callback], msg.text)
				if blocks then

					if msg.chat.type ~= 'private' and msg.chat.type ~= 'inline' and not db.getvchat(msg.chat.id, 'lastmsg') and not msg.service then --init agroup if the bot wasn't aware to be in
							u.initGroup(msg.chat.id)
						end

					if config.bot_settings.stream_commands then --print some info in the terminal
						print('['..os.date('%X')..']'..' '..trigger..' '..msg.from.first_name..' ['..msg.from.id..'] -> ['..msg.chat.id..']')
					end

					--if not check_callback(msg, callback) then goto searchaction end
					local success, result = xpcall(plugin[callback], debug.traceback, msg, blocks) --execute the main function of the plugin triggered

					if not success then --if a bug happens
							print(result)
							if config.bot_settings.notify_bug then
								api.sendReply(msg, ("🐞 Sorry, a *bug* occurred"), true)
							end
										api.sendAdmin('An #error occurred.\n'..result..'\n'..'\n'..msg.text)
							return
						end

					if type(result) == 'string' then --if the action returns a string, make that string the new msg.text
						msg.text = result
					elseif not result then --if the action returns true, then don't stop the loop of the plugin's actions
						return
					end
				end

			end
		end
	else
		if msg.group_chat_created or (msg.new_chat_member and msg.new_chat_member.id == bot.id) then
			db.setvchat(msg.chat.id, 'lang', '"'..config.lang..'"') -- set the chat language

			-- send disclamer
			api.sendMessage(msg.chat.id, ([[
Hello everyone!
My name is %s, and I'm a bot made to help administrators in their hard work.
Unfortunately I can't work in normal groups, please ask the creator to convert this group to a supergroup.
]]):format(bot.first_name))

			-- log this event
			if config.bot_settings.stream_commands then
				print(string.format('[%s] Bot was added to a normal group %s [%d] -> [%d]',
						os.date('%X'), msg.from.first_name, msg.from.id, msg.chat.id))
			end
		end
	end
end

local function parseMessageFunction(update)
	local msg, function_key

	--if update.message or update.edited_message or update.channel_post or update.edited_channel_post then
	if update.message or update.edited_message then

		function_key = 'onTextMessage'

		--if not update.message then
			if update.edited_message then
				update.edited_message.edited = true
				update.edited_message.original_date = update.edited_message.date
				update.edited_message.date = update.edited_message.edit_date
				function_key = 'onEditedMessage'
			--[[elseif update.channel_post then
				update.channel_post.channel_post = true
				function_key = 'onChannelPost'
			elseif update.edited_channel_post then
				update.edited_channel_post.edited_channel_post = true
				update.edited_channel_post.original_date = update.edited_channel_post.date
				update.edited_channel_post.date = update.edited_channel_post.edit_date
				function_key = 'onEditedChannelPost']]
			end
		--end

		--msg = update.message or update.edited_message or update.channel_post or update.edited_channel_post
		msg = update.message or update.edited_message

		if msg.text then
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
			for i, entity in pairs(msg.entities) do
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
	--[[elseif update.inline_query then
		msg = update.inline_query
		msg.inline = true
		msg.chat = {id = msg.from.id, type = 'inline', title = 'inline'}
		msg.date = os.time()
		msg.text = '###inline:'..msg.query
		function_key = 'onInlineQuery'
	elseif update.chosen_inline_result then
		msg = update.chosen_inline_result
		msg.text = '###chosenresult:'..msg.query
		msg.chat = {type = 'inline', id = msg.from.id, title = msg.from.first_name}
		msg.message_id = msg.inline_message_id
		msg.date = os.time()
		function_key = 'onChosenInlineQuery']]
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
		msg.from.admin = u.least_rank('admin',msg.target_id or msg.chat.id, msg.from.id)
		if msg.from.admin then
			msg.from.mod = true
		else
			msg.from.mod = u.least_rank('mod',msg.target_id or msg.chat.id, msg.from.id)
		end
	end

	db.accchat(msg.chat.id, 'stats_messages') -- Count how many messages were processed on a given chat

	--print('Mod:', msg.from.mod, 'Admin:', msg.from.admin)
	return on_msg_receive(msg, function_key)
end

parseMessageFunction(msg)

-- pg:keepalive() -- Allows this connection to be reused by future requests
