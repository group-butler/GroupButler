    en = {
        status = {
            kicked = '&&&1 is banned from this group',
            left = '&&&1 left the group or has been kicked and unbanned',
            administrator = '&&&1 is an Admin',
            creator = '&&&1 is the group creator',
            unknown = 'This user has nothing to do with this chat',
            member = '&&&1 is a chat member'
        },
        userinfo = {
            header_1 = '*Ban info (globals)*:\n',
            header_2 = '*General info*:\n',
            warns = '`Warns`: ',
            media_warns = '`Media warns`: ',
            group_msgs = '`Messages in the group`: ',
            group_media = '`Media sent in the group`: ',
            last_msg = '`Last message here`: ',
            global_msgs = '`Total number of messages`: ',
            global_media = '`Total number of media`: ',
            remwarns_kb = 'Remove warns'
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
                            .."`/user [by reply|username|id]` = returns a two pages messages: the first shows how many times the user has been banned *in all the groups* (divided in sections), "
                            .."the second page shows some general stats about the user: messages/media in the group, warns received and so on.\n"
                            .."`/status [username|id]` = show the current status of the user `(member|kicked/left the chat|banned|admin/creator|never seen)`.\n"
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
                            .."`/menu` = receive in private the menu keyboard. You will find an option to enable/disable the welcome message.\n"
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
                        .."You can reply to a media (_photo, file, vocal, video, gif, audio_) with `/extra #yourtrigger` to save the #extra and receive that media each time you use # command\n"
                        .."`/extra list` = get the list of your custom commands.\n"
                        .."`/extra del [#trigger]` = delete the trigger and its message.\n"
                        .."\n*Note:* the markdown is supported. If the text sent breaks the markdown, the bot will notify that something is wrong.\n"
                        .."For a correct use of the markdown, check [this post](https://telegram.me/GroupButler_ch/46) in the channel",
                warns = "*Moderators: warns*\n\n"
                        .."`/warn [by reply]` = warn a user. Once the max number is reached, he will be kicked/banned.\n"
                        .."`/warnmax` = set the max number of the warns before the kick/ban.\n"
                        .."\nHow to see how many warns a user has received: the number is showed in the second page of the `/user` command. In this page, you will see a button to reset this number.",
                char = "*Moderators: special characters*\n\n"
                        .."`/menu` = you will receive in private the menu keyboard.\n"
                        .."Here you will find two particular options: _Arab and RTL_.\n"
                        .."\n*Arab*: when Arab it's not allowed (🚫), everyone who will write an arab character will be kicked from the group.\n"
                        .."*Rtl*: it stands for 'Righ To Left' character, and it's the responsible of the weird service messages that are written in the opposite sense.\n"
                        .."When Rtl is not allowed (🚫), everyone that writes this character (or that has it in his name) will be kicked.",
                links = "*Moderators: links*\n\n"
                        .."`/setlink [link|'no']` : set the group link, so it can be re-called by other admins, or unset it.\n"
                        .."`/link` = get the group link, if already setted by the owner.\n"
                        .."\n*Note*: the bot can recognize valid group links. If a link is not valid, you won't receive a reply.",
                lang = "*Moderators: group language*\n\n"
                        .."`/lang` = choose the group language (can be changed in private too).\n"
                        .."\n*Note*: translators are volunteers, so I can't ensure the correctness of all the translations. And I can't force them to translate the new strings after each update (not translated strings are in english)."
                        .."\nAnyway, translations are open to everyone. Use `/strings` command to receive a _.lua_ file with all the strings (in english).\n"
                        .."Use `/strings [lang code]` to receive the file for that specific language (example: _/strings es_ ).\n"
                        .."In the file you will find all the instructions: follow them, and as soon as possible your language will be available ;)",
                settings = "*Moderators: group settings*\n\n"
                            .."`/menu` = manage the group settings in private with an handy inline keyboard.\n"
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
                welcome_locked = 'Welcome message won\'t be displayed from now',
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
            zero = 'The number of warnings received by this user is already _zero_',
            nowarn = 'The number of warns received by this user have been *reset*'
        },
        setlang = {
            list = '*List of available languages:*',
            success = '*New language set:* &&&1',
            error = 'Language not yet supported'
        },
		banhammer = {
            kicked = '`&&&1` kicked `&&&2`!',
            banned = '`&&&1` banned `&&&2`!',
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
                ..'• you can use *+/-* to change the current sensitivity of the antiflood system\n'
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
                antiflood = '- *Status*: `&&&1`\n- *Action* when an user floods: `&&&2`\n- Number of messages *every 5 seconds* allowed: `&&&3`\n- *Ignored media*:\n&&&4',
                settings = 'Settings',
                admins = 'Admins',
                rules = 'Rules',
                about = 'Description',
                welcome = 'Welcome message',
                extra = 'Extra commands',
                media = 'Media settings',
                flood = 'Flood settings'
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
            media_first = 'Tap on a voice in the right colon to *change the setting*\n'
                        ..'You can use the last line to change how many warnings should the bot give before kick/ban someone for a forbidden media\n'
                        ..'The number is not related the the normal `/warn` command',
        },
    },
