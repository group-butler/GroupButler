HTTP = require('socket.http')
HTTPS = require('ssl.https')
URL = require('socket.url')
JSON = require('dkjson')
redis = require('redis')
clr = require 'term.colors'
db = Redis.connect('127.0.0.1', 6379)
--db:select(0)
serpent = require('serpent')

local function check_config()
	if not config.bot_api_key or config.bot_api_key == '' then
		return 'Bot token missing. You must set it!'
	elseif not config.admin.owner or config.admin.owner == '' then
		return 'You have to set the id of the owner'
	elseif not config.bot_settings.cache_time.adminlist or config.bot_settings.cache_time.adminlist == '' then
		return 'Please set up a cache time for the adminlist'
	end
end

function bot_init(on_reload) -- The function run when the bot is started or reloaded.
	
	config = dofile('config.lua') -- Load configuration file.
	local error = check_config()
	if error then
		print(clr.red..error)
		return
	end
	misc, roles = dofile('utilities.lua') -- Load miscellaneous and cross-plugin functions.
	lang = dofile(config.languages) -- All the languages available
	api = require('methods')
	
	current_m = 0
	last_m = 0
	
	bot = nil
	while not bot do -- Get bot info and retry if unable to connect.
		bot = api.getMe()
	end
	bot = bot.result

	plugins = {} -- Load plugins.
	for i,v in ipairs(config.plugins) do
		local p = dofile('plugins/'..v)
		table.insert(plugins, p)
	end
	if config.bot_settings.multipurpose_mode then
		for i,v in ipairs(config.multipurpose_plugins) do
			local p = dofile('plugins/multipurpose/'..v)
			table.insert(plugins, p)
		end
	end

	print('\n'..clr.blue..'BOT RUNNING:'..clr.reset, clr.red..'[@'..bot.username .. '] [' .. bot.first_name ..'] ['..bot.id..']'..clr.reset..'\n')
	if not on_reload then
		db:hincrby('bot:general', 'starts', 1)
		api.sendAdmin('*Bot started!*\n_'..os.date('On %A, %d %B %Y\nAt %X')..'_\n'..#plugins..' plugins loaded', true)
	end
	
	-- Generate a random seed and "pop" the first random number. :)
	math.randomseed(os.time())
	math.random()

	last_update = last_update or 0 -- Set loop variables: Update offset,
	last_cron = last_cron or os.time() -- the time of the last cron job,
	is_started = true -- whether the bot should be running or not.
	
	if on_reload then return #plugins end

end

local function get_from(msg)
	local user = '['..msg.from.first_name
	if msg.from.last_name then
		user = user..' '..msg.from.last_name
	end
	user = user..']'
	if msg.from.username then
		user = user..' [@'..msg.from.username..']'
	end
	user = user..' ['..msg.from.id..']'
	return user
end

local function get_what(msg)
	if msg.sticker then
		return 'sticker'
	elseif msg.photo then
		return 'photo'
	elseif msg.document then
		return 'document'
	elseif msg.audio then
		return 'audio'
	elseif msg.video then
		return 'video'
	elseif msg.voice then
		return 'voice'
	elseif msg.contact then
		return 'contact'
	elseif msg.location then
		return 'location'
	elseif msg.text then
		return 'text'
	else
		return 'service message'
	end
end

local function collect_stats(msg)
	
	--count the number of messages
	db:hincrby('bot:general', 'messages', 1)
	
	--for resolve username
	if msg.from and msg.from.username then
		db:hset('bot:usernames', '@'..msg.from.username:lower(), msg.from.id)
		db:hset('bot:usernames:'..msg.chat.id, '@'..msg.from.username:lower(), msg.from.id)
	end
	if msg.forward_from and msg.forward_from.username then
		db:hset('bot:usernames', '@'..msg.forward_from.username:lower(), msg.forward_from.id)
		db:hset('bot:usernames:'..msg.chat.id, '@'..msg.forward_from.username:lower(), msg.forward_from.id)
	end
	
	if not(msg.chat.type == 'private') then
		if msg.from then
			db:hset('chat:'..msg.chat.id..':userlast', msg.from.id, os.time()) --last message for each user
			db:hset('bot:chat:latsmsg', msg.chat.id, os.time()) --last message in the group
		end
	end
	
	--user stats
	if msg.from then
		db:hincrby('user:'..msg.from.id, 'msgs', 1)
	end
