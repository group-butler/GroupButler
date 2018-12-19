local config = require "groupbutler.config"

local _M = {}

function _M:new(update_obj)
	local plugin_obj = {}
	setmetatable(plugin_obj, {__index = self})
	for k, v in pairs(update_obj) do
		plugin_obj[k] = v
	end
	return plugin_obj
end

local function permissions(self)
	local i18n = self.i18n
	return {
		can_change_info = i18n("can't change the chat title/description/icon"),
		can_send_messages = i18n("can't send messages"),
		can_delete_messages = i18n("can't delete messages"),
		can_invite_users = i18n("can't invite users/generate a link"),
		can_restrict_members = i18n("can't restrict members"),
		can_pin_messages = i18n("can't pin messages"),
		can_promote_members = i18n("can't promote new admins"),
		can_send_media_messages = i18n("can't send photos/videos/documents/audios/voice messages/video messages"),
		can_send_other_messages = i18n("can't send stickers/GIFs/games/use inline bots"),
		can_add_web_page_previews = i18n("can't show link previews")
	}
end

local function do_keyboard_cache(self, chat_id)
	local i18n = self.i18n
	local keyboard = {inline_keyboard = {{{text = i18n("🔄️ Refresh cache"), callback_data = 'recache:'..chat_id}}}}
	return keyboard
end

local function get_time_remaining(seconds)
	local final = ''
	local hours = math.floor(seconds/3600)
	seconds = seconds - (hours*60*60)
	local min = math.floor(seconds/60)
	seconds = seconds - (min*60)

	if hours and hours > 0 then
		final = final..hours..'h '
	end
	if min and min > 0 then
		final = final..min..'m '
	end
	if seconds and seconds > 0 then
		final = final..seconds..'s'
	end

	return final
end

local function do_keyboard_userinfo(self, user_id)
	local i18n = self.i18n
	local keyboard = {
		inline_keyboard = {
			{{text = i18n("Remove warnings"), callback_data = 'userbutton:remwarns:'..user_id}}
		}
	}
	return keyboard
end

local function get_userinfo(self, user_id, chat_id)
	local red = self.red
	local i18n = self.i18n

	local text = i18n([[*User ID*: `%d`
`Warnings`: *%d*
`Media warnings`: *%d*
`Spam warnings`: *%d*
]])
	local warns = tonumber(red:hget('chat:'..chat_id..':warns', user_id)) or 0
	local media_warns = tonumber(red:hget('chat:'..chat_id..':mediawarn', user_id)) or 0
	local spam_warns = tonumber(red:hget('chat:'..chat_id..':spamwarns', user_id)) or 0
	return text:format(tonumber(user_id), warns, media_warns, spam_warns)
end

