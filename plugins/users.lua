local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function do_keyboard_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("Channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = _("GitHub"), url = 'https://github.com/RememberTheAir/GroupButler'},
    		{text = _("Rate me!"), url = 'https://telegram.me/storebot?start='..bot.username},
		}
	}
	return keyboard
end

local function do_keyboard_cache(chat_id)
	local keyboard = {inline_keyboard = {{{text = _("🔄️ Refresh cache"), callback_data = 'recache:'..chat_id}}}}
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

local function get_user_id(msg, blocks)
	if msg.reply then
		return msg.reply.from.id
	elseif blocks[2] then
		if blocks[2]:match('@[%w_]+$') then --by username
			local user_id = u.resolve_user(blocks[2])
			if not user_id then
				print('username (not found)')
				return false
			else
				print('username (found)')
				return user_id
			end
		elseif blocks[2]:match('%d+$') then --by id
			print('id')
			return blocks[2]
		elseif msg.mention_id then --by text mention
			print('text mention')
			return msg.mention_id
		else
			return false
		end
	end
end

local function do_keyboard_userinfo(user_id)
	local keyboard = {
		inline_keyboard = {
			{{text = _("Remove warnings"), callback_data = 'userbutton:remwarns:'..user_id}}
		}
	}

	return keyboard
end

local function get_userinfo(user_id, chat_id)
	local text = _([[*User ID*: `%d`
`Warnings`: *%d*
`Media warnings`: *%d*
`Spam warnings`: *%d*
]])
	local warns = (db:hget('chat:'..chat_id..':warns', user_id)) or 0
	local media_warns = (db:hget('chat:'..chat_id..':mediawarn', user_id)) or 0
	local spam_warns = (db:hget('chat:'..chat_id..':spamwarns', user_id)) or 0
	return text:format(tonumber(user_id), warns, media_warns, spam_warns)
