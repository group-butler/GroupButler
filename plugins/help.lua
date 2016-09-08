local function get_helped_string(key)
	if key == 'private' then
		return _([[
Hello *%s* 👋🏼, nice to meet you!
I'm Group Butler, the first administration bot using the official Bot API.

*I can do a lot of cool stuffs*, here's a short list:
• I can *kick or ban* users (even in normal groups) by reply / username
• You can use me to set the group rules and a description
• I have a flexible *anti-flood* system
• I can *welcome new users* with a customizable message, or if you want with a gif or a sticker
• I can *warn* users, and ban them when they reach the maximum number of warnings
• I can also warn, kick or ban users when they post a specific media
…and more, below you can find the "all commands" button to get the whole list!

I work better if you add me to the group administrators (otherwise I won't be able to kick or ban)!
]])
	elseif key == 'all' then
		return _([[
*Commands for all*:
`/dashboard` : see all the group info from private
`/rules` : show the group rules (via pm)
`/about` : show the group description (via pm)
`/adminlist` : show the moderators of the group (via pm)
`/kickme` : get kicked by the bot
`/echo [text]` : the bot will send the text back (with markdown, available only in private for non-admin users)
`/info` : show some useful informations about the bot
`/groups` : show the list of the discussion groups
`/help` : show this message
]])
	elseif key == 'mods_info' then
		return _([[
*Moderators: info about the group*

`/setrules [group rules]` = set the new regulation for the group (the old will be overwritten).
`/setrules -` = delete the current rules.
`/addrules [text]` = add some text at the end of the existing rules.
`/setabout [group description]` = set a new description for the group (the old will be overwritten).
`/setabout -` = delete the current description.
`/addabout [text]` = add some text at the end of the existing description."

*Note*: the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.
For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel
]])
	elseif key == 'mods_banhammer' then
		return _([[
*Moderators: banhammer powers*

`/kick [by reply|username]` = kick a user from the group (he can be added again).
`/ban [by reply|username]` = ban a user from the group (also from normal groups).
`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.
`/unban [by reply|username]` = unban the user from the group.
`/user [by reply|username|text mention|id]` = shows how many times the user has been banned *in all the groups*, and the warns received.
`/status [username|id]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`
]])
	elseif key == 'mods_flood' then
		return _([[
*Moderators: flood settings*

`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.
`/antiflood [number]` = set how many messages a user can write in 5 seconds.
_Note_ : the number must be higher than 3 and lower than 26.
]])
	elseif key == 'mods_media' then
		return _([[
*Moderators: media settings*

`/config` command, then `media` button = receive via private message an inline keyboard to change all the media settings.
`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.
`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).

*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file, link, telegram.me links_
]])
	elseif key == 'mods_welcome' then
		return _([[
*Moderators: welcome settings*

`/menu` = receive in private the menu keyboard. You will find an option to enable/disable welcome and goodbye messages.

*Custom welcome message*:
`/welcome Welcome $name, enjoy the group!`
Write after `/welcome` your welcome message. You can use some placeholders to include the name/username/id of the new member of the group
Placeholders: _$username_ (will be replaced with the username); _$name_ (will be replaced with the name); _$id_ (will be replaced with the id); _$title_ (will be replaced with the group title).

*GIF/sticker as welcome message*
You can use a particular gif/sticker as welcome message. To set it, reply to a gif/sticker with `/welcome`
]])
	elseif key == 'mods_extra' then
		return _([[
*Moderators: extra commands*

`/extra [#trigger] [reply]` = set a reply to be sent when someone writes the trigger.
_Example_ : with "`/extra #hello Good morning!`", the bot will reply "Good morning!" each time someone writes #hello.
You can reply to a media (_photo, file, vocal, video, gif, audio_) with `/extra #yourtrigger` to save the #extra and receive that media each time you use # command
`/extra list` = get the list of your custom commands.
`/extra del [#trigger]` = delete the trigger and its message.

*Note:* the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.
For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel
]])
	elseif key == 'mods_warns' then
		return _([[
*Moderators: warns*

`/warn [by reply]` = warn a user. Once the max number is reached, he will be kicked/banned.
`/warnmax [number]` = set the max number of the warns before the kick/ban.
`/warnmax media [number]` = set the max number of the warns before kick/ban when an unallowed media is sent.

How to see how many warns a user has received (or to reset them): use `/user` command.
How to change the max. number of warnings allowed: `/config` command, then `menu` button.
How to change the max. number of warnings allowed for media: `/config` command, then `media` button.
]])
	elseif key == 'mods_chars' then
		return _([[
*Moderators: special characters*

`/config` command, then `menu` button = you will receive in private the menu keyboard.
Here you will find two particular options: _Arab and RTL_.

*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.
*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of the weird service messages that are written in the opposite sense.
When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.
]])
	elseif key == 'mods_links' then
		return _([[
*Moderators: links*

`/setlink [link|-]` : set the group link, so it can be re-called by other admins, or unset it.
`/link` = get the group link, if already setted by the owner.

*Note*: the bot can recognize valid group links. If a link is not valid, you won't receive a reply.
]])
	elseif key == 'mods_langs' then
		return _([[
*Moderators: group language*"
`/lang` = choose the group language (can be changed in private too).

*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english).

Anyway, translations are open to everyone. If you want to translate the bot, see an [information](https://github.com/RememberTheAir/GroupButler#translators) on GitHub.
]])
	elseif key == 'mods_settings' then
		return _([[
*Moderators: group settings*

`/config` = manage the group settings in private with a comfortable inline keyboard.
The inline keyboard has three sub-menus:

*Menu*: manage the most important group settings
*Antiflood*: turn on or off the antiflood, set its sensitivity and choose some media to ignore, if you want
*Media*: choose which media to forbid in your group, and set the number of times that an user will be warned before being kicked/banned
]])
	else
		assert('bad key')
	end
