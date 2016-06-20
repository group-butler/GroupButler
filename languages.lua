return {
    en = {
        status = {
            kicked = '&&&1 is banned from this group',
            left = '&&&1 left the group or has been kicked and unbanned',
            administrator = '&&&1 is an Admin',
            creator = '&&&1 is the group creator',
            unknown = 'This user has nothing to do with this chat',
            member = '&&&1 is a chat member'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'I\'ve never seen this user before.\nIf you want to teach me who he is, forward me a message from him',
            the_group = 'the group',
            adminlist_admin_required = 'I\'m not a group Admin.\n*Only an Admin can see the administrators list*',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            too_long = 'This text is too long, I can\'t send it',
            msg_me = '_Message me first so I can message you_',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*Group ID*: &&&1',
        },
        not_mod = 'You are *not* a moderator',
        breaks_markdown = 'This text breaks the markdown.\nMore info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).',
        credits = '*Some useful links:*',
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
                            .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
                            .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                            .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban)\n"
                            .."`/banlist -` = clean the banlist.\n"
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
                        .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
                        .."`/antiflood [number]` = set how many messages a user can write in 5 seconds.\n"
                        .."_Note_ : the number must be higher than 3 and lower than 26.\n",
                media = "*Moderators: media settings*\n\n"
                        .."`/media` = receive via private message an inline keyboard to change all the media settings.\n"
                        .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
                        .."`/media list` = show the current settings for all the media.\n"
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*Moderators: welcome settings*\n\n"
                            .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
                            .."\n*Custom welcome message:*\n"
                            .."`/welcome Welcome $name, enjoy the group!`\n"
                            .."Write after \"/welcome\" your welcome message. You can use some placeholders to include the name/username/id of the new member of the group\n"
                            .."Placeholders: _$username_ (will be replaced with the username); _$name_ (will be replaced with the name); _$id_ (will be replaced with the id); _$title_ (will be replaced with the group title).\n"
                            .."\n*GIF/sticker as welcome message*\n"
                            .."You can use a particular gif/sticker as welcome message. To set it, reply to a gif/sticker with \'/welcome\'\n"
                            .."\n*Composed welcome message*\n"
                            .."You can compose your welcome message with the rules, the description and the moderators list.\n"
                            .."You can compose it by writing `/welcome` followed by the codes of what the welcome message has to include.\n"
                            .."_Codes_ : *r* = rules; *a* = description (about); *m* = adminlist.\n"
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
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n",
                char = "*Moderators: special characters*\n\n"
                        .."`/menu` = you will receive in private the menu keyboard.\n"
                        .."Here you will find two particular options: _Arab and RTL_.\n"
                        .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                        .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
                        .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                links = "*Moderators: links*\n\n"
                        ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by other admins, or unset it\n'
                        .."`/link` = get the group link, if already setted by the owner\n"
                        .."`/setpoll [pollbot link]` = save a poll link from @pollbot. Once setted, moderators can retrieve it with `/poll`.\n"
                        .."`/setpoll no` = delete the current poll link.\n"
                        .."`/poll` = get the current poll link, if setted\n"
                        .."\n*Note*: the bot can recognize valid group links/poll links. If a link is not valid, you won't receive a reply.",
                lang = "*Moderators: group language*\n\n"
                        .."`/lang` = choose the group language (can be changed in private too).\n"
                        .."\n*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english)."
                        .."\nAnyway, translations are open to everyone. Use `/strings` command to receive a _.lua_ file with all the strings (in english).\n"
                        .."Use `/strings [lang code]` to receive the file for that specific language (example: _/strings es_ ).\n"
                        .."In the file you will find all the instructions: follow them, and as soon as possible your language will be available ;)",
                settings = "*Moderators: group settings*\n\n"
                            .."`/menu` = manage the group settings in private with an handy inline keyboard.\n"
                            .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
                            .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
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
                    ..'`/group` : get the discussion group link\n'
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
            modlist = '*Creator*:\n&&&1\n\n*Admins*:\n&&&2'
        },
        report = {
            no_input = 'Write your suggestions/bugs/doubt near the !',
            sent = 'Feedback sent!',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
        },
        service = {
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
                rules_locked = '/rules command is now available only for moderators',
                about_locked = '/about command is now available only for moderators',
                welcome_locked = 'Welcome message won\'t be displayed* from now',
                modlist_locked = '/adminlist command is now available only for moderators',
                flag_locked = '/flag command won\'t be available from now',
                extra_locked = '#extra commands are now available only for moderator',
                flood_locked = 'Anti-flood is now off',
                report_locked = '@admin command won\'t be available from now',
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                rules_unlocked = '/rules command is now available for all',
                about_unlocked = '/about command is now available for all',
                welcome_unlocked = 'Welcome message will be displayed',
                modlist_unlocked = '/adminlist command is now available for all',
                flag_unlocked = '/flag command is now available',
                extra_unlocked = 'Extra # commands are now available for all',
                flood_unlocked = 'Anti-flood is now on',
                report_unlocked = '@admin command is now available',
                admin_mode_unlocked = 'Admin mode on',
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
                w_m = '*Welcome type*: `welcome + adminlist`\n',
                w_ra = '*Welcome type*: `welcome + rules + about`\n',
                w_rm = '*Welcome type*: `welcome + rules + adminlist`\n',
                w_am = '*Welcome type*: `welcome + about + adminlist`\n',
                w_ram = '*Welcome type*: `welcome + rules + about + adminlist`\n',
                w_no = '*Welcome type*: `welcome only`\n',
                w_media = '*Welcome type*: `gif/sticker`\n',
                w_custom = '*Welcome type*: `custom message`\n',
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_'
            },
            char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
            broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            Rules = '/rules',
            About = '/about',
            Welcome = 'Welcome message',
            Modlist = '/adminlist',
            Flag = 'Flag',
            Extra = 'Extra',
            Flood = 'Anti-flood',
            Rtl = 'Rtl',
            Arab = 'Arab',
            Report = 'Report',
            Admin_mode = 'Admin mode',
        },
        warn = {
            warn_reply = 'Reply to a message to warn the user',
            changed_type = 'New action on max number of warns received: *&&&1*',
            mod = 'A moderator can\'t be warned',
            warned_max_kick = 'User &&&1 *kicked*: reached the max number of warnings',
            warned_max_ban = 'User &&&1 *banned*: reached the max number of warnings',
            warned = '&&&1 *have been warned.*\n_Number of warnings_   *&&&2*\n_Max allowed_   *&&&3*',
            warnmax = 'Max number of warnings changed&&&3.\n*Old* value: &&&1\n*New* max: &&&2',
            getwarns_reply = 'Reply to a user to check his numebr of warns',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            nowarn_reply = 'Reply to a user to delete his warns',
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            ban_motivation = 'Too many warnings',
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            nowarn = 'The number of warns received by this user have been *reset*'
        },
        setlang = {
            list = '*List of available languages:*',
            success = '*New language set:* &&&1'
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
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` is not a valid value!\nThe value should be *higher* than `3` and *lower* then `26`',
            not_changed = 'The max number of messages is already &&&1',
            changed_plug = 'The *max number* of messages (in *5 seconds*) changed _from_  &&&1 _to_  &&&2',
            kick = 'Now flooders will be kicked',
            ban = 'Now flooders will be banned',
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
			warn = 'This kind of media are *not allowed* in this group.\n_The next time_ you will be kicked or banned',
            settings_header = '*Current settings for media*:\n\n',
            changed = 'New status for [&&&1] = &&&2',
        },
        preprocess = {
            flood_ban = '&&&1 *banned* for flood!',
            flood_kick = '&&&1 *kicked* for flood!',
            media_kick = '&&&1 *kicked*: media sent not allowed!',
            media_ban = '&&&1 *banned*: media sent not allowed!',
            rtl_kicked = '&&&1 *kicked*: rtl character in names/messages not allowed!',
            arab_kicked = '&&&1 *kicked*: arab message detected!',
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
            first_warn = 'This type of media is *not allowed* in this chat.'
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
            dashboard = {
                private = '_I\'ve sent you the group dashboard in private_',
                first = 'Navigate this message to see *all the info* about this group!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            menu = '_I\'ve sent you the settings menu in private_',
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
	it = {
	    status = {
            kicked = '&&&1 è bannato da questo gruppo',
            left = '&&&1 ha lasciato il gruppo, o è stato kickato e unbannato',
            administrator = '&&&1 è un Admin',
            creator = '&&&1 è il creatore del gruppo',
            unknown = 'Questo utente non ha nulla a che fare con questo gruppo',
            member = '&&&1 è un membro del gruppo'
        },
        getban = {
            header = '*Info globali* su ',
            nothing = '`Nulla da segnalare`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Rimosso per flood: ',
            warn = 'Rimosso per warns: ',
            media = 'Rimosso per media vietati: ',
            arab = 'Rimosso per caratteri arabi: ',
            rtl = 'Rimosso per carattere RTL: ',
            kicked = '_Kickato!_',
            banned = '_Bannato!_'
        },
	    bonus = {
            general_pm = '_Ti ho inviato il messaggio in privato_',
            the_group = 'il gruppo',
            settings_header = 'Impostazioni correnti per *il gruppo*:\n\n*Lingua*: `&&&1`\n',
            no_user = 'Non ho mai visto questo utente prima.\nSe vuoi insegnarmi dirmi chi è, inoltrami un suo messaggio',
            reply = '*Rispondi a qualcuno* per usare questo comando, o scrivi lo *username*',
            adminlist_admin_required = 'Non sono un Admin del gruppo.\n*Solo un Admin puà vedere la lista degli amministratori*',
            too_long = 'Questo testo è troppo lungo, non posso inviarlo',
            msg_me = '_Scrivimi prima tu, in modo che io possa scriverti_',
            menu_cb_settings = 'Tocca le icone sulla destra!',
            menu_cb_warns = 'Usa la riga sottostante per modificare le impostazioni dei warns!',
            menu_cb_media = 'Usa uno switch!',
            tell = '*ID gruppo*: &&&1'
        },
        not_mod = '*Non sei* un moderatore!',
        breaks_markdown = 'Questo messaggio impedisce il markdown.\nControlla quante volte hai usato asterischi oppure underscores.\nPiù info [qui](https://telegram.me/GroupButler_ch/46)',
        credits = '*Alcuni link utili:*',
        extra = {
            setted = '&&&1 salvato!',
			usage = 'Scrivi accanto a /extra il titolo del comando ed il testo associato.\nAd esempio:\n/extra #ciao Hey, ciao!. Il bot risponderà _\'Hey, ciao!\'_ ogni volta che qualcuno scriverà #ciao',
            new_command = '*Nuovo comando impostato!*\n&&&1\n&&&2',
            no_commands = 'Nessun comando impostato!',
            commands_list = 'Lista dei *comandi personalizzati*:\n&&&1',
            command_deleted = 'Il comando personalizzato &&&1 è stato eliminato',
            command_empty = 'Il comando &&&1 non esiste'
        },
        help = {
            mods = {
                banhammer = "*Moderatori: il banhammer*\n\n"
                            .."`/kick [by reply|username]` = kicka un utente dal gruppo (potrà essere aggiunto nuovamente).\n"
                            .."`/ban [by reply|username]` = banna un utente dal gruppo (anche per gruppi normali).\n"
                            .."`/tempban [minutes]` = banna un utente per un tot di minuti (i minuti devono essere < 10.080, ovvero una settimana). Per ora funziona solo by reply.\n"
                            .."`/unban [by reply|username]` = unbanna l\'utente dal gruppo.\n"
                            .."`/getban [by reply|username]` = mostra il *numero globale* di ban/kick ricevuti dall'utente, e divisi per categoria.\n"
                            .."`/status [username]` = mostra la posizione attuale dell\'utente `(membro|kickato/ha lasciato il gruppo|bannato|admin/creatore|mai visto)`.\n"
                            .."`/banlist` = mostra la lista degli utenti bannati. Sono incluse le motivazioni (se descritte durante il ban).\n"
                            .."`/banlist -` = elimina la lista degli utenti bannati.\n"
                            .."\n*Nota*: puoi scrivere qualcosa dopo il comando `/ban` (o dopo l'username, se stai bannando per username)."
                            .." Questo commento verrà considerato la motivazione.",
                info = "*Moderatori: info sul gruppo*\n\n"
                        .."`/setrules [regole del gruppo]` = imposta il regolamento del gruppo (quello vecchio verrà eventualmente sovrascritto).\n"
                        .."`/addrules [testo]` = aggiungi del testo al regolamento già esistente.\n"
                        .."`/setabout [descrizione]` = imposta una nuova descrizione per il gruppo (quella vecchia verrà eventualmente sovrascritta).\n"
                        .."`/addabout [testo]` = aggiungi del testo alla descrizione già esistente.\n"
                        .."\n*Nota:* il markdown è permesso. Se del testo presenta un markdown scorretto, il bot notificherà che qualcosa è andato storto.\n"
                        .."Per un markdown corretto, consulta [questo post](https://telegram.me/GroupButler_ch/46) nel canale ufficiale",
                flood = "*Moderatori: impostazioni flood*\n\n"
                        .."`/antiflood` = gestisci le impostazioni dell\'antiflood in privato, tramite una tastiera inline. Puoi cambiare la sensibilità, l\'azione (kick/ban), ed anche impostare una lista di media ignorati.\n"
                        .."`/antiflood [numero]` = imposta quanti messaggi possono essere inviati in 5 secondi senza attivare l\'anti-flood.\n"
                        .."_Nota_ : il numero deve essere maggiore di 3 e minore di 26.\n",
                media = "*Moderatori: impostazioni media*\n\n"
                        .."`/media` = ricevi in privato una tastiera inline per gestire le impostazioni di tutti i media.\n"
                        .."`/warnmax media [numero]` = imposta il numero massimo di warning prima di essere kickato/bannato per aver inviato un media vietato.\n"
                        .."`/nowarns (by reply)` = resetta il numero di warnings ricevuti dall'utente (*NOTA: sia warn normali che warn per i media*).\n"
                        .."`/media list` = mostra l'elenco delle impostazioni attuali per i media.\n"
                        .."\n*Lista dei media supportati*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*Moderatori: messaggio di benvenuto*\n\n"
                            .."`/menu` = ricevi in privato la tastiera del menu. Lì troverai un\'opzione per abilitare/disabilitare il messaggio di benvenuto.\n"
                            .."\n*Messaggio di benvenuto personalizzato:*\n"
                            .."`/welcome Benvenuto $name, benvenuto nel gruppo!`\n"
                            .."Scrivi dopo \"/welcome\" il tuo benvenuto personalizzato. Puoi usare dei segnaposto per includere nome/username/id del nuovo membro del gruppo\n"
                            .."Segnaposto: _$username_ (verrà sostituito con lo username); _$name_ (verrà sostituito col nome); _$id_ (verrà sostituito con l\'id); _$title_ (verrà sostituito con il nome del gruppo).\n"
                            .."\n*GIF/sticker come messaggio di benvenuto*\n"
                            .."Puoi usare una gif/uno sticker per dare il benvenuto ai nuovi membri. Per impostare la gif/sticker, invialo e rispondigli con \'/welcome\'\n"
                            .."\n*Messaggio di benvenuto composto*\n"
                            .."Puoi comporre il messaggio di benvenuto con le regole, la descrizione e la lista dei moderatori.\n"
                            .."Per comporlo, scrivi `/welcome` seguito dai codici di cosa vuoi includere nel messaggio.\n"
                            .."_Codici_ : *r* = regole; *a* = descrizione (about); *m* = moderatori.\n"
                            .."Ad esempio, con \"`/welcome rm`\"il messaggio di benvenuto mostrerà regole e moderatori",
                extra = "*Moderatori: comandi extra*\n\n"
                        .."`/extra [#comando] [risposta]` = scrivi la risposta che verrà inviata quando il comando viene scritto.\n"
                        .."_Esempio_ : con \"`/extra #ciao Buon giorno!`\", il bot risponderà \"Buon giorno!\" ogni qualvolta qualcuno scriverà #ciao.\n"
                        .."`/extra list` = ottieni la lista dei comandi personalizzati impostati.\n"
                        .."`/extra del [#comando]` = elimina il comando ed il messaggio associato.\n"
                        .."`/disable extra` = solo gli admin potranno usare un comando #extra nel gruppo. Per gli altri utenti, verrà inviato in privato.\n"
                        .."`/enable extra` = chiunque potrà usare i comandi #extra in un gruppo, non solo gli admin.\n"
                        .."\n*Nota:* il markdown è permesso. Se del testo presenta un markdown scorretto, il bot notificherà che qualcosa è andato storto.\n"
                        .."Per un markdown corretto, consulta [questo post](https://telegram.me/GroupButler_ch/46) nel canale ufficiale",
                warns = "*Moderatori: warns*\n\n"
                        .."`/warn [kick/ban]` = scegli l\'azione da compiere (kick/ban) quando il numero massimo di warns viene raggiunto.\n"
                        .."`/warn [by reply]` = ammonisci (warn) un utente. Quando il numero massimo di warn viene raggiunto dall\'utente, verrà kickato/bannato.\n"
                        .."`/warnmax` = imposta il numero massimo di richiami prima di kickare/bannare.\n"
                        .."`/getwarns [by reply]` = restituisce il numero di volte che un utente è stato richiamato.\n"
                        .."`/nowarns (by reply)` = resetta il numero di warnings ricevuti dall'utente (*NOTA: sia warn normali che warn per i media*).\n",
                char = "*Moderatori: i caratteri*\n\n"
                        .."`/menu` = riceverai la tastiera del menu in privato dove potrai trovare due opzioni particolari: _Arabo ed Rtl_.\n"
                        .."\n*Arabo*: quando l'arabo non è permesso (🚫), chiunque scriva un carattere arabo evrrà kickato dal gruppo.\n"
                        .."*Rtl*: sta per carattere 'Righ To Left'. In poche parole, se inserito nel proprio nome, qualsiasi stringa (scritta) dell\'app di Telegram che contiene il nome dell'utente verrà visualizzata al contrario"
                        .." (ad esempio, lo 'sta scrivendo'). Quando il carattere Rtl non è permesso (🚫), chiunque ne farà utilizzo nel nome (o nei messaggi) verrà kickato.",
                links = "*Moderatori: link*\n\n"
                        ..'`/setlink [link|\'no\']` : imposta il link del gruppo, in modo che possa essere richiesto da altri Admin, oppure eliminalo\n'
                        .."`/link` = ottieni il link del gruppo, se già impostato dal proprietario\n"
                        .."`/setpoll [link pollbot]` = salva un link ad un sondaggio di @pollbot. Una volta impostato, i moderatori possono ottenerlo con `/poll`.\n"
                        .."`/setpoll no` = elimina il link al sondaggio corrente.\n"
                        .."`/poll` = ottieni il link al sondaggio corrente, se impostato.\n"
                        .."\n*Note*: il bot può riconoscere link validi a gruppi/sondaggi. Se il link non è valido, non otterrai una risposta.",
                lang = "*Moderatori: linguaggio del bot*\n\n"
                        .."`/lang` = scegli la lingua del bot (può essere cambiata anche in privato).\n"
                        .."\n*Nota*: i traduttori sono utenti volontari, quindi non posso assicurare la correttezza delle traduzioni. E non posso costringerli a tradurre le nuove stringhe dopo un aggiornamento (le stringhe non tradotte saranno in inglese)."
                        .."\nComunque, chiunque può tradurre il bot. Usa il comando `/strings` per ricevere un file _.lua_ con tutte le stringhe (in inglese).\n"
                        .."Usa `/strings [codice lingua]` per ricevere il file associato alla lingua richiesta (esempio: _/strings es_ ).\n"
                        .."Nel file troverai tutte le istruzioni: seguile, e il linguggio sarà disponibile il prima possibile ;)  (traduzione in italiano NON NECESSARIA)",
                settings = "*Moderatori: impostazioni del gruppo*\n\n"
                            .."`/menu` = gestisci le impostazioni del gruppo in privato tramite una comoda tastiera inline.\n"
                            .."`/adminmode on` = _/rules, /adminlist_ ed ogni comando #extra verranno inviati in privato a meno che non sia un Admin ad usarli.\n"
                            .."`/adminmode off` = _/rules, /adminlist_ ed ogni comando #extra verranno inviati sempre nel gruppo.\n"
                            .."`/report [on/off]` (by reply) = l'utente non potrà (_off_) o potrà (_on_) usare il comando \"@admin\".\n",
            },
            all = '*Comandi per tutti*:\n'
                    ..'`/dashboard` : consulta tutte le info sul gruppo in privato\n'
                    ..'`/rules` (se sbloccato) : mostra le regole del gruppo\n'
                    ..'`/about` (se sbloccato) : mostra la descrizione del gruppo\n'
                    ..'`/adminlist` (se sbloccato) : mostra la lista dei moderatori\n'
                    ..'`@admin` (se sbloccato) : by reply= inoltra il messaggio a cui hai risposto agli admin; no reply (con descrizione)= inoltra un feedback agli admin\n'
                    ..'`/kickme` : fatti kickare dal bot\n'
                    ..'`/faq` : le risposte alle domande più frequenti\n'
                    ..'`/id` : mostra l\'id del gruppo, oppure l\'id dell\'utente a cui si ha risposto\n'
                    ..'`/echo [testo]` : il bot replicherà il testo scritto (markdown supportato, disponibile solo in privato per non-admin)\n'
                    ..'`/info` : mostra alcune info sul bot\n'
                    ..'`/group` : ottieni il link del gruppo di discussione (inglese)\n'
                    ..'`/c` <feedback> : invia un feedback/segnala un bug/fai una domanda al creatore. _OGNI GENERE DI SUGGERIMENTO E\' IL BENVENUTO_. Risponderà ASAP\n'
                    ..'`/help` : show this message.'
		            ..'\n\nSe ti piace questo bot, per favore lascia il voto che credi si meriti [qui](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'Sono un semplice bot creato con lo scopo di aiutare gli utenti di Telegram ad amministrare i propri gruppi.\n'
                    ..'\n*Cosa posso fare per aiutarti?*\n'
                    ..'Beh, ho un sacco di funzioni utili!\n'
                    ..'• Puoi *kickare or bannare* gli utenti (anche in gruppi normali) by replyo by username\n'
                    ..'• Puoi impostare regole e descrizione\n'
                    ..'• Puoi attivare un *anti-flood* configurabile\n'
                    ..'• Puoi personalizzare il *messaggio di benvenuto*, ed usare anche gif e sticker\n'
                    ..'• Puoi ammonire gli utenti, e kickarli/bannarli se raggiungono il numero massimo di ammonizioni\n'
                    ..'• Puoi decidere se ammonire o kickare gli utenti che inviano un media specifico\n'
                    ..'...e questo è solo l\'inizio, puoi trovare tutti i comandi disponibili premendo sul pulsante "all commands", appena qui sotto :)\n'
                    ..'\nPer usarmi, *devo essere impostato come amministratore*, o non potrò funzionare correttamente! (se non ti fidi, spero di toglierti qualche dubbio sul perchè di questa necessità con [questo post](https://telegram.me/GroupButler_ch/63))'
                    ..'\nPuoi segnalare bug/inviare un feedback/fare una domanda al mio creatore usando il comando "`/c <feedback>`". SI ACCETTA QUALSIASI RICHIESTA/SEGNALAZIONE!',
            group_success = '_Ti ho inviato il messaggio in privato_',
            group_not_success = '_Per favore, avviami cosicchè io possa risponderti_',
            initial = 'Scegli un *ruolo* per visualizzarne i comandi:',
            kb_header = 'Scegli una voce per visualizzarne i *comandi associati*'
        },
        links = {
            no_link = '*Nessun link* per questo gruppo. Chiedi al proprietario di settarne uno',
            link = '[&&&1](&&&2)',
            link_invalid = 'Questo link *non è valido!*',
            link_no_input = 'Questo non è un *supergruppo pubblico*, quindi devi specificare il link affianco a /setlink',
            link_updated = 'Il link è stato aggiornato.\n*Ecco il nuovo link*: [&&&1](&&&2)',
            link_setted = 'Il link è stato impostato.\n*Ecco il link*: [&&&1](&&&2)',
            link_unsetted = 'Link *rimosso*',
            poll_unsetted = 'Sondaggio *rimosso*',
            poll_updated = 'Il sondaggio è stato aggiornato.\n*Vota qui*: [&&&1](&&&2)',
            poll_setted = 'Il sondaggio è stato impostato.\n*Vota qui*: [&&&1](&&&2)',
            no_poll = '*Nessun sondaggio attivo* in questo gruppo',
            poll = '*Vota qui*: [&&&1](&&&2)'
        },
        mod = {
            modlist = '*Creatore*:\n&&&1\n\n*Admin*:\n&&&2',
        },
        report = {
            no_input = 'Scrivi il tuo suggerimento/bug/dubbio accanto al punto esclamativo (!)',
            sent = 'Feedback inviato!',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
        },
        service = {
            welcome = 'Ciao &&&1, e benvenuto/a in *&&&2*!',
            welcome_rls = 'Anarchia totale!',
            welcome_abt = 'Nessuna descrizione per questo gruppo.',
            welcome_modlist = '\n\n*Creatore*:\n&&&1\n*Admin*:\n&&&2',
            abt = '\n\n*Descrizione*:\n',
            rls = '\n\n*Regole*:\n',
        },
        setabout = {
            no_bio = '*Nessuna descrizione* per questo gruppo.',
            no_bio_add = '*Nessuna descrizione per questo gruppo*.\nUsa /setabout [descrizione] per impostare una nuova descrizione',
            no_input_add = 'Per favore, scrivi qualcosa accanto a "/addabout"',
            added = '*Descrzione aggiunta:*\n"&&&1"',
            no_input_set = 'Per favore, scrivi qualcosa accanto a "/setabout"',
            clean = 'La descrizione è stata eliminata.',
            new = '*Nuova descrizione:*\n"&&&1"',
            about_setted = 'La nuova descrizione *è stata salvata correttamente*!'
        },
        setrules = {
            no_rules = '*Anarchia totale*!',
            no_rules_add = '*Nessuna regola* in questo gruppo.\nUsa /setrules [regole] per impostare delle nuove regole',
            no_input_add = 'Per favore, scrivi qualcosa accanto a "/addrules"',
            added = '*Rules added:*\n"&&&1"',
            no_input_set = 'Per favore, scrivi qualcosa accanto a "/setrules"',
            clean = 'Le regole sono state eliminate.',
            new = '*Nuove regole:*\n"&&&1"',
            rules_setted = 'Le nuove regole *sono state salvate correttamente*!'
        },
        settings = {
            disable = {
                rules_locked = '/rules è ora utilizzabile solo dai moderatori',
                about_locked = '/about è ora utilizzabile solo dai moderatori',
                welcome_locked = 'Il messaggio di benvenuto non verrà mostrato da ora',
                modlist_locked = '/adminlist è ora utilizzabile solo dai moderatori',
                flag_locked = '/flag command won\'t be available from now',
                extra_locked = 'I comandi #extra sono ora utilizzabili solo dai moderatori',
                rtl_locked = 'Anti-RTL è ora on',
                flood_locked = 'L\'anti-flood è ora off',
                arab_locked = 'Anti-caratteri arabi è ora on',
                report_locked = '@admin non sarà disponibile da ora',
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                rules_unlocked = '/rules è ora utilizzabile da tutti',
                about_unlocked = '/about è ora utilizzabile da tutti',
                welcome_unlocked = 'il messaggio di benvenuto da ora verrà mostrato',
                modlist_unlocked = '/adminlist è ora utilizzabile da tutti',
                flag_unlocked = '/flag command is now available',
                extra_unlocked = 'I comandi #extra sono già disponibili per tutti',
                rtl_unlocked = 'Anti-RTL è ora off',
                flood_unlocked = 'L\'anti-flood è ora on',
                arab_unlocked = 'Anti-caratteri arabi è ora off',
                report_unlocked = '@admin è ora disponibile',
                admin_mode_unlocked = 'Admin mode on',
            },
            welcome = {
                no_input = 'Welcome e...?',
                media_setted = 'Media impostato come messaggio di benvenuto: ',
                reply_media = 'Rispondi ad uno `sticker` a ad una `gif` per usarli come *messaggio di benvenuto*',
                a = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\n*Descrizione*\nLista dei moderatori',
                r = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\nDescrizione\nLista dei moderatori',
                m = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\nDescrizione\n*Lista dei moderatori*',
                ra = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\n*Descrizione*\nLista dei moderatori',
                rm = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\nDescrizione\n*Lista dei moderatori*',
                am = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\n*Descrizione*\n*Lista dei moderatori*',
                ram = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\n*Descrizione*\n*Lista dei moderatori*',
                no = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\nDescrizione\nLista dei moderatori',
                wrong_input = 'Argomento non disponibile.\nUsa invece _/welcome [no|r|a|ra|ar]_',
                custom = '*Messaggio di benvenuto personalizzato* impostato!\n\n&&&1',
                custom_setted = '*Messaggio di benvenuto personalizzato salvato!*',
                wrong_markdown = '_Non impostato_ : non posso reinviarti il messaggio, probabilmente il markdown usato è *sbagliato*.\nPer favore, controlla il messaggio inviato e riprova',
            },
            resume = {
                header = 'Impostazioni correnti di *&&&1*:\n\n*Lingua*: `&&&2`\n',
                w_media = "*Tipo di benvenuto*: `gif/sticker`\n",
                w_custom = "*Tipo di benvenuto*: `messaggio personalizzato`\n",
                w_a = '*Tipo di benvenuto*: `benvenuto + descrizione`\n',
                w_r = '*Tipo di benvenuto*: `benvenuto + regole`\n',
                w_m = '*Tipo di benvenuto*: `benvenuto + moderatori`\n',
                w_ra = '*Tipo di benvenuto*: `benvenuto + regole + descrizione`\n',
                w_rm = '*Tipo di benvenuto*: `benvenuto + regole + moderatori`\n',
                w_am = '*Tipo di benvenuto*: `benvenuto + descrizione + moderatori`\n',
                w_ram = '*Tipo di benvenuto*: `benvenuto + regole + descrizione + moderatori`\n',
                w_no = '*Tipo di benvenuto*: `solo benvenuto`\n',
                w_media = '*Tipo di benvenuto*: `gif/sticker`\n',
                legenda = '✅ = _abilitato/permesso_\n🚫 = _disabilitato/non permesso_\n👥 = _inviato nel gruppo (sempre, per gli admin)_\n👤 = _inviato in privato_'
            },
            char = {
                arab_kick = 'Messaggi in arabo = kick',
                arab_ban = 'Messaggi in arabo = ban',
                arab_allow = 'Messaggi in arabo permessi',
                rtl_kick = 'Uso del carattere RTL = kick',
                rtl_ban = 'Uso del carattere RTL = ban',
                rtl_allow = 'Carattere RTL consentito',
            },
            broken_group = 'Sembra che questo gruppo non abbia delle impostazioni salvate.\nPer favore, usa /initgroup per risolvere il problem :)',
            Rules = '/rules',
            About = '/about',
            Welcome = 'Messaggio di benvenuto',
            Modlist = '/adminlist',
            Flag = 'Flag',
            Extra = 'Extra',
            Flood = 'Anti-flood',
            Rtl = 'Rtl',
            Arab = 'Arabo',
            Report = 'Report',
            Admin_mode = 'Admin mode',
        },
        warn = {
            warn_reply = 'Rispondi ad un messaggio per ammonire un utente (warn)',
            changed_type = 'Nuova azione: *&&&1*',
            mod = 'Un moderatore non può essere ammonito',
            warned_max_kick = 'Utente &&&1 *kickato*: raggiunto il numero massimo di warns',
            warned_max_ban = 'Utente &&&1 *bannato*: raggiunto il numero massimo di warns',
            warned = '*L\'utente* &&&1 *è stato ammonito.*\n_Numero di ammonizioni_   *&&&2*\n_Max consentito_   *&&&3*',
            warnmax = 'Numero massimo di waning aggiornato&&&3.\n*Vecchio* valore: &&&1\n*Nuovo* valore: &&&2',
            getwarns_reply = 'Rispondi ad un utente per ottenere il suo numero di ammonizioni',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            nowarn_reply = 'Rispondi ad un utente per azzerarne le ammonizioni',
            ban_motivation = 'Troppi warning',
            inline_high = 'Il nuovo valore è troppo alto (>12)',
            inline_low = 'Il nuovo valore è troppo basso (<1)',
            warn_removed = '*Warn rimosso!*\n_Numero di ammonizioni_   *&&&1*\n_Max consentito_   *&&&2*',
            nowarn = 'Il numero di ammonizioni ricevute da questo utente è stato *azzerato*'
        },
        setlang = {
            list = '*Elenco delle lingue disponibili:*',
            success = '*Nuovo linguaggio impostato:* &&&1'
        },
		banhammer = {
            kicked = '&&&1 è stato kickato! (ma può ancora rientrare)',
            banned = '&&&1 è stato bannato!',
            unbanned = 'L\'utente è stato unbannato!',
            reply = 'Rispondi a qualcuno',
            globally_banned = '&&&1 è stato bannato globalmente!',
            no_unbanned = 'Questo è un gruppo normale, gli utenti non vengono bloccati se kickati',
            already_banned_normal = '&&&1 è *già bannato*!',
            not_banned = 'L\'utente non è bannato',
            banlist_header = '*Utenti bannati*:\n\n',
            banlist_empty = '_La lista è vuota_',
            banlist_error = '_Si è verificato un errore nello svuotare la banlist_',
            banlist_cleaned = '_La lista degli utenti bannati è stata eliminata_',
            tempban_zero = 'Puoi usare direttamente /ban per questo',
            tempban_week = 'Il limite è una settimana (10.080 minuti)',
            tempban_banned = 'L\'utente &&&1 è stato bannato. Scadenza del ban:',
            tempban_updated = 'Scadenza aggiornata per &&&1. Scadenza ban:',
            general_motivation = 'Non posso kickare questo utente.\nProbabilmente non sono un Admin, o l\'utente che hai cercato di kickare è un Admin'
        },
        floodmanager = {
            number_invalid = '`&&&1` non è un valore valido!\nil valore deve essere *maggiore* di `3` e *minore* di `26`',
            not_changed = 'il massimo numero di messaggi che può essere inviato in 5 secondi è già &&&1',
            changed_plug = 'Il numero *massimo di messaggi* che possono essere inviato in *5 secondi* è passato _da_  &&&1 _a_  &&&2',
            enabled = 'Antiflood abilitato',
            disabled = 'Antiflood disabilitato',
            kick = 'I flooders verranno kickati',
            ban = 'I flooders verranno bannati',
            changed_cross = '&&&1 -> &&&2',
            text = 'Messaggi normali',
            image = 'Immagini',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Video',
            sent = '_Ti ho inviato il menu dell\'anti-flood in privato_',
            ignored = '[&&&1] saranno ignorati dall\'anti-flood',
            not_ignored = '[&&&1] verranno considerati dall\'anti-flood',
            number_cb = 'Sensibilità del flood. Tappa su + oppure -',
            header = 'Puoi gestire le impostazioni dell\'anti-flood da qui.\n'
                ..'\n*1^ riga*\n'
                ..'• *ON/OFF*: lo stato corrente dell\'anti-flood\n'
                ..'• *Kick/Ban*: cosa fare quando un utente sta floodando\n'
                ..'\n*2^ riga*\n'
                ..'• puoi usare *+/-* per cambiare la sensibilità dell\'anti-flood\n'
                ..'• il valore rappresenta il numero massimo di messaggi che possono essere inviati in _5 secondi_\n'
                ..'• valore max: _25_ - valore min: _4_\n'
                ..'\n*3^ riga* ed a seguire\n'
                ..'Puoi impostare alcune eccezioni per l\'anti-flood:\n'
                ..'• ✅: il media verrà ignorato dal conteggio del flood\n'
                ..'• ❌: il media verrà considerato nel conteggio del flood\n'
                ..'• *Nota*: in "_messaggi normali_" sono compresi anche tutti i media non citati (file, audio...)'
        },
        mediasettings = {
			warn = 'Questo tipo di media *non è consentito* in questo gruppo.\n_La prossima volta_ verrai kickato o bannato',
            settings_header = '*Impostazioni correnti per i media*:\n\n',
            changed = 'Nuovo stato per [&&&1] = &&&2',
        },
        preprocess = {
            flood_ban = '&&&1 *bannato* per flood',
            flood_kick = '&&&1 *kickato* per flood',
            media_kick = '&&&1 *kickato*: media inviato non consentito',
            media_ban = '&&&1 *bannato*: media inviato non consentito',
            rtl_kicked = '&&&1 *kickato*: carattere rtl nel nome/nei messaggi non consentito',
            arab_kicked = '&&&1 *kickato*: caratteri arabi non consentiti',
            rtl_banned = '&&&1 *bannato*: carattere rtl nel nome/nei messaggi non consentito',
            arab_banned = '&&&1 *bannato*: caratteri arabi non consentiti',
            flood_motivation = 'Bannato per flood',
            media_motivation = 'Ha inviato un media non consentito',
            first_warn = 'Questo tipo di media *non è consentito* in questo gruppo.'
        },
        kick_errors = {
            [1] = 'Non sono admin, non posso kickare utenti',
            [2] = 'Non posso kickare o bannare un admin',
            [3] = 'Non c\'è bisogno di unbannare in un gruppo normale',
            [4] = 'Questo utente non fa parte del gruppo',
        },
        flag = {
            no_input = 'Rispondi ad un messaggio per segnalarlo agli admin, o scrivi qualcosa accanto ad \'@admin\' per inviare un feedback ai moderatori',
            reported = 'Segnalato!',
            no_reply = 'Rispondi a qualcuno!',
            blocked = 'Questo utente da ora non potrà usare \'@admin\'',
            already_blocked = 'Questo utente non può già usare \'@admin\'',
            unblocked = 'L\'utente ora può usare \'@admin\'',
            already_unblocked = 'L\'utente può già usare \'@admin\'',
        },
        all = {
            dashboard = {
                private = '_Ti ho inviato la scheda del gruppo in privato_',
                first = 'Naviga questo messaggio tramite i tasti per consultare *tutte le info* sul gruppo!',
                flood = '- *Stato*: `&&&1`\n- *Azione* da intraprendere quando un utente sta floodando: `&&&2`\n- Numero di messaggi *in 5 secondi* consentito: `&&&3`\n- *Media ignorati*:\n&&&4',
                settings = 'Impostazioni',
                admins = 'Admin',
                rules = 'Regole',
                about = 'Descrizione',
                welcome = 'Messaggio di benvenuto',
                extra = 'Comandi extra',
                flood = 'Impostazioni Anti-flood',
                media = 'Impostazioni dei media'
            },
            menu = '_Ti ho inviato il menu delle impostazioni in privato_',
            menu_first = 'Gestisci le impostazioni del gruppo.\n'
                ..'\nAlcuni comandi (_/rules, /about, /adminlist, comandi #extra_) possono essere *disabilitati per utento *non*-admin*\n'
                ..'Cosa accade se un comando è disabilitato per i non-admin:\n'
                ..'• Se il comando è richiesto da un admin, il bot risponderà *nel gruppo*\n'
                ..'• Se il comando è richiesto da un utente normale, il bot risponderà *in privato all\'utente* (ovviamente, solo se l\'utente aveva già avviato il bot in precedenza)\n'
                ..'\nL\'icona vicino al comando indica lo stato corrente:\n'
                ..'• 👥: il bot risponderà *nel gruppo*, senza distinzioni\n'
                ..'• 👤: il bot risponderà *in prvato* se richiesto da un utente, nel gruppo invece se richiesto da un admin\n'
                ..'\n*Altre impostazioni*: per le altre impostazioni, l\'icona esprime bene il loro stato corrente\n',
            media_first = 'Tocca una voce sulla colonna destra per *cambiare le impostazioni*'
        },
    },
	es = {
	    status = {
            kicked = '&&&1 is banned from this group',
            left = '&&&1 left the group or has been kicked and unbanned',
            administrator = '&&&1 is an Admin',
            creator = '&&&1 is the group creator',
            unknown = 'This user has nothing to do with this chat',
            member = '&&&1 is a chat member'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
	    bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'I\'ve never seen this user before.\nIf you want to teach me who he is, forward me a message from him',
            the_group = 'the group',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            adminlist_admin_required = 'I\'m not a group Admin.\n*Only an Admin can see the administrators list*',
            too_long = 'This text is too long, I can\'t send it',
            msg_me = '_Message me first so I can message you_',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*ID del grupo*: &&&1'
        },
        not_mod = 'Tu *no* eres moderador',
        breaks_markdown = 'This text breaks the markdown.\nMore info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).',
        credits = '*Some useful links:*',
        extra = {
            setted = '&&&1 command saved!',
			usage = 'Escribe seguido de /extra el titulo del comando y el texto asociado.\nPor ejemplo:\n/extra #motm esta positivo. El bot respondera _\'Esta positivo\'_ cada vez que alguien escriba #motm',
            new_command = '*Nuevo comando programado!*\n&&&1\n&&&2',
            no_commands = 'No hay comandos programados!',
            commands_list = 'Lista de *comandos personalizados*:\n&&&1',
            command_deleted = 'El comando &&&1 ha sido eliminado',
            command_empty = 'El comando &&&1 no existe'
        },
        help = {
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n"
                            .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
                            .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                            .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban).\n"
                            .."`/banlist -` = clean the banlist.\n"
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
                       .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
                        .."`/antiflood [number]` = set how many messages a user can write in 5 seconds.\n"
                        .."_Note_ : the number must be higher than 3 and lower than 26.\n",
                media = "*Moderators: media settings*\n\n"
                        .."`/media` = receive via private message an inline keyboard to change all the media settings.\n"
                        .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
                        .."`/media list` = show the current settings for all the media.\n"
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*Moderators: welcome settings*\n\n"
                            .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
                            .."\n*Custom welcome message:*\n"
                            .."`/welcome Welcome $name, enjoy the group!`\n"
                            .."Write after \"/welcome\" your welcome message. You can use some placeholders to include the name/username/id of the new member of the group\n"
                            .."Placeholders: _$username_ (will be replaced with the username); _$name_ (will be replaced with the name); _$id_ (will be replaced with the id); _$title_ (will be replaced with the group title).\n"
                            .."\n*GIF/sticker as welcome message*\n"
                            .."You can use a particular gif/sticker as welcome message. To set it, reply to a gif/sticker with \'/welcome\'\n"
                            .."\n*Composed welcome message*\n"
                            .."You can compose your welcome message with the rules, the description and the moderators list.\n"
                            .."You can compose it by writing `/welcome` followed by the codes of what the welcome message has to include.\n"
                            .."_Codes_ : *r* = rules; *a* = description (about); *m* = adminlist.\n"
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
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n",
                char = "*Moderators: special characters*\n\n"
                        .."`/menu` = you will receive in private the menu keyboard.\n"
                        .."Here you will find two particular options: _Arab and RTL_.\n"
                        .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                        .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
                        .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                links = "*Moderators: links*\n\n"
                        ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by other admins, or unset it\n'
                        .."`/link` = get the group link, if already setted by the owner\n"
                        .."`/setpoll [pollbot link]` = save a poll link from @pollbot. Once setted, moderators can retrieve it with `/poll`.\n"
                        .."`/setpoll no` = delete the current poll link.\n"
                        .."`/poll` = get the current poll link, if setted\n"
                        .."\n*Note*: the bot can recognize valid group links/poll links. If a link is not valid, you won't receive a reply.",
                lang = "*Moderators: group language*\n\n"
                        .."`/lang` = choose the group language (can be changed in private too).\n"
                        .."\n*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english)."
                        .."\nAnyway, translations are open to everyone. Use `/strings` command to receive a _.lua_ file with all the strings (in english).\n"
                        .."Use `/strings [lang code]` to receive the file for that specific language (example: _/strings es_ ).\n"
                        .."In the file you will find all the instructions: follow them, and as soon as possible your language will be available ;)",
                settings = "*Moderators: group settings*\n\n"
                            .."`/menu` = manage the group settings in private with an handy inline keyboard.\n"
                            .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
                            .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
                            .."`/report [on/off]` (by reply) = the user won't be able (_off_) or will be able (_on_) to use \"@admin\" command.\n",
            },
            all = '*Comandos para todos*:\n'
                    ..'`/dashboard` : see all the group info from private\n'
                    ..'`/rules` (si desbloqueado) : Ver reglas del grupo\n'
                    ..'`/about` (si desbloqueado) : Ver descripcion de grupo\n'
                    ..'`/adminlist` (si desbloqueado) : Ver los moderadores del grupo\n'
                    ..'`@admin` (si desbloqueado) : mencionar= informar del mensaje contestado a todos los administradores; sin respuesta (con texto)= enviar el mensaje a todos los administradores\n'
                    ..'`/kickme` : get kicked by the bot\n'
                    ..'`/faq` : some useful answers to frequent quetions\n'
                    ..'`/id` : show the chat id, or the id of an user if by reply\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown, available only in private for non-admin users)\n'
                    ..'`/info` : Ver informacion sobre el bot\n'
                    ..'`/group` : get the discussion group link\n'
                    ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
                    ..'`/help` : Ver este mensaje.'
		            ..'\n\nSi te gusta este bot, por favor deja tu voto [aqui](https://telegram.me/storebot?start=groupbutler_bot)',
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
            group_success = '_Te he enviado el mensaje por privado_',
            group_not_success = '_Please message me first so I can message you_',
            initial = 'Choose the *role* to see the available commands:',
            kb_header = 'Tap on a button to see the *related commands*'
        },
        links = {
            no_link = '*No hay enlace* para este grupo. Pidele al admin que lo añada',
            link = '[&&&1](&&&2)',
            link_invalid = 'Este enlace *no* es valido.',
            link_no_input = 'This is not a *public supergroup*, so you need to write the link near /setlink',
            link_updated = 'El enlace ha sido actualizado.\n*Este es el nuevo enlace*: [&&&1](&&&2)',
            link_setted = 'El link ha sido configurado.\n*Este es el enlace*: [&&&1](&&&2)',
            link_unsetted = 'Enlace *sin establecer*',
            poll_unsetted = 'Encuesta *sin establecer*',
            poll_updated = 'La encuesta ha sido actualizada.\n*Vota aqui*: [&&&1](&&&2)',
            poll_setted = 'El enlace ha sido configurado.\n*Vota aqui*: [&&&1](&&&2)',
            no_poll = '*No hay encuestas activas* en este grupo',
            poll = '*Vota aqui*: [&&&1](&&&2)'
        },
        mod = {
            modlist = '*Creator*:\n&&&1\n\n*Admins*:\n&&&2'
        },
        report = {
            no_input = 'Escribe tus comentarios/bugs/dudas despues del !',
            sent = 'Mensaje enviado!',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
        },
        service = {
            welcome = 'Hola &&&1, bienvenido a *&&&2*!',
            welcome_rls = '¡Anarquia total!',
            welcome_abt = 'No hay descripcion sobre este grupo.',
            welcome_modlist = '\n\n*Creator*:\n&&&1\n*Admins*:\n&&&2',
            abt = '\n\n*Descripcion*:\n',
            rls = '\n\n*Reglas*:\n',
        },
        setabout = {
            no_bio = '*NO hay descripcion* de este grupo.',
            no_bio_add = '*No hay descripcion* de este grupo.\nUsa /setabout [bio] para añadir una descripcion',
            no_input_add = 'Por favor, escribe algo despues de "/addabout"',
            added = '*Descripcion añadida:*\n"&&&1"',
            no_input_set = 'Por favor, escribe algo despues de "/setabout"',
            clean = 'La descripcion ha sido eliminada.',
            new = '*Nueva descripcion:*\n"&&&1"',
            about_setted = 'New description *saved successfully*!'
        },
        setrules = {
            no_rules = '*¡Anarquia total*!',
            no_rules_add = '*No hay reglas* en este grupo.\nUsa /setrules [rules] para crear la constitucion',
            no_input_add = 'Por favor, escribe algo despues de "/addrules"',
            added = '*Reglas añadidas:*\n"&&&1"',
            no_input_set = 'Por favor, escribe algo despues de "/setrules"',
            clean = 'Las reglas han sido eliminadas.',
            new = '*Nuevas reglas:*\n"&&&1"',
            rules_setted = 'New rules *saved successfully*!'
        },
        settings = {
            disable = {
                rules_locked = '/rules comando disponible solo para moderadores',
                about_locked = '/about comando disponible solo para moderadores',
                welcome_locked = 'Mensaje de bienvenida no sera mostrado',
                modlist_locked = '/adminlist comando disponible solo para moderadores',
                flag_locked = '/flag comando no disponible',
                extra_locked = 'Comandos #extra solo para moderadores',
                rtl_locked = 'Anti-RTL desactivado',
                flood_locked = 'Anti-flood is now off',
                arab_locked = 'Anti-caracteres arabe desactivado',
                report_locked = 'Comando @admin no disponible',
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                rules_unlocked = '/rules comando disponible para todos',
                about_unlocked = '/about comando disponible para todos',
                welcome_unlocked = 'El mensaje de bienvenida sera mostrado',
                modlist_unlocked = '/adminlist comando disponible para todos',
                flag_unlocked = '/flag comando disponible',
                extra_unlocked = 'Comandos #extra disponibles para todos',
                rtl_unlocked = 'Anti-RTL apagado',
                flood_unlocked = 'Anti-flood is now on',
                arab_unlocked = 'Anti-caracteres arabe apagado',
                report_unlocked = 'Comando @admin disponible',
                admin_mode_unlocked = 'Admin mode on',
            },
            welcome = {
                no_input = 'Bienvenida y...?',
                media_setted = 'New media setted as welcome message: ',
                reply_media = 'Reply to a `sticker` or a `gif` to set them as *welcome message*',
                a = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\n*Descripcion*\nModeradores',
                r = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\nDescripcion\nModeradores',
                m = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\nDescripcion\n*Moderadores*',
                ra = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\n*Descripcion*\nModeradores',
                rm = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\nDescripcion\n*Moderadores*',
                am = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\n*Descripcion*\n*Moderadores*',
                ram = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\n*Descripcion*\n*Moderadores*',
                no = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\nDescripcion\nModeradores',
                wrong_input = 'Argumento no disponible.\nUsa _/welcome [no|r|a|ra|ar]_',
                custom = '*Custom welcome message* setted!\n\n&&&1',
                custom_setted = '*Custom welcome message saved!*',
                wrong_markdown = '_Not setted_ : I can\'t send you back this message, probably the markdown is *wrong*.\nPlease check the text sent',
            },
            resume = {
                header = 'Ajustes actuales de *&&&1*:\n\n*Idioma*: `&&&2`\n',
                w_a = '*Tipo de Bienvenida*: `welcome + descripcion`\n',
                w_r = '*Tipo de Bienvenida*: `welcome + reglas`\n',
                w_m = '*Tipo de Bienvenida*: `welcome + moderadores`\n',
                w_ra = '*Tipo de Bienvenida*: `welcome + reglas + descripcion`\n',
                w_rm = '*Tipo de Bienvenida*: `welcome + reglas + moderadores`\n',
                w_am = '*Tipo de Bienvenida*: `welcome + descripcion + moderadores`\n',
                w_ram = '*Tipo de Bienvenida*: `welcome + reglas + descripcion + moderadores`\n',
                w_no = '*Tipo de Bienvenida*: `welcome only`\n',
                w_media = '*Tipo de Bienvenida*: `gif/sticker`\n',
                w_custom = '*Tipo de Bienvenida*: `custom message`\n',
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_'
            },
            char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
            broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            Rules = '/rules',
            About = '/about',
            Welcome = 'Mensaje Bienvenida',
            Modlist = '/adminlist',
            Flag = 'Flag',
            Extra = 'Extra',
            Flood = 'Anti-flood',
            Rtl = 'Rtl',
            Arab = 'Arabe',
            Report = 'Reportar',
            Admin_mode = 'Admin mode',
        },
        warn = {
            warn_reply = 'Menciona el mensaje para advertir al usuario',
            changed_type = 'Nueva consecuencia al alcanzar el numero max de advertencias: *&&&1*',
            mod = 'Un moderador *no* puede ser advertido',
            warned_max_kick = '*&&&1 ha sido expulsado*: alcanzado el numero maximo de advertencias',
            warned_max_ban = '*&&&1 ha sido baneado*: alcanzado el numero maximo de advertencias',
            warned = '*&&&1 ha sido advertido.*\n_Numero de advertencias_   *&&&2*\n_Maximo_   *&&&3*',
            warnmax = 'Numero maximo de advertencias cambiado&&&3.\n*Antes*: &&&1\n*Ahora*: &&&2',
            getwarns_reply = 'Reply to a user to check his numebr of warns',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            nowarn_reply = 'Menciona al miembro para eliminarle la advertencia',
            ban_motivation = 'too many warnings',
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            nowarn = 'El número de advertencias de este miembro ha sido *reseteado*'
        },
        setlang = {
            list = '*Idiomas disponibles:*',
            success = '*New language set:* &&&1'
        },
		banhammer = {
            kicked = '&&&1 ha sido expulsado! (pero puede volver a entrar)',
            banned = '&&&1 ha sido baneado!',
            unbanned = 'User unbanned!',
            reply = 'Responder a alguien',
            globally_banned = '&&&1 ha sido baneado globalmente!',
            no_unbanned = 'Este es un grupo normal, los miembros no son bloqueados al expulsarlos',
            already_banned_normal = '&&&1 is *already banned*!',
            not_banned = 'The user is not banned',
            banlist_header = '*Banned users*:\n\n',
            banlist_empty = '_The list is empty_',
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` no es un valor valido!\nel valor tiene que ser *mayor* que `3` y *menor* que `26`',
            not_changed = 'El numero maximo de mensajes que pueden ser enviados en 5 segundos es &&&1',
            changed_plug = 'El numero maximo de mensajes que pueden ser enviados en 5 segundos por &&&1 a &&&2',
            enabled = 'Antiflood activado',
            disabled = 'Antiflood desactivado',
            kick = 'Los flooders seran expulsados',
            ban = 'Los flooders seran baneados',
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
			warn = 'Este tipo de multimedia *no esta permitida* en este grupo.\n_La proxima vez_ seras baneado o expulsado',
            settings_header = '*Ajustes actuales de multimedia*:\n\n',
            changed = 'Nuevo estado para [&&&1] = &&&2',
        },
        preprocess = {
            flood_ban = '&&&1 *baneado* por flood',
            flood_kick = '&&&1 *expulsado* por flood',
            media_kick = '&&&1 *expulsado*: multimedia no permitido',
            media_ban = '&&&1 *baneado*: multimedia no permitido',
            rtl_kicked = '&&&1 *expulsado*: caracter rtl en el nombre/mensage no permitido',
            arab_kicked = '&&&1 *expulsado*: mensaje arabe detectado',
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
            first_warn = 'This type of media is *not allowed* in this chat.'
        },
        kick_errors = {
            [1] = 'No soy administrador, no puedo expulsar miembros',
            [2] = 'No puedo expulsar ni banear administradores',
            [3] = 'No hay necesidad de desbanear en un grupo normal',
            [4] = 'This user is not a chat member',
        },
        flag = {
            no_input = 'Responde al mensaje para reportarlo al administrador o escribe algo despues de \'@admin\' para enviarle un mensaje',
            reported = '¡Reportado!',
            no_reply = '¡Menciona a un miembro!',
            blocked = 'El miembro ya no puede usar \'@admin\'',
            already_blocked = 'El miembro ya no puede usar \'@admin\'',
            unblocked = 'El miembro ya puede usar \'@admin\'',
            already_unblocked = 'El miembro ya puede usar \'@admin\'',
        },
        all = {
            dashboard = {
                private = '_I\'ve sent you the group dashboard in private_',
                first = 'Navigate this message to see *all the info* about this group!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            menu = 'I\'ve sent you the settings menu in private',
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
    br = {
        status = {
            kicked = '&&&1 já foi banido deste grupo.',
            left = '&&&1 deixou o grupo ou fui expulso/desbanido.',
            administrator = '&&&1 é o administrador do grupo',
            creator = '&&&1 é o criador do grupo.',
            unknown = 'Não está no grupo.',
            member = '&&&1 is a chat member'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_Enviei a mensagem no seu privado_',
            no_user = 'I\'ve never seen this user before.\nIf you want to teach me who he is, forward me a message from him',
            the_group = 'the group',
            adminlist_admin_required = 'I\'m not a group Admin.\n*Only an Admin can see the administrators list*',
            mods_list = '*Group moderators*:\n&&&1',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Responda alguém!* Não reconheci o *username*',
            too_long = 'This text is too long, I can\'t send it',
            msg_me = '_Message me first so I can message you_',
            menu_cb_settings = 'Clique em um botãl!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*ID do grupo*: &&&1'
        },
        not_mod = 'Você *não* é um(a) moderador(a)',
        breaks_markdown = 'This text breaks the markdown.\nMore info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).',
        credits = '*Clique em alguma informação desejada abaixo:*',
        extra = {
            setted = '&&&1 comando salvo!',
			usage = 'Escreva ao lado de /extra o título do comando e o texto associado.\nPor exemplo:\n/extra #motm seja positivo. O bot irá respoder _\'seja positivo\'_ toda vez que alguém digitar #motm',
            new_command = '*Novo comando definido!*\n&&&1\n&&&2',
            no_commands = 'Sem comandos definidos!',
            commands_list = 'Lista de *comandos personalizados*:\n&&&1',
            command_deleted = 'O comando &&&1 foi deletado',
            command_empty = 'O comando &&&1 não existe'
        },
        help = {
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [por resposta|username]` = remover o usuário do grupo (poderá retornar).\n"
                            .."`/ban [por resposta|username]` = bamir o usuário do grupo (não poderá voltar).\n"
                            .."`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.\n"
                            .."`/unban [by reply|username]` = Desbanir um usuário que havia sido banido anteriormente.\n"
                            .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
                            .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                            .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban).\n"
                            .."`/banlist -` = clean the banlist.\n"
                            .."\n*Note*: you can write something after `/ban` command (or after the username, if you are banning by username)."
                            .." This comment will be used as the motivation of the ban.",
                info = "*Moderators: info about the group*\n\n"
                        .."`/setrules [group rules]` = define as regras para o grupo (the old will be overwritten).\n"
                        .."`/addrules [text]` = acrescentar algo as regras já definidas.\n"
                        .."`/setabout [group description]` = define a descrição do grupo (the old will be overwritten).\n"
                        .."`/addabout [text]` = acrescentar algo a descrição do grupo já definida.\n"
                        .."\n*Note:* the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.\n"
                        .."For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel",
                flood = "*Moderators: flood settings*\n\n"
                        .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
                        .."`/antiflood [number]` = define a quantia de mensagems permitidas dentro de 5 segundos.\n"
                        .."_Note_ : mínimo: *4* e máximo *25*.\n",
                media = "*Moderators: media settings*\n\n"
                        .."`/media` = receive via private message an inline keyboard to change all the media settings.\n"
                        .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
                        .."`/media list` = show the current settings for all the media.\n"
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*Moderators: welcome settings*\n\n"
                            .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
                            .."\n*Custom welcome message:*\n"
                            .."`/welcome Welcome $name, enjoy the group!`\n"
                            .."Write after \"/welcome\" your welcome message. You can use some placeholders to include the name/username/id of the new member of the group\n"
                            .."Placeholders: _$username_ (will be replaced with the username); _$name_ (will be replaced with the name); _$id_ (will be replaced with the id); _$title_ (will be replaced with the group title).\n"
                            .."\n*GIF/sticker as welcome message*\n"
                            .."You can use a particular gif/sticker as welcome message. To set it, reply to a gif/sticker with \'/welcome\'\n"
                            .."\n*Composed welcome message*\n"
                            .."You can compose your welcome message with the rules, the description and the moderators list.\n"
                            .."You can compose it by writing `/welcome` followed by the codes of what the welcome message has to include.\n"
                            .."_Codes_ : *r* = rules; *a* = description (about); *m* = adminlist.\n"
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
                        .."`/warn [kick/ban]` = define uma ação para quando o usuário atingir o limite de advertências.\n"
                        .."`/warn [by reply]` = advertir tal usuário. Once the max number is reached, he will be kicked/banned.\n"
                        .."`/warnmax` = set the max number of the warns before the kick/ban.\n"
                        .."`/getwarns [by reply]` = visualizar a quantia de advertências dadas ao usuário.\n"
                        .."`/nowarns (by reply)` = resetar todas advertências do usuário (*NOTE: both regular warnings and media warnings*).\n",
                char = "*Moderators: special characters*\n\n"
                        .."`/menu` = you will receive in private the menu keyboard.\n"
                        .."Here you will find two particular options: _Arab and RTL_.\n"
                        .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                        .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
                        .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                links = "*Moderators: links*\n\n"
                        ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by other admins, or unset it\n'
                        .."`/link` = enviar o link do grupo, if already setted by the owner\n"
                        .."`/setpoll [pollbot link]` = save a poll link from @pollbot. Once setted, moderators can retrieve it with `/poll`.\n"
                        .."`/setpoll no` = delete the current poll link.\n"
                        .."`/poll` = get the current poll link, if setted\n"
                        .."\n*Note*: the bot can recognize valid group links/poll links. If a link is not valid, you won't receive a reply.",
                lang = "*Moderators: group language*\n\n"
                        .."`/lang` = choose the group language (can be changed in private too).\n"
                        .."\n*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english)."
                        .."\nAnyway, translations are open to everyone. Use `/strings` command to receive a _.lua_ file with all the strings (in english).\n"
                        .."Use `/strings [lang code]` to receive the file for that specific language (example: _/strings es_ ).\n"
                        .."In the file you will find all the instructions: follow them, and as soon as possible your language will be available ;)",
                settings = "*Moderators: group settings*\n\n"
                            .."`/menu` = manage the group settings in private with an handy inline keyboard.\n"
                            .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
                            .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
                            .."`/report [on/off]` (by reply) = the user won't be able (_off_) or will be able (_on_) to use \"@admin\" command.\n",
            },
            all = '*Comandos para todos*:\n'
                    ..'`/dashboard` : see all the group info from private\n'
                    ..'`/rules` (se desbloqueado) : mostra as regra do grupo\n'
                    ..'`/about` (se desbloqueado) : mostra a descrição do grupo \n'
                    ..'`/adminlist` (se desbloqueado) : mostra a lista de moderadores(as) do group\n'
                    ..'`@admin` (se desbloqueado) : by reply= report the message replied to all the admins; no reply (with text)= send a feedback to all the admins\n'
                    ..'`/kickme` : remover você do grupo\n'
                    ..'`/faq` : some useful answers to frequent quetions\n'
                    ..'`/id` : show the chat id, or the id of an user if by reply\n'
                    ..'`/echo [text]` : repitir o texto desejado (markdown permitido, available only in private for non-admin users)\n'
                    ..'`/info` : mostra algumas informações úteis sobre o bot\n'
                    ..'`/group` : get the discussion group link\n'
                    ..'`/c` <feedback> : envia um feedback/bug/pergunta ao meu criador. _TODO TIPO DE SUGESTÃO OU PEDIDO DE FUNCIONALIDADE É BEM-VINDO_. Ele irá responder o mais breve possível\n'
                    ..'`/help` : exibe esta mensagem.'
		            ..'\n\nSe você gosta deste bot, por favor vote no quanto você acha que ele merece [aqui](https://telegram.me/storebot?start=groupbutler_bot)',
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
			group_success = '_Eu enviei a mensagem de ajuda no privado_',
			group_not_success = '_Caso você nunca tenha me usado, me *inicie* e envie o comando /help por aqui novamente_',
			initial = '*Clique em algum comando abaixo:*',
			kb_header = 'Tap on a button to see the *related commands*'
        },
        links = {
            no_link = '*Sem link* para este grupo. Peça ao dono para gerar um',
            link = '[&&&1](&&&2)',
            link_invalid = 'Esse link *não é válido!*',
            link_no_input = 'This is not a *public supergroup*, so you need to write the link near /setlink',
            link_updated = 'O link foi atualizado.\n*Aqui está o novo link*: [&&&1](&&&2)',
            link_setted = 'O link foi definido.\n*Aqui está o link*: [&&&1](&&&2)',
            link_unsetted = 'Link *desativado*',
            poll_unsetted = 'Enquete *desativada*',
            poll_updated = 'A enquete foi atualizada.\n*Vote aqui*: [&&&1](&&&2)',
            poll_setted = 'O link foi definido.\n*Vote aqui*: [&&&1](&&&2)',
            no_poll = '*Nenhuma enquete disponível* para este grupo',
            poll = '*Vote aqui*: [&&&1](&&&2)'
        },
        mod = {
            modlist = '*Criador*:\n&&&1\n\n*Admins*:\n&&&2'
        },
        report = {
            no_input = 'Envie suas sugestões/bugs/dúvidas com !\nExample: !hello, this is a test',
            sent = '*Feedback enviado!*',
            feedback_reply = '*Olá, isto é uma resposta do dono do bot*:\n&&&1',
        },
        service = {
            welcome = 'Olá, &&&1, e seja bem-vindo(a) ao *&&&2*!',
            welcome_rls = 'Anarquia total!',
            welcome_abt = 'Sem descrição para este grupo.',
            welcome_modlist = '\n\n*Creator*:\n&&&1\n*Admins*:\n&&&2',
            abt = '\n\n*Descrição*:\n',
            rls = '\n\n*Regras*:\n',
        },
        setabout = {
            no_bio = '*SEM DESCRIÇÃO* para este grupo.',
            no_bio_add = '*Sem descrição para este grupo*.\nUse /setabout [descrição] para definir uma nova descrição',
            no_input_add = 'Por favor escreva algo após este pobre "/addabout"',
            added = '*Descrição adicionada:*\n"&&&1"',
            no_input_set = 'Por favor escreva algo após este pobre "/setabout"',
            clean = 'A descrição foi limpada.',
            new = '*Nova descrição:*\n"&&&1"',
            about_setted = 'New description *saved successfully*!'
        },
        setrules = {
            no_rules = '*Anarquia total*!',
            no_rules_add = '*Sem regras* para este grupo.\nUse /setrules [regras] para definir uma nova constituição',
            no_input_add = 'Por favor adicione algo após este pobre "/addrules"',
            added = '*Regras adicionadas:*\n"&&&1"',
            no_input_set = 'Por favor escreva algo após este pobre "/setrules"',
            clean = 'As regras foram removidas.',
            new = '*Novas regras:*\n"&&&1"',
            rules_setted = 'New rules *saved successfully*!'
        },
        settings = {
            disable = {
                rules_locked = 'O comando /rules agora está disponível apenas para moderadores(as)',
                about_locked = 'O comando /about agora está disponível apenas para moderadores(as)',
                welcome_locked = 'Mensagem de boas-vindas não será mostrada a partir de agora',
                modlist_locked = 'O comando /adminlist agora está disponível apenas para moderadores(as)',
                flag_locked = 'O comando /flag não estará disponível a partir de agora',
                extra_locked = 'Comandos #extra agora estão disponíveis apenas para moderadores(as)',
                rtl_locked = 'Anti-RTL agora está ativado',
                flood_locked = 'Anti-flood is now off',
                arab_locked = 'Anti-árabe agora está ativado',
                report_locked = 'O comando @admin não estará disponível a partir de agora',
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                rules_unlocked = 'O comando /rules agora está disponível para todos(as)',
                about_unlocked = 'O comando /about agora está disponível para todos(as)',
                welcome_unlocked = 'Mensagem de boas-vindas será mostrada a partir de agora',
                modlist_unlocked = 'O comando /adminlist agora está disponível para todos(as)',
                flag_unlocked = 'O comando /flag agora está disponível',
                extra_unlocked = 'Comandos # Extra agora estão disponíveis para todos(as)',
                rtl_unlocked = 'Anti-RTL agora está desligado',
                flood_unlocked = 'Anti-flood is now on',
                arab_unlocked = 'Anti-árabe agora está desligado',
                report_unlocked = 'O comando @admin agora está disponível',
                admin_mode_unlocked = 'Admin mode on',
            },
            welcome = {
                no_input = 'Bem-vindo(a) e...?',
                media_setted = 'New media setted as welcome message: ',
                reply_media = 'Reply to a `sticker` or a `gif` to set them as *welcome message*',
                a = 'Nova configuração para a mensagem de boas-vindas:\nRegras\n*Descrição*\nLista de moderadores(as)',
                r = 'Nova configuração para a mensagem de boas-vindas:\n*Regras*\nDescrição\nLista de moderadores(as)',
                m = 'Nova configuração para a mensagem de boas-vindas:\nRegras\nDescrição\n*Lista de moderadores(as)*',
                ra = 'Nova configuração para a mensagem de boas-vindas:\n*Regras*\n*Descrição*\nLista de moderadores(as)',
                rm = 'Nova configuração para a mensagem de boas-vindas:\n*Regras*\nDescrição\n*Lista de moderadores(as)*',
                am = 'Nova configuração para a mensagem de boas-vindas:\nRegras\n*Descrição*\n*Lista de moderadores(as)*',
                ram = 'Nova configuração para a mensagem de boas-vindas:\n*Regras*\n*Descrição*\n*Lista de moderadores(as)*',
                no = 'Nova configuração para a mensagem de boas-vindas:\nRegras\nDescrição\nLista de moderadores(as)',
                wrong_input = 'Argumento inválido.\nUse _/welcome [no|r|a|ra|ar]_',
                custom = '*Custom welcome message* setted!\n\n&&&1',
                custom_setted = '*Custom welcome message saved!*',
                wrong_markdown = '_Not setted_ : I can\'t send you back this message, probably the markdown is *wrong*.\nPlease check the text sent',
            },
            resume = {
                header = 'Atuais configurações para *&&&1*:\n\n*Idioma*: `&&&2`\n',
                w_a = '*Tipo de boas-vindas*: `boas-vindas + descrição`\n',
                w_r = '*Tipo de boas-vindas*: `boas-vindas + regras`\n',
                w_m = '*Tipo de boas-vindas*: `boas-vindas + lista de moderadores(as)`\n',
                w_ra = '*Tipo de boas-vindas*: `boas-vindas + regras + descrição`\n',
                w_rm = '*Tipo de boas-vindas*: `boas-vindas + regras + lista de moderadores(as)`\n',
                w_am = '*Tipo de boas-vindas*: `boas-vindas + descrição + lista de moderadores(as)`\n',
                w_ram = '*Tipo de boas-vindas*: `boas-vindas + regras + descrição + lista de moderadores(as)`\n',
                w_no = '*Tipo de boas-vindas*: `boas-vindas apenas`\n',
                w_media = '*Tipo de boas-vindas*: `gif/sticker`\n',
                w_custom = '*Tipo de boas-vindas*: `custom message`\n',
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_'
		    },
		    char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
		    broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            Rules = '/rules',
            About = '/about',
            Welcome = 'Mensagem de boas-vindas',
            Modlist = '/adminlist',
            Flag = 'Flag',
            Extra = 'Extra',
			Flood = 'Anti-flood',
            Rtl = 'Rtl',
            Arab = 'Árabe',
            Report = 'Denúncia',
            Admin_mode = 'Admin mode',
        },
        warn = {
            warn_reply = 'Responda a uma mensagem para adventir o(a) usuário(a)',
            changed_type = 'Nova ação ao receber máximo número de advertências: *&&&1*',
			mod = 'Moderadores(as) não podem ser advertidos',
			warned_max_kick = 'Usuário(a) &&&1 *removido(a)*: atingiu o número máximo de advertências',
            warned_max_ban = 'Usuário(a) &&&1 *banido(a)*: atingiu o número máximo de advertências',
            warned = '*Usuário(a)* &&&1 *foi advertido(a).*\n_Número de advertências_   *&&&2*\n_Máximo permitido_   *&&&3*',
            warnmax = 'Número máximo de advertências foi alterado&&&3.\n*Antigo* valor: &&&1\n*Novo* valor: &&&2',
            getwarns_reply = 'Responda a um(a) usuário(a) para verificar seu número de advertências',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            nowarn_reply = 'Responda a um(a) usuário(a) para deletar suas advertências',
            ban_motivation = 'too many warnings',
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            nowarn = 'O número de advertências recebidas por este(a) usuário(a) foi *resetado*'
        },
        setlang = {
            list = '*Lista de idiomas disponíveis:*',
            success = '*Novo idioma selecionado:* &&&1'
        },
		banhammer = {
            kicked = '&&&1 foi removido(a)! Ainda pode entrar no grupo',
            banned = '&&&1 foi banido(a)!',
            unbanned = 'User unbanned!',
			reply = 'Responda alguém',
            globally_banned = '&&&1 foi banido(a) globalmente!',
            no_unbanned = 'Este é um grupo comum, pessoas não são bloqueadas quando excluídas',
            already_banned_normal = '&&&1 is *already banned*!',
            not_banned = 'The user is not banned',
            banlist_header = '*Banned users*:\n\n',
            banlist_empty = '_The list is empty_',
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` não é um número válido!\nO valor deve ser *maior* que `3` e *menor* que `26`',
            not_changed = 'O número máximo de mensagens que podem ser enviadas em 5 segundos já é &&&1',
            changed_plug = 'O número máximo de mensagen que podem ser enviadas em 5 segundos foi alterada de &&&1 para &&&2',
            enabled = 'Antiflood habilitado',
            disabled = 'Antiflood desabilitado',
            kick = 'Agora floodadores(as) serão removidos(as)',
            ban = 'Agora floodadores(as) serão banidos(as)',
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
			warn = 'Esse tipo de mídia *não é permitida* neste grupo.\n_Na próxima vez_ voce séra removido(a) ou banido(a)',
            settings_header = '*Atuais configurações de midia*:\n\n',
            changed = 'Novo estado para [&&&1] = &&&2',
        },
        preprocess = {
            flood_ban = '&&&1 *banido(a)* por flood',
            flood_kick = '&&&1 *removido(a)* por flood',
            media_kick = '&&&1 *removido(a)*: midia enviada não permitida',
            media_ban = '&&&1 *banido(a)*: midia enviada não permitida',
            rtl_kicked = '&&&1 *removido(a)*: caracteres RTL (Right-to-Left, Direita para esquerda) em nomes/mensagens não são permitidos',
            arab_kicked = '&&&1 *removido(a)*: mensagem em árabe detectada',
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
            first_warn = 'This type of media is *not allowed* in this chat.'
        },
        kick_errors = {
            [1] = 'Não sou admin, não posso remover pessoas',
            [2] = 'Não posso remover ou banir um(a) admin',
            [3] = 'Não há necessidade de desbanir num grupo comum',
            [4] = 'This user is not a chat member',
        },
        flag = {
            no_input = 'Responda a uma mensagem para reportá-la para um(a) moderador(a) ou escreva algo ao lado de \'@admin\' para enviar um feedback a eles(as)',
            reported = 'Denunciado!',
            no_reply = 'Responda a um(a) usuário(a)!',
            blocked = 'O(A) usuário(a) a partir de agora não pode usar \'@admin\'',
            already_blocked = 'O(a) usuário(a) já está impedido(a) de usar \'@admin\'',
            unblocked = 'O(a) usuário(a) agora está permitido(a) a usar \'@admin\'',
            already_unblocked = 'O(a) usuário(a) já está permitido(a) a usar \'@admin\'',
        },
        all = {
            dashboard = {
                private = '_I\'ve sent you the group dashboard in private_',
                first = 'Navigate this message to see *all the info* about this group!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            menu = 'I\'ve sent you the settings menu in private',
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
    ru = {
        status = {
            kicked = '&&&1 is banned from this group',
            left = '&&&1 left the group or has been kicked and unbanned',
            administrator = '&&&1 is an Admin',
            creator = '&&&1 is the group creator',
            unknown = 'This user has nothing to do with this chat',
            member = '&&&1 is a chat member'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'Я не видел этого человека раньше.\nЕсли ты хочешь объяснить мне, кто он, сделай мне forward его сообщения',
            the_group = 'Группа',
            adminlist_admin_required = 'I\'m not a group Admin.\n*Only an Admin can see the administrators list*',
            settings_header = 'Текущие настройки для *the group*:\n\n*Язык*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            too_long = 'This text is too long, I can\'t send it',
            msg_me = '_Чтобы я мог тебе писать, сначала напиши мне_',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*ID группы*: &&&1'
        },
        not_mod = 'Ты *не* модератор',
        breaks_markdown = 'Этот текст содержит ошибку (markdown).\nИнформация о правильном использовании markdown [здесь](https://telegram.me/GroupButler_ch/46).',
        credits = '*Some useful links:*',
        extra = {
            setted = '&&&1 command saved!',
			usage = 'Напиши после /extra хэштег и текст, который будет печататься при написании этого хэштега.\nНапример:\n/extra #hello Приветствую. Бот будет печатать _\' Приветствую\'_ каждый раз, когда кто-то будет писать #hello',
            new_command = '*Команд�� установлена!*\n&&&1\n&&&2',
            no_commands = ' Нет команд!',
            commands_list = 'Список *установленных команд*:\n&&&1',
            command_deleted = '&&&1 команда удалена',
            command_empty = '&&&1 такой команды не существует'
        },
        help = {
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n"
                            .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
                            .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                            .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban).\n"
                            .."`/banlist -` = clean the banlist.\n"
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
                        .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
                        .."`/antiflood [number]` = set how many messages a user can write in 5 seconds.\n"
                        .."_Note_ : the number must be higher than 3 and lower than 26.\n",
                media = "*Moderators: media settings*\n\n"
                        .."`/media` = receive via private message an inline keyboard to change all the media settings.\n"
                        .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
                        .."`/media list` = show the current settings for all the media.\n"
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*Moderators: welcome settings*\n\n"
                            .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
                            .."\n*Custom welcome message:*\n"
                            .."`/welcome Welcome $name, enjoy the group!`\n"
                            .."Write after \"/welcome\" your welcome message. You can use some placeholders to include the name/username/id of the new member of the group\n"
                            .."Placeholders: _$username_ (will be replaced with the username); _$name_ (will be replaced with the name); _$id_ (will be replaced with the id); _$title_ (will be replaced with the group title).\n"
                            .."\n*GIF/sticker as welcome message*\n"
                            .."You can use a particular gif/sticker as welcome message. To set it, reply to a gif/sticker with \'/welcome\'\n"
                            .."\n*Composed welcome message*\n"
                            .."You can compose your welcome message with the rules, the description and the moderators list.\n"
                            .."You can compose it by writing `/welcome` followed by the codes of what the welcome message has to include.\n"
                            .."_Codes_ : *r* = rules; *a* = description (about); *m* = adminlist.\n"
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
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n",
                char = "*Moderators: special characters*\n\n"
                        .."`/menu` = you will receive in private the menu keyboard.\n"
                        .."Here you will find two particular options: _Arab and RTL_.\n"
                        .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                        .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
                        .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                links = "*Moderators: links*\n\n"
                        ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by other admins, or unset it\n'
                        .."`/link` = get the group link, if already setted by the owner\n"
                        .."`/setpoll [pollbot link]` = save a poll link from @pollbot. Once setted, moderators can retrieve it with `/poll`.\n"
                        .."`/setpoll no` = delete the current poll link.\n"
                        .."`/poll` = get the current poll link, if setted\n"
                        .."\n*Note*: the bot can recognize valid group links/poll links. If a link is not valid, you won't receive a reply.",
                lang = "*Moderators: group language*\n\n"
                        .."`/lang` = choose the group language (can be changed in private too).\n"
                        .."\n*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english)."
                        .."\nAnyway, translations are open to everyone. Use `/strings` command to receive a _.lua_ file with all the strings (in english).\n"
                        .."Use `/strings [lang code]` to receive the file for that specific language (example: _/strings es_ ).\n"
                        .."In the file you will find all the instructions: follow them, and as soon as possible your language will be available ;)",
                settings = "*Moderators: group settings*\n\n"
                            .."`/menu` = manage the group settings in private with an handy inline keyboard.\n"
                            .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
                            .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
                            .."`/report [on/off]` (by reply) = the user won't be able (_off_) or will be able (_on_) to use \"@admin\" command.\n",
            },
            all = '*Команды для всех*:\n'
                    ..'`/rules` (если включено) : показать правила группы\n'
                    ..'`/about` (если включено) : показать описание группы\n'
                    ..'`/adminlist` (если включено) : показать модераторов этой группы\n'
                    ..'`@admin` (если включено) : ответом= жалоба на это сообщение будет отправлена всем модераторам | без ответа (но с текстом после @admin)= отправит этот текст всем модераторам\n'
                    ..'`/kickme` : get kicked by the bot\n'
                    ..'`/faq` : some useful answers to frequent quetions\n'
                    ..'`/id` : show the chat id, or the id of an user if by reply\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown, available only in private for non-admin users)\n'
                    ..'`/info` : показать информацию о боте\n'
                    ..'`/group` : get the discussion group link\n'
                    ..'`/c` <сообщение> : отправить текст/ отчет об ошибке/ вопрос моему создателю . _Любая темя обсуждения и общения приветствуется_. Он ответит тебе здесь\n'
                    ..'`/help` : show this message.'
		            ..'\n\nЕсли тебе нравится этот бот, то ты можешь оценить его и заплатить эту ссылку куда-нибудь. Поставь свою оценку [ТУТ](https://telegram.me/storebot?start=groupbutler_bot)',
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
            group_success = '_Я отправил тебе приватное сообщение_',
            group_not_success = '_Сначала напиши мне, потом я смогу писать тебе_',
            initial = 'Выбери *роль*, которую ты хочешь посмотреть:',
            kb_header = 'Tap on a button to see the *related commands*'
        },
        links = {
            no_link = '*Нет ссылки* на это группу. Попроси главного сгенерировать ссылку',
            link = '[&&&1](&&&2)',
            link_invalid = 'Эта ссылка *неправильна!*',
            link_no_input = 'This is not a *public supergroup*, so you need to write the link near /setlink',
            link_updated = 'Ссылка была обновлена. \n*Вот новая ссылка*: [&&&1](&&&2)',
            link_setted = 'Ссылка установлена.\n*Вот новая ссылка*: [&&&1](&&&2)',
            link_unsetted = 'Ссылка *удалена*',
            poll_unsetted = 'Опрос*удален*',
            poll_updated = 'Опрос обновлен.\n*Голосуй здесь*: [&&&1](&&&2)',
            poll_setted = 'Ссылка установлена! \n*Голосуй здесь*: [&&&1](&&&2)',
            no_poll = '*Нет активных опросов* для этой группы',
            poll = '*Голосуй здесь*: [&&&1](&&&2)'
        },
        mod = {
            modlist = '*Creator*:\n&&&1\n\n*Admins*:\n&&&2'
        },
        report = {
            no_input = 'Напиши свои идеи / баги /ошибки после !\nExample: !hello, this is a test',
            sent = ' Отправлено!',
            feedback_reply = '*Привет, это ответ от создателя *:\n&&&1',
        },
        service = {
            welcome = 'Привет, &&&! Добро пожаловать в *&&&2*!',
            welcome_rls = 'АНАРХИЯ!',
            welcome_abt = 'Описание этой группы отсутствует!',
            welcome_modlist = '\n\n*Creator*:\n&&&1\n*Admins*:\n&&&2',
            abt = '\n\n*Описание*:\n',
            rls = '\n\n*Правила*:\n',
        },
        setabout = {
            no_bio = 'Описание этой группы *отсутствует*.',
            no_bio_add = 'Описание этой группы *отсутствует*.\nИспользуй /setabout [описание], чтобы установить описание для группы',
            no_input_add = ' Пожалуйста, напиши что-нибудь после "/addabout"',
            added = '* Описание добавлено:*\n"&&&1"',
            no_input_set = ' Пожалуйста, напиши что-нибудь после "/setabout"',
            clean = ' Описание было изменено.',
            new = '*Новое описание:*\n"&&&1"',
            about_setted = 'New description *saved successfully*!'
        },
        setrules = {
            no_rules = '*ТОЛЬКО АНАРХИЯ*!',
            no_rules_add = 'У этой группы *нет правил*.\nИспользуй /setrules [правила], чтобы добавить правила',
            no_input_add = 'Пожалуйста, напиши что-нибудь после "/addrules"',
            added = '*Правила добавлены:*\n"&&&1"',
            no_input_set = 'Пожалуйста, напиши что-нибудь после "/setrules"',
            clean = 'Правила были очищены.',
            new = '*Новые правила:*\n"&&&1"',
            rules_setted = 'New rules *saved successfully*!'
        },
        settings = {
            disable = {
                rules_locked = '/rules теперь доступна только для модераторов',
                about_locked = '/about теперь доступна только для модераторов',
                welcome_locked = 'Приветственное сообщение теперь не будет показано.',
                modlist_locked = '/adminlist теперь доступна только для модераторов',
                flag_locked = '/flag теперь не будет доступна',
                extra_locked = '#extra теперь доступна только для модераторов',
                rtl_locked = 'Anti-RTL фильтр включен',
                flood_locked = 'Antiflood is nor off',
                arab_locked = 'Anti-arab фильтр включен',
                report_locked = '@admin теперь не будет доступна',
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                rules_unlocked = '/rules команда теперь доступна всем',
                about_unlocked = '/about теперь доступна для всех',
                welcome_unlocked = 'Приветственное сообщение теперь будет показываться',
                modlist_unlocked = '/adminlist теперь доступна для всех',
                flag_unlocked = '/flag теперь включена',
                extra_unlocked = 'Extra # теперь доступна для всех',
                rtl_unlocked = 'Anti-RTL фильтр выключен',
                flood_unlocked = 'Аnti-flood is now on',
                arab_unlocked = 'Anti-arab фильтр тепепь выключен',
                report_unlocked = '@admin теперь включена',
                admin_mode_unlocked = 'Admin mode on',
            },
            welcome = {
                no_input = 'Привет и ...?',
                a = 'Новые настройки в приветственном сообщении:\nПравила\n*Описание*\nСписок модераторов',
                r = 'Новые настройки в приветственном сообщении:\n*Правила*\nОписание\nСписок модераторов',
                m ='Новые настройки в приветственном сообщении:\nПравила\nОписание\n*Список модераторов*',
                ra = 'Новые настройки в приветственном сообщении:\n*Правила*\n*Описание*\nСписок модераторов',
                rm = 'Новые настройки в приветственном сообщении:\n*Правила*\nОписание\n*Список модераторов*',
                am = 'Новые настройки в приветственном сообщении:\nПравила\n*Описание*\n*Список модераторов*',
                ram = 'Новые настройки в приветственном сообщении\n*Правила*\n*Описание*\n*Список модераторов*',
                no = 'Новые настройки в приветственном сообщении:\nПравила\nОписание\nСписок модераторов',
                wrong_input = 'Неправильный аргумент.\nИспользуй _/welcome [no|r|a|ra|ar]_',
                media_setted = 'New media setted as welcome message: ',
                reply_media = 'Reply to a `sticker` or a `gif` to set them as *welcome message*',
                custom = '*Custom welcome message* setted!\n\n&&&1',
                custom_setted = '*Custom welcome message saved!*',
                wrong_markdown = '_Not setted_ : I can\'t send you back this message, probably the markdown is *wrong*.\nPlease check the text sent',
            },
            resume = {
                header = 'Текущие настройки для *&&&1*:\n\n*Язык*: `&&&2`\n',
                w_a = '*Тип приветствия*: `Привет + описание`\n',
                w_r = '*Тип приветствия*: `Привет + правила`\n',
                w_m = '*Тип приветствия*: `Привет + список модераторов`\n',
                w_ra = '*Тип приветствия*: `Привет + правила + описание`\n',
                w_rm = '*Тип приветствия*: `Привет + правила + список модераторов`\n',
                w_am = '*Тип приветствия*: `Привет + описание + список модераторов`\n',
                w_ram = '*Тип приветствия*: `Привет+ правила + описание + список модераторов`\n',
                w_no = '*Тип приветствия*: `Только приветствие`\n',
                w_media = '*Welcome type*: `gif/sticker`\n',
                w_custom = '*Welcome type*: `custom message`\n',
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_'
            },
            char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
            broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            Rules = '/rules',
            About = '/about',
            Welcome = 'Приветственное сообщение',
            Modlist = '/adminlist',
            Flag = 'Флаг',
            Extra = 'Экстра',
            Flood = 'Anti-flood',
            Rtl = 'Rtl',
            Arab = 'Арабский',
            Report = 'Жалоба',
            Admin_mode = 'Admin mode',
        },
        warn = {
            warn_reply = 'Ответь на сообщение пользователя, на которого ты хочешь пожаловаться',
            changed_type = 'Новое максимальное количество предупреждений: *&&&1*',
            mod = 'Модераторы не могут быть предупреждены',
            warned_max_kick = 'Пользователь &&&1 *кикнут* по причине достижения максимального количества предупреждений',
            warned_max_ban = 'Пользователь &&&1 *забанен* по причине достижения максимального количества предупреждений',
            warned = '*Пользователь* &&&1 *был предупрежден!*\n_Количество предупреждений_   *&&&2*\n_Максимальное разрешение_   *&&&3*',
            warnmax = 'Макмимальное количество предупреждений изменено&&&3.\n*Старое* значение: &&&1\n*Новое* значение: &&&2',
            getwarns_reply = 'Ответь на сообщение пользователя, у которого хочешь проверить количество предупреждений',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            nowarn_reply = 'Ответь на сообщение пользователя, чтобы обнулить его счетчик предупреждений',
            ban_motivation = 'too many warnings',
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            nowarn = 'Количество предупреждений у этого пользователя *сброшено*'
        },
        setlang = {
            list = '*Список доступных языков:*',
            success = '*Новый язык установлен:* &&&1'
        },
		banhammer = {
            kicked = '&&&1 был кикнут! ( все еще может зайти )',
            banned = '&&&1 был забанен!',
            already_banned_normal = '&&&1 *уже забанен*!',
            unbanned = 'User unbanned!',
            reply = 'Ответь (reply) на сообщение этого пользователя',
            globally_banned = '&&&1 был глобально забанен!',
            not_banned = 'Это обычная группа, пользователи не блокируются, когда кикаются из группы',
            banlist_header = '*Banned users*:\n\n',
            banlist_empty = '_The list is empty_',
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` неправильное число!\nЧисло должно быть *больше* чем `3` и *меньше* чем `26`',
            not_changed = 'Максимальное количество сообщений, которые можно отправить за 5 секунд уже &&&1',
            changed_plug = 'Максимальное количество сообщений, которые можно отправить за 5 секунд изменено с &&&1 на &&&2',
            enabled = 'Антифлуд фильтр включен',
            disabled = 'Антифлуд фильтр выключен',
            kick = 'Теперь флудеры будут кикнуты',
            ban = 'Теперь флудеры будут забанены',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself',
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
			warn = 'Этот тип медиа *не разрешен* в этой группе.\n_В следующий раз_ ты будешь кикнут или забанен',
            settings_header = '*Текущие настройки для медиа*:\n\n',
            changed = 'Новый статус для [&&&1] = &&&2',
        },
        preprocess = {
            flood_ban = '&&&1 *забанен* за флуд',
            flood_kick = '&&&1 *кикнут* за флуд',
            media_kick = '&&&1 *кикнут*: отправленный тип медиа не разрешен',
            media_ban = '&&&1 *забанен*: отправленный тип медиа не разрешен',
            rtl_kicked = '&&&1 *кикнут*: rtl символы в имени/сообщениях не разрешены',
            arab_kicked = '&&&1 *кикнут*: арабские сообщения обнаружены',
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
            first_warn = 'This type of media is *not allowed* in this chat.'
        },
        kick_errors = {
            [1] = 'Я не администратор этой группы, я не могу кикать людей', --1
            [2] = 'Я не могу кикать или банить администратора',--2
            [3] = 'Нет необходимости на разбан, это обычная группа',--3
            [4] = 'Этот пользователь не состоит в чате',--4
        },
        flag = {
            no_input = 'Ответь на сообщение с текстом @admin, чтобы рассказать о нарушении всей администрации или напиши свое сообщение после @admin и оно тоже отправится всей администрации',
            reported = 'Жалоба отправлена!',
            no_reply = 'Ответь пользователю на сообщение!',
            blocked = 'Теперь этот пользователь не сможет использовать команду \'@admin\'',
            already_blocked = 'Пользователь уже заблокирован на использование команды \'@admin\'',
            unblocked = 'Теперь пользователь сможет использовать команду "@admin"',
            already_unblocked = 'Пользователь уже мог использовать команду "@admin"',
        },
        all = {
            dashboard = {
                private = '_I\'ve sent you the group dashboard in private_',
                first = 'Navigate this message to see *all the info* about this group!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            menu = 'Я отправил тебе меню настроек личным сообщением',
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
    de = {
        status = {
            kicked = '&&&1 is banned from this group',
            left = '&&&1 left the group or has been kicked and unbanned',
            administrator = '&&&1 is an Admin',
            creator = '&&&1 is the group creator',
            unknown = 'This user has nothing to do with this chat',
            member = '&&&1 is a chat member'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_Ich habe dir die Nachricht als Direktnachricht geschickt_',
            no_user = 'Ich habe den Nutzer (user) noch nicht kennen gelernt.\nWenn du ihn mir vorstellen möchtest damit ich weiß wen du meinst, leite eine seiner Nachrichten an mich weiter',
            the_group = 'die Gruppe',
            adminlist_admin_required = 'I\'m not a group Admin.\n*Only an Admin can see the administrators list*',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Antworte (reply) jemandem* um diesen Befehl (command) zu nutzen oder schreibe einen *Nutzernamen (username)*',
            too_long = 'This text is too long, I can\'t send it',
            msg_me = '_Schreibe zuerst mir, damit ich dann dir schreiben kann_',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*Gruppen ID*: &&&1'
        },
        not_mod = 'Du bist *kein* Moderator',
        breaks_markdown = 'Dieser Text sprengt die Formatierung (markdown).\nMehr Informationen über die korrekte Nutzung der Formatierungsoptionen gibt es [hier](https://telegram.me/GroupButler_ch/46).',
        credits = '*Einige nützliche Links:*',
        extra = {
            setted = '&&&1 command saved!',
			command_deleted = '&&&1 Befehl (command) wurde gelöscht',
            command_empty = '&&&1 Befehl (command) existiert nicht',
            commands_list = 'Liste der *selbsterstellten Befehle (custom commands)*:\n&&&1',
            new_command = '*Neuer Befehl gespeichert (command set)!*\n&&&1\n&&&2',
            no_commands = 'Keine Befehle (commands) gespeichert!',
            usage = 'Schreibe nach /extra den Namen des Befehls (title of command) und den dazugehörigen Text,\nZum Beispiel:\n/extra #motto Bleib geschmeidig. Der Bot wird jedesmal wenn jemand #motto schreibt mit  _"Bleib geschmeidig"_ antworten'
        },
        help = {
            all = "*Befehle (commands) für alle*:\n"
                .."`/dashboard` : Bekomme das Übersichtsmenü der Gruppe in einer Direktnachrticht gesendet\n"
                .."`/rules` (wenn genutzt) : Zeige die Gruppenregeln\n"
                .."`/about` (wenn genutzt) : Zeige die Beschreibung\n"
                .."`/adminlist` (wenn genutzt) : Zeige die Moderatoren (mods) der Gruppe\n"
                .."`@admin` (wenn genutzt) : per Antwort (by reply) = melde (report) die Nachricht auf die geantwortet wurde an alle Administratoren; ohne Direktantwort (reply) dafür mit Nachricht = Lasse allen Admins ein Feedback zukommen\n"
                .."`/id` : get the chat id, or the user id if by reply\n"
                .."`/echo [text]` : Der Bot wird dir den Text (formatiert (with markdown)) zurückschicken\n"
                .."`/info` : Zeige einige nützliche Informationen über den Bot an\n"
                ..'`/group` : get the discussion group link\n'
                .."`/c` <feedback> : Kontaktiere den Entwickler wegen einer Rückmeldung (feeback), einem Fehlerbericht (bug report) oder einer Frage. "
                .."_JEDER VORSCHLAG UND JEDE FUNKTIONSERWEITERUNGSANFRAGE (FEATURE REQUEST) IST GERNE GESEHEN_ Der Entwickler wird SBWM (so bald wie möglich ^^ ; ASAP - as soon as possible) antworten\n"
                .."`/help` : Zeige diese Nachricht an\n\n"
                .."Wenn dir der Bot gefällt, bewerte ihn [hier](https://telegram.me/storebot?start=groupbutler_bot) bitte so wie du es für richtig hälst",
            group_not_success = "_Schreibe zuerst mir, damit ich dann dir schreiben kann>_",
            group_success = "_Ich habe dir das Hilfsmenü als Direktnachricht geschickt_",
            initial = "Wähle die *Rolle (role)* um die möglichen Befehle (available commands) anzuzeigen:",
            kb_header = "Klicke auf ein Feld (button) um die *damit verbundenen Befehle (related commands)* anzuzeigen",
            mods = {
                banhammer = "*Moderatoren: Die Macht des Sperrschlägers (banhammer powers):*\n\n"
                    .."`/kick [per Antworten (reply) | Nutzername (username)]` = entferne einen Nutzer (user) aus der Gruppe (er kann wieder hinzugefügt (readded) werden.\n"
                    .."`/ban [per Antwort|Nutzername]` = sperre einen Nutzer der Gruppe  (ban user) (funktioniert auch bei normalen Gruppen).\n"
                    .."`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.\n"
                    .."`/unban [per Antwort|Nutzername]` = Entsperre einen Nutzer der Gruppe.\n"
                    .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
                    .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                    .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban).\n"
                    .."`/banlist -` = clean the banlist.\n"
                    .."\n*Note*: you can write something after `/ban` command (or after the username, if you are banning by username)."
                    .." This comment will be used as the motivation of the ban.",
                char = "*Moderatoren: Spezielle Zeichen*\n\n"
                    .."`/menu` = you will receive in private the menu keyboard.\n"
                    .."Here you will find two particular options: _Arab and RTL_.\n"
                    .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                    .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
                    .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                extra = "*Moderatoren: Zusätzliche Befehle (extra commands)*\n\n"
                    .."`/extra [#trigger] [reply]` = Setzte eine Antwort, die gesendet wird wann immer jemand den Trigger erwähnt\n_Zum Beispiel_: Mit \""
                    .."`/extra #hallo Guten Morgen!`\" wird der Bot jedes Mal wenn jemand #hallo schreibt mit \"Guten Morgen!\" antworten.\n"
                    .."`/extra list` = Zeige eine Liste mit deinen zusätzlichen Befehlen.\n"
                    .."`/extra del [#trigger]` = Entferne den Auslöser (trigger) und die dazugehörige Nachricht.\n"
                    .."`/disable extra` = only an admin can use #extra commands in a group. For the other users, the bot will reply in private.\n"
                    .."`/enable extra` = everyone use #extra commands in a group, and not only the Admins.\n\n"
                    .."*Merke*: Formatierungsoptionen werden unterstützt. Wenn der Text die Formatierung sprengt, wird der Bot sich beschweren.\n"
                    .."Für korrekten Umgang mit den Formatierungsoptionen sieh dir [diese Nachricht](https://telegram.me/GroupButler_ch/46) im Kanal (channel) an",
                flood = "*Moderatoren: Flutschutzeinstellungen (flood settings) *\n\n"
                    .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
                    .."`/antiflood [number]` = Setze eine Anzahl von Nachrichten, die ein Nutzer innerhalb von 5 Sekunden senden kann.\n"
                    .."_Merke_ : Die Zahl muss größer als 3 und kleiner als 26 sein.\n",
                info = "*Moderatoren: Informationen zur Gruppe*\n\n"
                    .."`/setrules [group rules]` = Setze einen neuen Regelsatz (rules) für die Gruppe fest (die alten Regeln werden dabei überschrieben).\n"
                    .."`/addrules [text]` = Füge einige Zeilen am Ende des bestehenden Regelsatz hinzu.\n"
                    .."`/setabout [group description]` = Setze eine neue Gruppenbeschreibung (die alte wird dabei überschrieben).\n"
                    .."`/addabout [text]` = Füge einige Zeilen am Ende der bestehenden Beschreibung hinzu.\n\n"
                    .."*Merke* : Formatierungsoptionen werden unterstützt. Wenn der Text die Formatierung sprengt wird der Bot sich beschweren.\n"
                    .."Für korrekten Umgang mit den Formatierungsoptionen sieh dir [diese Nachricht](https://telegram.me/GroupButler_ch/46) im Kanal (channel) an",
                lang = "*Moderatoren: Spracheinstellungen*\n\n"
                    .."`/lang` = choose the group language (can be changed in private too).\n"
                    .."*Beachte*: Übersetzter sind ehrenamtliche Freiwillige, ich kann also nicht für die Korrektheit aller Übersetzungen garantieren. "
                    .."Ich kann auch niemanden dazu zwingen die neuen Zeichenketten (strings) nach jedem neuen Update zu aktualisieren (nicht Übersetztes ist auf Englisch).\n"
                    .."Wie dem auch sei - jeder ist herzlich eingeladen bei der Übersetzung zu helfen. Nutze einfach den `strings` Befehl um eine _.lua_ Datei mit allen zu übersetzenden Zeichenketten (strings) auf Englisch zu erhalten.\n"
                    .."Nutze `/strings [lang code]` um die Datei für die jeweilige Sprache zu erhalten (zum Beispiel: _/strings es_ ).\n"
                    .."Innerhalb der Datei findest du eine Anleitung: Befolge sie und innerhalb kürzester Zeit wird *deine Sprache* verfügbar sein ;)",
                links = "*Moderators: Links*\n\n"
                    .."`/link` = Bekomme den Gruppenlink (grouplink) angezeigt - sofern er durch den Besitzer (owner) bereits gesetzt wurde\n"
                    .."`/setpoll [name] [pollbot link]` = Speichere einen Umfragelink von @pollbot. Einmal gespeichert, kann ihn jeder Moderator mit `/poll` ernuet anzeigen.\n"
                    .."`/setpoll no` = Lösche den derzeitigen Umfragelink.\n"
                    .."`/poll` = Zeige den momentanen Umfragelink an - sofern gesetzt\n\n"
                    .."*Merke*: Der Bot erkennt zulässige (valid) Gruppenlinks/Umfragelinks. Wenn ein Link nicht zulässig (valid) ist, wirst du keine Antwort (reply) bekommen.",
                media = "*Moderatoren: Medieneinstellungen*\n\n"
                    .."`/media` = Erhalte per Direktnachricht eine inline Tastatur (inline keyboard) um die Medieneinstellungen zu ändern.\n"
                    .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
                    .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
                    .."`/media list` = Zeige die momentanen Einstellungen für alle Medientypen.\n\n"
                    .."*Liste der unterstützten Medientypen (supported media)*: _image, audio, aideo, sticker, gif, voic), contact, file, link_\n\n",
                settings = "*Moderatoren: Gruppeneinstellungen*\n\n"
                    .."`/menu` = Bearbeite die Gruppeneinstellungen ohne, dass es jemand mitbekommt (private) mit einer nützlichen inline Tastatur (inline keyboard).\n"
                    .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
                    .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
                    .."`/report [on/off]` (by reply) = Der Nutzer (user) wird (_on_) oder wird nicht (_off_) in der Lage sein den\"@admin\" Befehl (command) zu nutzen.\n",
                warns = "*Moderatoren: (Ver)warnungen*\n\n"
                    .."`/warn [kick/ban]` = Wähle die anzuwendende Maßnhame (action), wenn die maximale Zahl an Verwarnungen (warns) erreicht ist.\n"
                    .."`/warn [by reply]` = Verwarne (warn) einen Nutzer (user). Ist das Limit einmal erreicht, wird dieser entfernt/gesperrt (kicked/banned).\n"
                    .."`/warnmax` = Setze das Limit für Verwarnungen bevor der Nutzer entfernt/gesperrt (kicked/bannend) wird.\n"
                    .."`/getwarns [by reply]` = Zeige an wie oft ein Nutzer bereits verwarnt (warnend) wurde.\n"
                    .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n",
                welcome = "*Moderatoren: Willkommensnachrichteinstellungen*\n\n"
                    .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
                    .."*Selbsterstellte Willkommensnachricht*:\n`/welcome Welcome $name, enjoy the group!"
                    .."`\nSchreibe nach \"/welcome\" deine Willkommensnachricht. Du kannst einige Platzhalter wie den Namen/Nutzernamen/ID des Neulings in der Gruppe einfügen\n"
                    .."Platzhalter: _$username_ (wird durch den Nutzernamen ersetzt); _$name_ (wird durch den Namen ersetzt); _$id_ (wird durch die ID ersetzt); _$title_ (wird durch den Gruppennamen (group title) ersetzt).\n\n"
                    .."*GIF/Sticker als Willkommensnachricht*\nDu kannst ein bestimmtes GIF/einen bestimten Sticker als Willkommensnachricht verwenden. Dafür antworte (reply) einfach mit '/welcome' auf ein GIF/Sticker\n\n"
                    .."*Zusammengesetzte Willkommensnachricht*\n"
                    .."Du kannst deine Willkommensnachricht mit den Gruppenregeln, der Gruppenbeschreibung und der Liste der Moderatoren versehen (rules, description, moderators list).\n"
                    .."Dazu schreibe `/welcome` gefolgt von dem entsprechenden Code.\n_Codes_ : *r* = Gruppenregeln (rules); *a* = Gruppenbeschreibung (description, about); *m* = Liste der Moderatoren (adminlist).\n"
                    .."Zum Beispiel wird die Willkommensnachricht mit \"`/welcome rm`\" die Gruppenregeln und die Liste der Moderatoren (rules and adminlist) enthalten",
            },
            private = "Moin, *&&&1*!\nIch bin ein einfacher Bot, dazu geschaffen Leuten wie dir dabie zu helfen ihre Gruppen zu organisieren.\n\n*Wie ich dir helfen kann?*\nPuhh - ich habe so einige nützliche Fertigkeiten! Du kannst Nutzer *entfernen oder sperren (kick or ban)*, einen Regelsatz (rules)  und eine -beschreibung (description) definieren, Nutzer (users) verwarnen (warn), einige Parameter setzen um jemanden zu entfernen (kick) wenn bestimmte Voraussetzungen zutreffen (lies hierzu: *Flutschutz (antiflood)*/RNL (RTL)/Medientypen (media)...)\nErfahre mehr indem du mich zu einer Gruppe hinzufügst!\n\nDer Nutzer (user), der mich hinzufügt wird als Besitzer (owner) der Gruppe gespeichert. Wenn du nicht der tatsächliche Besitzer der Gruppe bist, kannst du jemand anders als solchen setzten indem du einfach auf eine seiner Nachrichten mit `/owner` antwortest.\nUm meine Moderationsfähigkeiten (entfernen/sperren; kick/ban) voll entfalten zu können, *musst du mich als Administrator zur Gruppe hinzufügen*.\nMerke: Moderationsbefehle (moderator commands) können nur von mit `/promote` beförderten Nutzern (user) genutzt werden. Ich bin leider nicht in der Lage herauszufinden, wer Administrator in der Gruppe ist - das ist momentan der einzige Weg.\n\nKontaktiere den Entwickler wegen einer Rückmeldung (feeback), einem Fehlerbericht (bug report) oder einer Frage mittels des \"`/c <feedback>`\" Befehls (command). EGAL WEGEN WAS - ER FREUT SICH ÜBER ALLES!\n\n[Offizieller Kanal (official channel)](https://telegram.me/GroupButler_ch) und der [Bewertungslink (vote link)](https://telegram.me/storebot?start=groupbutler_bot)"
        },
        links = {
            link = "[&&&1](&&&2)",
            link_invalid = "Dieser Link ist *ungültig (not valid!)!*",
            link_setted = "Der Link wurde gespeichert.\n*Er lautet wie folgt*: [&&&1](&&&2)",
            link_no_input = 'This is not a *public supergroup*, so you need to write the link near /setlink',
            link_updated = "Der Link wurde geupdated.\n*Er lautet jetzt*: [&&&1](&&&2)",
            link_unsetted = "Link *entfernt*",
            no_link = "Es existiert *kein Link* für diese Gruppe. Bitte den Besitzer (owner) einen zu generieren",
            no_poll = "*Keine aktiven Umfragen (polls)* für diese Gruppe",
            poll = "*Stimme (vote) hier ab*: [&&&1](&&&2)",
            poll_setted = "Der Link wurde gespeichert.\n*Stimme (vote) hier ab*: [&&&1](&&&2)",
            poll_unsetted = "Umfrage (poll) *entfernt*",
            poll_updated = "Die Umfrage (poll) wurde aktualisiert (updated).\n*Stimme (vote) hier ab*: [&&&1](&&&2)"
        },
        mod = {
            modlist = '*Creator*:\n&&&1\n\n*Admins*:\n&&&2'
        },
        report = {
            feedback_reply = "*Moin! Das ist eine Antwort (reply) des Botbesitzers (bot owner)*:\n&&&1",
            no_input = "Fasse deine Vorschläge/Fehler/Zweifel nach ! zusammen\nExample: !hello, this is a test",
            sent = "Feedback gesendet (sent)!"
        },
        service = {
            abt = "\n\n*Beschreibung*:\n",
            rls = "\n\n*Gruppenregeln (rules)*:\n",
            welcome = "Moin &&&1, und Willkommen in der Gruppe *&&&2*!",
            welcome_abt = "Es gibt keine Gruppenbeschreibung (description).",
            welcome_modlist = '\n\n*Creator*:\n&&&1\n*Admins*:\n&&&2',
            welcome_rls = "PAARRTY!"
        },
        setabout = {
            added = "*Beschreibung hinzugefügt (description added)*:\n\"&&&1\"",
            clean = "Die Gruppenbeschreibung (bio/description) wurde gelöscht.",
            new = "*Neue Biografie (bio/description):*\n\"&&&1\"",
            no_bio = "*KEINE BIO* für diese Gruppe.",
            no_bio_add = "*Es gibt keine Biografie (bio/description) für diese Gruppe*.\nNutze /setabout [bio] um eine Biografie (bio/description) zu verfassen",
            no_input_add = "Bitte schreibe etwas nach diesem armen, einsamen \"/addabout\"",
            no_input_set = "Bitte schreibe etwas nach diesem armen, einsamen \"/setabout\"",
            about_setted = 'New description *saved successfully*!'
        },
        setrules = {
            added = "*Gruppenregeln hinzugefügt (rules added):*\n\"&&&1\"",
            clean = "Die Gruppenregeln wurden gelöscht (rules wiped).",
            new = "*Neue Gruppenregeln (new rules)*:\n\"&&&1\"",
            no_input_add = "Bitte schreibe etwas nach diesem armen, einsamen \"/addrules\"",
            no_input_set = "Bitte schreibe etwas nach diesem armen, einsamen \"/setrules\"",
            no_rules = "*PAARRTY*!",
            no_rules_add = "Es gibt *keine Regeln (no rules)* für diese Gruppe.\nNutze /setrules [rules] um einen neuen Regelsatz anzulegen",
            rules_setted = 'New rules *saved successfully*!'
        },
        settings = {
            disable = {
                about_locked = "Der /about Befehl (command) ist von nun an nur für Moderatoren verfügbar",
                arab_locked = "Das System gegen Arabische Zeichen ist von nun an aktiv",
                extra_locked = "#Eigene Befehle (#extra commands) sind von nun an nur für Moderatoren verfügbar",
                flag_locked = "Der /flag Befehl (command) wird nun an nicht mehr verfügbar sein",
                flood_locked = "Antiflood is now off",
                modlist_locked = "Der /adminlist Befehl (command) ist von nun an nur für Moderatoren verfügbar",
                report_locked = "Der @admin Befehl (command) wird nun an nicht mehr verfügbar sein",
                rtl_locked = "Das Anti-RNL-System (anti-RTL) ist jetzt aktiviert",
                rules_locked = "Der /rules Befehl (command) ist von nun an nur für Moderatoren verfügbar",
                welcome_locked = "Die Willkommensnachricht wird nun nicht mehr angezeigt",
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                about_unlocked = "Der /about Befehl (command) ist jetzt für alle verfügbar",
                arab_unlocked = "Das Anti-Arabische-Zeichen-System ist nun deaktiviert",
                extra_unlocked = "Eigene # (extra # commands) sind nun für alle verfügbar",
                flag_unlocked = "Der /flag Befehl (command) ist von nun an verfügbar",
                flood_unlocked = "Аnti-flood is now on",
                modlist_unlocked = "Der /adminlist Befehl (command) ist jetzt für alle verfügbar",
                report_unlocked = "Der @admin Befehl (command) wird nun verfügbar sein",
                rtl_unlocked = "Das Anti-RNL-System (anti-RTL) ist nun deaktiviert",
                rules_unlocked = "Der /rules Befehl (command) ist jetzt für alle verfügbar",
                welcome_unlocked = "Die Willkommensnachricht wird von nun an angezeigt",
                admin_mode_unlocked = 'Admin mode on',
            },
            welcome = {
                a = "Neue Zusammensetzung der Willkommensnachricht:\nGruppenregeln (rules)\n*Gruppenbeschreibung (bio/description)*\nModeratorenliste",
                am = "Neue Zusammensetzung der Willkommensnachricht:\nGruppenregeln (rules)\n*Gruppenbeschreibung (bio/description)*\n*Moderatoreniste*",
                custom = "*Eigene Willkommensnachricht* gesetzt!\n\n&&&1",
                m = "Neue Zusammensetzung der Willkommensnachricht:\nGruppenregeln (rules)\nGruppenbeschreibung (bio/description)\n*Moderatorenliste*",
                media_setted = "Neuer Medientyp als Willkommensnachricht gesetzt: ",
                no = "Neue Zusammensetzung der Willkommensnachricht:\nGruppenregeln (rules)\nGruppenbeschreibung (bio/description)\nModeratorenliste",
                no_input = "Willkommen und weiter...?",
                r = "Neue Zusammensetzung der Willkommensnachricht:\n*Gruppenregeln (rules)*\nGruppenbeschreibung (bio/description)\nModeratorenliste",
                ra = "Neue Zusammensetzung der Willkommensnachricht:\n*Gruppenregeln (rules)*\n*Gruppenbeschreibung (bio/description)*\nModeratorenliste",
                ram = "Neue Zusammensetzung der Willkommensnachricht:\n*Gruppenregeln (rules)*\n*Gruppenbeschreibung (bio/description)*\n*Moderatorenliste*",
                reply_media = "Antwort (reply) auf einen `sticker` oder  ein `gif` um diesen/dieses as *Willkommensnachricht* zu setzen",
                rm = "Neue Zusammensetzung der Willkommensnachricht:\n*Gruppenregeln (rules)*\nGruppenbeschreibung (bio/description)\n*Moderatorenliste*",
                wrong_input = "Eingabe ungültig.\nNutze _/welcome [no|r|a|ra|ar]_",
                wrong_markdown = "_Nicht speicherbar_ : Ich kann dir diese Nachricht nicht zurückschicken, wahrscheinlich wurden die *Formatierungsoptionen falsch* benutzt.\nBitte überarbeite den gesendeten Text nochmal",
                custom_setted = '*Custom welcome message saved!*',
            },
            resume = {
                header = "Momentane Einstellungen für *&&&1*:\n\n*Sprache*: `&&&2`\n",
                w_a = "*Willkommensnachrichtenzusammensetzung*: `Willkommensnachricht + Gruppenbeschreibung (bio/description)`\n",
                w_am = "*Willkommensnachrichtenzusammensetzung*: `Willkommensnachricht + Gruppenbeschreibung (bio/description) + Moderatorenliste`\n",
                w_custom = "*Willkommensnachrichtenzusammensetzung*: `Eigene Willkommensnachricht (custom message)`\n",
                w_m = "*Willkommensnachrichtenzusammensetzung*: `welcome + adminlist`\n",
                w_media = "*Willkommensnachrichtenzusammensetzung*: `GIF/Sticker`\n",
                w_no = "*Willkommensnachrichtenzusammensetzung*: `Nur die Willkommensnachricht`\n",
                w_r = "*Willkommensnachrichtenzusammensetzung*: `Willkommensnachricht + Gruppenregeln (rules)`\n",
                w_ra = "Willkommensnachrichtenzusammensetzung type*: `Willkommensnachricht + Gruppenregeln (rules) + Gruppenbeschreibung (bio/description)`\n",
                w_ram = "*Willkommensnachrichtenzusammensetzung*: `Willkommensnachricht + Gruppenregeln (rules) + Gruppenbeschreibung (bio/description) + Moderatorenliste`\n",
                w_rm = "*Willkommensnachrichtenzusammensetzung*: `Willkommensnachricht + Gruppenregeln (rules) + Moderatorenliste`\n",
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_'
            },
            char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
            broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            About = "/about",
            Arab = "Arabische Zeichen",
            Extra = "Eigenes (extra)",
            Flag = "Schandmal (flag)",
            Flood = "Anti-flood",
            Modlist = "/adminlist",
            Report = "Melden(report)",
            Rtl = "RNL (RTL)",
            Rules = "/rules",
            Welcome = "Willkommensnachricht",
            Admin_mode = 'Admin mode',
        },
        warn = {
            changed_type = "Neue Maßnahme, die ausgeführt wird, wenn das Limit an Verwarnungen erreicht ist: *&&&1*",
            getwarns_reply = "Antworte (reply) einem Nutzer um die Zahl seiner Verwarnungen (warns) angezeigt zu bekommen",
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            mod = "Ein Moderator kann nicht verwarnt (warned) werden",
            nowarn = "Die Anzahl der Verwarnungen (warns) des Nutzers (user) wurde auf den Ausgangszustand zurückgesetzt (reseted)",
            nowarn_reply = "Antworte (reply) einem Nutzer um die Anzahl seiner Verwarnungen zu löschen (delete warns)",
            warn_reply = "Antworte (reply) auf die Nachricht eines Nutzers (user) um ihn zu verwarnen (warn)",
            warned = "*Nutzer* &&&1 *wurde verwarnt.*\n_Anzahl der Verwarnungen_    *&&&2*\n_Limit_    *&&&3*",
            warned_max_ban = "Nutzer &&&1 *gesperrt (banned)*: Das Limit der Verwarnungen wurde erreicht",
            warned_max_kick = "Nutzer &&&1 *entfernt (kicked)*: Das Limit der Verwarnungen wurde erreicht",
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            warnmax = "Das Limit der Verwarnungen wurde geändert&&&3.\n*Vorher*: &&&1\n*Jetzt* max: &&&2",
            ban_motivation = 'Too many warnings',
        },
        setlang = {
            list = "*Liste der unterstützten Sprachen (available languages)*",
            success = "*Folgende Sprache wurde eingestellt:* &&&1"
        },
		banhammer = {
            kicked = '&&&1 wurde entfernt  (kicked)! (Aber es ist dem Nutzer (user) noch immer möglich zurückzukommen (rejoin))',
            banned = '&&&1 wurde gesperrt (banned)!',
            already_banned_normal = '&&&1 ist *bereits gesperrt (banned)*!',
            unbanned = 'Nutzer (user) entsperrt (unbanned)!',
            reply = 'Antworte (reply) jemandem',
            globally_banned = '&&&1 have been globally banned!',
            not_banned = 'Der Nutzer (user) ist nicht gesperrt',
            banlist_header = '*Banned users*:\n\n',
            banlist_empty = '_The list is empty_',
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'Ich kann diesen Nutzer (user) nicht entfernen (kick).\nWahrscheinlich bin ich entweder kein Administrator oder der Nutzer ist selbst Admin'
        },
        floodmanager = {
            ban = "Fluter (flooders) werden gesperrt (bannend)",
            changed_plug = "Die *maximale Anzahl* von Nachrichten, die in *5 Sekunden* gesendet werden können, wurde _von_ &&&1 _auf_ &&&2 geändert",
            disabled = "Flutschutz (antiflood) deaktiviert",
            enabled = "Flutschutz (antiflood) aktiviert",
            kick = "Fluter (flooders) werden entfernt (kicked)",
            not_changed = "Die maximale Anzahl von Nachrichten, die innerhalb von 5 Sekunden gesendet werden können, ist bereits &&&1",
            number_invalid = "`&&&1` ist kein gültiger Wert!\nDer Wert sollte *größer* als `3` und *kleiner* als `26` sein",
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
            changed = "Neue Einstellung für [&&&1] = &&&2",
            settings_header = "*Momentane Einstellungen für Medientypen*:\n\n",
            warn = "Dieser Medientyp ist in dieser Gruppe *nicht gestattet*.\n_Beim nächsten Mal_ wirst du entfernt oder gesperrt (kicked or banned)",
        },
        preprocess = {
            arab_kicked = "&&&1 *entfernt (kicked)*: Nachricht mit arabischen Zeichen entdeckt!",
            first_warn = "Dieser Medientyp ist in diesem Chat *nicht gestattet (not allowed)*.",
            flood_ban = "&&&1 *gesperrt (bannend)* wegen flutens (flooding)!",
            flood_kick = "&&&1 *entfernt (kicked)* wegen flutens (flodding)!",
            media_ban = "&&&1 *gesperrt (bannend)*: Der gesendete Medientyp ist nicht gestattet (not allowed)!",
            media_kick = "&&&1 *entfernt (kicked)*: Der gesendete Medientyp ist nicht gestattet (not allowed)!",
            rtl_kicked = "&&&1 *entfernt (kicked)*: RNL (RTL) Zeichen sind weder in Nachrichten noch in Namen gestattet (not allowed)!",
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
        },
        kick_errors = {
            [1] = 'Ich bin kein Administrator, ich kann keine Luete entfernen (kick)',
            [2] = 'Ich kann einen Administrator weder entfernen, noch sperren (kick/ban)',
            [3] = 'Es gibt keinen Grund in einer normalen Gruppe jemanden wieder zu entsperren (unban)',
            [4] = 'Dieser Nutzer ist kein Mitglied (member) dieses Chats',
        },
        flag = {
            already_blocked = 'Dem Nutzer (user) ist es bereits untersagt "@admin" zu nutzen',
            already_unblocked = 'Dem Nutzer (user) ist es bereits erlaubt "@admin" zu nutzen',
            blocked = 'Von nun an ist es dem Nutzer (user) untersagt/unmölgich "@admin" zu nutzen',
            no_input = 'Antworte (reply) auf eine Nachricht um sie zu melden (report) oder schreibe eine Nachricht nach "@admin" um diesen ein Feedback zukommen zu lassen',
            no_reply = 'Antworte (reply) einem Nutzer (user)!',
            reported = 'Gemeldet (reported)!',
            unblocked = 'Dem Nutzer ist von nun an erlaubt/möglich "@admin" zu nutzen'
        },
        all = {
            dashboard = {
                private = '_I\'ve sent you the group dashboard in private_',
                first = 'Navigate this message to see *all the info* about this group!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            media_first = 'Klicke auf eine Stimme (?) in der rechten Spalte um *die entsprechende Einstellung zu ändern*',
            menu = 'Ich habe dir das Einstellungsmenü als Direktnachricht geschickt',
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
        },
    },
    sv = {
        status = {
            kicked = '&&&1 is banned from this group',
            left = '&&&1 left the group or has been kicked and unbanned',
            administrator = '&&&1 is an Admin',
            creator = '&&&1 is the group creator',
            unknown = 'This user has nothing to do with this chat',
            member = '&&&1 is a chat member'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_Jag har skickat dig meddelandet privat_',
            no_user = 'Jag har inte sett den användaren förut.\nOm du vill lära mig vem det är så kan du vidarebefordra ett meddelande från användaren till mig.',
            the_group = 'gruppen',
            adminlist_admin_required = 'I\'m not a group Admin.\n*Only an Admin can see the administrators list*',
            settings_header = 'Nuvarande inställningar för *gruppen*:\n\n*Språk*: `&&&1`\n',
            reply = '*Skicka som meddelandesvar* för att använda detta kommando eller skriv ett *användarnamn*',
            too_long = 'This text is too long, I can\'t send it',
            msg_me = '_Skicka mig meddelande privat först, så jag kan skicka till dig efter det_',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*Group ID*: &&&1'
        },
        not_mod = 'You are *not* a moderator',
        breaks_markdown = 'Texten bryter markdown-formatteringen.\nMer information om markdown-formattering hitter du [här](https://telegram.me/GroupButler_ch/46).',
        credits = '*Några användbara länkar:*',
        extra = {
            setted = '&&&1 command saved!',
			usage = 'Skriv /extra följt av namnet på kommandot och texten som hör till.\nTill exampel:\n/extra #motm Var positiv. Botten kommer svara _"Var positiv"_ varje gång någon skriver #motm',
            new_command = '*Nytt kommando skapat!*\n&&&1\n&&&2',
            no_commands = 'Inga anpassade kommandon!',
            commands_list = '*Anpassade kommandon*:\n&&&1',
            command_deleted = 'Kommandot &&&1 har tagits bort',
            command_empty = '&&&1 finns inte som kommando',
        },
        help = {
            all = "*Kommandon för alla*:\n"
            .."`/dashboard` : se all gruppinformation privat\n"
            .."`/rules` (om upplåst) : visa gruppens regler\n"
            .."`/about` (om upplåst) : visa gruppens beskrivning\n"
            .."`/adminlist` (om upplåst) : visa gruppens moderatorer\n"
            .."`@admin` (om upplåst) : som meddelandesvar= rapportera meddelandet till alla som är admin; ej svar (fast med text)= skicka återkoppling till alla som är admin\n"
            .."`/kickme` : get kicked by the bot\n"
            .."`/faq` : some useful answers to frequent quetions\n"
            .."`/id` : get the chat id, or the user id if by reply\n"
            .."`/echo [text]` : botten skickar texten tillbaka (med markdown)\n"
            .."`/info` : visa användbar information om botten\n"
            ..'`/group` : get the discussion group link\n'
            .."`/c` <feedback> : skicka återkoppling/buggrapport/fråga till min skapare. _ALLA FÖRSLAG ÄR VÄKOMNA_. Han kommer svara ASAP\n"
            .."`/help` : visa detta meddelande.\n\nOm du gillar den här botten, lämna gärna den röst du tycker botten förtjänar [här](https://telegram.me/storebot?start=groupbutler_bot)",
            group_not_success = "_Skicka mig ett meddelande först, så kan jag därefter skicka meddelanden till dig_",
            group_success = "_Jag har skickat dig hjälpen privat_",
            initial = "Välj vilken *roll* du vill se kommandon för:",
            kb_header = "Tryck på en knapp för att se *motsvarande kommando*",
            mods = {
              banhammer = "*Moderatorer: kicka/banna*\n\n`/kick [meddelandesvar|användarnamn]` = kicka ut en användare (hen kan läggas till igen).\n"
              .."`/ban [meddelandesvar|användarnamn]` = banna en användare (även från vanliga grupper).\n"
              .."`/unban [meddelandesvar|användarnamn]` = avbanna en användare.\n"
              .."`/tempban [minutes]` = ban an user for a specific amount of minutes (minutes must be < 10.080, one week). For now, only by reply.\n"
              .."`/unban [by reply|username]` = unban the user from the group.\n"
              .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
              .."`/status [username]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
              .."`/banlist` = show a list of banned users. Includes the motivations (if given during the ban) (temporary disabled).\n"
              .."`/banlist -` = clean the banlist.\n"
              .."\n*Note*: you can write something after `/ban` command (or after the username, if you are banning by username)."
              .." This comment will be used as the motivation of the ban.",
              char = "*Moderatorer: specialtecken*\n\n"
              .."`/menu` = you will receive in private the menu keyboard.\n"
              .."Here you will find two particular options: _Arab and RTL_.\n"
              .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
              .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
              .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
              extra = "*Moderatorer: extrakommandon*\n\n"
              .."`/extra [#trigger] [svar]` = sätter en text som ska skickas som svar när någon skriver en trigger-text.\n"
              .."_Exempel_ : med \"`/extra #hej God morgon!`\", botten svarar \"God morgon!\" varje gång någon skriver #hej.\n"
              .."`/extra list` = visar en lista över dina extrakommandon.\n"
              .."`/extra del [#trigger]` = tar bort en trigger och tillhörande svarstext.\n"
              .."`/disable extra` = only an admin can use #extra commands in a group. For the other users, the bot will reply in private.\n"
              .."`/enable extra` = everyone use #extra commands in a group, and not only the Admins.\n\n"
              .."*Obs!* Man kan använda markdown-formatering. Om det inte är korrekt markdown, så får du ett meddelande om det.\n"
              .."Hur man skriver korrekt markdown kan de se [här](https://telegram.me/GroupButler_ch/46) i kanalen",
              flood = "*Moderatorer: flood-inställningar*\n\n"
              .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
              .."`/antiflood [number]` = sätter hur många meddelande man får skicka under 5 sekunder.\n"
              .."_Obs!_ Antalet måste vara mellan 4 och 25.\n",
              info = "*Moderatorer: gruppinformation*\n\n"
              .."`/setrules [gruppregler]` = sätter nya regler för gruppen (och skriver över tidigare regler).\n"
              .."`/addrules [text]` = Lägger till text i slutet av nuvarande regler.\n"
              .."`/setabout [gruppbeskrivning]` = sätter en ny beskrivning av gruppen (och skriver över föregående).\n"
              .."`/addabout [text]` = Lägger till text i slutet av nuvarande beskrivning.\n\n"
              .."*Obs!* Man kan använda markdown-formatering. Om det inte är korrekt markdown, så får du ett meddelande om det.\n"
              .."Hur man skriver korrekt markdown kan de se [här](https://telegram.me/GroupButler_ch/46) i kanalen",
              lang = "*Moderatorer: gruppspråk*\n\n"
              .."`/lang` = choose the group language (can be changed in private too).\n"
              .."*Obs!* översättarna jobbar ideellt och frivilligt, så jag kan inte garantera att all översättning är korrekt. Och jag kan inte tvinga dem att översätta allt nytt vid uppdateringar (texter som inte är översatta visas på engelska).\n"
              .."Vem som helst får översätta i alla fall. Använd kommandot `/strings` för att få en _.lua_-fil med alla texter på engelska.\n"
              .."Använd `/strings [språkkod]` för att få en fil för ett specifikt språk (exempel: _/strings es_ ).\nI filen finns alla instruktioner: följ dem, så blir ditt språk tillgängligt så snart som möjligt ;)",
              links = "*Moderatorer: länkar*\n\n"
              .."`/link` = Visar gruppens länk om den har sats av gruppägaren\n"
              .."`/setpoll [poll name] [pollbot-länk]` = Sparar en poll-länk från @pollbot. När man har satt den så kan moderatorer hämta den med `/poll`.\n"
              .."`/setpoll no` = Tar bort poll-länken.\n"
              .."`/poll` = Visar nuvarande poll-länk om den har sats\n\n"
              .."*Obs!* Botten kan känna igen formatet på länkar. Om länken är felaktig så får du inget svar.",
              media = "*Moderatorer: mediainställningar*\n\n"
              .."`/media` = Skickar dig en meny för mediainställningar privat.\n"
              .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
              .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
              .."`/media list` = show the current settings for all the media.\n"
              .."\n*Mediatyper*: _image, audio, video, sticker, gif, voice, contact, file, link_",
              settings = "*Moderatorer: gruppinställningar*\n\n"
              .."`/menu` = Visar en meny för gruppinställningar i ett privat meddelande.\n"
              .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
              .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
              .."`/report [on/off]` (som meddelandesvar) = Användaren kan inte (_off_) eller kan (_on_) använda kommandot \"@admin\".\n",
              warns = "*Moderatorer: varningar*\n\n"
              .."`/warn [kick/ban]` = Bestämmer vad som ska hända när en användare har fått för många varningar.\n"
              .."`/warn (som meddelandesvar)` = Warnar användaren. Efter max antal varningar blir användaren kickad/bannad.\n"
              .."`/warnmax` = Sätter max antal varningar.\n"
              .."`/getwarns (som meddelandesvar)` = Se hur många gånger användaren blivit varnad.\n"
              .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n",
              welcome = "*Moderatorer: välkomstinställningar*\n\n"
              .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
              .."*Eget välkomstmeddelande:*\n`/welcome Välkommen $name, ha det så roligt i gruppen!`\n"
              .."Skriv ditt välkomstmeddelande efter \"/welcome\". Du kan använda You can use some \"placeholders\" för användarens namn/användarnamn/id\n"
              .."Placeholders: _$username_ (ersätts av användarnamnet); _$name_ (ersätts av namnet); _$id_ (ersätts av id); _$title_ (infogar gruppens namn).\n\n"
              .."*GIF/sticker som välkomstmeddelande*\nDu kan använda en gif/sticker som välkomstmeddelande genom att besvara en gif/sticker med '/welcome'\n\n*Sammansatta välkomstmeddelanden*\n"
              .."Du kan komponera ihop ett meddelande med hjälp av gruppens regler, beskrivning och en lista över moderatorerna.\n"
              .."Du gör det genom att skriva `/welcome` följt av koderna för vad du vill inkludera.\n"
              .."_Koder_ : *r* = regler; *a* = beskrivning (about); *m* = moderatorlista.\nTill exempel, med \"`/welcome rm`\", så blir meddelandet reglerna följt av moderatorlistan"
            },
            private = "Hej, *&&&1*!\nJag är en simpel bot för att hjälpa folk administrera grupper.\n\n"
              .."*Hur kan jag hjälpa dig?*\nJag har många användbara verktyg! Du kan *kicka och banna* användare, sätta regler och gruppbeskrivning, varna användare, sätta parmetrar för att kicka någon när något händer (dvs: *antiflood*/RTL/media...)\n"
              .."Upptäck mer genom att lägga till mig i en grupp!\n\nFör att ge mig makt att moderera (kicka/banna), så *måste du sätta mig som moderator i gruppen*.\n"
              .."Kom ihåg: moderator-kommandon kan bara användas av gruppens administratörer.\n\nDu kan rapportera buggar, skicka feedback eller ställa frågor till min skapare genom att använda kommandot \"`/c <feedback>`\" på engelska. "
              .."ALLT ÄR VÄLKOMMET!\n\n[Officiell kanal](https://telegram.me/GroupButler_ch) och [röstlänk](https://telegram.me/storebot?start=groupbutler_bot)"
        },
        links = {
            link = "[&&&1](&&&2)",
            link_invalid = "Länken är *inte giltig!*",
            link_no_input = 'This is not a *public supergroup*, so you need to write the link near /setlink',
            link_setted = "Länken har sats.\n*Här är länken*: [&&&1](&&&2)",
            link_updated = "Länken uppdaterad.\n*Här är nya länken*: [&&&1](&&&2)",
            link_unsetted = "Länk *borttagen*",
            no_link = "*Ingen länk* för den här gruppen. Be gruppägaren generera en",
            no_poll = "*Ingen aktiv poll* för den här gruppen",
            poll = "*Rösta här*: [&&&1](&&&2)",
            poll_setted = "Länken har sats.\n*Rösta här*: [&&&1](&&&2)",
            poll_unsetted = "Pollen *borttagen*",
            poll_updated = "Pollen har uppdaterats.\n*Rösta här*: [&&&1](&&&2)"
        },
        mod = {
            modlist = '*Creator*:\n&&&1\n\n*Admins*:\n&&&2',
        },
        report = {
            no_input = "Skriv ditt förslag/bug/fråga efter '!'\nExample: !hello, this is a test",
            sent = 'Feedback skickad!',
            feedback_reply = '*Hej, det här är ett svar från bot-ägaren*:\n&&&1',
        },
        service = {
            abt = "\n\n*Beskrivning*:\n",
            rls = "\n\n*Regler*:\n",
            welcome = "Hej &&&1, och välkommen till *&&&2*!",
            welcome_abt = "Ingen gruppbeskrivning.",
            welcome_modlist = "\n\n*Moderatorer*:\n",
            welcome_rls = "Total anarki!"
        },
        setabout = {
            added = "*Beskrivning satt:*\n\"&&&1\"",
            clean = "Beskrivning borttagen.",
            new = "*Ny beskrivning:*\n\"&&&1\"",
            no_bio = "*Ingen gruppbeskrivning*.",
            no_bio_add = "*Ingen gruppbeskrivning*.\nAnvänd /setabout [beskrivning] för att sätta en ny beskrivning",
            no_input_add = "Du måste skriva något till höger om \"/addabout\"",
            no_input_set = "Du måste skriva något till höger om \"/setabout\"",
            about_setted = 'New description *saved successfully*!'
        },
        setrules = {
            added = "*Regel tillagd:*\n\"&&&1\"",
            clean = "Regler borttagna.",
            new = "*Nya regler:*\n\"&&&1\"",
            no_input_add = "Du måste skriva något till höger om \"/addrules\"",
            no_input_set = "Du måste skriva något till höger om \"/setrules\"",
            no_rules = "*Total anarki*!",
            no_rules_add = "*Inga gruppregler*.\nAnvänd /setrules [regler] för att sätta en ny konstitution.",
            rules_setted = 'New rules *saved successfully*!'
        },
        settings = {
            About = "/about",
            Arab = "Arabiska",
            Extra = "Extra",
            Flag = "Flagga",
            Flood = "Anti-flood",
            Modlist = "/adminlist",
            Report = "Rapportera",
            Rtl = "Rtl",
            Rules = "/rules",
            Welcome = "Välkomstmeddelande",
            Admin_mode = 'Admin mode',
            broken_group = 'There are no settings saved for this group.\nPlease run /initgroup to solve the problem :)',
            char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
            disable = {
                about_locked = "Kommandot /about är nu tillgängligt bara för moderatorer",
                arab_locked = "Anti-arab-tecken är nu aktiverat",
                extra_locked = "Kommandot #extra är nu tillgängligt bara för moderatorer",
                flag_locked = "Kommandot /flag är nu avstängt",
                flood_locked = "Antiflood is now off",
                modlist_locked = "Kommandot /adminlist är nu tillgängligt bara för moderatorer",
                report_locked = "Kommandot @admin är nu avstängt",
                rtl_locked = "Anti-RTL är nu aktiverat",
                rules_locked = "Kommandot /rules är nu tillgängligt bara för moderatorer",
                welcome_locked = "Välkomstmeddelande komma inte visas mer",
                admin_mode_locked = 'Admin mode off',
            },
            enable = {
                about_unlocked = "Kommandot /about command is now available for all",
                arab_unlocked = "Anti-arab-tecken är nu avstängt",
                extra_unlocked = "Kommandot #extra är nu tillgängligt för alla",
                flag_unlocked = "Kommandot /flag är nu tillgängligt",
                flood_unlocked = "Аnti-flood is now on",
                modlist_unlocked = "Kommandot /adminlist är nu tillgängligt för alla",
                report_unlocked = "Kommandot @admin nu tillgängligt",
                rtl_unlocked = "Anti-RTL är nu avstängt",
                rules_unlocked = "Kommandot /rules är nu tillgängligt för alla",
                welcome_unlocked = "Välkomstmeddelande kommer nu visas när någon kommer in i gruppen",
                admin_mode_unlocked = 'Admin mode on',
            },
            resume = {
                header = "Inställningar för *&&&1*:\n\n*Språk*: `&&&2`\n",
                w_a = "*Välkomsttyp*: `welcome + about`\n",
                w_am = "*Välkomsttyp*: `welcome + about + adminlist`\n",
                w_custom = "*Välkomsttyp*: `custom message`\n",
                w_m = "*Välkomsttyp*: `welcome + adminlist`\n",
                w_media = "*Välkomsttyp*: `gif/sticker`\n",
                w_no = "*Välkomsttyp*: `bara welcome`\n",
                w_r = "*Välkomsttyp*: `welcome + rules`\n",
                w_ra = "*Välkomsttyp*: `welcome + rules + about`\n",
                w_ram = "*Välkomsttyp*: `welcome + rules + about + adminlist`\n",
                w_rm = "*Välkomsttyp*: `welcome + rules + adminlist`\n",
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_'
            },
            welcome = {
                a = "Ny inställning för välkomstmeddelande:\nRules\n*About*\nModerators list",
                am = "Ny inställning för välkomstmeddelande:\nRules\n*About*\n*Moderators list*",
                custom = "*Eget välkomstmeddelande* satt!\n\n&&&1",
                m = "Ny inställning för välkomstmeddelande:\nRules\nAbout\n*Moderators list*",
                media_setted = "Ny media satt som välkomstmeddelande: ",
                no = "Ny inställning för välkomstmeddelande:\nRules\nAbout\nModerators list",
                no_input = "Välkommen och...?",
                r = "Ny inställning för välkomstmeddelande:\n*Rules*\nAbout\nModerators list",
                ra = "Ny inställning för välkomstmeddelande:\n*Rules*\n*About*\nModerators list",
                ram = "Ny inställning för välkomstmeddelande:\n*Rules*\n*About*\n*Moderators list*",
                reply_media = "Besvara en `sticker` eller en `gif-bild` för att sätta den som *välkomstmeddelande*",
                rm = "Ny inställning för välkomstmeddelande:\n*Rules*\nAbout\n*Moderators list*",
                wrong_input = "Fel argument.\nAnvänd _/welcome [no|r|a|ra|ar]_ istället",
                wrong_markdown = "_Inte ändrat_ : Jag kan inte skicka texten tillbaka till dig, antagligen har den *fel* markdown-formattering.\nVänligen kontrollera texten."
            }
        },
        warn = {
            ban_motivation = 'Too many warnings',
            changed_type = "Nytt resultat av för många varningar: *&&&1*",
            getwarns_reply = "Besvara ett meddelande för att se hur många varningar meddelandets avsändare har",
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            mod = "Moderatorer kan inte varnas",
            nowarn = "Antalet varningar har *nollställts* för denna användare",
            nowarn_reply = "Besvara ett meddelande för att nollställa den användarens varningar",
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            warn_reply = "Besvara en användares meddelande för att varna den användaren",
            warned = "*Användare* &&&1 *har varnats.*\n_Antal varningar_   *&&&2*\n_Max tillåtet_   *&&&3*",
            warned_max_ban = "Användare &&&1 *bannad*: nådde max antal varningar",
            warned_max_kick = "Användare &&&1 *kickad*: nådde max antal varningar",
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            warnmax = "Max antal varningar ändrat&&&3.\n*Tidigare* värde: &&&1\n*Nytt* maxvärde: &&&2"
        },
        setlang = {
            list = "*Tillgängliga språk:*",
            success = "*Nytt språk:* &&&1"
        },
		banhammer = {
            kicked = '&&&1 har kickats! (men kan komma tillbaka)',
            banned = '&&&1 har bannats!',
            already_banned_normal = '&&&1 är *redan bannad*!',
            unbanned = '&&&1 är inte bannad längre!',
            reply = 'Skicka som svar till någon',
            globally_banned = '&&&1 har bannats globalt!',
            not_banned = 'Användaren är inte bannad',
            banlist_header = '*Banned users*:\n\n',
            banlist_empty = '_The list is empty_',
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'For this, you can directly use /ban',
            tempban_week = 'The time limit is one week (10.080 minutes)',
            tempban_banned = 'User &&&1 banned. Ban expiration:',
            tempban_updated = 'Ban time updated for &&&1. Ban expiration:',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            ban = "Nu blir man bannad om man postar för mycket",
            changed_plug = "*Max antal* meddelanden som får skickas under *5 sekunder* ändrades _från_  &&&1 _till_  &&&2",
            disabled = "Antiflood avstängt",
            enabled = "Antiflood aktiverat",
            kick = "Nu blir man kickad om man postar för mycket",
            not_changed = "Max antal meddelanden som kan skickas under 5 sekunder är redan &&&1",
            number_invalid = "`&&&1` är inte ett giltigt värde!\nVärdet ska vara *högre* än `3` och *lägre* än `26`",
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
            changed = "Ny status för [&&&1] = &&&2",
            settings_header = "*Nuvarande mediainställningar*:\n\n",
            warn = "Följande media är *inte tillåtet* i gruppen.\n_Nästa gång_ blir du kickad eller bannad",
        },
        preprocess = {
            arab_kicked = "&&&1 *kickad* för arabiskt meddelande!",
            first_warn = "Denna mediatyp är *inte tillåten* i denna grupp.",
            flood_ban = "&&&1 *bannad* för flood!",
            flood_kick = "&&&1 *kickad* för flood!",
            media_ban = "&&&1 *bannad* för otillåten media!",
            media_kick = "&&&1 *kicked* för otillåten media!",
            flood_motivation = 'Banned for flood',
            media_motivation = 'Sent a forbidden media',
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            rtl_kicked = "&&&1 *kicked*: rtl-tecken i namn/meddelande är inte tillåtet!"
        },
        kick_errors = {
            [1] = 'Jag är inte admin, så jag kan inte kicka någon',
            [2] = 'Jag kan inte kicka eller banna en admin',
            [3] = 'Unban behövs bara i supergrupper',
            [4] = 'Den användaren är inte med här i gruppen',
        },
        flag = {
            already_blocked = "Användaren kan redan inte använda '@admin'",
            already_unblocked = "Användaren kan redan använda '@admin'",
            blocked = "Användaren kan inte längre använda '@admin'",
            no_input = "Besvara ett meddelande för att rapportera det till en admin, eller skriv något efter '@admin' för att skicka återkoppling till dem.",
            no_reply = "Skicka som meddelandesvar!",
            reported = "Rapporterad!",
            unblocked = "Användaren kan nu använda '@admin'"
        },
        all = {
            dashboard = {
                private = '_Jag har sänt informationen till dig i privat chat_',
                first = 'Använd knapparna nedan för att se *all information* om denna grupp!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            media_first = "Tryck på en knapp i högra kolumnen för att *ändra inställningen*",
            menu = "Jag har skickat menyn för inställningar privat till dig",
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
        },
    },
    ar = {
        status = {
            kicked = 'لقد تم حظر &&&1 من المجموعة',
            left = 'لقد تم ترك &&&1 من المجموعة أم إزالته وإلغاء حظره',
            administrator = 'إن &&&1 مشرف',
            creator = 'إن &&&1 خالق المجموعة',
            unknown = 'هذا المستخدم ليس لديه علاقة بهذا الدردشة',
            member = 'إن &&&1 عضو في الدردشة'
        },
        getban = {
            header = '*Global stats* for ',
            nothing = '`Nothing to display`',
            kick = 'Kick: ',
            ban = 'Ban: ',
            tempban = 'Tempban: ',
            flood = 'Removed for flood: ',
            warn = 'Removed for warns: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_لقد أرسلت لك الرسالة بواسطة رسالة خاصة_',
            no_user = 'لم أرى هذا المستخدم من قبل.\nإذا رغبت تخبرني عن هويته، عليك تحويل رسالة منه إلي.',
            the_group = 'المجموعة',
            adminlist_admin_required = 'أنا لست مشرف مجموعة.\n*فقط يمكن للمشرف أن يرى قائمة المشرفون.*',
            settings_header = 'الإعدادات الحالية *للمجموعة*:\n\n*لغة*: `&&&1`\n',
            reply = '*رد على شخص ما* لاستخدام هذا الأمر، أم اكتب *اسم مستخدم*',
            too_long = 'إن هذا النص طويل جداً، ليس بإمكاني إرساله',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            msg_me = '_أرسل لي رسالة اولاً حتى أستطيع إرسال رسائل لك_',
            tell = '*هوية المجموعة*: &&&1'
        },
        not_mod = 'إنك لست مشرفاً',
        breaks_markdown = 'هذا النص يكسر تنسيق ماركداون.. لمزيد من المعلومات حول الاستخدام السليم لماركداون [هنا](https://telegram.me/GroupButler_ch/46).',
        credits = '*بعض الروابط المفيد:*',
        extra = {
            setted = 'أمر &&&1 محفوظ!',
			usage = 'أكتب بجانب /extra عنوان الأمر والنص المرتبط.\nمثلاً:\n/extra #motm0كن سعيداً\nالبوت سيرد "كن سعيداً" كل مرة أحد يكتب #motm',
            new_command = '*أمر جديد محفوظ!*\n&&&1\n&&&2',
            no_commands = 'ليست هناك أي أوامر محفوظة!',
            commands_list = 'قائمة *أوامر خاصة*:\n&&&1',
            command_deleted = 'لقد تم حذف أمر &&&1',
            command_empty = 'لا يوجد أمر &&&1'
        },
        help = {
            mods = {
                banhammer = "*مشرفون: سلطات الإزالة*\n\n"
                            .."`/kick [by reply|username]` = أزل المستخدم من المجموعة (يمكن إضافته مرة أخرى).\n"
                            .."`/ban [by reply|username]` = احظر المستخدم من المجموعة (أيضاً من مجموعات عادية).\n"
                            .."`/tempban [minutes]` = 'احظر المستخدم لفترة محددة من دقائق (يجب أن يكون أقل من 10.080 دقائق، أي أسبوع واحد). في الوقت الراهن، فقط بواسطة الرد.\n"
                            .."`/unban [by reply|username]` = ارفع حظر المستخدم من المجموعة.\n"
                            .."`/getban [by reply|username]` = returns the *global* number of bans/kicks received by the user. Divided in categories.\n"
                            .."`/status [username]` = أظهر الحالة الحالية للمستخدم `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
                            .."`/banlist` = أظهر قائمة المستخدمون المحظورون. يشمل الدوافع (إذا تم ذكرها أثناء الحظر).\n"
                            .."`/banlist -` = clean the banlist.\n"
                            .."\n*ملاحظة*:يمكنك أن تكتب شيئاً ما بعد أمر `/ban` (أم بعد اسم المستخدم، إذا كنت تحظر بواسطة اسم المستخدم)."
                            .." هذا التعليق سيُستخدم كدافع الحظر.",
                info = "*مشرفون: مزيد من المعلومات عن المجموعة*\n\n"
                        .."`/setrules [group rules]` = احفظ قواعد جديدة للمجموعة )سيتم حذف القاوعد القديمة).\n"
                        .."`/addrules [text]` = أضف بعض النص في نهاية القواعد الموجودة.\n"
                        .."`/setabout [group description]` = احفظ وصفاً جديداً للمجموعة (سيتم حذف الوصف القاديم).\n"
                        .."`/addabout [text]` = أضف بعض النص في نهاية الوصف.\n"
                        .."\n*ملاحظة:* هذا البرنامج متوافق مع تنسيق ماركداون. إذا تم إرسال نص يكسر تنسيق ماركداون، البوت سيبلغ أن هناك شيء خاطئ.\n"
                        .."للاستخدام السليم لتنسيق ماركداون، برجاء الرجوع إلى [هذا الرابط](https://telegram.me/GroupButler_ch/46) في القناة.",
                flood = "*مشرفون: إعدادات مكافحة إغراق رسائل*\n\n"
                        .."`/antiflood` = manage the flood settings in private, with an inline keyboard. You can change the sensitivity, the action (kick/ban), and even set some exceptions.\n"
                        .."`/antiflood [number]` = حدد كم رسائل المستخدم يستطيع إرسالها أثناء فترة 5 ثوان.\n"
                        .."_ملاحظة_: يجب أن يكون العدد أكبر من 3 وأقل من 26.\n",
                media = "*مشرف: إعدادات الوسائط*\n\n"
                        .."`/media` = استقبل من خلال رسالة خاصة لوحة المفاتيح لتغيير إعدادات الوسائط.\n"
                        .."`/warnmax media [number]` = set the max number of warnings before be kicked/banned for have sent a forbidden media.\n"
                        .."`/nowarns (by reply)` = reset the number of warnings for the users (*NOTE: both regular warnings and media warnings*).\n"
                        .."`/media list` = أظهر الإعدادات الحالية لجمع الوسائط.\n"
                        .."\n*قائمة وسائط يجري دعمها*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*مشرف: إعدادات الترحيب*\n\n"
                            .."`/menu` = receive in private the menu keyboard. You will find an opton to enable/disable the welcome message.\n"
                            .."\n*رسالة الترحيب الخاصة:*\n"
                            .."`/welcome مرحباً $name، استمتع بالمجموعة!`\n"
                            .."اكبت رسالتك للترحيب بعد أمر \"/welcome\". استطيع أن تكتب شيء بشكل مؤقت لتشل اسم مستخدم العضو الجديد للمجموعة.\n"
                            .."بديل مؤقت: _$username_ (سيتم استبداله باسم المستخدم); _$name_ (سيتم استبداله بالاسم); _$id_ (سيتم استدباله بالهوية); _$title_ (سيتم استبداله بعنوان المجموعة).\n"
                            .."\n*صورة متحركة أم ملصق كرسالة الترحيب*\n"
                            .."بإمكانك استخدام صورة متحركة أم ملصق كرسالة الترحيب. لتحديده، رد لصورة متحركة أو لملصق ب \"/welcome\"\n"
                            .."\n*إنشاء رسالة الترحيب*\n"
                            .."بإمكانك إنشاء رسالة الترحيب التي تشمل قواعد، الوصف وقائمة المشرفين.\n"
                            .."تستطيع أن تكتبها بدءً من `/welcome` يتبعه المعلومات التي ترغب عن تشملها رسالة الترحيب\n"
                            .."_Codes_ : *r* = قواعد; *a* = وصف (حول); *m* = قائمة المشرفين.\n"
                            .."مثلا، مع \"`/welcome rm`\", ستظهر رسالة الترحيب قواعد وقائمة المشرفين",
                extra = "*المشرفون: أوامر إضافية*\n\n"
                        .."`/extra [#trigger] [reply]` = حدد در سيتم إرساله عندما يكتب أحد الكامةالمحفزة.\n"
                        .."_مثال_ : مع \"`/extra #hello صباح الخير!`\", سيرد البوت \"صباح الخير\" كلما أحد كتب #hello.\n"
                        .."`/extra list` = حصول على قائمة الأوامر الخاصة بك.\n"
                        .."`/extra del [#trigger]` = حذف الكلمةالمحفزة ورسالتها.\n"
                        .."`/disable extra` = فقط المشرف يستطيع أن يستخدم أوامر #extra في المجموعة. إذا تم كتابة الأمر من قبل مستخدم أخر، البوت سيرد برسالة خاصة.\n"
                        .."`/enable extra` = كل الناس يستخدمون أوامر #extra في المجموعة، وليس فقط المشرفون.\n"
                        .."\n*ملاحظة:* يجري دعم تنسيق ماركداون. إذا كسب النص المرسل تنسيق ماركداون، البوت سيبلغ أن هناك شيء خاطئ.\n"
                        .."من أجل تعرف عن الاستخدام السليم لتنسيق ماركداون، اضغط [هنا](https://telegram.me/GroupButler_ch/46) في القناة",
                warns = "*المشرفون: تحذير*\n\n"
                        .."`/warn [kick/ban]` = اختر إجراء سيتم اتخاذه بعد الوصول إلى المبلغ الأقصى من التحذيرات.\n"
                        .."`/warn [by reply]` = تحذير المستخدم. بعد وصول إلى المبلغ الأقصى، سيتم إزالته أم حظره.\n"
                        .."`/warnmax` = حدد المبلغ الأقصى للتحذيرات قبل الإزالة أم الحظر.\n"
                        .."`/getwarns [by reply]` = حصول على عدد المرات تم تحذير المستخدم.\n"
                        .."`/nowarns [by reply]` = إعادة تعيين تحذيرات المستخدم لصفر.\n",
                char = "*المشرفون: محارف خاصة*\n\n"
                        .."`/menu` = you will receive in private the menu keyboard.\n"
                        .."Here you will find two particular options: _Arab and RTL_.\n"
                        .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                        .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of th wierd service messages that are written in the opposite sense.\n"
                        .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                links = "*المشرفون: روابط*\n\n"
                        ..'`/setlink [link|\'no\']` : أدخل رابط المجموعة، كي يمكن مشرفين أخرين استخدامه، أم احذفه.\n'
                        .."`/link` = حصول على رابط المجموعة، إذا تم تحديده من قبل ��لمالك.\n"
                        .."`/setpoll [pollbot link]` = احفظ رابط استبيان من جانب @pollbot. بعد تحديده، يمكن المشرفون الحصول عليه مع أمر `/poll`.\n"
                        .."`/setpoll no` = احذف الرابط للاستبيان الحالي.\n"
                        .."`/poll` = حصول على الرابط للاستبيان الحالي، إذا تم تحديده\n"
                        .."*ملاخظة*: يمكن للبوت أن يعترف الروابط الصحيحة لمجموعات أم استبيانات. إذا لم يكون الرابط صحيح، لن تستقبل ردا.\n",
                lang = "*المشرفون: لغات المجموعات*\n\n"
                        .."`/lang` = حصول على قائمة اللغات المتاحة.\n"
                        .."\n*ملاحظة*: إن المترجمون متطوعين، فلا أستطيع أن أؤكد تصحيح كل الترجمات. وأيضاً لا أستطيع أن أضطرهم لترجمة النصوص الجديدة بعد كل تحديث )النصوص غير مترجمة ستظل باللغة لإنجليزية."
                        .."\nعلى أي حال، إن الترجمات مفتوح أي شخص. استدخم أمر `/strings` للاستقبال ملف من شكل '.lua' مع كل النصوص (باللغة الإنجليزية) .\n"
                        .."استخدم `/strings [lang code]` لاستقبال الملف لهذا اللغة المعينة (مثال: _/strings es_ ).\n"
                        .."في داخل الملف ستجد كل التعليمات. اتتبعها، وفي أقرب وقت ممكن يتكون لغتك متاحة ;)",
                settings = "*المشرفون: إعدادات المجموعة*\n\n"
                            .."`/menu` = إدارة إعدادات المجموعة بشكل خاص مع لوحة المفاتيح خاصة و مفيدة.\n"
                            .."`/adminmode on` = _/rules, /adminlist_ and every #extra command will be sent in private unless if triggered by an admin.\n"
                            .."`/adminmode off` = _/rules, /adminlist_ and every #extra command will be sent in the group, no exceptions.\n"
                            .."`/report [on/off]` (by reply) = هل تستطيع المستخدم أن تستخدم الأمر\"@admin\" command?\n",
            },
            all = '*الأوامر المتاح لكل المستخدمين*:\n'
                    ..'`/dashboard` : حصول على كل المعلومات الخاصة بالمجموعة\n'
                    ..'`/rules` (if unlocked) : أظهر قواعد المجموعة\n'
                    ..'`/about` (if unlocked) : أظهر وصف المجموعة\n'
                    ..'`/adminlist` (if unlocked) : أظهر مشرفين المجموعة\n'
                    ..'`@admin` (if unlocked) : برد= إبلاغ الرسالة لكل المشرفين ; بدون رد (يعني مع نص)= إرسال تعليقات لكل المشرفين\n'
                    ..'`/kickme` : سيتم إزالتك من قبل البوت\n'
                    ..'`/faq` : بعض الردور المفيدة على الأسئلة الأكثر تكرارا \n'
                    ..'`/id` : حصول على هوية الدردشة أم هوية المستخدم لو تم الحصول بواسطة الرد\n'
                    ..'`/echo [text]` :سيقوم البوت بإعادة الرسالة إليك (بإستخدام تنسيق مارك داون، متاح فقط بدردشة خاصة لمستخدم غير مشرف)\n'
                    ..'`/info` : أظهر بعض المعلومات المفيدة حول البوت\n'
                    ..'`/group` : get the discussion group link (English only)\n'
                    ..'`/c` <feedback> : ارسل تعليق، تقرير خطأ أم سؤال للخالق. أنا أرحب أن نوع من الاقتراحات أم أي طلب ميزة وسيوف أرد عليك في أقرب وقت ممكن.\n'
                    ..'`/help` : أظهر هذه الرسالة'
		            ..'\n\nلو أحببت هذا البوت، رجاءً اترك التصويت الذي يستحقه البوت [هنا](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'مرحباً,يا *&&&1*!\n'
                    ..'إنني بوت بسيط مخلوق لمساعدة الناس في إدارة مجموعتهم\n'
                    ..'\n*ماذا يمكنني أن أفعل  لك؟*\n'
                    ..'رائع، عندي كثير من الأدوات المفيدة!\n'
                    ..'• يمكنك إزالة أم حظر المستخدمين (حتي في مجموعات عادية) بإستخدام الرد أم اسم المستخدم\n'
                    ..'• حدد القواعد ووصف المجموعة\n'
                    ..'• شغل نظام مكافحة إرسال عدد ساحق من الرسائل، قابل للإعداد\n'
                    ..'• عدل رسالة الترحيب، بما في ذلك صور متحركة وملصقات\n'
                    ..'• حذر مستخدمين، وقم بإزالتهم أم حظرهم لو وصلوا إلى المبلغ الأقصى من التحذيرات\n'
                    ..'• حذر وأزل المستخدمين لو قاموا بإرسال ملف وسائطي معين\n'
                    ..'...وأكثر من ذلك، فيما يلي يمكنك أن تجد رز \"كل ال أوامر\" للحصول على القائمة الكاملة!\n'
                    ..'\nلاستخدامي، عليك أن تضفني كمشرف إلى المجموعة، وإلا تلجرام لن يسمح لي بالعمل! إذا كان لديك شكوك حول ذلك، اقرأ [هذا](https://telegram.me/GroupButler_ch/63))'
                    ..'\nيمكنك إرسال تقارير خطأ، تعليقات أم أسألة لخالقي باستخدام أمر "`/c <feedback>`" أنا سعيدة لكل!',
            group_success = '_لقد قمت بإرسال لك رسالة المساعدة برسالة خاصة_',
            group_not_success = '_رجاءً أرسل لي رسالة أولاً، حتي يمكنني إرسال رسائل لك.',
            initial = 'اختر الدور حتي ترى الأوامر المتاحة:',
            kb_header = 'اضغط زر حتى ترى الأوامر ذات الصلة'
        },
        links = {
            no_link = '*ليس هناك رابط* لهذه المجموعة. اسأل المالك من أجل خلقه',
            link = '[&&&1](&&&2)',
            link_no_input = 'إن هذا ليس مجموعة عامة من شكل سوبر، عليك أن تكتب الرابط ب /setlink',
            link_invalid = 'هذا الرابط *غير صحيح*!',
            link_updated = 'تم تحديث الرابط، وهو الآن: [&&&1](&&&2)',
            link_setted = 'تم تحديد الرابط، إنه الآن: [&&&1](&&&2)',
            link_unsetted = 'تم *حذف* الرابط',
            poll_unsetted = 'تم *حذف* الاستبيان',
            poll_updated = 'تم تحديث الاستبيان. صوت هنا: [&&&1](&&&2)',
            poll_setted = 'تم تحديد رابط الاستبيان. صوت هنا: [&&&1](&&&2)',
            no_poll = 'ليس هناك استبيان نشط لهذه المجموعة',
            poll = '*صوت هنا*: [&&&1](&&&2)'
        },
        mod = {
            not_owner = 'إنك لست مالك هذه المجموعة.',
            reply_promote = 'رد على شخص ما لتعزيزه',
            reply_demote = 'رد على شحص ما لإنزاله',
            reply_owner = 'رد على شخص ما لعطائه دور المالك',
            already_mod = 'إن &&&1 بالقعل مشرف في مجموعة *&&&2*',
            already_owner = 'إنك بالفعل مالك هذه المجموعة',
            not_mod = '&&&1 ليس مشرفا في مجموعة *&&&2*',
            promoted = 'تم تعزيز &&&1 كمشرف في مجموعة *&&&2*',
            demoted = 'تم إنزال &&&1 ',
            new_owner = 'إن &&&1 المالك الجديد ل *&&&2*',
            modlist = '*خالق*:\n&&&1\n\n*مشرفون*:\n&&&2'
        },
        report = {
            no_input = 'Write your feedback near the !\nExample: !hello, this is a test',
            sent = 'تم إرسال التعليق!',
            feedback_reply = '*مرحباً، هذا رد مالك البوت:\n&&&1',
        },
        service = {
            welcome = 'السلام عليكم يا &&&1, ومرحباً بكم في *&&&2*!',
            welcome_rls = 'الفوضوية الكلية!',
            welcome_abt = 'لا يوجد وصف لهذه المجموعة',
            welcome_modlist = '\n\n*خالق*:\n&&&1\n*مشرفون*:\n&&&2',
            abt = '\n\n*وصف*:\n',
            rls = '\n\n*قواعد*:\n',
        },
        setabout = {
            no_bio = '*لا يوجد وصف لهذه المجموعة.',
            no_bio_add = '*لا يوجد وصف لهذه المجموعة*.\nاستخدم /setabout [bio] لتحديد وصف جديد',
            no_input_add = 'رجاءً اكتب شيء بعد "/addabout"',
            added = '*تم إضافة وصف:*\n"&&&1"',
            no_input_set = 'رجاءً، اكتب شيء بعد "/setabout"',
            clean = 'تم حذف الوصف.',
            new = '*وصف جديد:*\n"&&&1"',
            about_setted = 'تم حفظ الوصف الجديد بنجاح!'
        },
        setrules = {
            no_rules = '*الفوضوية الكلية*!',
            no_rules_add = 'ليس هناك قواعد لهذه المجموعة.\nاستخذم /setrules [rules] لتحديد قواعد جديدة',
            no_input_add = 'رجاءً اكتب شيء بعد "/addrules"',
            added = '*تم إضافة القواعد:*\n"&&&1"',
            no_input_set = 'رجاءً اكتب شيء بعد "/setrules"',
            clean = 'تم حذف القواعد.',
            new = '*القواعد الجديدة:*\n"&&&1"',
            rules_setted = 'تم حفظ القواعد الجديدة بنجاح!'
        },
        settings = {
            disable = {
                rules_locked = 'إن أمر /rules متاح لمشرفين فقط',
                about_locked = 'إن أمر /about متاح لمشرفين فقط',
                welcome_locked = 'لن يتم عرض رسالة الترحيب من الآن',
                modlist_locked = 'إن أمر /adminlist متاح لمشرفين فقط',
                flag_locked = 'إن أمر /flag سيكن غير متاح من الآن',
                extra_locked = 'إن أوامر #extra متاحة لمشرفين فقط',
                rtl_locked = 'إن نظام مكافحة الكتابة من اليمين إلى اليسير مفعل الآن',
                flood_locked = 'نظام مكافحة تكرار الرسائل معطل الآن.',
                arab_locked = 'إن نظام مكافحة الكتابة بمحارف عربية مفعل الآن',
                report_locked = 'إن أمر @admin لن يكن متاح من الآن',
                admin_mode_locked = 'Admin mode *off*',
            },
            enable = {
                rules_unlocked = 'أمر /rules الآن متاح *لكل الناس*.',
                about_unlocked = 'أمر /about الآن متاح لكل الناس.',
                welcome_unlocked = 'سوف يتم عرض رسالة الترحيب من الآن.',
                modlist_unlocked = 'أمر /adminlist الآن متاح لكل الناس.',
                flag_unlocked = 'أمر /flag الآن متاح.',
                extra_unlocked = 'أوامر إكسترا # الآن متاحة لكل الناس.',
                rtl_unlocked = 'نظام مكافحة كتابة من اليمين إلى اليسار معطل الآن.',
                flood_unlocked = 'إن نظام مكافحة إرسال عدد ساحق من الرسائل مفعل الآن',
                arab_unlocked = 'نظام مكافحة كتابة محارف عربية معطل الآن.',
                report_unlocked = 'أمر @admin متاح الآن.',
                admin_mode_unlocked = 'Admin mode *on*',
            },
            welcome = {
                no_input = 'مرحباً و...?',
                media_setted = 'تم تعيين ملف جديد كرسالة الترحيب: ',
                reply_media = 'رد على ملصق أم صور متحركة وعينها ك*رسالة الترحيب*',
                a = 'إعدادات جديدة للرسالة الترحيب:\nقواعد\n*حول*\nقائمة المشرفين',
                r = 'إعدادات جديدة لرسالة الترحيب:\n*قواعد*\nحول\nقائمة المشرفين',
                m = 'إعدادات جديدة لرسالة الترحيب:\nقواعد\nحول\n*قائمة المشرفين*',
                ra = 'إعدادات جديدة لرسالة الترحيب:\n*قواعد*\n*حول*\nقائمة المشرفين',
                rm = 'إعدادات جديدة لرسالة الترحيب:\n*قواعد*\nحول\n*قائمة المشرفين*',
                am = 'إعدادات جديدة لرسالة الترحيب:\nقواعد\n*حول*\n*قائمة المشرفين*',
                ram = 'إعدادات جديدة لرسالة الترحيب:\n*قواعد*\n*حول*\n*قائمة المشرفين*',
                no = 'إعدادات جديدة لرسالة الترحيب:\nقواعد\nحول\nقائمة المشرفين',
                wrong_input = 'الأمر غير متاح\nاستخدم _/welcome [no|r|a|ra|ar]_ بدلاً من ذلك',
                custom = '*تم تعيين رسالة مخصصة!\n\n&&&1',
                custom_setted = '*تم حفظ رسالة الترحيب!*',
                wrong_markdown = '_عدم تعيين_ : لا استطيع أن أعيد لك هذه الرسالة، ربما تنسيق ماركداون غير صحيح.\nرجاء تأكد النص المرسل.',
            },
            resume = {
                header = 'الإعدادات الحالية ل*&&&1*:\n\n*لغة*: `&&&2`\n',
                w_a = '*نوع الترحيب*: `ترحيب  + حول`\n',
                w_r = '*نوع الترحيب*: `ترحيب  + قواعد`\n',
                w_m = '*نوع الترحيب*: `ترحيب  + قائمة المشرفين`\n',
                w_ra = '*نوع الترحيب*: `ترحيب  + قواعد + حول`\n',
                w_rm = '*نوع الترحيب*: `ترحيب  + قواعد + قائمة المشرفين`\n',
                w_am = '*نوع الترحيب*: `ترحيب  + حول + قائمة المشرفين`\n',
                w_ram = '*نوع الترحيب*: `ترحيب  + قواعد + حول + قائمة المشرفين`\n',
                w_no = '*نوع الترحيب*: `ترحيب  فقط`\n',
                w_media = '*نوع الترحيب*: `صورة متحركة/ملصق`\n',
                legenda = '✅ = _enabled/allowed_\n🚫 = _disabled/not allowed_\n👥 = _sent in group (always for admins)_\n👤 = _sent in private_',
                w_custom = '*نوع الترحيب*: `رسالة مخصصة`\n',
            },
            char = {
                arab_kick = 'Senders of arab messages will be kicked',
                arab_ban = 'Senders of arab messages will be banned',
                arab_allow = 'Arab language allowed',
                rtl_kick = 'The use of the RTL character will lead to a kick',
                rtl_ban = 'The use of the RTL character will lead to a ban',
                rtl_allow = 'RTL character allowed',
            },
            broken_group = 'ليس هناك إعدادات مفظة لهذه المجموعة.\nرجاء نفّذ أمر /initgroup من أجل حل المشكلة)',
            Rules = '/rules',
            About = '/about',
            Welcome = 'رسالة الترحيب',
            Modlist = '/adminlist',
            Flag = 'علم',
            Extra = 'إكسترا',
            Flood = 'مكافحة التكرار',
            Rtl = 'نص مكبوت من اليمين إلى اليسار',
            Arab = 'نص عربي',
            Report = 'إبلاغ',
            Admin_mode = 'Admin mode',
        },
        warn = {
            warn_reply = 'رد على رسالة لتحذير المستخدم',
            changed_type = 'إجراء جديدة عند استقبال المبلغ المقصى من التحذيرات: *&&&1*',
            mod = 'لا يمكن تحذير مشرف',
            warned_max_kick = 'تم إزالة مستخدم &&&1: وصل إلى المبلغ الأقصى من التحذيرات',
            warned_max_ban = 'تم حظر مستخدم &&&1: وصل إلى المبلغ الأقصى من التحذيرات',
            warned = 'تم تحذير مستخدم &&&1.\n_عدد التحذيرات_   *&&&2*\n_مبلغ أقصى مسموح_   *&&&3*',
            warnmax = 'تم تغيير مبلغ أقصى التحذيرات.\nمبلغ قديم: &&&1\nمبلغ جديد: &&&2',
            getwarns_reply = 'رد على مستخدم لترى عدده التحذيرات',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia: (*&&&4/&&&5*)',
            nowarn_reply = 'رد على مستخدم حذف تحذيراته',
            warn_removed = '*Warn removed!*\n_Number of warnings_   *&&&1*\n_Max allowed_   *&&&2*',
            inline_high = 'The new value is too high (>12)',
            inline_low = 'The new value is too low (<1)',
            ban_motivation = 'الكثير من التحذيرات',
            nowarn = 'تم إعادة تعيين مبلغ تحذيرات هذا المستخدم.'
        },
        setlang = {
            list = '*قائمة اللغات المتاحة:*\n\n&&&1\nاستخدم `/lang xx` لتغيير لغتك.',
            success = '*تم تعيير لغة جديدة:* &&&1'
        },
		banhammer = {
            kicked = 'تم إزالة &&&1! (ولكن ما رال يستطيع أن يرجع)',
            banned = 'تم حظر &&&1!',
            already_banned_normal = '&&&1 محظور بالفعل!',
            unbanned = 'تم حذف حظر المستخدم!',
            reply = 'رد على شخص ما',
            globally_banned = 'تم حظر &&&1 بشكل عالمي!',
            not_banned = 'المستخدم غير محظور',
            banlist_header = '*مستخدمون مخظورون*:\n\n',
            banlist_empty = '_القائمة فارغة._',
            banlist_error = '_An error occurred while cleaning the banlist_',
            banlist_cleaned = '_The banlist has been cleaned_',
            tempban_zero = 'لهذا الإجراء، يمكنك أن تستخدم الأمر /ban مبشرة.',
            tempban_week = 'أقصى مدى ممكن هو أسبوع واحد، أي 10.080 دقيقة.',
            tempban_banned = 'تم حظر مستخدم &&&1. هذا حظر سينتهي:',
            tempban_updated = 'تم تحديث مدى الحظر ل &&&1. الحظر سينتهي:',
            general_motivation = 'لا أستطيع أن أزيل هذا المستخدم.\nببما أنا لست مشرفا، أم المستخدم هو مشرف نفسه.'
        },
        floodmanager = {
            number_invalid = '`&&&1` ليس قيمة صحيح. من اللازم أن تكون أكبر من 3 وأقل من 26.',
            not_changed = 'أقصى مبلغ الرسائل التي يمكن إرسالها في 5 ثوان بالفعل &&&1',
            changed = 'لقد تم تغيير أقصى مبلغ الرسائل التي يمكن إرسالها أثناء مدى 5 ثوان من &&&1 إلى &&&2',
            enabled = 'تم تشغيل نظام مكافحة تكرار رسائل',
            disabled = 'تم تعطيل نظام مكافحة تكرار رسائل',
            kick = 'الآن، سوف يتم إزالة مستخدمين يقومون بتكرار رسائل.',
            ban = 'الآن، سوف يتم حظر مستخدمين يقومون بتكرار رسائل.',
            changed_cross = '&&&1 -> &&&2',
            text = 'Texts',
            image = 'Images',
            sticker = 'Stickers',
            gif = 'Gif',
            video = 'Videos',
            sent = '_I\'ve sent you the anti-flood menu in private_',
            ignored = '[&&&1] will be ignored by the anti-flood',
            not_ignored = '[&&&1] won\'t be ignored by the anti-flood',
            number_cb = 'Current sensitivity. Tap on the + or the -',
            header = 'You can manage the group flood settings from here.\n'
                ..'\n*1st row*\n'
                ..'• *ON/OFF*: the current status of the anti-flood\n'
                ..'• *Kick/Ban*: what to do when someone is flooding\n'
                ..'\n*2nd row*\n'
                ..'• you can use *+/-* to chnage the current sensitivity of the antiflood system\n'
                ..'• the number it\'s the max number of messages that can be sent in _5 seconds_\n'
                ..'• max value: _25_ - min value: _4_\n'
                ..'\n*3rd row* and below\n'
                ..'You can set some exceptions for the antiflood:\n'
                ..'• ✅: the media will be ignored by the anti-flood\n'
                ..'• ❌: the media won\'t be ignored by the anti-flood\n'
                ..'• *Note*: in "_texts_" are included all the other types of media (file, audio...)'
        },
        mediasettings = {
            warn = 'هذا نوع من الوسائط غير مسموح في هذه المجموعة.\n_المرة القادمة_ سيتم إزالتك أم حظرك من المجموعة.',
            settings_header = '*الإعدادات الحالية لوسائط:\n\n',
            changed = 'الحالة الجديدة ل(`&&&1`) = *&&&2*',
        },
        preprocess = {
            flood_ban = 'تم حظر &&&1 بسبب تكرار الرسائل!',
            flood_kick = 'تم إزالة &&&1 بسبب تكرار الرسائل!',
            media_kick = 'تم إزالة &&&1: الملف المرسل غير مسموح!',
            media_ban ='تم حظر &&&1: الملف المرسل غير مسموح!',
            rtl_kicked = 'تم إزالة &&&1: ممنوع استخدام محارف مكتوبة من اليمين إلى اليسار في الأسماء والرسائل!',
            arab_kicked = 'تم إزالة &&&1: تم اكتشاف رسالة عربية.',
            rtl_banned = '&&&1 *banned*: rtl character in names/messages not allowed!',
            arab_banned = '&&&1 *banned*: arab message detected!',
            flood_motivation = 'محظور بسبب تكرار رسائل',
            media_motivation = 'قام بإرسال ملف ممنوع',
            first_warn = 'ممنوع هذا نوع من الوسائط في هذه الدردشة. المرة القادم سوف يتم *&&&1*!'
        },
        kick_errors = {
            [1] = 'أنا لست مشرفا، لا يمكنني إزالة أشخاص.',
            [2] = 'لا يمكنني إزالة أم حظر مشرف.',
            [3] = 'ليس هناك حاجة لإعادة حظر في مجموعة عادية.',
            [4] = 'أن هذا مستخدم ليس عضو الدردشة.',
        },
        flag = {
            no_input = 'در على رسالة لإبلاغها لمشرف، أم اكتب شيئ ما بجانب \'@admin\' لإرسال تعليقات إليهم.',
            reported = 'تم إبلاغ!',
            no_reply = 'رد على مستخدم!',
            blocked = 'من الآن، المستخدم لا يتسطيع إستخدام أمر \'@admin\'.',
            already_blocked = 'هذا مستخدم بالفعل لا يستطيع أن يستخدم أمر \'@admin\'.',
            unblocked = 'الآن، المستخدم يستطيع أن يستخدم أمر \'@admin\'.',
            already_unblocked = 'المستخدم يستطيع أن يستخدم أمر \'@admin\' بالفعل.',
        },
        all = {
            dashboard = {
                private = 'I\'ve sent you the group dashboard in private',
                first = 'Navigate this message to see *all the info* about this group!',
                flood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                flood = 'Anti-flood settings',
                media = 'Media settings'
            },
            menu = 'قمت بإرسال لك قائمة الإعدادات بواسطة رسالة خاصة.',
            menu_first = 'Manage the settings of the group.\n'
                ..'\nSome commands (_/rules, /about, /adminlist, #extra commands_) can be *disabled for non-admin users*\n'
                ..'What happens if a command is disabled for non-admins:\n'
                ..'• If the command is triggered by an admin, the bot will reply *in the group*\n'
                ..'• If the command is triggered by a normal user, the bot will reply *in the private chat with the user* (obviously, only if the user has already started the bot)\n'
                ..'\nThe icons near the command will show the current status:\n'
                ..'• 👥: the bot will reply *in the group*, with everyone\n'
                ..'• 👤: the bot will reply *in private* with normal users and in the group with admins\n'
                ..'\n*Other settings*: for the other settings, icon are self explanatory\n',
            media_first = 'اضغط على صوت في الجانب اليمين لتغيير الإعداد.'
        },
    },
}