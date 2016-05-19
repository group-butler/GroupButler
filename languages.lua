--[[
Added:
Edited:
]]

return {
    en = {
        bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'I\'ve never seen this user before.\nIf you want to teach me who he is, forward me a message from him',
            the_group = 'the group',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            msg_me = '_Message me first so I can message you_'
        },
        pv = 'This is a command available only in a group',
        not_mod = 'You are *not* a moderator',
        breaks_markdown = 'This text breaks the markdown.\nMore info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).',
        credits = '*Some useful links:*',
        extra = {
			usage = 'Write next to /extra the title of the command and the text associated.\nFor example:\n/extra #motm stay positive. The bot will reply _\'Stay positive\'_ each time someone writes #motm',
            new_command = '*New command set!*\n&&&1\n&&&2',
            no_commands = 'No commands set!',
            commands_list = 'List of *custom commands*:\n&&&1',
            command_deleted = '&&&1 command have been deleted',
            command_empty = '&&&1 command does not exist'
        },
        help = {
            owner = '*Commands for the owner*:\n'
                    ..'`/owner` (by reply) : set a new owner\n'
                    ..'`/promote` (by reply|username) : promote as moderator a member\n'
                    ..'`/demote` (by reply|username) : demote a member\n'
                    ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by mods, or unset it\n'
                    ..'(obviuosly, the ability to appoint moderators is aimed to let users know who are the real moderators in the group, and so who can add and kick people.\nSo it\'s hardly suggested to point as moderator only who really is a moderator)\n\n',
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n",
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
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file_\n"
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
                    ..'`/modlist` (if unlocked) : show the moderators of the group\n'
                    ..'`@admin` (if unlocked) : by reply= report the message replied to all the admins; no reply (with text)= send a feedback to all the admins\n'
                    ..'`/tell` : show your basical info or the info about the user you replied to\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown)\n'
                    ..'`/info` : show some useful informations about the bot\n'
                    ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
                    ..'`/help` : show this message.'
		            ..'\n\nIf you like this bot, please leave the vote you think it deserves [here](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'I\'m a simple bot created in order to help people to manage their groups.\n'
                    ..'\n*How can I help you?*\n'
                    ..'Wew, I have a lot of useful tools! You can *kick or ban* users, set rules and a description, warn users, set some parameters to kick someone when something happens (read: *antiflood*/RTL/media...)\nDiscover more by adding me to a group!\n'
                    ..'\nThe user who adds me will be set up as owner of the group. If you are not the real owner, you can set it by repliyng one of his messages with `/owner`.'
                    ..'\nTo use my moderation powers (kick/ban), *you need to add me as administrator of the group*.\nRemember: moderator commands can be used only by who have been promoted with `/promote`. I can\'t see the real admins of the group, this is the only way for now.\n'
                    ..'\nYou can report bugs/send feedbacks/ask a question to my creator just using "`/c <feedback>`" command. EVERYTHING IS WELCOME!'
                    ..'\n\n[Official channel](https://telegram.me/GroupButler_ch) and [vote link](https://telegram.me/storebot?start=groupbutler_bot)',
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
            modlist = '\n*Group moderators*:\n&&&1'
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
            welcome_modlist = '\n\n*Moderators list*:\n',
            abt = '\n\n*Description*:\n',
            rls = '\n\n*Rules*:\n',
            bot_removed = '*&&&1* datas have been flushed.\nThanks for having used me!\nI\'m always here if you need an hand ;)'
        },
        setabout = {
            no_bio = '*NO BIO* for this group.',
            no_bio_add = '*No bio for this group*.\nUse /setabout [bio] to set-up a new description',
            no_input_add = 'Please write something next this poor "/addabout"',
            added = '*Description added:*\n"&&&1"',
            no_input_set = 'Please write something next this poor "/setabout"',
            clean = 'The bio has been cleaned.',
            new = '*New bio:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*Total anarchy*!',
            no_rules_add = '*No rules* for this group.\nUse /setrules [rules] to set-up a new constitution',
            no_input_add = 'Please write something next this poor "/addrules"',
            added = '*Rules added:*\n"&&&1"',
            no_input_set = 'Please write something next this poor "/setrules"',
            clean = 'Rules has been wiped.',
            new = '*New rules:*\n"&&&1"'
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
                modlist_already = '`/modlist` command is already *locked*',
                modlist_locked = '`/modlist` command is now available *only for moderators*',
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
                modlist_already = '`/modlist` command is already *unlocked*',
                modlist_unlocked = '`/modlist` command is now available *for all*',
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
        tell = {
            group_id = '*Group ID*: &&&1'
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
            nowarn = 'The number of warns received by this user have been *resetted*'
        },
        setlang = {
            list = '*List of available languages:*\n\n&&&1\nUse `/lang xx` to change you language',
            error = 'The language setted is *not supported*. Use `/lang` to see the list of the available languages',
            success = '*New language setted:* &&&1'
        },
		banhammer = {
            kicked_header = 'List of kicked users:\n\n',
            kicked_empty = 'The list of kicked users is empty',
            kicked = '&&&1 have been kicked! (but is still able to join)',
            banned = '&&&1 have been banned!',
            already_banned_normal = '&&&1 is *already banned*!',
            unbanned = 'User unbanned!',
            reply = 'Reply to someone',
            globally_banned = '&&&1 have been globally banned!',
            not_banned = 'The user is not banned',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` is not a valid value!\nThe value should be *higher* than `3` and *lower* then `26`',
            not_changed = 'The max number of messages that can be sent in 5 seconds is already &&&1',
            changed = 'The *max number* of messages that can be sent in *5 seconds* changed _from_  &&&1 _to_  &&&2',
            enabled = 'Antiflood enabled',
            disabled = 'Antiflood disabled',
            kick = 'Now flooders will be kicked',
            ban = 'Now flooders will be banned',
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
	it = {
	    bonus = {
            general_pm = '_Ti ho inviato il messaggio in privato_',
            the_group = 'il gruppo',
            settings_header = 'Impostazioni correnti per *il gruppo*:\n\n*Lingua*: `&&&1`\n',
            no_user = 'Non ho mai visto questo utente prima.\nSe vuoi insegnarmi dirmi chi è, inoltrami un suo messaggio',
            reply = '*Rispondi a qualcuno* per usare questo comando, o scrivi lo *username*',
            msg_me = '_Scrivimi prima tu, in modo che io possa scriverti_'
        },
        pv = 'Questo comando è disponibile solo in un gruppo!',
        not_mod = '*Non sei* un moderatore!',
        breaks_markdown = 'Questo messaggio impedisce il markdown.\nControlla quante volte hai usato * oppure _ oppure `.\nPiù info [qui](https://telegram.me/GroupButler_ch/46)',
        credits = '*Alcuni link utili:*',
        extra = {
			usage = 'Scrivi accanto a /extra il titolo del comando ed il testo associato.\nAd esempio:\n/extra #ciao Hey, ciao!. Il bot risponderà _\'Hey, ciao!\'_ ogni volta che qualcuno scriverà #ciao',
            new_command = '*Nuovo comando impostato!*\n&&&1\n&&&2',
            no_commands = 'Nessun comando impostato!',
            commands_list = 'Lista dei *comandi personalizzati*:\n&&&1',
            command_deleted = 'Il comando personalizzato &&&1 è stato eliminato',
            command_empty = 'Il comando &&&1 non esiste'
        },
        help = {
            owner = '*Comandi per il proprietario*:\n'
                    ..'`/owner` (by reply) : imposta un nuovo proprietario\n'
                    ..'`/promote` (by reply|username) : promuovi a moderatore un membro\n'
                    ..'`/demote` (by reply|username) : rimuovi un membro dai moderatori\n'
                    ..'`/setlink [link|\'no\']` : imposta il link al gruppo, in modo tale che i moderatori possano mostrarlo. O rimuovilo con "no"\n'
                    ..'(ovviamente, la possibilità di nominare dei moderatori serve a far sapere al bot chi sono i reali admin del gruppo, e quindi chi può usare comandi sensibili per kickare e bannare.\nQuindi è caldamente consigliato di nominare admin solo chi lo è realmente)\n\n',
            mods = {
                banhammer = "*Moderatori: il banhammer*\n\n"
                            .."`/kick [by reply|username]` = kicka un utente dal gruppo (potrà essere aggiunto nuovamente).\n"
                            .."`/ban [by reply|username]` = banna un utente dal gruppo (anche per gruppi normali).\n"
                            .."`/unban [by reply|username]` = unbanna l\'utente dal gruppo.\n",
                info = "*Moderatori: info sul gruppo*\n\n"
                        .."`/setrules [regole del gruppo]` = imposta il regolamento del gruppo (quello vecchio verrà eventualmente sovrascritto).\n"
                        .."`/addrules [testo]` = aggiungi del testo al regolamento già esistente.\n"
                        .."`/setabout [descrizione]` = imposta una nuova descrizione per il gruppo (quella vecchia verrà eventualmente sovrascritta).\n"
                        .."`/addabout [testo]` = aggiungi del testo alla descrizione già esistente.\n"
                        .."\n*Nota:* il markdown è permesso. Se del testo presenta un markdown scorretto, il bot notificherà che qualcosa è andato storto.\n"
                        .."Per un markdown corretto, consulta [questo post](https://telegram.me/GroupButler_ch/46) nel canale ufficiale",
                flood = "*Moderatori: impostazioni flood*\n\n"
                        .."`/flood [on/off]` = abilita/diabilita l\'anti-flood.\n"
                        .."`/flood [numero]` = imposta quanti messaggi possono essere inviati in 5 secondi senza attivare l\'anti-flood.\n"
                        .."_Nota_ : il numero deve essere maggiore di 3 e minore di 26.\n"
                        .."`/flood [kick/ban]` = scegli l'\azione da compiere (kick or ban) quando un utente sfora i limiti impostati.\n"
                        .."\n*Nota:* puoi modificare le impostazioni dell\'anti-flood in privato tramite la tastiera inline ricevuta tramite il comando `/menu`.",
                media = "*Moderatori: impostazioni media*\n\n"
                        .."`/media` = ricevi in privato una tastiera inline per gestire le impostazioni di tutti i media.\n"
                        .."`/media [kick|ban|allow] [tipo media]` = cambia l\'impostazione relativa ad un media specifico.\n"
                        .."_Esempio_ : `/media kick sticker`.\n"
                        .."`/media list` = mostra l\'elenco delle impostazioni attuali per i media.\n"
                        .."\n*Lista dei media supportati*: _image, audio, video, sticker, gif, voice, contact, file_\n"
                        .."\n*Nota*: la prima volta che un utente invia un media non permesso, non verrà kickato dal bot. Riceverà invece un avvertimento: alla prossima violazione, l\'utente verrà kickato/bannato.",
                welcome = "*Moderatori: messaggio di benvenuto*\n\n"
                            .."`/enable welcome` = il messaggio di benvenuto verrà inviato quando un utente si unisce al gruppo.\n"
                            .."`/disable welcome` = il messaggio di benvenuto non verrà mostrato.\n"
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
                        .."\n*Nota:* il markdown è permesso. Se del testo presenta un markdown scorretto, il bot notificherà che qualcosa è andato storto.\n"
                        .."Per un markdown corretto, consulta [questo post](https://telegram.me/GroupButler_ch/46) nel canale ufficiale",
                warns = "*Moderatori: warns*\n\n"
                        .."`/warn [kick/ban]` = scegli l\'azione da compiere (kick/ban) quando il numero massimo di warns viene raggiunto.\n"
                        .."`/warn [by reply]` = ammonisci (warn) un utente. Quando il numero massimo di warn viene raggiunto dall\'utente, verrà kickato/bannato.\n"
                        .."`/warnmax` = imposta il numero massimo di richiami prima di kickare/bannare.\n"
                        .."`/getwarns [by reply]` = restituisce il numero di volte che un utente è stato richiamato.\n"
                        .."`/nowarns [by reply]` = azzera il numero di richiami dell\'utente.\n",
                char = "*Moderatori: i caratteri*\n\n"
                        .."`/disable rtl` = tutti coloro che scriveranno un messaggio con il carattere RTL (Righ To Left) nel testo stesso del messaggio o nel nome, verranno kickati.\n"
                        .."`/enable rtl` = il carattere RTL (Righ To Left) verrà ignorato, e nessuna azione intrapresa.\n"
                        .."`/disable arab` = il bot kickerà chiunque scriva un messaggio con all\'interno dei caratteri arabi.\n"
                        .."`/enable arab` = i caratteri arabi verranno ignorati.\n",
                links = "*Moderatori: link*\n\n"
                        .."`/link` = ottieni il link del gruppo, se già impostato dal proprietario\n"
                        .."`/setpoll [link pollbot]` = salva un link ad un sondaggio di @pollbot. Una volta impostato, i moderatori possono ottenerlo con `/poll`.\n"
                        .."`/setpoll no` = elimina il link al sondaggio corrente.\n"
                        .."`/poll` = ottieni il link al sondaggio corrente, se impostato.\n"
                        .."\n*Note*: il bot può riconoscere link validi a gruppi/sondaggi. Se il link non è valido, non otterrai una risposta.",
                lang = "*Moderatori: linguaggio del bot*\n\n"
                        .."`/lang` = ottieni l\'elenco delle lingue disponibili\n"
                        .."`/lang [codice]` = cambia la lingua del bot\n"
                        .."\n*Nota*: i traduttori sono utenti volontari, quindi non posso assicurare la correttezza delle traduzioni. E non posso costringerli a tradurre le nuove stringhe dopo un aggiornamento (le stringhe non tradotte saranno in inglese)."
                        .."\nComunque, chiunque può tradurre il bot. Usa il comando `/strings` per ricevere un file _.lua_ con tutte le stringhe (in inglese).\n"
                        .."Usa `/strings [codice lingua]` per ricevere il file associato alla lingua richiesta (esempio: _/strings es_ ).\n"
                        .."Nel file troverai tutte le istruzioni: seguile, e il linguggio sarà disponibile il prima possibile ;)  (traduzione in italiano NON NECESSARIA)",
                settings = "*Moderatori: impostazioni del gruppo*\n\n"
                            .."`/menu` = gestisci le impostazioni del gruppo in privato tramite una comoda tastiera inline.\n"
                            .."`/disable [rules|about|modlist|extra]` = questi comandi saranno disponibili *solamente ai moderatori* (il bot non risponderà agli utenti normali).\n"
                            .."_Esempio_ : con \"`/disable extra`\", i comanid #extra potranno essere usati solo dai moderatori. Lo stesso vale per _rules, about, modlist_.\n"
                            .."`/enable [rules|about|modlist|extra]` = il comando sarà diponibile a tutti (e non solamente ai moderatori). \"Abilitato\" è lo stato di default.\n"
                            .."`/enable report` = gli utenti potranno inviare un feedback o segnalare un messaggio ai moderatori, usando il comando \"@admin\".\n"
                            .."`/disable report` = gli utenti non potranno inviare un feedback/segnalare un messaggio ai moderatori con il comando \"@admin\" (stato di default: disabilitato).\n"
                            .."`/report [on/off]` (by reply) = l'utente non potrà (_off_) o potrà (_on_) usare il comando \"@admin\".\n",
            },
            all = '*Comandi per tutti*:\n'
                    ..'`/dashboard` : consulta tutte le info sul gruppo in privato\n'
                    ..'`/rules` (se sbloccato) : mostra le regole del gruppo\n'
                    ..'`/about` (se sbloccato) : mostra la descrizione del gruppo\n'
                    ..'`/modlist` (se sbloccato) : mostra la lista dei moderatori\n'
                    ..'`@admin` (se sbloccato) : by reply= inoltra il messaggio a cui hai risposto agli admin; no reply (con descrizione)= inoltra un feedback agli admin\n'
                    ..'`/tell` : mostra le tue informazioni basilari o quelle dell\'utente a cui hai risposto\n'
                    ..'`/echo [testo]` : il bot replicherà il testo scritto (markdown supportato)\n'
                    ..'`/info` : mostra alcune info sul bot\n'
                    ..'`/c` <feedback> : invia un feedback/segnala un bug/fai una domanda al creatore. _OGNI GENERE DI SUGGERIMENTO E\' IL BENVENUTO_. Risponderà ASAP\n'
                    ..'`/help` : show this message.'
		            ..'\n\nSe ti piace questo bot, per favore lascia il voto che credi si meriti [qui](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'Sono un semplice bot creato allo scopo di semplificare l\'amministrazione di un gruppo.\n'
                    ..'\n*Come puoi aiutarmi?*\n'
                    ..'Wow, ho un sacco di strumenti utili! Puoi *kickare o bannare* utenti, impostare regole e descrizione, abilitare l\'antiflood/anti RTL/anti messaggi in arabo e molto altro!\nScopri di più aggiungendomi ad un gruppo\n'
                    ..'\nL\'utente che mi aggiunge verrà riconosciuto come proprietario. Se il proprietario non rispecchia la realtà, può essere cambiato rispondendo con `/owner` a quello reale'
                    ..'\nPer usarele mie funzioni da amministratore (kick/ban), *devi impostarmi come amministratore del gruppo*.\nRicorda: i poteri da amministratore possono essere usati solo da chi è stato promosso con `/promote`. Non posso vedere i veri admin, per cui per ora è l\'unica via.\n'
                    ..'\nPuoi segnalare un bug/inviare un feedback/fare una domanda al mio creatore usando "`/c <feedback>`". QUALSIASI MESSAGGIO E\' IL BENVENUTO!'
                    ..'\n\n[Canale ufficiale](https://telegram.me/GroupButler_ch) e [link per votarmi](https://telegram.me/storebot?start=groupbutler_bot)',
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
            not_owner = '*Non sei* il proprietario di questo gruppo.',
            reply_promote = 'Rispondi a qualcuno per promuoverlo',
            reply_demote = 'Rispondi a qualcuno per rimuovrlo dai moderatori',
            reply_owner = 'Rispondi a qualcuno per impostarlo come proprietario',
            already_mod = '&&&1 è _già_ un moderatore di *&&&2*',
            already_owner = 'Sei _già il proprietario_ di questo gruppo',
            not_mod = '&&&1 _non è_ un moderatore di *&&&2*',
            promoted = '&&&1 è stato _promosso_ a moderatore di *&&&2*',
            demoted = '&&&1 è stato _rimosso dai moderatori_',
            new_owner = '&&&1 è il _nuovo proprietario_ di *&&&2*',
            modlist = '\n*Moderatori del gruppo*:\n&&&1',
        },
        report = {
            no_input = 'Scrivi il tuo suggerimento/bug/dubbio accanto a "/c"',
            sent = 'Feedback inviato!',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
        },
        service = {
            new_group = 'Hi all!\n*&&&1* added me here to help you to manage this group.\nIf you want to know how I work, please start me in private or type /help  :)',
            welcome = 'Ciao &&&1, e benvenuto/a in *&&&2*!',
            welcome_rls = 'Anarchia totale!',
            welcome_abt = 'Nessuna descrizione per questo gruppo.',
            welcome_modlist = '\n\n*Lista dei moderatori*:\n',
            abt = '\n\n*Descrizione*:\n',
            rls = '\n\n*Regole*:\n',
            bot_removed = 'I dati su *&&&1* sono stati rimossi.\nGrazie per avermi usato!\nSono sempre qui, se serve una mano;)'
        },
        setabout = {
            no_bio = '*Nessuna descrizione* per questo gruppo.',
            no_bio_add = '*Nessuna descrizione per questo gruppo*.\nUsa /setabout [descrizione] per impostare una nuova descrizione',
            no_input_add = 'Per favore, scrivi qualcosa accanto a "/addabout"',
            added = '*Descrzione aggiunta:*\n"&&&1"',
            no_input_set = 'Per favore, scrivi qualcosa accanto a "/setabout"',
            clean = 'La descrizione è stata eliminata.',
            new = '*Nuova descrizione:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*Anarchia totale*!',
            no_rules_add = '*Nessuna regola* in questo gruppo.\nUsa /setrules [regole] per impostare delle nuove regole',
            no_input_add = 'Per favore, scrivi qualcosa accanto a "/addrules"',
            added = '*Rules added:*\n"&&&1"',
            no_input_set = 'Per favore, scrivi qualcosa accanto a "/setrules"',
            clean = 'Le regole sono state eliminate.',
            new = '*Nuove regole:*\n"&&&1"'
        },
        settings = {
            disable = {
                no_input = 'Disabilitare cosa?',
                rules_already = '`/rules` è già bloccato *bloccato*',
                rules_locked = '`/rules` è ora utilizzabile *solo dai moderatori*',
                about_already = '`/about` è già bloccato *bloccato*',
                about_locked = '`/about` è ora utilizzabile *solo dai moderatori*',
                welcome_already = 'Il messaggio di benvenuto è *già bloccato*',
                welcome_locked = 'Il messaggio di benvenuto *non verrà mostrato* da ora',
                modlist_already = '`/modlist` è già bloccato *bloccato*',
                modlist_locked = '`/modlist` è ora utilizzabile *solo dai moderatori*',
                flag_already = '`/flag` command is already *not enabled*',
                flag_locked = '`/flag` command *won\'t be available* from now',
                extra_already = 'I comandi #extra sono *già bloccati*',
                extra_locked = 'I comandi #extra sono ora utilizzabili *solo dai moderatori*',
                rtl_already = 'Anti-RTL è già *on*',
                rtl_locked = 'Anti-RTL è ora *on*',
                flood_already = 'L\'anti-flood è già *on*',
                flood_locked = 'L\'anti-flood è ora *on*',
                arab_already = 'Anti-caratteri arabi è già *on*',
                arab_locked = 'Anti-caratteri arabi è ora *on*',
                report_already = '@admin è già *non disponibile*',
                report_locked = '@admin *non sarà disponibile* da ora',
                wrong_input = 'Argomento invalido.\nUsa invece `/disable [rules|about|welcome|modlist|report|extra|rtl|arab]`',
            },
            enable = {
                no_input = 'Abilitare cosa?',
                rules_already = '`/rules` è già *sbloccato*',
                rules_unlocked = '`/rules` è ora utilizzabile *da tutti*',
                about_already = '`/about` è già *sbloccato*',
                about_unlocked = '`/about` è ora utilizzabile *da tutti*',
                welcome_already = 'Il messaggio dibenvenuto è già *sbloccato*',
                welcome_unlocked = 'il messaggio di benvenuto da ora verrà mostrato',
                modlist_already = '`/modlist` è già *sbloccato*',
                modlist_unlocked = '`/modlist` è ora utilizzabile *da tutti*',
                flag_already = '`/flag` command is already *available*',
                flag_unlocked = '`/flag` command is now *available*',
                extra_already = 'I comandi #extra sono già *sbloccati*',
                extra_unlocked = 'I comandi #extra sono già disponibili *per tutti*',
                rtl_already = 'Anti-RTL è già *off*',
                rtl_unlocked = 'Anti-RTL è ora *off*',
                flood_already = 'L\'anti-flood è già *off*',
                flood_unlocked = 'L\'anti-flood è ora *off*',
                arab_already = 'Anti-caratteri arabi è già *off*',
                arab_unlocked = 'Anti-caratteri arabi è ora *off*',
                report_already = '@admin è già *disponibile*',
                report_unlocked = '@admin è ora *disponibile*',
                wrong_input = 'Argomento non disponibile.\nUsa invece `/enable [rules|about|welcome|modlist|report|extra|rtl|arab]`'
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
                w_custom = '*Tipo di benvenuto*: `personalizzato`\n',
                flood_info = '_Sensitività flood:_ *&&&1* (_azione:_ *&&&2*)\n'
            },
            Rules = 'Regole',
            About = 'Descrizione',
            Welcome = 'Benvenuto',
            Modlist = 'Moderatori',
            Flag = 'Flag',
            Extra = 'Extra',
            Flood = 'Flood',
            Rtl = 'Rtl',
            Arab = 'Arabo',
            Report = 'Report'
        },
        tell = {
            group_id = '*ID gruppo*: &&&1'
        },
        warn = {
            warn_reply = 'Rispondi ad un messaggio per ammonire un utente (warn)',
            changed_type = 'Nuova azione: *&&&1*',
            mod = 'Un moderatore non può essere ammonito',
            warned_max_kick = 'Utente &&&1 *kickato*: raggiunto il numero massimo di warns',
            warned_max_ban = 'Utente &&&1 *bannato*: raggiunto il numero massimo di warns',
            warned = '*L\'utente* &&&1 *è stato ammonito.*\n_Numero di ammonizioni_   *&&&2*\n_Max consentito_   *&&&3* (*-&&&4*)',
            warnmax = 'Numero massimo di waning aggiornato.\n*Vecchio* valore: &&&1\n*Nuovo* valore: &&&2',
            getwarns_reply = 'Rispondi ad un utente per ottenere il suo numero di ammonizioni',
            limit_reached = 'Questo utente ha già raggiunto il numero massimo di ammonizioni (*&&&1/&&&2*)',
            limit_lower = 'Questo utente si trova sotto la soglia massima di warnings.\n*&&&1* warning mancanti su un totale di *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Rispondi ad un utente per azzerarne le ammonizioni',
            nowarn = 'Il numero di ammonizioni ricevute da questo utente è stato *azzerato*'
        },
        setlang = {
            list = '*Elenco delle lingue disponibili:*\n\n&&&1\nUsa `/lang xx` per cambiare lingua',
            error = 'Questo codice *non è supportato*. Usa `/lang` per vedere la lista dei linguaggi disponibili',
            success = '*Nuovo linguaggio impostato:* &&&1'
        },
		banhammer = {
            kicked_header = 'Lista degli utenti kickati:\n\n',
            kicked_empty = 'la lista è vuota',
            kicked = '&&&1 è stato kickato! (ma può ancora rientrare)',
            banned = '&&&1 è stato bannato!',
            unbanned = 'L\'utente è stato unbannato!',
            reply = 'Rispondi a qualcuno',
            globally_banned = '&&&1 è stato bannato globalmente!',
            no_unbanned = 'Questo è un gruppo normale, gli utenti non vengono bloccati se kickati',
            already_banned_normal = '&&&1 è *già bannato*!',
            not_banned = 'L\'utente non è bannato',
            general_motivation = 'Non posso kickare questo utente.\nProbabilmente non sono un Admin, o l\'utente che hai cercato di kickare è un Admin'
        },
        floodmanager = {
            number_invalid = '`&&&1` non è un valore valido!\nil valore deve essere *maggiore* di `3` e *minore* di `26`',
            not_changed = 'il massimo numero di messaggi che può essere inviato in 5 secondi è già &&&1',
            changed = 'Il numero *massimo di messaggi* che possono essere inviato in *5 secondi* è passato _da_  &&&1 _a_  &&&2',
            enabled = 'Antiflood abilitato',
            disabled = 'Antiflood disabilitato',
            kick = 'I flooders verranno kickati',
            ban = 'I flooders verranno bannati',
        },
        mediasettings = {
			warn = 'Questo tipo di media *non è consentito* in questo gruppo.\n_La prossima volta_ verrai kickato o bannato',
            list_header = '*Ecco la lista dei media che puoi bloccare*:\n\n',
            settings_header = '*Impostazioni correnti per i media*:\n\n',
            already = 'Lo stato del media (`&&&1`) è già (`&&&2`)',
            changed = 'Nuovo stato per (`&&&1`) = *&&&2*',
            wrong_input = 'Input errato. Usa `/media list` per vedere i media correnti',
        },
        preprocess = {
            flood_ban = '&&&1 *bannato* per flood',
            flood_kick = '&&&1 *kickato* per flood',
            media_kick = '&&&1 *kickato*: media inviato non consentito',
            media_ban = '&&&1 *bannato*: media inviato non consentito',
            rtl = '&&&1 *kickato*: carattere rtl nel nome/nei messaggi non consentito',
            arab = '&&&1 *kickato*: caratteri arabi non consentiti',
            first_warn = 'Questo tipo di media *non è consentito* in questo gruppo. la prossima volta, *&&&1*'
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
            dashboard = 'Ti ho inviato la scheda con le info sul gruppo in privato',
            menu = 'Ti ho inviato il menu delle impostazioni in privato',
            dashboard_first = 'Usa la tastiera per vedere *tutte le info* su questo gruppo!',
            menu_first = 'Tappa un lucchetto per *cambiare le impostazioni del gruppo*, o usa l\'ultima riga per _impostare il comportamento dell\'anti-flood_',
            media_first = 'Tocca una voce sulla colonna destra per *cambiare le impostazioni*'
        },
    },
	es = {
	    bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'I\'ve never seen this user before.\nIf you want to teach me who he is, forward me a message from him',
            the_group = 'the group',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            msg_me = '_Message me first so I can message you_'
        },
        pv = 'Este comando solo esta disponible en los grupos',
        not_mod = 'Tu *no* eres moderador',
        breaks_markdown = 'This text breaks the markdown.\nMore info about a proper use of markdown [here](https://telegram.me/GroupButler_ch/46).',
        credits = '*Some useful links:*',
        extra = {
			usage = 'Escribe seguido de /extra el titulo del comando y el texto asociado.\nPor ejemplo:\n/extra #motm esta positivo. El bot respondera _\'Esta positivo\'_ cada vez que alguien escriba #motm',
            new_command = '*Nuevo comando programado!*\n&&&1\n&&&2',
            no_commands = 'No hay comandos programados!',
            commands_list = 'Lista de *comandos personalizados*:\n&&&1',
            command_deleted = 'El comando &&&1 ha sido eliminado',
            command_empty = 'El comando &&&1 no existe'
        },
        help = {
            owner = '*Comandos para el propietario*:\n'
                    ..'`/owner` (mencionar) : Añade nuevo propietario\n'
                    ..'`/promote` (mencionar|username) : Ascender como moderador a un miembro\n'
                    ..'`/demote` (mencionar|username) : Degradar a un miembro\n'
                    ..'`/setlink [link|\'no\']` : Ajustar el link del grupo\n'
                    ..'(Obviamente, la capacidad de nombrar moderadores pretende que los usuarios sepan que son los moderadores reales en el grupo, y así pueden añadir y echar a la gente.)\n\n',
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n",
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
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file_\n"
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
            all = '*Comandos para todos*:\n'
                    ..'`/dashboard` : see all the group info from private\n'
                    ..'`/rules` (si desbloqueado) : Ver reglas del grupo\n'
                    ..'`/about` (si desbloqueado) : Ver descripcion de grupo\n'
                    ..'`/modlist` (si desbloqueado) : Ver los moderadores del grupo\n'
                    ..'`@admin` (si desbloqueado) : mencionar= informar del mensaje contestado a todos los administradores; sin respuesta (con texto)= enviar el mensaje a todos los administradores\n'
                    ..'`/tell` : Ver tu información básica o la información sobre el usuario que ha respondido\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown)\n'
                    ..'`/info` : Ver informacion sobre el bot\n'
                    ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
                    ..'`/help` : Ver este mensaje.'
		            ..'\n\nSi te gusta este bot, por favor deja tu voto [aqui](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hola, *&&&1*!\n'
                    ..'Soy un simple bot creado para ayudar a la gente a gestionar sus grupos.\n'
                    ..'\n*¿Como puedes ayudarme?*\n'
                    ..'¡Tengo un monton de herramientas utiles! Puedes *expulsar* o *banear* miembros, establecer reglas y descripcion al grupo, advertir a miembros, ajustar varios parametros para expulsar para expulsar a miembros cuando pasa algo (Lee: *antiflood*/RTL/media...)\nDescrubre mas añadiendome a un grupo!\n'
                    ..'\nEl usuario que me añada a un grupo sera condifugrado como el propietario del grupo. Si tu no eres el propietario del grupo, puedes establecer al propietario mencionadole despues de escribir `/owner`.'
                    ..'\nPara usar mis poderes de (expulsar/banear), *me tienes que añadir como administrador del grupo*.\nRecuerda: los comandos de moderador solo podran ser usador por lo miembros que hayas sido ascendidos con el comando `/promote`. No puedo ver los administradores del grupo por ahora.\n'
                    ..'\nPuedes reportar bugs o preguntar dudas al creador del bot utilizando el comando "`/c <tumensaje>`". ¡TODO ES BIENVENIDO!'
                    ..'\n\n[Canal OFICIAL](https://telegram.me/GroupButler_ch) y el [link para votar](https://telegram.me/storebot?start=groupbutler_bot)',
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
            not_owner = 'Tu *no* eres el propietario del grupo.',
            reply_promote = 'Menciona a un miembro para ascenderlo',
            reply_demote = 'Mensiona a un miembro para degradarlo',
            reply_owner = 'Menciona a un miembro para establecerlo como propietario',
            already_mod = '*&&&1* ya es moderador de *&&&2*',
            already_owner = 'Ya eres el propietario de este grupo',
            not_mod = '*&&&1* no es moderador de *&&&2*',
            promoted = '*&&&1* ha sido ascendido a moderador de *&&&2*',
            demoted = '*&&&1* ha sido degradado',
            new_owner = '*&&&1* es el nuevo propietario de *&&&2*',
            modlist = '\n*Group moderators*:\n&&&1'
        },
        report = {
            no_input = 'Escribe tus comentarios/bugs/dudas despues de "/c"',
            sent = 'Mensaje enviado!',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
        },
        service = {
            new_group = '¡Hola a todos!\n*&&&1* Me han añadido para administrar este grupo.\nSi quieres saber como funciono, iniciame en privado y escribe /help  :)',
            welcome = 'Hola &&&1, bienvenido a *&&&2*!',
            welcome_rls = '¡Anarquia total!',
            welcome_abt = 'No hay descripcion sobre este grupo.',
            welcome_modlist = '\n\n*Lista de moderadores*:\n',
            abt = '\n\n*Descripcion*:\n',
            rls = '\n\n*Reglas*:\n',
            bot_removed = '*&&&1* los datos se han vaciado.\n¡Gracias por usarme!\nSiempre estoy aqui para lo que necesites ;)'
        },
        setabout = {
            no_bio = '*NO hay descripcion* de este grupo.',
            no_bio_add = '*No hay descripcion* de este grupo.\nUsa /setabout [bio] para añadir una descripcion',
            no_input_add = 'Por favor, escribe algo despues de "/addabout"',
            added = '*Descripcion añadida:*\n"&&&1"',
            no_input_set = 'Por favor, escribe algo despues de "/setabout"',
            clean = 'La descripcion ha sido eliminada.',
            new = '*Nueva descripcion:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*¡Anarquia total*!',
            no_rules_add = '*No hay reglas* en este grupo.\nUsa /setrules [rules] para crear la constitucion',
            no_input_add = 'Por favor, escribe algo despues de "/addrules"',
            added = '*Reglas añadidas:*\n"&&&1"',
            no_input_set = 'Por favor, escribe algo despues de "/setrules"',
            clean = 'Las reglas han sido eliminadas.',
            new = '*Nuevas reglas:*\n"&&&1"'
        },
        settings = {
            disable = {
                no_input = '¿Desactivar el que?',
                rules_already = '`/rules` comando ya *bloqueado*',
                rules_locked = '`/rules` comando disponible *solo* para *moderadores*',
                about_already = '`/about` comando ya *bloqueado*',
                about_locked = '`/about` comando disponible *solo* para *moderadores*',
                welcome_already = 'Mensaje de bienvenida ya *bloqueado*',
                welcome_locked = 'Mensaje de bienvenida *no* sera mostrado',
                modlist_already = '`/modlist` comando ya *bloqueado*',
                modlist_locked = '`/modlist` comando disponible *solo* para *moderadores*',
                flag_already = '`/flag` comando ya *no activado*',
                flag_locked = '`/flag` comando *no disponible*',
                extra_already = 'Comandos #extra ya *bloqueados*',
                extra_locked = 'Comandos #extra *solo* para *moderadores*',
                rtl_already = 'Anti-RTL ya *desactivado*',
                rtl_locked = 'Anti-RTL *desactivado*',
                flood_already = 'Anti-flood is already *on*',
                flood_locked = 'Anti-flood is now *on*',
                arab_already = 'Anti-caracteres arabe ya *desactivado*',
                arab_locked = 'Anti-caracteres arabe *desactivado*',
                report_already = 'Comando @admin ya *desactivado*',
                report_locked = 'Comando @admin *no disponible*',
                wrong_input = 'Argumento no valido.\nUsa `/disable [rules|about|welcome|modlist|report|extra|rtl|arab|private]`',
            },
            enable = {
                no_input = '¿Activar el que?',
                rules_already = '`/rules` comando ya *desbloqueado*',
                rules_unlocked = '`/rules` comando disponible *para todos*',
                about_already = '`/about` comando ya *desbloqueado*',
                about_unlocked = '`/about` comando disponible *para todos*',
                welcome_already = 'Mensaje de bienvenida ya *desbloqueado*',
                welcome_unlocked = 'El mensaje de bienvenida sera mostrado',
                modlist_already = '`/modlist` comando ya *desbloqueado*',
                modlist_unlocked = '`/modlist` comando disponible *para todos*',
                flag_already = '`/flag` comando ya *disponible*',
                flag_unlocked = '`/flag` comando *disponible*',
                extra_already = 'Comandos #extra ya *desbloqueados*',
                extra_unlocked = 'Comandos #extra disponibles *para todos*',
                rtl_already = 'Anti-RTL ya *apagado*',
                rtl_unlocked = 'Anti-RTL *apagado*',
                flood_already = 'Anti-flood is already *off*',
                flood_unlocked = 'Anti-flood is now *off*',
                arab_already = 'Anti-caracteres arabe ya *apagado*',
                arab_unlocked = 'Anti-caracteres arabe *apagado*',
                report_already = 'Comando @admin ya *disponible*',
                report_unlocked = 'Comando @admin *disponible*',
                wrong_input = 'Argumento no disponible.\nUsa `/enable [rules|about|welcome|modlist|report|extra|rtl|arab|private]`'
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
                flood_info = '_Sensibilidad del Flood:_ *&&&1* (_Accion:_ *&&&2*)\n'
            },
            Rules = 'Reglas',
            About = 'Informacion',
            Welcome = 'Mensaje Bienvenida',
            Modlist = 'Lista de Mods',
            Flag = 'Flag',
            Extra = 'Extra',
            Flood = 'Flood',
            Rtl = 'Rtl',
            Arab = 'Arabe',
            Report = 'Reportar',
        },
        tell = {
            group_id = '*ID del grupo*: &&&1'
        },
        warn = {
            warn_reply = 'Menciona el mensaje para advertir al usuario',
            changed_type = 'Nueva consecuencia al alcanzar el numero max de advertencias: *&&&1*',
            mod = 'Un moderador *no* puede ser advertido',
            warned_max_kick = '*&&&1 ha sido expulsado*: alcanzado el numero maximo de advertencias',
            warned_max_ban = '*&&&1 ha sido baneado*: alcanzado el numero maximo de advertencias',
            warned = '*&&&1 ha sido advertido.*\n_Numero de advertencias_   *&&&2*\n_Maximo_   *&&&3* (*-&&&4*)',
            warnmax = 'Numero maximo de advertencias cambiado.\n*Antes*: &&&1\n*Ahora*: &&&2',
            getwarns_reply = 'Reply to a user to check his numebr of warns',
            limit_reached = 'Este miembro ya ha alcanzado el número máximo de advertencias (*&&&1/&&&2*)',
            limit_lower = 'Este miembro esta por debajo de las advertencias maximas.\n*&&&1* de *&&&2* advertencias(*&&&3/&&&4*)',
            nowarn_reply = 'Menciona al miembro para eliminarle la advertencia',
            nowarn = 'El número de advertencias de este miembro ha sido *reseteado*'
        },
        setlang = {
            list = '*Idiomas disponibles:*\n\n&&&1\nUsa `/lang xx` para cambiar el idioma',
            error = 'Idioma seleccionado *no disponible*. Usa `/lang` para ver los idiomas disponibles',
            success = '*New language setted:* &&&1'
        },
		banhammer = {
            kicked_header = 'Miembros expulsados:\n\n',
            kicked_empty = 'La lista de los miembros expulsados esta vacia',
            kicked = '&&&1 ha sido expulsado! (pero puede volver a entrar)',
            banned = '&&&1 ha sido baneado!',
            unbanned = 'User unbanned!',
            reply = 'Responder a alguien',
            globally_banned = '&&&1 ha sido baneado globalmente!',
            no_unbanned = 'Este es un grupo normal, los miembros no son bloqueados al expulsarlos',
            already_banned_normal = '&&&1 is *already banned*!',
            not_banned = 'The user is not banned',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` no es un valor valido!\nel valor tiene que ser *mayor* que `3` y *menor* que `26`',
            not_changed = 'El numero maximo de mensajes que pueden ser enviados en 5 segundos es &&&1',
            changed = 'El numero maximo de mensajes que pueden ser enviados en 5 segundos por &&&1 a &&&2',
            enabled = 'Antiflood activado',
            disabled = 'Antiflood desactivado',
            kick = 'Los flooders seran expulsados',
            ban = 'Los flooders seran baneados',
        },
        mediasettings = {
			warn = 'Este tipo de multimedia *no esta permitida* en este grupo.\n_La proxima vez_ seras baneado o expulsado',
            list_header = '*Lista del multimedia bloqueable*:\n\n',
            settings_header = '*Ajustes actuales de multimedia*:\n\n',
            already = 'El estado para el multimedia (`&&&1`) es (`&&&2`)',
            changed = 'Nuevo estado para (`&&&1`) = *&&&2*',
            wrong_input = 'Entrada invalida. Usa `/media list` para ver el multimedia disponible',
        },
        preprocess = {
            flood_ban = '&&&1 *baneado* por flood',
            flood_kick = '&&&1 *expulsado* por flood',
            media_kick = '&&&1 *expulsado*: multimedia no permitido',
            media_ban = '&&&1 *baneado*: multimedia no permitido',
            rtl = '&&&1 *expulsado*: caracter rtl en el nombre/mensage no permitido',
            arab = '&&&1 *expulsado*: mensaje arabe detectado',
            first_warn = 'This type of media is *not allowed* in this chat. The next time, *&&&1*'
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
            dashboard = 'I\'ve sent you the group dashboard in private',
            menu = 'I\'ve sent you the settings menu in private',
            dashboard_first = 'Navigate this message to see *all the info* about this group!',
            menu_first = 'Tap on a lock to *change the group settings*, or use the last row to _manage the anti-flood behaviour_',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
    br = {
        bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'I\'ve never seen this user before.\nIf you want to teach me who he is, forward me a message from him',
            the_group = 'the group',
            mods_list = '*Group moderators*:\n&&&1',
            settings_header = 'Current settings for *the group*:\n\n*Language*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            msg_me = '_Message me first so I can message you_'
        },
        pv = 'Esse comando está disponível apenas em grupos',
        not_mod = 'Você *não* é um(a) moderador(a)',
        breaks_markdown = 'Esse texto apresenta problemas com markdown.\nVerifique quantas vezes você usou * ou _ ou `',
        credits = '*Some useful links:*',
        extra = {
			usage = 'Escreva ao lado de /extra o título do comando e o texto associado.\nPor exemplo:\n/extra #motm seja positivo. O bot irá respoder _\'seja positivo\'_ toda vez que alguém digitar #motm',
            new_command = '*Novo comando definido!*\n&&&1\n&&&2',
            no_commands = 'Sem comandos definidos!',
            commands_list = 'Lista de *comandos personalizados*:\n&&&1',
            command_deleted = 'O comando &&&1 foi deletado',
            command_empty = 'O comando &&&1 não existe'
        },
        help = {
            owner = '*Comandos para o(a) dono(a)*:\n'
                    ..'`/owner` (por resposta) : define um(a) novo(a) dono(a)\n'
                    ..'`/promote` (por resposta|username) : promove membro(a) à moderador(a)\n'
                    ..'`/demote` (por resposta|username) : rebaixa um(a) membro(a)\n'
                    ..'`/setlink [link|\'no\']` : define o link do grupo para que possa ser chamado por moderadores(as), ou o desativa\n'
                    ..'(obviamente, a habilidade de apontar moderadores(as) tem como objetivo permitir usuários(as) de saberem quem são os verdadeiros moderadores(as) no grupo, e assim quem pode adicionar e remover pessoas.\nDesta forma, é altamente sugerido apontar como moderator(a) apenas quem realmente é um(a) moderador(a))\n\n',
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n",
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
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file_\n"
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
            all = '*Comandos para todos*:\n'
                    ..'`/dashboard` : see all the group info from private\n'
                    ..'`/rules` (se desbloqueado) : mostra as regra do grupo\n'
                    ..'`/about` (se desbloqueado) : mostra a descrição do grupo \n'
                    ..'`/modlist` (se desbloqueado) : mostra a lista de moderadores(as) do group\n'
                    ..'`@admin` (se desbloqueado) : by reply= report the message replied to all the admins; no reply (with text)= send a feedback to all the admins\n'
                    ..'`/tell` : mostra sua informação básica ou do(a) usuário(a) que você respondeu\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown)\n'
                    ..'`/info` : mostra algumas informações úteis sobre o bot\n'
                    ..'`/c` <feedback> : envia um feedback/bug/pergunta ao meu criador. _TODO TIPO DE SUGESTÃO OU PEDIDO DE FUNCIONALIDADE É BEM-VINDO_. Ele irá responder o mais breve possível\n'
                    ..'`/help` : exibe esta mensagem.'
		            ..'\n\nSe você gosta deste bot, por favor vote no quanto você acha que ele merece [aqui](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Olá, *&&&1*!\n'
                    ..'Eu sou um bot simples criado para ajudar pessoas a gerenciarem seus grupos.\n'
                    ..'\n*Como você pode me ajudar?*\n'
                    ..'Wew, Eu tenho várias ferraments úteis! Você pode *remover ou banir* usuários, definir regras e uma descrição, advertir usuários, definir alguns parâmetros parameters para remover alguem quando algo acontece (ler: *antiflood*/RTL/mídia...)\nDescubra mais me adicionando a um grupo!\n'
                    ..'\nO(a) usuário(a) que me adicionar será definido(a) automaticamente como o(a) dono(a) do grupo. Se você não for o(a) verdadeiro(a) dono(a), você pode definir respondendo uma das mensagens dele(a) com `/owner`.\n'
                    ..'\nPara usar meus poderes de administrador(remover/banir), *você deve me adicionar como administrador do grupo*.\nLembre-se: comandos de moderação só podem ser usados por quem foi promovido com `/promote`. Eu não posso ver quem são os(as) reais administradores(as) do grupo, esse é o único método por enquanto.\n'
                    ..'\nVocê pode relatar bugs/enviar feedbacks/fazer uma pergunta ao meu criador apenas usando o comando "`/c <feedback>`". TUDO É BEM-VINDO!'
                    ..'\n\n[Canal Oficial](https://telegram.me/GroupButler_ch) and [vote link](https://telegram.me/storebot?start=groupbutler_bot)',
			group_success = '_Eu enviei a mensagem de ajuda no privado_',
			group_not_success = '_Caso você nunca tenha me usado, me *inicie* e envie o comando /help por aqui novamente_',
			initial = 'Choose the *role* to see the available commands:',
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
            not_owner = 'Você *não* é o(a) dono(a) deste grupo.',
            reply_promote = 'Responda alguem para promovê-lo(a)',
            reply_demote = 'Responda alguem para rebaixá-lo(a)',
            reply_owner = 'Responda alguem para defini-lo(a) como dono(a)',
            already_mod = '*&&&1* já é moderador(a) de *&&&2*',
            already_owner = 'Você já é dono(a) deste grupo',
            not_mod = '*&&&1* não é moderador(a) de *&&&2*',
            promoted = '*&&&1* foi promovido(a) a moderador de *&&&2*',
            demoted = '*&&&1* foi rebaixado(a)',
            new_owner = '*&&&1* é o(a) novo(a) dono(a) de *&&&2*',
            modlist = '\n*Group moderators*:\n&&&1'
        },
        report = {
            no_input = 'Envie suas sugestões/bugs/dúvidas com "/c"',
            sent = '*Feedback enviado!*',
            feedback_reply = '*Olá, isto é uma resposta do dono do bot*:\n&&&1',
        },
        service = {
            new_group = 'Olá, todo mundo!\n*&&&1* me adicionou aqui para ajudá-los(as) a gerenciar este grupo.\nSe você quiser saber como eu funciono, por favor inice uma conversa comigo no privado ou digite /help :)',
            welcome = 'Olá, &&&1, e seja bem-vindo(a) ao *&&&2*!',
            welcome_rls = 'Anarquia total!',
            welcome_abt = 'Sem descrição para este grupo.',
            welcome_modlist = '\n\n*Lista de moderadores(as)*:\n',
            abt = '\n\n*Descrição*:\n',
            rls = '\n\n*Regras*:\n',
            bot_removed = '*&&&1* dados foram deletados.\nObrigado por ter me usado!\nEu estarei sempre aqui caso precise de uma mãozinha ;)'
        },
        setabout = {
            no_bio = '*SEM DESCRIÇÃO* para este grupo.',
            no_bio_add = '*Sem descrição para este grupo*.\nUse /setabout [descrição] para definir uma nova descrição',
            no_input_add = 'Por favor escreva algo após este pobre "/addabout"',
            added = '*Descrição adicionada:*\n"&&&1"',
            no_input_set = 'Por favor escreva algo após este pobre "/setabout"',
            clean = 'A descrição foi limpada.',
            new = '*Nova descrição:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*Anarquia total*!',
            no_rules_add = '*Sem regras* para este grupo.\nUse /setrules [regras] para definir uma nova constituição',
            no_input_add = 'Por favor adicione algo após este pobre "/addrules"',
            added = '*Regras adicionadas:*\n"&&&1"',
            no_input_set = 'Por favor escreva algo após este pobre "/setrules"',
            clean = 'As regras foram removidas.',
            new = '*Novas regras:*\n"&&&1"'
        },
        settings = {
            disable = {
                no_input = 'Desabilitar o que?',
                rules_already = 'O comando `/rules` já está *bloqueado*',
                rules_locked = 'O comando `/rules` agora está disponível *apenas para moderadores(as)*',
                about_already = 'O comando `/about` já está *bloqueado*',
                about_locked = 'O comando `/about` agora está disponível *apenas para moderadores(as)*',
                welcome_already = 'Mensagem de boas-vindas já está *bloqueada*',
                welcome_locked = 'Mensagem de boas-vindas *não será mostrada* a partir de agora',
                modlist_already = 'O comando `/modlist` já está *bloqueado*',
                modlist_locked = 'O comando `/modlist` agora está disponível *apenas para moderadores(as)*',
                flag_already = 'O comando `/flag` já está *desabilitado*',
                flag_locked = 'O comando `/flag` *não estará disponível* a partir de agora',
                extra_already = 'Comandos #extra já estão *bloqueados*',
                extra_locked = 'Comandos #extra agora estão disponíveis *apenas para moderadores(as)*',
                rtl_already = 'Anti-RTL já está *ativado*',
                rtl_locked = 'Anti-RTL agora está *ativado*',
                flood_already = 'Anti-flood is already *on*',
                flood_locked = 'Anti-flood is now *on*',
                arab_already = 'Anti-árabe já está *ativado*',
                arab_locked = 'Anti-árabe agora está *ativado*',
                report_already = 'comando @admin já está *desabilitado*',
                report_locked = 'O comando @admin *não estará disponível* a partir de agora',
                wrong_input = 'Argumento inválido.\nUse `/disable [rules|about|welcome|modlist|report|extra|rtl|arab|private]`',
            },
            enable = {
                no_input = 'Habilitar o que?',
                rules_already = 'O comando `/rules` já está *desbloqueado*',
                rules_unlocked = 'O comando `/rules` agora está disponível *para todos(as)*',
                about_already = 'O comando `/about` já está *desbloqueado*',
                about_unlocked = 'O comando `/about` agora está disponível *para todos(as)*',
                welcome_already = 'Mensagem de boas-vindas já está *desbloqueada*',
                welcome_unlocked = 'Mensagem de boas-vindas será mostrada a partir de agora',
                modlist_already = 'O comando `/modlist` já está *desbloqueado*',
                modlist_unlocked = 'O comando `/modlist` agora está disponível *para todos(as)*',
                flag_already = 'O comando `/flag` já está *disponível*',
                flag_unlocked = 'O comando `/flag` agora está *disponível*',
                extra_already = 'Comandos # Extra já estão *desbloqueados*',
                extra_unlocked = 'Comandos # Extra agora estão disponíveis *para todos(as)*',
                rtl_already = 'Anti-RTL já está *desligado*',
                rtl_unlocked = 'Anti-RTL agora está *desligado*',
                flood_already = 'Anti-flood is already *off*',
                flood_unlocked = 'Anti-flood is now *off*',
                arab_already = 'Anti-árabe já está *desligado*',
                arab_unlocked = 'Anti-árabe agora está *desligado*',
                report_already = 'O comando @admin já está *disponível*',
                report_unlocked = 'O comando @admin agora está *disponível*',
                wrong_input = 'Argumento inválido.\nUse `/enable [rules|about|welcome|modlist|report|extra|rtl|arab|private]`',
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
			    flood_info = '_Sensibilidade de flood :_ *&&&1* (_ação:_ *&&&2*)\n',
		    },
            Rules = 'Regras',
            About = 'Descrição',
            Welcome = 'Mensagem de boas-vindas',
            Modlist = 'Lista de moderadores(as)',
            Flag = 'Flag',
            Extra = 'Extra',
			Flood = 'Flood',
            Rtl = 'Rtl',
            Arab = 'Árabe',
            Report = 'Denúncia',
        },
        tell = {
            group_id = '*ID do grupo*: &&&1'
        },
        warn = {
            warn_reply = 'Responda a uma mensagem para adventir o(a) usuário(a)',
            changed_type = 'Nova ação ao receber máximo número de advertências: *&&&1*',
			mod = 'Moderadores(as) não podem ser advertidos',
			warned_max_kick = 'Usuário(a) &&&1 *removido(a)*: atingiu o número máximo de advertências',
            warned_max_ban = 'Usuário(a) &&&1 *banido(a)*: atingiu o número máximo de advertências',
            warned = '*Usuário(a)* &&&1 *foi advertido(a).*\n_Número de advertências_   *&&&2*\n_Máximo permitido_   *&&&3* (*-&&&4*)',
            warnmax = 'Número máximo de advertências foi alterado.\n*Antigo* valor: &&&1\n*Novo* valor: &&&2',
            getwarns_reply = 'Responda a um(a) usuário(a) para verificar seu número de advertências',
            limit_reached = 'Esse(a) usuário(a) já atingiu o número máximo de advertências (*&&&1/&&&2*)',
            limit_lower = 'Esse(a) usuário(a) está abaixo do número máximo de advertências.\nð*&&&1* restantes de um total de *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Responda a um(a) usuário(a) para deletar suas advertências',
            nowarn = 'O número de advertências recebidas por este(a) usuário(a) foi *resetado*'
        },
        setlang = {
            list = '*Lista de idiomas disponíveis:*\n\n&&&1\nUse `/lang xx` para mudar seu idioma',
            error = 'O idioma selecionado *não é suportado*. Use `/lang` para ver a lista de idiomas disponíveis',
            success = '*Novo idioma selecionado:* &&&1'
        },
		banhammer = {
            kicked_header = 'Lista de usuários(as) removido(as):\n\n',
            kicked_empty = 'A lista de usuários(as) removido(as) está vazia',
            kicked = '&&&1 foi removido(a)! Ainda pode entrar no grupo',
            banned = '&&&1 foi banido(a)!',
            unbanned = 'User unbanned!',
			reply = 'Responda alguém',
            globally_banned = '&&&1 foi banido(a) globalmente!',
            no_unbanned = 'Este é um grupo comum, pessoas não são bloqueadas quando excluídas',
            already_banned_normal = '&&&1 is *already banned*!',
            not_banned = 'The user is not banned',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        floodmanager = {
            number_invalid = '`&&&1` não é um número válido!\nO valor deve ser *maior* que `3` e *menor* que `26`',
            not_changed = 'O número máximo de mensagens que podem ser enviadas em 5 segundos já é &&&1',
            changed = 'O número máximo de mensagen que podem ser enviadas em 5 segundos foi alterada de &&&1 para &&&2',
            enabled = 'Antiflood habilitado',
            disabled = 'Antiflood desabilitado',
            kick = 'Agora floodadores(as) serão removidos(as)',
            ban = 'Agora floodadores(as) serão banidos(as)'
        },
        mediasettings = {
			warn = 'Esse tipo de mídia *não é permitida* neste grupo.\n_Na próxima vez_ voce séra removido(a) ou banido(a)',
            list_header = '*Aqui está a lista de midias que você pode bloquear*:\n\n',
            settings_header = '*Atuais configurações de midia*:\n\n',
            already = 'O estado para a midia (`&&&1`) já é (`&&&2`)',
            changed = 'Novo estado para (`&&&1`) = *&&&2*',
            wrong_input = 'Entrada incorreta. Use `/media list` para ver as midias disponíveis',
        },
        preprocess = {
            flood_ban = '&&&1 *banido(a)* por flood',
            flood_kick = '&&&1 *removido(a)* por flood',
            media_kick = '&&&1 *removido(a)*: midia enviada não permitida',
            media_ban = '&&&1 *banido(a)*: midia enviada não permitida',
            rtl = '&&&1 *removido(a)*: caracteres RTL (Right-to-Left, Direita para esquerda) em nomes/mensagens não são permitidos',
            arab = '&&&1 *removido(a)*: mensagem em árabe detectada',
            first_warn = 'This type of media is *not allowed* in this chat. The next time, *&&&1*'
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
            dashboard = 'I\'ve sent you the group dashboard in private',
            menu = 'I\'ve sent you the settings menu in private',
            dashboard_first = 'Navigate this message to see *all the info* about this group!',
            menu_first = 'Tap on a lock to *change the group settings*, or use the last row to _manage the anti-flood behaviour_',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
    ru = {
        bonus = {
            general_pm = '_I\'ve sent you the message in private_',
            no_user = 'Я не видел этого человека раньше.\nЕсли ты хочешь объяснить мне, кто он, сделай мне forward его сообщения',
            the_group = 'Группа',
            settings_header = 'Текущие настройки для *the group*:\n\n*Язык*: `&&&1`\n',
            reply = '*Reply to someone* to use this command, or write a *username*',
            msg_me = '_Чтобы я мог тебе писать, сначала напиши мне_'
        },
        pv = 'Эта команда доступна только в группе',
        not_mod = 'Ты *не* модератор',
        breaks_markdown = 'Этот текст содержит ошибку (markdown).\nИнформация о правильном использовании markdown [здесь](https://telegram.me/GroupButler_ch/46).',
        credits = '',
        extra = {
			usage = 'Напиши после /extra хэштег и текст, который будет печататься при написании этого хэштега.\nНапример:\n/extra #hello Приветствую. Бот будет печатать _\' Приветствую\'_ каждый раз, когда кто-то будет писать #hello',
            new_command = '*Команд�� установлена!*\n&&&1\n&&&2',
            no_commands = ' Нет команд!',
            commands_list = 'Список *установленных команд*:\n&&&1',
            command_deleted = '&&&1 команда удалена',
            command_empty = '&&&1 такой команды не существует'
        },
        help = {
            owner = '*Команды для владельца*:\n'
                    ..'`/owner (ответом) : сделать нового владельца\n'
                    ..'`/promote` (ответом) : сделать модератором\n'
                    ..'`/demote` (ответом) : снять с модераторства\n'
                    ..'`/setlink [ссылка|\'no\']` : установить ссылку на группу. Может быть изменена модераторами\n'
                    ..'( также добавление в модераторы даст возможность понять участникам группы кто настоящий модератор в группе и кто может банить / кикать людей из группы.\n)',
            mods = {
                banhammer = "*Moderators: banhammer powers*\n\n"
                            .."`/kick [by reply|username]` = kick a user from the group (he can be added again).\n"
                            .."`/ban [by reply|username]` = ban a user from the group (also from normal groups).\n"
                            .."`/unban [by reply|username]` = unban the user from the group.\n",
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
                        .."\n*List of supported media*: _image, audio, video, sticker, gif, voice, contact, file_\n"
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
            all = '*Команды для всех*:\n'
                    ..'`/rules` (если включено) : показать правила группы\n'
                    ..'`/about` (если включено) : показать описание группы\n'
                    ..'`/modlist` (если включено) : показать модераторов этой группы\n'
                    ..'`@admin` (если включено) : ответом= жалоба на это сообщение будет отправлена всем модераторам | без ответа (но с текстом после @admin)= отправит этот текст всем модераторам\n'
                    ..'`/tell` : показать информацию о человеке, которому ты отвечаешь\n'
                    ..'`/echo [text]` : the bot will send the text back (with markdown)\n'
                    ..'`/info` : показать информацию о боте\n'
                    ..'`/c` <сообщение> : отправить текст/ отчет об ошибке/ вопрос моему создателю . _Любая темя обсуждения и общения приветствуется_. Он ответит тебе здесь\n'
                    ..'`/help` : show this message.'
		            ..'\n\nЕсли тебе нравится этот бот, то ты можешь оценить его и заплатить эту ссылку куда-нибудь. Поставь свою оценку [ТУТ](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'Я бот, который создан, чтобы помогать администрации в организовании группы\n'
                    ..'\n*Чем я могу помочь тебе?*\n'
                    ..' Нус, у меня есть очень много полезных функций. Ты можешь банить, кикать людей. устанавливать правила и описание для группы, выдавать предупреждения людям с плохим поведением, задавать параметры, при которых кикать человека и ЕЩЕ ОЧЕНЬ МНОГО ВЕЩЕЙ, например антифлуд, медиа, фильтр символов.\nУзнай больше, добавив меня в группу\n'
                    ..'\nПользователь, который добавит меня в группу автоматически становится моим владельцем. Если ты не настоящий владелец, ты можешь поставить любого другого человека владельцем, ответив на его сообщение текстом `/owner`.'
                    ..'\n Чтобы я мог кикать/банить людей, *тебе нужно добавить меня как администратора в группу*.\nЗапомни: команды модератора доступны только тем, кто был повышен с помощью команды `/promote`. Я не могу видеть администраторов группы! \n'
                    ..'\nТы можешь сообщать разработчику о багах, недоработках. Задавать ему вопросы просто написав "`/c <сообщение>`" . Любые сообщения приветствуются!'
                    ..'\n\n[Официальный канал](https://telegram.me/GroupButler_ch) и [Поставить оценку](https://telegram.me/storebot?start=groupbutler_bot)',
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
            not_owner = 'Ты *не* владелец этой группы.',
            reply_promote = 'Ответь (reply) на чье-то сообщение, чтобы сделать его модератором',
            reply_demote = 'Ответь (reply) на чье-то сообщение, чтобы исключить его из администраторов',
            reply_owner = 'Ответь (reply) на чье-то сообщение, чтобы сделать его владельцем', 
            already_mod = '*&&&1* уже является модератором *&&&2*',
            already_owner = '*&&&1* уже является владельцем *&&&2*', 
            not_mod = '*&&&1* is not a moderator of *&&&2*',
            promoted = '*&&&1* был повышен до модератора *&&&2*',
            demoted = '*&&&1* был исключён из администраторов',
            new_owner = '*&&&1* является новым владельцем *&&&2*',
            modlist = '\nСписок *модераторов группы*:\n&&&1'
        },
        report = {
            no_input = 'Напиши свои идеи / баги /ошибки после "/c"',
            sent = ' Отправлено!',
            feedback_reply = '*Привет, это ответ от создателя *:\n&&&1',
        },
        service = {
            new_group = 'Привет всем!\n*&&&1* добавил меня сюда, чтобы помочь следить за группой. \nЕсли ты хочешь узнать как я работаю, пожалуйста напиши мне в личном сообщении или напиши /help  :)',
            welcome = 'Привет, &&&! Добро пожаловать в *&&&2*!',
            welcome_rls = 'АНАРХИЯ!',
            welcome_abt = 'Описание этой группы отсутствует!',
            welcome_modlist = '\n\n*Список модераторов*:\n',
            abt = '\n\n*Описание*:\n',
            rls = '\n\n*Правила*:\n',
            bot_removed = '*&&&1* информация была удалена.\nСпасибо за пользование!\nЯ всегда здесь, если тебе понадобится правая рука - обращайся ;)'
        },
        setabout = {
            no_bio = 'Описание этой группы *отсутствует*.',
            no_bio_add = 'Описание этой группы *отсутствует*.\nИспользуй /setabout [описание], чтобы установить описание для группы',
            no_input_add = ' Пожалуйста, напиши что-нибудь после "/addabout"',
            added = '* Описание добавлено:*\n"&&&1"',
            no_input_set = ' Пожалуйста, напиши что-нибудь после "/setabout"',
            clean = ' Описание было изменено.',
            new = '*Новое описание:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*ТОЛЬКО АНАРХИЯ*!',
            no_rules_add = 'У этой группы *нет правил*.\nИспользуй /setrules [правила], чтобы добавить правила',
            no_input_add = 'Пожалуйста, напиши что-нибудь после "/addrules"',
            added = '*Правила добавлены:*\n"&&&1"',
            no_input_set = 'Пожалуйста, напиши что-нибудь после "/setrules"',
            clean = 'Правила были очищены.',
            new = '*Новые правила:*\n"&&&1"'
        },
        settings = {
            disable = {
                no_input = 'Что отключить?',
                rules_already = '`/rules` уже *выключена*',
                rules_locked = '`/rules` теперь доступна *только для модераторов*',
                about_already = '`/about` уже *выключена*',
                about_locked = '`/about` теперь доступна *только для модераторов*',
                welcome_already = 'Приветственное сообщение уже *выключено*',
                welcome_locked = 'Приветственное сообщение теперь не будет показано.',
                modlist_already = '`/modlist` уже *выключена*',
                modlist_locked = '`/modlist` теперь доступна *только для модераторов*',
                flag_already = '`/flag` уже *выключена*',
                flag_locked = '`/flag` теперь не будет доступна',
                extra_already = '#extra уже *выключена*',
                extra_locked = '#extra теперь доступна *только для модераторов*',
                rtl_already = 'Anti-RTL фильтр уже *включен*',
                rtl_locked = 'Anti-RTL фильтр *включен*',
                flood_already = 'Анти-флуд уже *включен*',
                flood_locked = 'Анти-флуд *включен*',
                arab_already = 'Anti-arab фильтр уже *включен*',
                arab_locked = 'Anti-arab фильтр *включен*',
                report_already = '@admin уже *выключена*',
                report_locked = '@admin теперь не будет доступна',
                wrong_input = 'Неправильно задан аргумент.\nИспользуй `/disable [rules|about|welcome|modlist|report|extra|rtl|arab]` ',
            },
            enable = {
                no_input = 'Что включить?',
                rules_already = '`/rules` уже *включена*',
                rules_unlocked = '`/rules` команда теперь доступна *всем*',
                about_already = '`/about` уже *включена*',
                about_unlocked = '`/about` теперь доступна *для всех*',
                welcome_already = 'Приветственное сообщение уже *включено*',
                welcome_unlocked = 'Приветственное сообщение теперь будет показываться',
                modlist_already = '`/modlist` уже *включена*',
                modlist_unlocked = '`/modlist` теперь доступна *для всех*',
                flag_already = '`/flag` уже *включена*',
                flag_unlocked = '`/flag` теперь *включена*',
                extra_already = 'Extra # уже *включена*',
                extra_unlocked = 'Extra # теперь доступна *для всех*',
                rtl_already = 'Anti-RTL фильтр уже *выключен*',
                rtl_unlocked = 'Anti-RTL фильтр *выключен*',
                flood_already = 'Анти-флуд уже *выключен*',
                flood_unlocked = 'Анти-флуд *выключен*',
                arab_already = 'Anti-arab фильтр уже *выключен*',
                arab_unlocked = 'Anti-arab фильтр тепепь *выключен*',
                report_already = '@admin уже *включена*',
                report_unlocked = '@admin теперь *включена*',
                wrong_input = 'Неправильный аргумент.\nИспользуй `/enable [rules|about|welcome|modlist|report|extra|rtl|arab]` '
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
                flood_info = '_Чувствительность флуд-фильтра:_ *&&&1* (_action:_ *&&&2*)\n'
            },
            Rules = 'Правила',
            About = 'Описание',
            Welcome = 'Приветственное сообщение',
            Modlist = 'Список модераторов',
            Flag = 'Флаг',
            Extra = 'Экстра',
            Flood = 'Флуд',
            Rtl = 'Rtl',
            Arab = 'Арабский',
            Report = 'Жалоба',
        },
        tell = {
            group_id = '*ID группы*: &&&1'
        },
        warn = {
            warn_reply = 'Ответь на сообщение пользователя, на которого ты хочешь пожаловаться',
            changed_type = 'Новое максимальное количество предупреждений: *&&&1*',
            mod = 'Модераторы не могут быть предупреждены',
            warned_max_kick = 'Пользователь &&&1 *кикнут* по причине достижения максимального количества предупреждений',
            warned_max_ban = 'Пользователь &&&1 *забанен* по причине достижения максимального количества предупреждений', 
            warned = '*Пользователь* &&&1 *был предупрежден!*\n_Количество предупреждений_   *&&&2*\n_Максимальное разрешение_   *&&&3* (*-&&&4*)',
            warnmax = 'Макмимальное количество предупреждений изменено.\n*Старое* значение: &&&1\n*Новое* значение: &&&2',
            getwarns_reply = 'Ответь на сообщение пользователя, у которого хочешь проверить количество предупреждений',
            limit_reached = 'Этот пользователь уже получил максимальное количество предупреждений (*&&&1/&&&2*)',
            limit_lower = 'Этот пользователь почти достиг максимального количества предупреждений.\n*&&&1* предупреждений осталось до *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Ответь на сообщение пользователя, чтобы обнулить его счетчик предупреждений',
            nowarn = 'Количество предупреждений у этого пользователя *сброшено*'
        },
        setlang = {
            list = '*Список доступных языков:*\n\n&&&1\nИспользуй `/lang xx` чтобы сменить язык',
            error = 'Выбранный язык *не поддерживается*. Используй `/lang`, чтобы просмотреть список доступных языков',
            success = '*Новый язык установлен:* &&&1'
        },
		banhammer = {
            kicked_header = 'Список кикнутых пользователей:\n\n',
            kicked_empty = 'Список пуст',
            kicked = '&&&1 был кикнут! ( все еще может зайти )',
            banned = '&&&1 был забанен!',
            already_banned_normal = '&&&1 *уже забанен*!',
            unbanned = 'User unbanned!',
            reply = 'Ответь (reply) на сообщение этого пользователя',
            globally_banned = '&&&1 был глобально забанен!',
            not_unbanned = 'Это обычная группа, пользователи не блокируются, когда кикаются из группы'
        },
        floodmanager = {
            number_invalid = '`&&&1` неправильное число!\nЧисло должно быть *больше* чем `3` и *меньше* чем `26`',
            not_changed = 'Максимальное количество сообщений, которые можно отправить за 5 секунд уже &&&1',
            changed = 'Максимальное количество сообщений, которые можно отправить за 5 секунд изменено с &&&1 на &&&2',
            enabled = 'Антифлуд фильтр включен',
            disabled = 'Антифлуд фильтр выключен',
            kick = 'Теперь флудеры будут кикнуты',
            ban = 'Теперь флудеры будут забанены',
            general_motivation = 'I can\'t kick this user.\nProbably I\'m not an Amdin, or the user is an Admin iself'
        },
        mediasettings = {
			warn = 'Этот тип медиа *не разрешен* в этой группе.\n_В следующий раз_ ты будешь кикнут или забанен',
            list_header = '*Вот список  медиа, который ты можешь заблокировать*:\n\n',
            settings_header = '*Текущие настройки для медиа*:\n\n',
            already = ' Статус медиа (`&&&1`) уже (`&&&2`)',
            changed = 'Новый статус для (`&&&1`) = *&&&2*',
            wrong_input = 'Неверный ввод. Используй `/media list` чтобы просмотреть список надстроек медиа'
        },
        preprocess = {
            flood_ban = '&&&1 *забанен* за флуд',
            flood_kick = '&&&1 *кикнут* за флуд',
            media_kick = '&&&1 *кикнут*: отправленный тип медиа не разрешен',
            media_ban = '&&&1 *забанен*: отправленный тип медиа не разрешен',
            rtl = '&&&1 *кикнут*: rtl символы в имени/сообщениях не разрешены',
            arab = '&&&1 *кикнут*: арабские сообщения обнаружены',
            first_warn = 'This type of media is *not allowed* in this chat. The next time, *&&&1*'
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
            dashboard = 'Я отправил тебе меню управления личным сообщением',
            menu = 'Я отправил тебе меню настроек личным сообщением',
            dashboard_first = 'Navigate this message to see *all the info* about this group!',
            menu_first = 'Tap on a lock to *change the group settings*, or use the last row to _manage the anti-flood behaviour_',
            media_first = 'Tap on a voice in the right colon to *change the setting*'
        },
    },
}