end

local function make_keyboard(mod, mod_current_position)
	local keyboard = {}
	keyboard.inline_keyboard = {}
	if mod then --extra options for the mod
	    local list = {
	        [_("Banhammer")] = 'banhammer',
	        [_("Group info")] = 'info',
	        [_("Flood manager")] = 'flood',
	        [_("Media settings")] = 'media',
	        [_("Welcome settings")] = 'welcome',
	        [_("General settings")] = 'settings',
	        [_("Extra commands")] = 'extra',
	        [_("Warns")] = 'warns',
	        [_("Characters strictness")] = 'char',
	        [_("Links")] = 'links',
	        [_("Languages")] = 'lang'
        }
        local line = {}
        for k,v in pairs(list) do
            --if mod_current_position ~= v:gsub('!', '') then --(to remove the current tab button)
            if next(line) then
                local button = {text = '📍'..k, callback_data = v}
                --change emoji if it's the current position button
                if mod_current_position == v then button.text = '💡 '..k end
                table.insert(line, button)
                table.insert(keyboard.inline_keyboard, line)
                line = {}
            else
                local button = {text = '📍'..k, callback_data = v}
                --change emoji if it's the current position button
                if mod_current_position == v:gsub('!', '') then button.text = '💡 '..k end
                table.insert(line, button)
            end
            --end --(to remove the current tab button)
        end
        if next(line) then --if the numer of buttons is odd, then add the last button alone
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    local bottom_bar
    if mod then
		bottom_bar = {{text = _("🔰 User commands"), callback_data = 'user'}}
	else
	    bottom_bar = {{text = _("🔰 Admin commands"), callback_data = 'mod'}}
	end
	table.insert(bottom_bar, {text = _("Info"), callback_data = 'fromhelp:info'}) --insert the "Info" button
	table.insert(keyboard.inline_keyboard, bottom_bar)
	return keyboard
end