function _M:onTextMessage(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local i18n = self.i18n
	local u = self.u

	if blocks[1] == 'id' then --in private: send user id
		if msg.chat.id > 0 and msg.chat.type == 'private' then
			api:sendMessage(msg.chat.id, string.format(i18n('Your ID is `%d`'), msg.from.id), "Markdown")
		end
	end

	if msg.chat.type == 'private' then return end

	if blocks[1] == 'id' then --in groups: send chat ID
		if msg.chat.id < 0 and msg:is_from_admin() then
			api:sendMessage(msg.chat.id, string.format('`%d`', msg.chat.id), "Markdown")
		end
	end

	if blocks[1] == 'adminlist' then
		local adminlist = u:getAdminlist(msg.chat.id)
		if not msg:is_from_admin() then
			api:sendMessage(msg.from.id, adminlist, 'html', true)
		else
			msg:send_reply(adminlist, 'html', true)
		end
	end

	if blocks[1] == 'status' then
		if (not blocks[2] and not msg.reply) or not msg:is_from_admin() then
			return
		end

		local user_id, error_tr_id = u:getUserId(msg, blocks)
		if not user_id then
			msg:send_reply(error_tr_id, "Markdown")
			return
		end
		local res = api:getChatMember(msg.chat.id, user_id)

		if not res then
			msg:send_reply(i18n("That user has nothing to do with this chat"))
			return
		end

		local status = res.status
		local name = u:getname_final(res.user)
		local statuses = {
			kicked = i18n("%s is banned from this group"),
			left = i18n("%s left the group or has been kicked and unbanned"),
			administrator = i18n("%s is an admin"),
			creator = i18n("%s is the group creator"),
			unknown = i18n("%s has nothing to do with this chat"),
			member = i18n("%s is a chat member"),
			restricted = i18n("%s is a restricted")
		}
		local denied_permissions = {}
		for permission, str in pairs(permissions(self)) do
			if res[permission] ~= nil and res[permission] == false then
				table.insert(denied_permissions, str)
			end
		end

		local text = statuses[status]:format(name)
		if next(denied_permissions) then
			text = text..i18n('\nRestrictions: <i>%s</i>'):format(table.concat(denied_permissions, ', '))
		end

		msg:send_reply(text, 'html')
	end
	if blocks[1] == 'user' then
		if not msg:is_from_admin() then return end

		if not msg.reply
			and (not blocks[2] or (not blocks[2]:match('@[%w_]+$') and not blocks[2]:match('%d+$')
			and not msg.mention_id)) then
			msg:send_reply(i18n("Reply to a user or mention them by username or numerical ID"))
			return
		end

		------------------ get user_id --------------------------
		local user_id, err = u:getUserId(msg, blocks)

		if not user_id then
			msg:send_reply(err, "Markdown")
			return
		end
		-----------------------------------------------------------------------------

		local keyboard = do_keyboard_userinfo(self, user_id)

		local text = get_userinfo(self, user_id, msg.chat.id)

		api:sendMessage(msg.chat.id, text, "Markdown", nil, nil, nil, keyboard)
	end
	if blocks[1] == 'cache' then
		if not msg:is_from_admin() then return end
		local hash = 'cache:chat:'..msg.chat.id..':admins'
		local seconds = red:ttl(hash)
		local cached_admins = red:scard(hash)
		local text = i18n("📌 Status: `CACHED`\n⌛ ️Remaining: `%s`\n👥 Admins cached: `%d`")
			:format(get_time_remaining(tonumber(seconds)), cached_admins)
		local keyboard = do_keyboard_cache(self, msg.chat.id)
		api:sendMessage(msg.chat.id, text, "Markdown", nil, nil, nil, keyboard)
	end
	if blocks[1] == 'msglink' then
		if not msg.reply or not msg.chat.username then return end

		local text = string.format('[%s](https://telegram.me/%s/%d)',
			i18n("Message N° %d"):format(msg.reply.message_id), msg.chat.username, msg.reply.message_id)
		if not u:is_silentmode_on(msg.chat.id) or msg:is_from_admin() then
			msg.reply:send_reply(text, "Markdown")
		else
			api:sendMessage(msg.from.id, text, "Markdown")
		end
	end
	if blocks[1] == 'leave' and msg:is_from_admin() then
		-- u:remGroup(msg.chat.id)
		api:leaveChat(msg.chat.id)
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local red = self.red
	local db = self.db
	local i18n = self.i18n
	local u = self.u

	if not msg:is_from_admin() then
		api:answerCallbackQuery(msg.cb_id, i18n("You are not allowed to use this button"))
		return
	end

	if blocks[1] == 'remwarns' then
		db:forgetUserWarns(msg.chat.id, blocks[2])

		local name = u:getname_final(msg.from)
		local res = api:getChatMember(msg.chat.id, blocks[2])
		local text = i18n("The number of warnings received by this user has been <b>reset</b>, by %s"):format(name)
		api:editMessageText(msg.chat.id, msg.message_id, nil, text:format(name), 'html')
		u:logEvent('nowarn', msg, {
			admin = name,
			user = u:getname_final(res.user),
			user_id = blocks[2]
		})
	end
	if blocks[1] == 'recache' and msg:is_from_admin() then
		local missing_sec = tonumber(red:ttl('cache:chat:'..msg.target_id..':admins') or 0)
		local wait = 600
		if config.bot_settings.cache_time.adminlist - missing_sec < wait then
			local seconds_to_wait = wait - (config.bot_settings.cache_time.adminlist - missing_sec)
			api:answerCallbackQuery(msg.cb_id,i18n(
					"The adminlist has just been updated. You must wait 10 minutes from the last refresh (wait  %d seconds)"
				):format(seconds_to_wait), true)
		else
			red:del('cache:chat:'..msg.target_id..':admins')
			u:cache_adminlist(msg.target_id)
			local cached_admins = red:smembers('cache:chat:'..msg.target_id..':admins')
			local time = get_time_remaining(config.bot_settings.cache_time.adminlist)
			local text = i18n("📌 Status: `CACHED`\n⌛ ️Remaining: `%s`\n👥 Admins cached: `%d`")
				:format(time, #cached_admins)
			api:answerCallbackQuery(msg.cb_id, i18n("✅ Updated. Next update in %s"):format(time))
			api:editMessageText(msg.chat.id, msg.message_id, nil, text, "Markdown", nil, do_keyboard_cache(self, msg.target_id))
		end
	end
end

_M.triggers = {
	onTextMessage = {
		config.cmd..'(id)$',
		config.cmd..'(adminlist)$',
		config.cmd..'(status) (.+)$',
		config.cmd..'(status)$',
		config.cmd..'(cache)$',
		config.cmd..'(msglink)$',
		config.cmd..'(user)$',
		config.cmd..'(user) (.*)',
		config.cmd..'(leave)$'
	},
	onCallbackQuery = {
		'^###cb:userbutton:(remwarns):(%d+)$',
		'^###cb:(recache):'
	}
}

return _M