end

local function match_pattern(pattern, text)
  	if text then
  		text = text:gsub('@'..bot.username, '')
    	local matches = {}
    	matches = { string.match(text, pattern) }
    	if next(matches) then
    		return matches
		end
  	end
end

on_msg_receive = function(msg) -- The fn run whenever a message is received.
	--vardump(msg)
	if not msg then
		api.sendAdmin('A loop without msg') return
	end
	
	if msg.date < os.time() - 7 then return end -- Do not process old messages.
	if not msg.text then msg.text = msg.caption or '' end
	
	msg.normal_group = false
	if msg.chat.type == 'group' then msg.normal_group = true end
	
	--for commands link
	--[[if msg.text:match('^/start .+') then
		msg.text = '/' .. msg.text:input()
	end]]
	
	--Group language
	msg.ln = (db:get('lang:'..msg.chat.id)) or 'en'
	
	collect_stats(msg) --resolve_username support, chat stats
	
	local stop_loop
	for i, plugin in pairs(plugins) do
		if plugin.on_each_msg then
			msg, stop_loop = plugin.on_each_msg(msg, msg.lang)
		end
		if stop_loop then --check if on_each_msg said to stop the triggers loop
			return
		end
	end
	
	for i,plugin in pairs(plugins) do
		if plugin.triggers then
			if (config.bot_settings.testing_mode and plugin.test) or not plugin.test then --run test plugins only if test mode is on
				for k,w in pairs(plugin.triggers) do
					local blocks = match_pattern(w, msg.text)
					if blocks then
						
						--workaround for the stupid bug
						if not(msg.chat.type == 'private') and not db:exists('chat:'..msg.chat.id..':settings') and not msg.service then
							misc.initGroup(msg.chat.id)
						end
						
						--print in the terminal
						print(clr.reset..clr.blue..'['..os.date('%X')..']'..clr.red..' '..w..clr.reset..' '..get_from(msg)..' -> ['..msg.chat.id..'] ['..msg.chat.type..']')
						
						--print the match
						if blocks[1] ~= '' then
      						db:hincrby('bot:general', 'query', 1)
      						if msg.from then db:incrby('user:'..msg.from.id..':query', 1) end
      					end
						
						--execute the plugin
						local success, result = pcall(function()
							return plugin.action(msg, blocks)
						end)
						
						--if bugs
						if not success then
							print(msg.text, result)
							if config.bot_settings.notify_bug then
								api.sendReply(msg, '*A bug occurred*', true)
							end
							--misc.save_log('errors', result, msg.from.id or false, msg.chat.id or false, msg.text or false)
          					api.sendAdmin('An #error occurred.\n'..result..'\n'..msg.ln..'\n'..msg.text)
							return
						end
						
						-- If the action returns a table, make that table msg.
						if type(result) == 'table' then
							msg = result
						elseif type(result) == 'string' then
							msg.text = result
						-- If the action returns true, don't stop.
						elseif result ~= true then
							return
						end
					end
				end
			end
		end
	end
end

local function service_to_message(msg)
	msg.service = true
	if msg.new_chat_member then
    	if tonumber(msg.new_chat_member.id) == tonumber(bot.id) then
			msg.text = '###botadded'
		else
			msg.text = '###added'
		end
		msg.adder = misc.clone_table(msg.from)
		msg.added = misc.clone_table(msg.new_chat_member)
	elseif msg.left_chat_member then
    	if tonumber(msg.left_chat_member.id) == tonumber(bot.id) then
			msg.text = '###botremoved'
		else
			msg.text = '###removed'
		end
		msg.remover = misc.clone_table(msg.from)
		msg.removed = misc.clone_table(msg.left_chat_member)
	elseif msg.group_chat_created then
    	msg.chat_created = true
    	msg.adder = misc.clone_table(msg.from)
    	msg.text = '###botadded'
	end
    return on_msg_receive(msg)
end

local function forward_to_msg(msg)
	if msg.text then
		msg.text = '###forward:'..msg.text
	else
		msg.text = '###forward'
	end
    return on_msg_receive(msg)
