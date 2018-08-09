local config = require "groupbutler.config"
local u = require "groupbutler.utilities"
local api = require "groupbutler.methods"
local db = require "groupbutler.database"
local locale = require "groupbutler.languages"
local i18n = locale.translate

local plugin = {}

local function get_helped_string(key)
	if key == 'start' then
		return i18n([[Hello %s 👋🏼, nice to meet you!
I'm Group Butler, the first administration bot using the official Bot API.

*I can do a lot of cool stuffs*, here's a short list:
• I can *kick or ban* users
• You can use me to set the group rules
• I have a flexible *anti-flood* system
• I can *welcome new users* with a customizable message, or if you want with a gif or a sticker
• I can *warn* users, and ban them when they reach the maximum number of warnings
• I can also warn, kick or ban users when they post a specific media
…and more, below you can find the "all commands" button to get the whole list!

I work better if you add me to the group administrators (otherwise I won't be able to kick or ban)!
]])
	elseif key == 'basics' then
		return i18n([[This bot works only in supergroups.

To work properly, [it needs to be admin in your group](https://telegram.me/GroupButler_ch/104), so it can kick or ban people if needed.
Only the group owner can promote it :)

You can use `/, ! or #` to trigger a command.

Group Butler saves the adminlist of a group in its databse to avoid to send too many requests to Telegram.
This list is updated every 5 hours, so there could be some differences between who the bot thinks are the admins and who the admins actually are, if during the 5 hours timeframe some users have been promoted/demoted.
It's possible to force the bot to update its adminlist with `/cache`.

Remember: you have to use commands  *in the group*, unless they are specifically designed for private chats (see "private" tab).
]])
	elseif key == 'main_menu' then
		return i18n("In this menu you will find all the available commands")
	elseif key == 'private' then
		return i18n([[*Commands that work in private*:

• `/mysettings`: show a keyboard that allows you to change your personal settings, such as choosing if receive the rules in private when you join a group or if receive reports made with the `@admin` command
• `/echo [text]` : the bot will send the text back, formatted with markdown
• `/about` : show some useful informations about the bot
• `/groups` : show the list of the discussion groups
• `/id`: get your id
• `/start` : show the initial message
• `/help` : show this message
]])
	elseif key == 'users_group' then
		return i18n([[*Commands available for every user in a group*:

• `/dashboard`: see all the informations about the group
• `/rules`: show the group rules
• `/adminlist`: show the administrators of the group
• `/help`: receive the help message
• `!kickme`: the bot will kick you
*Note*: `/dashboard`, `/adminlist` and `/staff` always reply in private. If the bot is unable to reach an user, it will ask in the group to that user to be started, but just if _silent mode_ is off.
With `/rules`, the bot always answer in the group for admins, but with normal users the message is sent in the group or in private according to the group settings.

• `@admin` (by reply): report a message to the admins of the group (the bot will forward it in prvate). This ability could be turned off from the group settings. A description of the report can be added.
Admins need to give their consense to receive reports from users, with `/mysettings` command
]])
	elseif key == 'info' then
		return i18n([[*Admins: info about the group*

• `/setrules [group rules]`: set the new regulation for the group (the old will be overwritten).
• `/setrules -`: delete the current rules.

*Note*: the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.
For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel

• `/setlink [link|-]`: set the group link, so it can be re-called by other admins, or unset it.
If you are going to use it in a public supergroup, you do not need to append the group link. Just send `/setlink`
• `/link`: get the group link, if already set.
• `/msglink`: get the link to a message. Works only in public supergroups

*Note*: the bot can recognize valid group links. If a link is not valid, you won't receive a reply.
]])
	elseif key == 'banhammer' then
		return i18n([[*Banhammer powers*
A set of commands that let admins kick and ban people from a group, and get some information about an user.
Kicked people can join back, banned people can't. Banned users are added to the group's blacklist. It's possible to blacklist users even if they are not part of the group.
Only the administrators who have the permission to restrict users can use these commands, but `/status` can be used by all the admins.

• `/kick [by reply|username|id|text mention]`: kick a user from the group.
• `/ban [by reply|username|id|text mention]`: ban a user from the group.
• `/tempban [by reply|username|id|text mention]`: ban an user for a specific amount of time. Use the returned keyboard to ban the user.
Pass a value on a new line to use it as starting value. When a ban expires, the user won't be added back. Check the Telegram's restricted users list for pending unbans.
• `/fwdban [by reply]`: ban the original sender of a forwarded message.
• `/unban [by reply|username|id|text mention]`: unban the user from the group.
• `/user [by reply|username|id|text mention]`: shows how many times the user has been banned *in all the groups*, and the warns received.
• `/status [username|id]`: show the current status of the user `(member|restricted|kicked/left the chat|banned|admin/creator|never seen)`.
Will also show the permissions the user *doesn't* have.

*Antiflood*
The "antiflood" is a system that auto-removes people that send many consecutive messages in a group.
If on, the antiflood system will kick/ban flooders.

• `/config` command, then `antiflood` button: manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban) to perform, and even set some exceptions.
]])
	elseif key == 'report' then
		return i18n([[*Reports settings*
`@admin` is an useful command to let users report some messages to the group admins.
A reported message will be forwarded to the available admins.

• `/config` command, then `menu` button: here you can find an option, "Report". If turned on, users will be able to use the `@admin` command.
Only admins who accepted to receive reports (with `/mysettings` command) will be notified
• `/mysettings` (in private): from here, you can choose if receive reports or not

*Note*: admins can't use the `@admin` command, and users can't report admins with it.]])
	elseif key == 'welcome' then
		return i18n([[*Welcome/goodbye settings*

• `/config`, then `menu` tab: receive in private the menu keyboard. You will find an option to enable/disable welcome/goodbye messages.
*Note*: goodbye messages don't work in large groups. This is a Telegram limitation that can't be avoided.

*Custom welcome message*:
• `/welcome Welcome $name, enjoy the group!`
Write after `/welcome` your welcome message. `/goodbye` works in the same way.

You can use some placeholders to include the name/username/id of the new member of the group
Placeholders:
`$username`: _will be replaced with the username_
`$name`: _will be replaced with the name_
`$id`: _will be replaced with the id_
`$title`: _will be replaced with the group title_
`$surname`: _will be replaced by the user's last name_
`$rules`: _will be replaced by a link to the rules of the group. Please read_ [here](https://telegram.me/GroupButler_beta/26) _how to use it, or you will get an error for sure_
*Note*: `$name`, `$surname`, and `$title` may not work properly within markdown markup.

*GIF/sticker as welcome message*
You can use a particular gif/sticker as welcome message. To set it, reply to the gif/sticker you want to set as welcome message with `/welcome`. Same goes for `/goodbye`
]])
	elseif key == 'whitelist' then
		return i18n([[*Whitelist settings*

As you may know, the bot can warn/kick/ban who sends a telegram.me link (antispam settings) or any other link (media settings).
The whitelist is a list of links that will be ignored by the bot.
If users send a whitelisted link, they won't be warned or kicked.

`/whitelist [link(s)]` or `/wl [link(s)]`: add one or more links to the whitelist.
`/unwhitelist [link(s)]` or `/unwl [link(s)]`: remove one or more links from the whitelist.
`/whitelist` or `/wl`: get the whitelist.
`/whitelistl -` or `/wl -`: empty the whitelist.

When the group link is saved with `/setlink`, it gets automatically added to the whitelist.

*Why links are saved without* _https://_ *and* _www_*?*
The bot auto-removes _https://, http:// and www_ from every link to reduce the possibility of having the same link saved twice.
]])
	elseif key == 'extra' then
		return i18n([[*Extra commands*
#extra commands are a smart way to save your own custom commands.

• `/extra [#trigger] [reply]`: set a reply to be sent when someone writes the trigger.
_Example_ : with "`/extra #hello Good morning!`", the bot will reply "Good morning!" each time someone writes #hello.
You can reply to a media (_photo, file, vocal, video, gif, audio_) with `/extra #yourtrigger` to save the #extra and receive that media each time you use # command
• `/extra list`: get the list of your custom commands.
• `/extra del [#trigger]`: delete the trigger and its message.

*Note:* the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.
For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel.
Now supports placeholders. Check the "welcome" tab for the list of the available placeholders
]])
	elseif key == 'warns' then
		return i18n([[*Warns*
Warn are made to keep the count of the admonitions received by an user. Once users have been warned for the defined number of times, they are kicked/banned by the bot.
There are two different type of warns:
- _normal warns_, given by an admin with the `/warn` command
- _automatic warns_ (read: media warns and spam warns), given by the bot when someone sends a media that is not allowed in the chat, or spams other channels or telegram.me links.

• `/warn [by reply]`: warn a user
• `/sw`: you can place a `/sw` (_"silent warn"_) everywhere you want in your message. The bot will silently count the warn, but won't answer in the group unless the user reached the max. number of warnings.
• `/nowarns [by reply]`: reset the warns received by an user (both normal and automatic warns).
• `/warnmax [number]`: set the max number of the warns before the kick/ban.
• `/warnmax media [number]`: set the max number of the warns before kick/ban when an unallowed media is sent.

How to see how many warns a user has received (or to reset them): `/user` command.
How to change the max. number of warnings allowed: `/config` command, then `menu` button.
How to change the max. number of warnings allowed for medias: `/config` command, then `media` button.
How to change the max. number of warnings allowed for spam: `/config` command, then `antispam` button.
]])
	elseif key == 'pin' then
		return i18n([[*Pinning messages*
The "48 hours limit" to edit your own messages doesn't apply to bots.
This command was born from the necessity of editing the pinned message without sending it again, maybe just to change few things.
So with `/pin` you can generate a message to pin, and edit it how many times you want.

• `/pin [text]`: the bot will send you back the text you used as argument, with markdown. You can pin the message and use `/pin [text]` again to edit it
• `/pin`: the bot will find the latest message generate by `/pin`, if it still exists
• `/newpin [text]`: forces the bot to send another message that will be saved as new target for `/pin`

*Note*: `/pin` supports markdown, but only `$rules` and `$title` placeholders
]])
	elseif key == 'lang' then
		return i18n([[*Group language*
• `/lang`: change the bot language (works on groups and private chats)

*Note*: the translators are volunteers, so neither the correctness nor completeness of localizations can be guaranteed.

You can help improve translations on our [Crowdin Project](https://crowdin.com/project/group-butler).

*Special characters*

• `/config` command, then `menu` button: you will receive in private the menu keyboard.
Here you will find two particular options: _Arab and RTL_.

*Arab*: when Arab is not allowed (🚫), people who write Arab characters will be kicked from the group.
*Rtl*: stands for 'Right To Left' character, is the cause of weird service messages written in the opposite direction.
When Rtl is not allowed (🚫), people who write Rtl characters (or have it in their names) will be kicked.
]])
	elseif key == 'config' then
		return i18n([[*General group settings*

`/config` or  `/settings`: manage the group settings in private from an inline keyboard.
The inline keyboard has six sub-menus:

*Menu*: manage the most important group settings
*Antiflood*: turn on or off the antiflood, set its sensitivity and choose some media to ignore, if you want
*Media*: choose which media to forbid in your group, and set the number of times that an user will be warned before being kicked/banned
*Antispam*: choose which kind of spam you want to forbid (example: telegram.me links, forwarded messages from channels)
*Log channel*: choose which updates should be logged

*Bonus commands*:
`/reportflood [number of messages]/[timeframe]`: set how many times users can use the @admin command within a certain timeframe.
`/leave`: the bot will leave the group without deleting its data. Use this command only if you are going to add the bot to the group again
`/snap`: generate a backup file that can be restored with `/import` (send the file in the group and reply to it). `/snap` can be used once every three days
]])
	elseif key == 'logchannel' then
		return i18n([[*Log channel informations*

A log channel is a _(private)_ channel where the bot will record all the important events that will happen in your group.
If you want to use this feature, you need to pair your group with a channel with the commands described below.
All the events, by default, are *not logged*. Admins can choose which events to log from the `/config` menu -> `log channel` button.

To pair a channel with a group, the *channel creator* must [add the bot to the channel administrators](telegram.me/gb_tutorials/4) (otherwise it won't be able to post), and send in the channel this command:
`/setlog`
Then, an admin of the group must forward in the group the message ("`/setlog`") sent in the channel. *Done*!
(you can find a video-tutorial [here](https://telegram.me/GB_tutorials/8))

A channel can be used as log by different groups.
To change your log channel, simply repeat this process with another channel.

`/unsetlog`: remove your current log channel
`/logchannel`: get some informations about your log channel, if paired]])
	end
end

local function dk_admins()
	local keyboard = {}
	keyboard.inline_keyboard = {}
	local list = {
		{
			[i18n("Banhammer")] = 'banhammer',
			[i18n("Group info")] = 'info'
		},
		{
			[i18n("Report system")] = 'report',
			[i18n("Pin")] = 'pin'
		},
		{
			[i18n("Languages")] = 'lang',
			[i18n("Group configuration")] = 'config'
		},
		{
			[i18n("Extra commands")] = 'extra',
			[i18n("Warns")] = 'warns'
		},
		{
			[i18n("Welcome settings")] = 'welcome',
			[i18n("Links whitelist")] = 'whitelist',
		}

	}
	for _, line in pairs(list) do
		local kb_line = {}
		for label, cb_data in pairs(line) do
			table.insert(kb_line, {text = '× '..label, callback_data = 'help:admins:'..cb_data})
		end
		table.insert(keyboard.inline_keyboard, kb_line)
	end

	return keyboard
end

local function do_keyboard_private()
	local keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = i18n("📢 Bot channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
			{text = i18n("🌍 Select your language"), callback_data = 'selectlang'},
		},
		{
			{text = i18n("📕 All the commands"), callback_data = 'help:back'}
		}
	}
	return keyboard
end

local function dk_main()
	local keyboard = {inline_keyboard={}}
	keyboard.inline_keyboard = {
		{{text = i18n('Basics'), callback_data = 'help:basics'}},
		{{text = i18n('Admin commands'), callback_data = 'help:admins:banhammer'}},
		{{text = i18n('Normal users commands'), callback_data = 'help:users'}},
		{{text = i18n('Commands in private'), callback_data = 'help:private'}},
		{{text = i18n('Log channel'), callback_data = 'help:logchannel'}},
	}

	return keyboard
end

local function do_keyboard(keyboard_type)
	local callbacks = {
		['main'] = dk_main(),
		['admins'] = dk_admins()
	}

	local keyboard = callbacks[keyboard_type] or {inline_keyboard = {}}

	if keyboard_type ~= 'main' then
		table.insert(keyboard.inline_keyboard, {{text = i18n('Back'), callback_data = 'help:back'}})
	end

	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'start' then
		if msg.chat.type == 'private' then
			local message = get_helped_string('start'):format(msg.from.first_name:escape())
			local keyboard = do_keyboard_private()
			api.sendMessage(msg.from.id, message, true, keyboard)
		end
	end
	if blocks[1] == 'help' then
		local text = get_helped_string(blocks[2] or 'main_menu')
		if blocks[2] then
			api.sendMessage(msg.from.id, text, true)
		else
			local keyboard = do_keyboard('main')
			local res = api.sendMessage(msg.from.id, text, true, keyboard)
			if not res and msg.chat.type ~= 'private' and db:hget('chat:'..msg.chat.id..':settings', 'Silent') ~= 'on' then
				api.sendMessage(msg.chat.id,
					i18n('[Start me](%s) _to get the list of commands_'):format(u.deeplink_constructor('', 'help')), true)
			end
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	local query = blocks[1]
	local text, keyboard_type, answerCallbackQuery_text

	if query == 'back' then
		keyboard_type = 'main'
		text = get_helped_string('main_menu')
		answerCallbackQuery_text = i18n('Main menu')
	elseif query == 'basics' then
		text = get_helped_string('basics')
		answerCallbackQuery_text = i18n('Basic usage')
	elseif query == 'users' then
		text = get_helped_string('users_group')
		answerCallbackQuery_text = i18n('Commands for users (group)')
	elseif query == 'private' then
		text = get_helped_string('private')
		answerCallbackQuery_text = i18n('Available commands in private')
	elseif query == 'logchannel' then
		text = get_helped_string('logchannel')
		answerCallbackQuery_text = i18n('Log channel informations')
	else --query == 'admins'
		keyboard_type = 'admins'
		text = get_helped_string(blocks[2])
		answerCallbackQuery_text = i18n('Available commands for admins')
	end

	if not text then
		api.answerCallbackQuery(msg.cb_id, i18n("Deprecated message, send /help again"), true)
	else
		local keyboard = do_keyboard(keyboard_type)
		local res, code = api.editMessageText(msg.chat.id, msg.message_id, text, true, keyboard)
		if not res and code and code == 111 then
			api.answerCallbackQuery(msg.cb_id, i18n("❗️ Already there"))
		else
			api.answerCallbackQuery(msg.cb_id, answerCallbackQuery_text)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(start)$',
		config.cmd..'(help)$',
		'^/start :(help)$',
		'^/start (help):([%w_]+)$',
	},
	onCallbackQuery = {
		'^###cb:help:(admins):(%a+)$',
		'^###cb:help:(.*)$'
	}
}

return plugin
