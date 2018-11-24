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

local function is_whitelisted(self, chat_id, text)
	local red = self.red
	local set = ('chat:%d:whitelist'):format(chat_id)
	local links = red:smembers(set)
	if links and next(links) then
		for i=1, #links do
			if text:find(links[i]:lower():gsub('%-', '%%-')) then
				return true
			end
		end
	end
end

local function getAntispamWarns(self, chat_id, user_id)
	local red = self.red
	local max_allowed = red:hget('chat:'..chat_id..':antispam', 'warns')
	if max_allowed == null then max_allowed = config.chat_settings['antispam']['warns'] end
	max_allowed = tonumber(max_allowed)

	local warns_received = red:hincrby('chat:'..chat_id..':spamwarns', user_id, 1)
	warns_received = tonumber(warns_received)

	return warns_received, max_allowed
end

local function humanizations(self)
	local i18n = self.i18n
	return {
		['ban'] = i18n:_('banned'),
		['kick'] = i18n:_('kicked'),
		['mute'] = i18n:_('muted'),
		['links'] = i18n:_('telegram.me links'),
		['forwards'] = i18n:_('Channels messages')
	}
end

function _M:on_message()
	local api = self.api
	local msg = self.message
	local u = self.u
	local red = self.red
	local i18n = self.i18n

	if not msg.inline and msg.spam and msg.chat.id < 0 and not msg.cb and not msg:is_from_admin() then
		local status = red:hget('chat:'..msg.chat.id..':antispam', msg.spam)
		if status ~= null and status ~= 'alwd' then
			local whitelisted
			if msg.spam == 'links' then
				whitelisted = is_whitelisted(self, msg.chat.id, msg.text:lower())
			--[[elseif msg.forward_from_chat then
				if msg.forward_from_chat.type == 'channel' then
					whitelisted = is_whitelisted_channel(msg.chat.id, msg.forward_from_chat.id)
				end]]
			end

			if not whitelisted then
				local hammer_text = nil
				local name = u:getname_final(msg.from)
				local warns_received, max_allowed = getAntispamWarns(self, msg.chat.id, msg.from.id) --also increases the warns counter

				if warns_received >= max_allowed then
					if status == 'del' then
						api:deleteMessage(msg.chat.id, msg.message_id)
					end

					local action = red:hget('chat:'..msg.chat.id..':antispam', 'action')
					if action == null then action = config.chat_settings['antispam']['action'] end

					local res
					if action == 'ban' then
						res = u:banUser(msg.chat.id, msg.from.id)
					elseif action == 'kick' then
						res = u:kickUser(msg.chat.id, msg.from.id)
					elseif action == 'mute' then
						res = u:muteUser(msg.chat.id, msg.from.id)
					end
					if res then
						red:hdel('chat:'..msg.chat.id..':spamwarns', msg.from.id) --remove spam warns
						api:sendMessage(msg.chat.id,
							i18n:_('%s %s for <b>spam</b>! (%d/%d)'):format(name, humanizations(self)[action], warns_received, max_allowed),
								'html'
							)
					end
				else
					if status == 'del' and warns_received == max_allowed - 1 then
						api:deleteMessage(msg.chat.id, msg.message_id)
						msg:send_reply(i18n:_('%s, spam is not allowed here. The next time you will be restricted'):format(name),
							'html')
					elseif status == 'del' then
						--just delete
						api:deleteMessage(msg.chat.id, msg.message_id)
					elseif status ~= 'del' then
						msg:send_reply(i18n:_("%s, this kind of message is not allowed in this chat (<b>%d/%d</b>)")
							:format(name, warns_received, max_allowed), 'html')
					end
				end
				local name_pretty = {links = i18n:_("telegram.me link"), forwards = i18n:_("message from a channel")}
				u:logEvent('spamwarn', msg,
					{hammered = hammer_text, warns = warns_received, warnmax = max_allowed, spam_type = name_pretty[msg.spam]})
			end
		end
	end

	if msg.edited then return false end
	return true
end