end

local function media_to_msg(msg)
	msg.media = true
	if msg.photo then
		msg.text = '###image'
		msg.media_type = 'image'
		--if msg.caption then
			--msg.text = msg.text..':'..msg.caption
		--end
	elseif msg.video then
		msg.text = '###video'
		msg.media_type = 'video'
	elseif msg.audio then
		msg.text = '###audio'
		msg.media_type = 'audio'
	elseif msg.voice then
		msg.text = '###voice'
		msg.media_type = 'voice'
	elseif msg.document then
		msg.text = '###file'
		msg.media_type = 'file'
		if msg.document.mime_type == 'video/mp4' then
			msg.text = '###gif'
			msg.media_type = 'gif'
		end
	elseif msg.sticker then
		msg.text = '###sticker'
		msg.media_type = 'sticker'
	elseif msg.contact then
		msg.text = '###contact'
		msg.media_type = 'contact'
	else
		msg.media = false
	end
	
	--check entities for links/text mentions. Increased strictness!
	if msg.entities then
		for i,entity in pairs(msg.entities) do
			if entity.type == 'text_mention' then
				msg.mention_id = entity.user.id
			end
			if entity.type == 'url' or entity.type == 'text_link' then
				if msg.text:match('([Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[%a][%a][%a]/)') or msg.text:match('([Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[%a][%a]/)') then 
					msg.media_type = 'TGlink'
				else
					msg.media_type = 'link'
				end
				msg.media = true
			end
		end
	end
	
	if msg.reply_to_message then
		msg.reply = msg.reply_to_message
	end
	return on_msg_receive(msg)
end

local function rethink_reply(msg)
	msg.reply = msg.reply_to_message
	if msg.reply.caption then
		msg.reply.text = msg.reply.caption
	end
	return on_msg_receive(msg)
end

local function handle_inline_keyboards_cb(msg)
	msg.text = '###cb:'..msg.data
	msg.old_text = msg.message.text
	msg.old_date = msg.message.date
	msg.date = os.time()
	msg.cb = true
	msg.cb_id = msg.id
	--msg.cb_table = JSON.decode(msg.data)
	msg.message_id = msg.message.message_id
	msg.chat = msg.message.chat
	msg.message = nil
	msg.target_id = msg.data:match('(-?%d+)$')
	return on_msg_receive(msg)
end

---------WHEN THE BOT IS STARTED FROM THE TERMINAL, THIS IS THE FIRST FUNCTION IT FINDS

bot_init() -- Actually start the script. Run the bot_init function.

while is_started do -- Start a loop while the bot should be running.
	local res = api.getUpdates(last_update+1) -- Get the latest updates!
	if res then
		--vardump(res)
		for i,msg in ipairs(res.result) do -- Go through every new message.
			last_update = msg.update_id
			current_m = current_m + 1
			if msg.message  or msg.callback_query --[[or msg.edited_message]]then
				--[[if msg.edited_message then
					msg.message = msg.edited_message
					msg.edited_message = nil
				end]]
				if msg.callback_query then
					handle_inline_keyboards_cb(msg.callback_query)
				elseif msg.message.migrate_to_chat_id then
					misc.to_supergroup(msg.message)
				elseif msg.message.new_chat_member or msg.message.left_chat_member or msg.message.group_chat_created then
					service_to_message(msg.message)
				elseif msg.message.photo or msg.message.video or msg.message.document or msg.message.voice or msg.message.audio or msg.message.sticker or msg.message.entities then
					media_to_msg(msg.message)
				elseif msg.message.forward_from then
					forward_to_msg(msg.message)
				elseif msg.message.reply_to_message then
					rethink_reply(msg.message)
				else
					on_msg_receive(msg.message)
				end
			end
		end
	else
		print('Connection error')
	end
	if last_cron ~= os.date('%M') then -- Run cron jobs every minute.
		last_cron = os.date('%M')
		last_m = current_m
		current_m = 0
		for i,v in ipairs(plugins) do
			if v.cron then -- Call each plugin's cron function, if it has one.
				local res, err = pcall(function() v.cron() end)
				if not res then
          			api.sendLog('An #error occurred.\n'..err)
					return
				end
			end
		end
	end
end

print('Halted.\n')
