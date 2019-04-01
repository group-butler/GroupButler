local config = require "groupbutler.config"
local User = require("groupbutler.user")
local Chat = require("groupbutler.chat")
local Util = require("groupbutler.util")

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
	local db = self.db
	local i18n = self.i18n
	local u = self.u

	if blocks[1] == 'id' then --in private: send user id
		if msg.from.chat.id > 0 and msg.from.chat.type == 'private' then
			api:sendMessage(msg.from.chat.id, string.format(i18n('Your ID is `%d`'), msg.from.user.id), "Markdown")
		end
	end

	if msg.from.chat.type == 'private' then return end

	if blocks[1] == 'id' then --in groups: send chat ID
		if msg.from.chat.id < 0 and msg.from:isAdmin() then
			api:sendMessage(msg.from.chat.id, string.format('`%d`', msg.from.chat.id), "Markdown")
		end
	end

	if blocks[1] == 'adminlist' then
		local adminlist = u:getAdminlist(msg.from.chat)
		if not msg.from:isAdmin() then
			api:sendMessage(msg.from.user.id, adminlist, 'html', true)
		else
			msg:send_reply(adminlist, 'html', true)
		end
	end

	if blocks[1] == 'status' then
		if (not blocks[2] and not msg.reply) or not msg.from:isAdmin() then
			return
		end

		local member, err = msg:getTargetMember(blocks)
		if not member then
			msg:send_reply(err, "Markdown")
			return
		end

		local statuses = {
			kicked = i18n("%s is banned from this group"),
			left = i18n("%s left the group or has been kicked and unbanned"),
			administrator = i18n("%s is an admin"),
			creator = i18n("%s is the group creator"),
			unknown = i18n("%s has nothing to do with this chat"),
			member = i18n("%s is a chat member"),
			restricted = i18n("%s is a restricted")
		} Util.setDefaultTableValue(statuses, statuses.unknown)

		local denied_permissions = {}
		for permission, str in pairs(permissions(self)) do
			if member[permission] ~= nil and member[permission] == false then
				table.insert(denied_permissions, str)
			end
		end

		local text = statuses[member.status]:format(member.user:getLink())
		if next(denied_permissions) then
			text = text..i18n('\nRestrictions: <i>%s</i>'):format(table.concat(denied_permissions, ', '))
		end

		msg:send_reply(text, 'html')
	end

	if blocks[1] == 'user' then
		if not msg.from:isAdmin() then return end
		if not msg.reply
			and (not blocks[2] or (not blocks[2]:match('@[%w_]+$') and not blocks[2]:match('%d+$')
			and not msg.mention_id)) then
			msg:send_reply(i18n("Reply to a user or mention them by username or numerical ID"))
			return
		end

		local member, err = msg:getTargetMember(blocks)
		if not member then
			msg:send_reply(err, "Markdown")
			return
		end

		local keyboard = do_keyboard_userinfo(self, member.user.id)

		local text = get_userinfo(self, member.user.id, msg.from.chat.id)
		api:sendMessage(msg.from.chat.id, text, "Markdown", nil, nil, nil, keyboard)
	end

	if blocks[1] == 'cache' then
		if not msg.from:isAdmin() then return end
		local text = i18n("👥 Admins cached: <code>%d</code>"):format(db:getChatAdministratorsCount(msg.from.chat))
		local keyboard = do_keyboard_cache(self, msg.from.chat.id)
		api:sendMessage(msg.from.chat.id, text, "html", nil, nil, nil, keyboard)
	end

	if blocks[1] == 'msglink' then
		if not msg.reply or not msg.from.chat.username then return end
		local text = string.format('[%s](https://telegram.me/%s/%d)',
			i18n("Message N° %d"):format(msg.reply.message_id), msg.from.chat.username, msg.reply.message_id)
		if not u:is_silentmode_on(msg.from.chat.id) or msg.from:isAdmin() then
			msg.reply:send_reply(text, "Markdown")
		else
			api:sendMessage(msg.from.user.id, text, "Markdown")
		end
	end

	if blocks[1] == 'leave' and msg.from:isAdmin() then
		-- u:remGroup(msg.from.chat.id)
		api:leaveChat(msg.from.chat.id)
	end
end

function _M:onCallbackQuery(blocks)
	local api = self.api
	local msg = self.message
	local db = self.db
	local i18n = self.i18n
	local u = self.u

	if not msg.from:isAdmin() then
		api:answerCallbackQuery(msg.cb_id, i18n("You are not allowed to use this button"))
		return
	end

	if blocks[1] == 'remwarns' then
		db:forgetUserWarns(msg.from.chat.id, blocks[2])
		local admin = msg.from.user
		local target = User:new({id = blocks[2]}, self)
		local text = i18n("The number of warnings received by this user has been <b>reset</b>, by %s"):format(admin:getLink())
		api:editMessageText(msg.from.chat.id, msg.message_id, nil, text, "html")
		u:logEvent("nowarn", msg, {
			admin = admin,
			user = target,
			user_id = blocks[2]
		})
	end

	if blocks[1] == 'recache' and msg.from:isAdmin() then
		u:cache_adminlist(Chat:new({id=msg.target_id}, self))
		api:answerCallbackQuery(msg.cb_id, i18n("✅ The admin list will be updated soon"))
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