local function toggleAntispamSetting(self, chat_id, key)
	local red = self.red
	local i18n = self.i18n
	local hash = 'chat:'..chat_id..':antispam'
	local current =red:hget(hash, key)
	if current == null then current = config.chat_settings['antispam'][key] end

	local next_state = { ['alwd'] = 'warn', ['warn'] = 'del', ['del'] = 'alwd' }
	local new = next_state[current] or 'alwd'
	red:hset(hash, key, new)

	if key == 'forwards' then
		if new == 'alwd' then
			return i18n:_("forwards are allowed")
		elseif new == 'warn' then
			return i18n:_("warn for forwards")
		elseif new == 'del' then
			return i18n:_("forwards will be deleted")
		end
	elseif key == 'links' then
		if new == 'alwd' then
			return i18n:_("links are allowed")
		elseif new == 'warn' then
			return i18n:_("warn for links")
		elseif new == 'del' then
			return i18n:_("links will be deleted")
		end
	end
end

local function changeWarnsNumber(self, chat_id, action)
	local red = self.red
	local i18n = self.i18n
	local hash = 'chat:'..chat_id..':antispam'
	local key = 'warns'
	local current = red:hget(hash, key)
	if current == null then current = config.chat_settings['antispam'][key] end
	current = tonumber(current)
	if current < 1 then
		current = 1
		red:hset(hash, key, 1)
	end

	if current == 1 and action == 'dim' then
		return i18n:_("You can't go lower")
	elseif current == 7 and action == 'raise' then
		return i18n:_("You can't go higher")
	else
		local new
		if action == 'dim' then
			new = red:hincrby(hash, key, -1)
		elseif action == 'raise' then
			new = red:hincrby(hash, key, 1)
		end
		return i18n:_("New value: %d"):format(new)
	end
end

local function changeAction(self, chat_id)
	local red = self.red
	local hash = 'chat:'..chat_id..':antispam'
	local key = 'action'
	local current = red:hget(hash, key)
	if current == null then current = config.chat_settings['antispam'][key] end
	local new_action

	if current == 'ban' then new_action = 'kick'
	elseif current == 'kick' then new_action = 'mute'
	elseif current == 'mute' then new_action = 'ban' end

	red:hset(hash, key, new_action)

	return '✅'
end

local function get_alert_text(self, key)
	local i18n = self.i18n
	if key == 'links' then
		return i18n:_("Allow/forbid telegram.me links")
	elseif key == 'forwards' then
		return i18n:_("Allow/forbid forwarded messages from channels")
	elseif key == 'warns' then
		return i18n:_("Set how many times the bot should warn users before kicking/banning them")
	else
		return i18n:_("Description not available")
	end
end

local function doKeyboard_antispam(self, chat_id)
	local red = self.red
	local i18n = self.i18n
	local keyboard = {inline_keyboard = {}}

	for field, _ in pairs(config.chat_settings['antispam']) do
		if field == 'links' or field == 'forwards' then
			local icon = '✅'
			local status = red:hget('chat:'..chat_id..':antispam', field)
			if status == null then status = config.chat_settings['antispam'][field] end
			if status == 'warn' then
				icon = '❌'
			elseif status == 'del' then icon = '🗑' end
			local line = {
				{
					text = humanizations(self)[field] or field,
					callback_data = 'antispam:alert:'..field..':'..i18n:getLanguage()
				},
				{text = icon, callback_data = 'antispam:toggle:'..field..':'..chat_id}
			}
			table.insert(keyboard.inline_keyboard, line)
		end
	end

	local warns = red:hget('chat:'..chat_id..':antispam', 'warns')
	if warns == null then warns = config.chat_settings['antispam']['warns'] end

	local action = red:hget('chat:'..chat_id..':antispam', 'action')
	if action == null then action = config.chat_settings['antispam']['action'] end

	if action == 'kick' then
		action = i18n:_("Kick 👞")
	elseif action == 'ban' then
		action = i18n:_("Ban 🔨")
	elseif action == 'mute' then
		action = i18n:_("Mute 👁")
	end

	local line = {
		{text = 'Warns: '..warns, callback_data = 'antispam:alert:warns:'..i18n:getLanguage()},
		{text = '➖', callback_data = 'antispam:toggle:dim:'..chat_id},
		{text = '➕', callback_data = 'antispam:toggle:raise:'..chat_id},
		{text = action, callback_data = 'antispam:toggle:action:'..chat_id}
	}

	table.insert(keyboard.inline_keyboard, line)

	--back button
	table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})

	return keyboard
