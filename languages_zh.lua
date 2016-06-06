    zh_cn = {
        status = {
            kicked = '&&&1 在这个群组已被屏蔽',
            left = '&&&1 离开或被移出了群组',
            administrator = '&&&1 是群组管理员',
            creator = '&&&1 是群组创建者',
            unknown = '此用户与本群没有关系',
            member = '&&&1 是本群群员'
        },
        bonus = {
            general_pm = '_我已经将消息私聊给您了_',
            no_user = '我不认识这位用户。\n如果您想告诉我他是谁，请转发一条他的消息给我。',
            the_group = '群组',
            adminlist_admin_required = '我还不是群组管理员。\n*只有群组管理员才能看见管理员名单*',
            settings_header = '当前*群组*的语言设定是:\n\n*简体中文*: `&&&1`\n',
            reply = '通过*回复某人*或写下对方的*用户名*来使用这个指令',
            too_long = '这段文本太长了，我无法发送它。',
            msg_me = '_Message me first so I can message you_',
            tell = '*Group ID*: &&&1'
        },
        pv = '这条指令仅在群组中可以使用',
        not_mod = '你*不是*监督员',
        breaks_markdown = 'This text breaks the markdown.\nMore info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).',
        credits = '*Some useful links:*',
        not_admin = '_I can\'t work if I\'m not Admin of the group. It\'s the only way I have to see if an user is an admin or not :(\nFor more info, check_  [here](https://telegram.me/GroupButler_ch/63)',
        extra = {
            setted = '&&&1 command saved!',
			usage = 'Write next to /extra the title of the command and the text associated.\nFor example:\n/extra #motm stay positive. The bot will reply _\'Stay positive\'_ each time someone writes #motm',
            new_command = '*New command set!*\n&&&1\n&&&2',
            no_commands = 'No commands set!',
            commands_list = 'List of *custom commands*:\n&&&1',
            command_deleted = '&&&1 command have been deleted',
            command_empty = '&&&1 command does not exist'
        },
        help = {
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n"
                            .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                            .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban)\n"
                            .."\n*Note*: you can write something after `/ban` command (or after the username, if you are banning by username)."
                            .." This comment will be used as the motivation of the ban.",
                info = "*Moderators: info about the group*\n\n"
                        .."`/setrules [group rules]` = set the new regulation for the group (the old will be overwritten).\n"
                        .."`/addrules [text]` = add some text at the end of the existing rules.\n"
                        .."`/setabout [group description]` = set a new description for the group (the old will be overwritten).\n"
                        .."`/addabout [text]` = add some text at the end of the existing description.\n"
                        .."\n*Note:* the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.\n"
                        .."For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel",
                flood = "*Moderators: flood settings*\n\n"
                        .."`/flood [on/off]` = turn on/off the anti-flood system.\n"
                        .."`/flood [number]` = set how many messages a user can write in 5 seconds.\n"
                        .."_Note_ : the number must be higher than 3 and lower than 26.\n"
                        .."`/flood [kick/ban]` = choose what the bot should do (kick or ban) when the flood limit is triggered.\n"
                        .."\n*Note:* you can manage flood settings in private from the inline keyboard called with `/menu`.",
                media = "*Moderators: media settings*\n\n"
                        .."`/media` = receive via private message an inline keyboard to change all the media settings.\n"
                        .."`/media [kick|ban|allow] [type]` = change the action to perform when that specific media is sent.\n"
                        .."_Example_ : `/media kick sticker`.\n"
                        .."`/media list` = show the current settings for all the media.\n"
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file, link_\n"
                        .."\n*Note*: the first time a user send a forbidden media, the bot won't kick him. Instead, a warn is sent: the next time, the user will be kicked/banned.",
                welcome = "*Moderators: welcome settings*\n\n"
                            .."`/enable welcome` = the welcome message will be sent when a new user join the group.\n"
                            .."`/disable welcome` = the welcome message won't be sent.\n"
                            .."\n*Custom welcome message:*\n"
                            .."`/welcome Welcome $name, enjoy the group!`\n"
                            .."Write after \"/welcome\" your welcome message. You can use some placeholders to include the name/username/id of the new member of the group\n"
                            .."Placeholders: _$username_ (will be replaced with the username); _$name_ (will be replaced with the name); _$id_ (will be replaced with the id); _$title_ (will be replaced with the group title).\n"
                            .."\n*GIF/sticker as welcome message*\n"
                            .."You can use a particular gif/sticker as welcome message. To set it, reply to a gif/sticker with \'/welcome\'\n"
                            .."\n*Composed welcome message*\n"
                            .."You can compose your welcome message with the rules, the description and the moderators list.\n"
                            .."You can compose it by writing `/welcome` followed by the codes of what the welcome message has to include.\n"
                            .."_Codes_ : *r* = rules; *a* = description (about); *m* = modlist.\n"
                            .."For example, with \"`/welcome rm`\", the welcome message will show rules and moderators list",
                extra = "*Moderators: extra commands*\n\n"
                        .."`/extra [#trigger] [reply]` = set a reply to be sent when someone writes the trigger.\n"
                        .."_Example_ : with \"`/extra #hello Good morning!`\", the bot will reply \"Good morning!\" each time someone writes #hello.\n"
                        .."`/extra list` = get the list of your custom commands.\n"
                        .."`/extra del [#trigger]` = delete the trigger and its message.\n"
                        .."`/disable extra` = only an admin can use #extra commands in a group. For the other users, the bot will reply in private.\n"
                        .."`/enable extra` = everyone use #extra commands in a group, and not only the Admins.\n"
                        .."\n*Note:* the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.\n"
                        .."For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel",
                warns = "*Moderators: warns*\n\n"
                        .."`/warn [kick/ban]` = choose the action to perform once the max number of warnings is reached.\n"
                        .."`/warn [by reply]` = warn a user. Once the max number is reached, he will be kicked/banned.\n"
                        .."`/warnmax` = set the max number of the warns before the kick/ban.\n"
                        .."`/getwarns [by reply]` = see how many times a user have been warned.\n"
                        .."`/nowarns [by reply]` = reset to zero the warns of a user.\n",
                char = "*Moderators: special characters*\n\n"
                        .."`/disable rtl` = everyone with RTL (Righ To Left) character in the name will be kicked. Also, the same is applied to messages.\n"
                        .."`/enable rtl` = the RTL (Righ To Left) character will be ignored.\n"
                        .."`/disable arab` = the bot will kick everyone sends a message that includes arabic characters.\n"
                        .."`/enable arab` = arabic characters will be ignored.\n",
                links = "*Moderators: links*\n\n"
                        ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by other admins, or unset it\n'
                        .."`/link` = get the group link, if already setted by the owner\n"
                        .."`/setpoll [pollbot link]` = save a poll link from @pollbot. Once setted, moderators can retrieve it with `/poll`.\n"
                        .."`/setpoll no` = delete the current poll link.\n"
                        .."`/poll` = get the current poll link, if setted\n"
                        .."\n*Note*: the bot can recognize valid group links/poll links. If a link is not valid, you won't receive a reply.",
                lang = "*Moderators: group language*\n\n"
                        .."`/lang` = see the list of available languages\n"
                        .."`/lang [code]` = change the language of the bot\n"
                        .."\n*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english)."
                        .."\nAnyway, translations are open to everyone. Use `/strings` command to receive a _.lua_ file with all the strings (in english).\n"
                        .."Use `/strings [lang code]` to receive the file for that specific language (example: _/strings es_ ).\n"
                        .."In the file you will find all the instructions: follow them, and as soon as possible your language will be available ;)",
                settings = "*Moderators: group settings*\n\n"
                            .."`/menu` = manage the group settings in private with an handy inline keyboard.\n"
                            .."`/disable [rules|about|modlist|extra]` = this commands will be available *only for moderators* (the bot won't reply to normal users).\n"
                            .."_Example_ : with \"`/disable extra`\", #extra commands will be available only for moderators. The same can be done with _rules, about, modlist_.\n"
                            .."`/enable [rules|about|modlist|extra]` = the commands will be available for everyone (and not only for moderators). Enabled it's the default status.\n"
                            .."`/enable report` = users will be able to send feedback/report messages to moderators, using \"@admin\" command.\n"
                            .."`/disable report` = users won't be able to send feedback/report messages to moderators (default status: disabled).\n"
                            .."`/report [on/off]` (by reply) = the user won't be able (_off_) or will be able (_on_) to use \"@admin\" command.\n",
            },
            all = '*Commands for all*:\n'
                    ..'`/dashboard` : see all the group info from private\n'
                    ..'`/rules` (if unlocked) : show the group rules\n'
                    ..'`/about` (if unlocked) : show the group description\n'
                    ..'`/adminlist` (if unlocked) : show the moderators of the group\n'
                    ..'`@admin` (if unlocked) : by reply= report the message replied to all the admins; no reply (with text)= send a feedback to all the admins\n'
                    ..'`/kickme` : get kicked by the bot\n'
                    ..'`/faq` : some useful answers to frequent quetions\n'
                    ..'`/id` : get the chat id, or the user id if by reply\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown, available only in private for non-admin users)\n'
                    ..'`/info` : show some useful informations about the bot\n'
                    ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
                    ..'`/help` : show this message.'
		            ..'\n\nIf you like this bot, please leave the vote you think it deserves [here](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'I\'m a simple bot created in order to help people to manage their groups.\n'
                    ..'\n*What can I do for you?*\n'
                    ..'Wew, I have a lot of useful tools!\n'
                    ..'• You can *kick or ban* users (even in normal groups) by reply/username\n'
                    ..'• Set rules and a description\n'
                    ..'• Turn on a configurable *anti-flood* system\n'
                    ..'• Customize the *welcome message*, also with gif and stickers\n'
                    ..'• Warn users, and kick/ban them if they reach a max number of warns\n'
                    ..'• Warn or kick users if they send a specific media\n'
                    ..'...and more, below you can find the "all commands" button to get the whole list!\n'
                    ..'\nTo use me, *you need to add me as administrator of the group*, or Telegram won\'t let me work! (if you have some doubts about this, check [this post](https://telegram.me/GroupButler_ch/63))'
                    ..'\nYou can report bugs/send feedbacks/ask a question to my creator just using "`/c <feedback>`" command. EVERYTHING IS WELCOME!',
            group_success = '_I\'ve sent you the help message in private_',
            group_not_success = '_Please message me first so I can message you_',
            initial = 'Choose the *role* to see the available commands:',
            kb_header = 'Tap on a button to see the *related commands*'
        },
        links = {
            no_link = '*No link* for this group. Ask the owner to generate one',
            link = '[&&&1](&&&2)',
            link_no_input = 'This is not a *public supergroup*, so you need to write the link near /setlink',
            link_invalid = 'This link is *not valid!*',
            link_updated = 'The link has been updated.\n*Here\'s the new link*: [&&&1](&&&2)',
            link_setted = 'The link has been setted.\n*Here\'s the link*: [&&&1](&&&2)',
            link_unsetted = 'Link *unsetted*',
            poll_unsetted = 'Poll *unsetted*',
            poll_updated = 'The poll have been updated.\n*Vote here*: [&&&1](&&&2)',
            poll_setted = 'The link have been setted.\n*Vote here*: [&&&1](&&&2)',
            no_poll = '*No active polls* for this group',
            poll = '*Vote here*: [&&&1](&&&2)'
        },
        mod = {
            not_owner = 'You are *not* the owner of this group.',
            reply_promote = 'Reply to someone to promote him',
            reply_demote = 'Reply to someone to demote him',
            reply_owner = 'Reply to someone to set him as owner',
            already_mod = '&&&1 is _already_ a moderator of *&&&2*',
            already_owner = 'You are _already the owner_ of this group',
            not_mod = '&&&1 is _not_ a moderator of *&&&2*',
            promoted = '&&&1 has been _promoted_ as moderator of *&&&2*',
            demoted = '&&&1 has been _demoted_',
            new_owner = '&&&1 is the _new owner_ of *&&&2*',
            modlist = '*Creator*:\n&&&1\n\n*Admins*:\n&&&2'
        },
        report = {
            no_input = 'Write your suggestions/bugs/doubt near "/c"',
            sent = 'Feedback sent!',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
        },
        service = {
            new_group = 'Hi all!\n*&&&1* added me here to help you to manage this group.\nIf you want to know how I work, please start me in private or type /help  :)',
            welcome = 'Hi &&&1, and welcome to *&&&2*!',
            welcome_rls = 'Total anarchy!',
            welcome_abt = 'No description for this group.',
            welcome_modlist = '\n\n*Creator*:\n&&&1\n*Admins*:\n&&&2',
            abt = '\n\n*Description*:\n',
            rls = '\n\n*Rules*:\n',
        },
        setabout = {
            no_bio = '*No description* for this group.',
            no_bio_add = '*No description for this group*.\nUse /setabout [bio] to set-up a new description',
            no_input_add = 'Please write something next this poor "/addabout"',
            added = '*Description added:*\n"&&&1"',
            no_input_set = 'Please write something next this poor "/setabout"',
            clean = 'The bio has been cleaned.',
            new = '*New bio:*\n"&&&1"',
            about_setted = 'New description *saved successfully*!'
        },
        setrules = {
            no_rules = '*Total anarchy*!',
            no_rules_add = '*No rules* for this group.\nUse /setrules [rules] to set-up a new constitution',
            no_input_add = 'Please write something next this poor "/addrules"',
            added = '*Rules added:*\n"&&&1"',
            no_input_set = 'Please write something next this poor "/setrules"',
            clean = 'Rules has been wiped.',
            new = '*New rules:*\n"&&&1"',
            rules_setted = 'New rules *saved successfully*!'
        },
        settings = {
            disable = {
                no_input = 'Disable what?',
                rules_already = '`/rules` command is already *locked*',
                rules_locked = '`/rules` command is now available *only for moderators*',
                about_already = '`/about` command is already *locked*',
                about_locked = '`/about` command is now available *only for moderators*',
                welcome_already = 'Welcome message is already *locked*',
                welcome_locked = 'Welcome message *won\'t be displayed* from now',
                modlist_already = '`/adminlist` command is already *locked*',
                modlist_locked = '`/adminlist` command is now available *only for moderators*',
                flag_already = '`/flag` command is already *not enabled*',
                flag_locked = '`/flag` command *won\'t be available* from now',
                extra_already = '#extra commands are already *locked*',
                extra_locked = '#extra commands are now available *only for moderators*',
                rtl_already = 'Anti-RTL is already *on*',
                rtl_locked = 'Anti-RTL is now *on*',
                flood_already = 'Anti-flood is already *on*',
                flood_locked = 'Anti-flood is now *on*',
                arab_already = 'Anti-arab characters is already *on*',
                arab_locked = 'Anti-arab characters is now *on*',
                report_already = '@admin command is already *not enabled*',
                report_locked = '@admin command *won\'t be available* from now',
                wrong_input = 'Argument unavailable.\nUse `/disable [rules|about|welcome|modlist|report|extra|rtl|arab]` instead',
            },
            enable = {
                no_input = 'Enable what?',
                rules_already = '`/rules` command is already *unlocked*',
                rules_unlocked = '`/rules` command is now available *for all*',
                about_already = '`/about` command is already *unlocked*',
                about_unlocked = '`/about` command is now available *for all*',
                welcome_already = 'Welcome message is already *unlocked*',
                welcome_unlocked = 'Welcome message from now will be displayed',
                modlist_already = '`/adminlist` command is already *unlocked*',
                modlist_unlocked = '`/adminlist` command is now available *for all*',
                flag_already = '`/flag` command is already *available*',
                flag_unlocked = '`/flag` command is now *available*',
                extra_already = 'Extra # commands are already *unlocked*',
                extra_unlocked = 'Extra # commands are now available *for all*',
                rtl_already = 'Anti-RTL is already *off*',
                rtl_unlocked = 'Anti-RTL is now *off*',
                flood_already = 'Anti-flood is already *off*',
                flood_unlocked = 'Anti-flood is now *off*',
                arab_already = 'Anti-arab characters is already *off*',
                arab_unlocked = 'Anti-arab characters is now *off*',
                report_already = '@admin command is already *available*',
                report_unlocked = '@admin command is now *available*',
                wrong_input = 'Argument unavailable.\nUse `/enable [rules|about|welcome|modlist|report|extra|rtl|arab]` instead'
            },
            welcome = {
                no_input = 'Welcome and...?',
                media_setted = 'New media setted as welcome message: ',
                reply_media = 'Reply to a `sticker` or a `gif` to set them as *welcome message*',
                a = 'New settings for the welcome message:\nRules\n*About*\nModerators list',
                r = 'New settings for the welcome message:\n*Rules*\nAbout\nModerators list',
                m = 'New settings for the welcome message:\nRules\nAbout\n*Moderators list*',
                ra = 'New settings for the welcome message:\n*Rules*\n*About*\nModerators list',
                rm = 'New settings for the welcome message:\n*Rules*\nAbout\n*Moderators list*',
                am = 'New settings for the welcome message:\nRules\n*About*\n*Moderators list*',
                ram = 'New settings for the welcome message:\n*Rules*\n*About*\n*Moderators list*',
                no = 'New settings for the welcome message:\nRules\nAbout\nModerators list',
                wrong_input = 'Argument unavailable.\nUse _/welcome [no|r|a|ra|ar]_ instead',
                custom = '*Custom welcome message* setted!\n\n&&&1',
                custom_setted = '*Custom welcome message saved!*',
                wrong_markdown = '_Not setted_ : I can\'t send you back this message, probably the markdown is *wrong*.\nPlease check the text sent',
            },
            resume = {
                header = 'Current settings for *&&&1*:\n\n*Language*: `&&&2`\n',
                w_a = '*Welcome type*: `welcome + about`\n',
                w_r = '*Welcome type*: `welcome + rules`\n',
                w_m = '*Welcome type*: `welcome + modlist`\n',
                w_ra = '*Welcome type*: `welcome + rules + about`\n',
                w_rm = '*Welcome type*: `welcome + rules + modlist`\n',
                w_am = '*Welcome type*: `welcome + about + modlist`\n',
                w_ram = '*Welcome type*: `welcome + rules + about + modlist`\n',
                w_no = '*Welcome type*: `welcome only`\n',
                w_media = '*Welcome type*: `gif/sticker`\n',
                w_custom = '*Welcome type*: `custom message`\n',
                flood_info = '_Flood sensitivity:_ *&&&1* (_action:_ *&&&2*)\n'
            },
            broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            Rules = 'Rules',
            About = 'About',
            Welcome = 'Welcome message',
            Modlist = 'Modlist',
            Flag = 'Flag',
            Extra = 'Extra',
            Flood = 'Flood',
            Rtl = 'Rtl',
            Arab = 'Arab',
            Report = 'Report',
        },
        warn = {
            warn_reply = 'Reply to a message to warn the user',
            changed_type = 'New action on max number of warns received: *&&&1*',
            mod = 'A moderator can\'t be warned',
            warned_max_kick = 'User &&&1 *kicked*: reached the max number of warnings',
            warned_max_ban = 'User &&&1 *banned*: reached the max number of warnings',
            warned = '*User* &&&1 *have been warned.*\n_Number of warnings_   *&&&2*\n_Max allowed_   *&&&3* (*-&&&4*)',
            warnmax = 'Max number of warnings changed.\n*Old* value: &&&1\n*New* max: &&&2',
            getwarns_reply = 'Reply to a user to check his numebr of warns',
            limit_reached = 'This user has already reached the max number of warnings (*&&&1/&&&2*)',
            limit_lower = 'This user is under the max number of warnings.\n*&&&1* warnings missing on a total of *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Reply to a user to delete his warns',
            ban_motivation = 'Too many warnings',
            nowarn = 'The number of warns received by this user have been *resetted*'
        },
        setlang = {
            list = '*List of available languages:*\n\n&&&1\nUse `/lang xx` to change you language',
            error = 'The language setted is *not supported*. Use `/lang` to see the list of the available languages',
            success = '*New language setted:* &&&1'
        },
		banhammer = {
            kicked = '&&&1 have been kicked! (but is still able to join)',
            banned = '&&&1 have been banned!',
            already_banned_normal = '&&&1 is *already banned*!',
            unbanned = 'User unbanned!',
            reply = 'Reply to someone',
            globally_banned = '&&&1 have been globally banned!',
            not_banned = 'The user is not banned',
            banlist_header = '*Banned users*:\n\n',
            banlist_empty = '_The list is empty_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` is not a valid value!\nThe value should be *higher* than `3` and *lower* then `26`',
            not_changed = 'The max number of messages that can be sent in 5 seconds is already &&&1',
            changed_plug = 'The *max number* of messages that can be sent in *5 seconds* changed _from_  &&&1 _to_  &&&2',
            enabled = 'Antiflood enabled',
            disabled = 'Antiflood disabled',
            kick = 'Now flooders will be kicked',
            ban = 'Now flooders will be banned',
            changed_cross = '&&&1 -> &&&2',
        },
        mediasettings = {
			warn = 'This kind of media are *not allowed* in this group.\n_The next time_ you will be kicked or banned',
            list_header = '*Here the list of the media you can block*:\n\n',
            settings_header = '*Current settings for media*:\n\n',
            already = 'The status for the media (`&&&1`) is already (`&&&2`)',
            changed = 'New status for (`&&&1`) = *&&&2*',
            wrong_input = 'Wrong input. Use `/media list` to see the available media',
        },
        preprocess = {
            flood_ban = '&&&1 *banned* for flood!',
            flood_kick = '&&&1 *kicked* for flood!',
            media_kick = '&&&1 *kicked*: media sent not allowed!',
            media_ban = '&&&1 *banned*: media sent not allowed!',
            rtl = '&&&1 *kicked*: rtl character in names/messages not allowed!',
            arab = '&&&1 *kicked*: arab message detected!',
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
            first_warn = 'This type of media is *not allowed* in this chat. The next time, *&&&1*!'
        },
        kick_errors = {
            [1] = 'I\'m not an admin, I can\'t kick people',
            [2] = 'I can\'t kick or ban an admin',
            [3] = 'There is no need to unban in a normal group',
            [4] = 'This user is not a chat member',
        },
        flag = {
            no_input = 'Reply to a message to report it to an admin, or write something next \'@admin\' to send a feedback to them',
            reported = 'Reported!',
            no_reply = 'Reply to a user!',
            blocked = 'The user from now can\'t use \'@admin\'',
            already_blocked = 'The user is already unable to use \'@admin\'',
            unblocked = 'The user now can use \'@admin\'',
            already_unblocked = 'The user is already able to use \'@admin\'',
        },
        all = {
            dashboard = 'I\'ve sent you the group dashboard in private',
            menu = 'I\'ve sent you the settings menu in private',
            dashboard_first = 'Navigate this message to see *all the info* about this group!',
            menu_first = 'Tap on a lock to *change the group settings*, or use the last row to _manage the anti-flood behaviour_',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