end

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'id' then
		-- Send ID of specified user or chat
		local what, text
		if msg.reply and msg.reply.from.id == msg.from.id or
				not msg.reply and msg.chat.type == 'private' then
			what = msg.from.id
			text = _("That's your ID. Copy it")
		elseif msg.reply and msg.reply.from.id == bot.id then
			what = bot.id
			text = _("That's my ID. Copy it")
		elseif not msg.reply then
			what = msg.chat.id
			text = _("That's the ID of this group. Copy it")
		else
			what = msg.reply.from.id
			text = _("That's his (her) ID. Copy it")
		end

		local where
		if msg.chat.type ~= 'private' and (u.is_mod(msg.chat.id, msg.from.id) or
										   not u.is_silentmode_on(msg.chat.id)) then
			where = msg.chat.id
		else
			where = msg.from.id
		end

		if msg.reply and where == msg.chat.id then
			api.sendReply(msg.reply, text)
		else
			api.sendMessage(where, text)
		end
		api.sendMessage(where, string.format('`%d`', what), true)
 	end

	if msg.chat.type == 'private' then return end

	if blocks[1] == 'adminlist' then
        local adminlist = u.getAdminlist(msg.chat.id)
        if not msg.from.mod then
        	api.sendMessage(msg.from.id, adminlist, 'html')
        else
            api.sendReply(msg, adminlist, 'html')
        end
    end
	if blocks[1] == 'staff' then
        local adminlist = u.getAdminlist(msg.chat.id)
        if adminlist then
        	local is_empty, modlist = u.getModlist(msg.chat.id)
        	local text = adminlist..'\n'..modlist
        	if not msg.from.mod then
        		api.sendMessage(msg.from.id, text, 'html')
        	else
        	    api.sendReply(msg, text, 'html')
        	end
        end
    end
	if blocks[1] == 'status' then
    	if u.is_allowed('hammer', msg.chat.id, msg.from) then
    		if not blocks[2] and not msg.reply then return end
    		local user_id, error_tr_id = u.get_user_id(msg, blocks)
    		if not user_id then
				api.sendReply(msg, _(error_tr_id), true)
		 	else
		 		local res = api.getChatMember(msg.chat.id, user_id)
		 		if not res then
					api.sendReply(msg, _("That user has nothing to do with this chat"))
		 			return
		 		end
		 		local status = res.result.status
				local name = u.getname_final(res.result.user)
				local texts = {
					kicked = _("%s is banned from this group"),
					left = _("%s left the group or has been kicked and unbanned"),
					administrator = _("%s is an admin"),
					creator = _("%s is the group creator"),
					unknown = _("%s has nothing to do with this chat"),
					member = _("%s is a chat member")
				}
				api.sendReply(msg, texts[status]:format(name), 'html')
		 	end
	 	end
 	end
	if blocks[1] == 'user' then
		if not u.is_allowed('hammer', msg.chat.id, msg.from) then return end

		if not msg.reply and (not blocks[2] or (not blocks[2]:match('@[%w_]+$') and not blocks[2]:match('%d+$') and not msg.mention_id)) then
			api.sendReply(msg, _("Reply to an user or mention them by username or numerical ID"))
			return
		end

		------------------ get user_id --------------------------
		local user_id = get_user_id(msg, blocks)

		if not user_id then
			api.sendReply(msg, _("I've never seen this user before.\n"
				.. "If you want to teach me who they are, forward a message from them to me"), true)
		 	return
		end
		-----------------------------------------------------------------------------

		local keyboard = do_keyboard_userinfo(user_id)

		local text = get_userinfo(user_id, msg.chat.id)

		api.sendMessage(msg.chat.id, text, true, keyboard)
	end
	if blocks[1] == 'cache' then
    	if not msg.from.admin then return end
    	local hash = 'cache:chat:'..msg.chat.id..':admins'
		local seconds = db:ttl(hash)
		local cached_admins = db:scard(hash)
		local text = _("📌 Status: `CACHED`\n⌛ ️Remaining: `%s`\n👥 Admins cached: `%d`")
			:format(get_time_remaining(tonumber(seconds)), cached_admins)
    	local keyboard = do_keyboard_cache(msg.chat.id)
    	api.sendMessage(msg.chat.id, text, true, keyboard)
    end
	if blocks[1] == 'msglink' then
    	if not msg.reply or not msg.chat.username then return end

		local text = string.format('[%s](https://telegram.me/%s/%d)',
			_("Message N° %d"):format(msg.reply.message_id), msg.chat.username, msg.reply.message_id)
		if msg.from.mod or not u.is_silentmode_on(msg.chat.id) then
			api.sendReply(msg.reply, text, true)
		else
			api.sendMessage(msg.from.id, text, true)
    	end
	end
	if blocks[1] == 'leave' then
		if msg.from.admin then
			u.remGroup(msg.chat.id)
			api.leaveChat(msg.chat.id)
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if not u.is_allowed('hammer', msg.chat.id, msg.from) then
		api.answerCallbackQuery(msg.cb_id, _("You are not allowed to use this button")) return
	end

	if blocks[1] == 'remwarns' then
		local removed = {
			normal = db:hdel('chat:'..msg.chat.id..':warns', blocks[2]),
			media = db:hdel('chat:'..msg.chat.id..':mediawarn', blocks[2]),
			spam = db:hdel('chat:'..msg.chat.id..':spamwarns', blocks[2])
		}

        local name = u.getname_final(msg.from)
		local text = _("The number of warnings received by this user has been <b>reset</b>, by %s"):format(name)
		api.editMessageText(msg.chat.id, msg.message_id, text:format(name), 'html')
		u.logEvent('nowarn', msg, {admin = name, user = ('<code>%s</code>'):format(msg.target_id), user_id = msg.target_id, rem = removed})
    end
    if blocks[1] == 'recache' and msg.from.admin then
		local missing_sec = tonumber(db:ttl('cache:chat:'..msg.target_id..':admins') or 0)
		local wait = 600
		if config.bot_settings.cache_time.adminlist - missing_sec < wait then
			local seconds_to_wait = wait - (config.bot_settings.cache_time.adminlist - missing_sec)
			api.answerCallbackQuery(msg.cb_id, _("The adminlist has just been updated. You must wait 10 minutes from the last refresh (wait %d seconds)"):format(seconds_to_wait), true)
		else
			db:del('cache:chat:'..msg.target_id..':admins')
			u.cache_adminlist(msg.target_id)
    		local cached_admins = db:smembers('cache:chat:'..msg.target_id..':admins')
    		local time = get_time_remaining(config.bot_settings.cache_time.adminlist)
			local text = _("📌 Status: `CACHED`\n⌛ ️Remaining: `%s`\n👥 Admins cached: `%d`")
				:format(time, #cached_admins)
    		api.answerCallbackQuery(msg.cb_id, _("✅ Updated. Next update in %s"):format(time))
    		api.editMessageText(msg.chat.id, msg.message_id, text, true, do_keyboard_cache(msg.target_id))
    		--api.sendLog('#recache\nChat: '..msg.target_id..'\nFrom: '..msg.from.id)
    	end
    end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(id)$',
		config.cmd..'(adminlist)$',
		config.cmd..'(status) (.+)$',
		config.cmd..'(status)$',
		config.cmd..'(cache)$',
		config.cmd..'(msglink)$',
		config.cmd..'(user)$',
		config.cmd..'(user) (.*)',
		config.cmd..'(leave)$',
		config.cmd..'(staff)$',
	},
	onCallbackQuery = {
		'^###cb:userbutton:(remwarns):(%d+)$',
		'^###cb:(recache):'
	}
}

return plugin