end

local function get_url(text, entity)
	return text:sub(entity.offset + 1, entity.offset + entity.length)
end

local function urls_table(entities, text)
	local links = {}
	for _, entity in pairs(entities) do
		if entity.type == 'url' then
			local url = get_url(text, entity):gsub(' ', ''):gsub('https?://', ''):gsub('www.', '')
			table.insert(links, url)
		end
	end

	return links
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local u = self.u
	local i18n = self.i18n

	if blocks[1] == 'alert' then
		i18n:setLanguage(blocks[3])
		local text = get_alert_text(self, blocks[2])
		api:answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
	else

		local chat_id = msg.target_id
		if not u:is_allowed('config', chat_id, msg.from) then
			api:answerCallbackQuery(msg.cb_id, i18n:_("You're no longer an admin"))
		else
			local antispam_first = i18n:_([[*Anti-spam settings*
Choose which kind of message you want to forbid
• ✅ = *Allowed*
• ❌ = *Not allowed*
• 🗑 = *Delete*
When set on `delete`, the bot doesn't warn users until they are about to be kicked/banned/muted (at the second-to-last warning)]]) -- luacheck: ignore 631

			local keyboard, text

			if blocks[1] == 'toggle' then
				if blocks[2] == 'forwards' or blocks[2] == 'links' then
					text = toggleAntispamSetting(self, chat_id, blocks[2])
				else
					if blocks[2] == 'raise' or blocks[2] == 'dim' then
						text = changeWarnsNumber(self, chat_id, blocks[2])
					elseif blocks[2] == 'action' then
						text = changeAction(self, chat_id, blocks[2])
					end
				end
			end

			keyboard = doKeyboard_antispam(self, chat_id)
			api:editMessageText(msg.chat.id, msg.message_id, nil, antispam_first, "Markdown", nil, keyboard)
			if text then api:answerCallbackQuery(msg.cb_id, text) end
		end
	end
end

local function edit_channels_whitelist(self, chat_id, list, action)
	local red = self.red

	local channels = {valid = {}, not_valid ={}}
	local for_entered
	local set = ('chat:%d:chanwhitelist'):format(chat_id)
	local res
	for channel_id in list:gmatch('-%d+') do
		if action == 'add' then
			-- Insert check for whitelists that contain invalid patterns here
			res = red:sadd(set, channel_id)
		elseif action == 'rem' then
			res = red:srem(set, channel_id)
		end

		if res == 1 then
			table.insert(channels.valid, channel_id)
		elseif res == 0 then
			table.insert(channels.not_valid, channel_id)
		end

		for_entered = true
	end

	return for_entered, channels
end

function _M:onTextMessage(blocks)
	local msg = self.message
	local u = self.u
	local red = self.red
	local i18n = self.i18n

	if u:is_allowed('texts', msg.chat.id, msg.from) then
		if (blocks[1] == 'wl' or blocks[1] == 'whitelist') and blocks[2] then
			if blocks[2] == '-' then
				local set = ('chat:%d:whitelist'):format(msg.chat.id)
				local n = red:scard(set) or 0
				local text
				if n == 0 then
					text = i18n:_("_The whitelist was already empty_")
				else
					red:del(set)
					text = i18n:_("*Whitelist cleaned*\n%d links have been removed"):format(n)
				end
				msg:send_reply(text, "Markdown")
			else
				local text
				if msg.entities then
					local links = urls_table(msg.entities, msg.text)
					if not next(links) then
						text = i18n:_("_I can't find any url in this message_")
					else
						local new = red:sadd(('chat:%d:whitelist'):format(msg.chat.id), unpack(links))
						text = i18n:_("%d link(s) will be whitelisted"):format(#links - (#links - new))
						if new ~= #links then
							text = text..i18n:_("\n%d links were already in the list"):format(#links - new)
						end
					end
				else
					text = i18n:_("_I can't find any url in this message_")
				end
				msg:send_reply(text, "Markdown")
			end
		end
		if (blocks[1] == 'wl' or blocks[1] == 'whitelist') and not blocks[2] then
			local links = red:smembers(('chat:%d:whitelist'):format(msg.chat.id))
			if not next(links) then
				msg:send_reply(i18n:_("_The whitelist is empty_.\nUse `/wl [links]` to add some links to the whitelist"),"Markdown")
			else
				local text = i18n:_("Whitelisted links:\n\n")
				for i=1, #links do
					text = text..'• '..links[i]..'\n'
				end
				msg:send_reply(text)
			end
		end
		if blocks[1] == 'unwl' or blocks[1] == 'unwhitelist' then
			local text
			if msg.entities then
				local links = urls_table(msg.entities, msg.text)
				if not next(links) then
					text = i18n:_("_I can't find any url in this message_")
				else
					local removed = red:srem(('chat:%d:whitelist'):format(msg.chat.id), unpack(links))
					text = i18n:_("%d link(s) removed from the whitelist"):format(removed)
					if removed ~= #links then
						text = text..i18n:_("\n%d links were already in the list"):format(#links - removed)
					end
				end
			else
				text = i18n:_("_I can't find any url in this message_")
			end
			msg:send_reply(text, "Markdown")
		end
		if blocks[1] == 'funwl' then --force the unwhitelist of a link
			red:srem(('chat:%d:whitelist'):format(msg.chat.id), blocks[2])
			msg:send_reply('Done')
		end
		if blocks[1] == 'wlchan' and not blocks[2] then
			local channels = red:smembers(('chat:%d:chanwhitelist'):format(msg.chat.id))
			if not next(channels) then
				msg:send_reply(i18n:_("_Whitelist of channels empty_"), "Markdown")
			else
				msg:send_reply(i18n:_("*Whitelisted channels:*\n%s"):format(table.concat(channels, '\n')), "Markdown")
			end
		end
		if blocks[1] == 'wlchan' and blocks[2] then
			local for_entered, channels = edit_channels_whitelist(self, msg.chat.id, blocks[2], 'add')

			if not for_entered then
				msg:send_reply(i18n:_("_I can't find a channel ID in your message_"), "Markdown")
			else
				local text = ''
				if next(channels.valid) then
					text = text..("*Channels whitelisted*: `%s`\n"):format(table.concat(channels.valid, ', '))
				end
				if next(channels.not_valid) then
					text = text..("*Channels already whitelisted*: `%s`\n"):format(table.concat(channels.not_valid, ', '))
				end

				msg:send_reply(text, "Markdown")
			end
		end
		if blocks[1] == 'unwlchan' then
			local for_entered, channels = edit_channels_whitelist(self, msg.chat.id, blocks[2], 'rem')

			if not for_entered then
				msg:send_reply(i18n:_("_I can't find a channel ID in your message_"), "Markdown")
			else
				local text = ''
				if next(channels.valid) then
					text = text..("*Channels unwhitelisted*: `%s`\n"):format(table.concat(channels.valid, ', '))
				end
				if next(channels.not_valid) then
					text = text..("*Channels not whitelisted*: `%s`\n"):format(table.concat(channels.not_valid, ', '))
				end

				msg:send_reply(text, "Markdown")
			end
		end
	end
end

_M.triggers = {
	onCallbackQuery = {
		'^###cb:antispam:(toggle):(%w+):(-?%d+)$',
		'^###cb:antispam:(alert):(%w+):([%w_]+)$',
		'^###cb:(config):antispam:(-?%d+)$'
	},
	onTextMessage = {
		config.cmd..'(wl) (.+)$',
		config.cmd..'(whitelist) (.+)$',
		--config.cmd..'(wlchan) (.+)$',
		config.cmd..'(unwl) (.+)$',
		config.cmd..'(unwhitelist) (.+)$',
		--config.cmd..'(unwlchan) (.+)$',
		config.cmd..'(wl)$',
		config.cmd..'(whitelist)$',
		--config.cmd..'(wlchan)$',
		config.cmd..'(funwl) (.+)'
	}
}

return _M