local function do_keyboard_private()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("👥 Add me to a group"), url = 'https://telegram.me/'..bot.username..'?startgroup=new'},
    		{text = _("📢 Bot channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
	    },
	    {
	        {text = _("📕 All the commands"), callback_data = 'user'}
        }
    }
    return keyboard
end

local function do_keyboard_startme()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("Start me"), url = 'https://telegram.me/'..bot.username}
	    }
    }
    return keyboard
end

local action = function(msg, blocks)
    -- save stats
    if blocks[1] == 'start' then
        if msg.chat.type == 'private' then
            db:hincrby('bot:general', 'users', 1)
            local message = get_helped_string('private'):format(msg.from.first_name:escape())
            local keyboard = do_keyboard_private()
            api.sendKeyboard(msg.from.id, message, keyboard, true)
        end
        return
    end
    if blocks[1] == 'help' then
		local keyboard = make_keyboard()
		local res = api.sendKeyboard(msg.from.id, get_helped_string('all'), keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                if msg.chat.type ~= 'private' then
					api.sendMessage(msg.chat.id, _("_I've sent you the help message in private_"), true)
                end
            else
                api.sendKeyboard(msg.chat.id, _("_Please message me first so I can message you_"), do_keyboard_startme(), true)
            end
        end
    end
    if msg.cb then
        local query = blocks[1]
        local text
        if query == 'info_button' then
            local keyboard = do_keybaord_credits()
		    api.editMessageText(msg.chat.id, msg.message_id, _("Some useful *links*:"), keyboard, true)
		    return
		end
        local with_mods_lines = true
        if query == 'user' then
            text = get_helped_string('all')
            with_mods_lines = false
        elseif query == 'mod' then
            text = _("Tap on a button to see the *related commands*")
        elseif query == 'info' then
        	text = get_helped_string('mods_info')
        elseif query == 'banhammer' then
        	text = get_helped_string('mods_banhammer')
        elseif query == 'flood' then
        	text = get_helped_string('mods_flood')
        elseif query == 'media' then
        	text = get_helped_string('mods_media')
        elseif query == 'welcome' then
        	text = get_helped_string('mods_welcome')
        elseif query == 'extra' then
        	text = get_helped_string('mods_extra')
        elseif query == 'warns' then
        	text = get_helped_string('mods_warns')
        elseif query == 'char' then
        	text = get_helped_string('mods_chars')
        elseif query == 'links' then
        	text = get_helped_string('mods_links')
        elseif query == 'lang' then
        	text = get_helped_string('mods_langs')
        elseif query == 'settings' then
        	text = get_helped_string('mods_settings')
        end
        local keyboard = make_keyboard(with_mods_lines, query)
        local res, code = api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
        if not res and code and code == 111 then
            api.answerCallbackQuery(msg.cb_id, _("❗️ Already on this tab"))
		elseif query == 'info' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: info about the group"))
		elseif query == 'banhammer' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: banhammer powers"))
		elseif query == 'flood' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: flood settings"))
		elseif query == 'media' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: media settings"))
		elseif query == 'links' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: links"))
		elseif query == 'lang' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: group language"))
		elseif query == 'welcome' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: welcome settings"))
		elseif query == 'extra' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: extra commands"))
		elseif query == 'warns' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: warns"))
		elseif query == 'char' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: special characters"))
		elseif query == 'settings' then
			api.answerCallbackQuery(msg.cb_id, _("💡 Moderators: group settings"))
        end
    end
end

return {
	action = action,
	admin_not_needed = true,
	triggers = {
	    config.cmd..'(start)$',
	    config.cmd..'(help)$',
	    '^###cb:(user)$',
	    '^###cb:(mod)$',
	    '^###cb:(info)$',
	    '^###cb:(banhammer)$',
	    '^###cb:(flood)$',
	    '^###cb:(media)$',
	    '^###cb:(links)$',
	    '^###cb:(lang)$',
	    '^###cb:(welcome)$',
	    '^###cb:(extra)$',
	    '^###cb:(warns)$',
	    '^###cb:(char)$',
	    '^###cb:(settings)$',
    }
}
