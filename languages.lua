--v1.2
return {
    en = {
        pv = 'This is a command available only in a group',
        not_mod = 'You are *not* a moderator',
        breaks_markdown = 'This text breaks the markdown.\nCheck how many times you used * or _ or `',
        ping= 'Pong!',
        control = {
            reload = '*Bot reloaded!*',
            stop = '*Stopping bot!*'
        },
        credits = 'This bot is based on [GroupButler bot](https://github.com/RememberTheAir/GroupButler), an *opensource* bot available on [Github](https://github.com/). Follow the link to know how the bot works or which data are stored.\n\nRemember you can always use /r command to ask something.',
        extra = {
			usage = 'Write next to /extra the title of the command and the text associated.\nFor example:\n/extra #motm stay positive. The bot will reply _\'Stay positive\'_ each time someone wites #motm',
            new_command = '*New command setted!*\n&&&1\n&&&2',
            no_commands = 'No commands setted!',
            commands_list = 'List of *custom commands*:\n&&&1',
            command_deleted = '&&&1 command have been deleted',
            command_empty = '&&&1 command does not exist'
        },
        flag = {
            reply_flag = 'Reply to a message to report it to admins',
            mod_msg = '&&&1&&&2 reported &&&3&&&4\nDescription: &&&5\nMessage reported:\n\n&&&6',
            group_msg = '*Flagged!*',
            reply_block = 'Reply to an user to block his /flag power',
            mod_cant_flag = 'Moderators can\'t flag people',
            already_unable = '*&&&1* is already unable to use /flag command',
            blocked = '*&&&1* is now *unable* to use /flag',
            reply_unblock = 'Reply to an user to unblock his /flag power',
            already_able = '*&&&1* is already *able* to use /flag command',
            unblocked = '*&&&1* is now *able* to use /flag',
            list_empty = 'There are zero people unable to use /flag command in this group',
            list = '\nUsers unable to flag:\n&&&1'
        },
        getstats = {
            redis = 'Redis updated',
            stats = '&&&1'
        },
        help = {
            owner = '*Commands for the owner*:\n'
                    ..'`/owner` (by reply) : set a new owner\n'
                    ..'`/promote` (by reply) : promote as moderator a member\n'
                    ..'`/demote` (by reply) : demote a member\n'
                    ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by mods, or unset it\n'
                    ..'(obviuosly, the ability to appoint moderators is aimed to let users know who are the real moderators in the group, and so who can add and kick people.\nSo it\'s hardly suggested to point as moderator only who really is a moderator)\n\n',
            moderator = '*Commands for moderators*:\n'
                        ..'`/kick` (by reply) : kick a user from the group (he can be added again)\n'
                        ..'`/ban` (by reply) : ban a user from the group\n'
                        ..'`/kicked list` :see a list of kicked users\n'
                        ..'`/flood [kick/ban]` : choose what the bot should do when the flood limit is triggered\n'
                        ..'`/flood [on/off]` : turn on/off the flood listener\n'
                        ..'`/flood [messages]` : set how many messages a user can write in 5 seconds\n'
                        ..'`/setrules <rules>` : set a completly new list of rules\n'
                        ..'`/addrules <rules>` : add at the tile of the existing rules a new set of rules\n'
                        ..'`/setabout <bio>` : set a completly new description for the group\n'
                        ..'`/addabout <bio>` : add at the end of the existing description other relevant informations\n'
                        ..'With this four commands above, you can use asterisks (*bold*), uderscores (_italic_) or the oblique accent (`monospace`) to markup your rules/description.\n'
                        ..'`/[kick|ban|allow] [media]` : choose the action to perform when the media is sent\n'
                        ..'`/media` : show the status of media settings\n'
                        ..'`/link` : get the group link, if setted\n'
                        ..'`/lang` : see the list of available languages\n'
                        ..'`/lang` [code] : change the language of the bot\n'
                        ..'`/settings` : show the group settings\n'
                        ..'`/warn [kick/ban]` : choose the action to perform once the max number of warnings is reached\n'
                        ..'`/warn` (by reply) : warn an user. At x warns, he will be kicked/banned\n'
                        ..'`/getwarns` (by reply) : see how many times an user have been warned\n'
                        ..'`/nowarns` (by reply) : reset to zero the warns of an user\n'
                        ..'`/warnmax` : set the max number of the warns before be banned/kicked\n'
                        ..'`/extra` [#trigger] [reply] : set a new custom command that will be triggered with #hashtags (markdown supported)\n'
                        ..'`/extra list` : get the list of your custom commands\n'
                        ..'`/extra del` [#trigger] : delete the trigger and its content\n'
                        ..'`/setpoll [link|\'no\']` : save a poll link from @pollbot, so it can be re-called by mods, or unset it\n'
                        ..'`/poll` : get the current poll link\n'
                        ..'`/disable <rules|about|modlist|extra>` : this commands will be available only for moderators\n'
                        ..'`/enable <rules|about|modlist|extra>` : this commands will be available for all\n'
                        ..'`/enable|/disable <welcome|flag>` : switch on/off the welcome message/the ability to flag messages\n'
                        ..'`/flag block|/flag free` (by reply) : the user won\'t be able/will be able to report messages\n'
                        ..'`/flag list` : show the list of users who can\'t flag messages\n'
                        ..'`/welcome <no|r|a|ra|ma|rm|rma>` : how the welcome message is composed\n'
                        ..'_no_ : only the simple welcome message\n'
                        ..'_r_ : the welcome message will be integrated with rules\n'
                        ..'_a_ : the welcome message will be integrated with the about text\n'
                        ..'_m_ : the welcome message will be integrated with the moderators list\n'
                        ..'_ra|ar_ : the welcome message will be integrated with rules and bio\n'
                        ..'_ma|am_ : the welcome message will be integrated with about text and moderators list\n'
                        ..'_rm|mr_ : the welcome message will be integrated with rules and moderators list\n'
                        ..'_ram|rma|mar|mra|arm|amr_ : the welcome message will be integrated with rules, about text and moderators list\n\n',
            all = '*Commands for all*:\n'
                    ..'`/rules` (if unlocked) : show the group rules\n'
                    ..'`/about` (if unlocked) : show the group description\n'
                    ..'`/modlist` (if unlocked) : show the moderators of the group\n'
                    ..'`/flag msg` (by reply and if unlocked) `[optional description]` : report the message to administrators\n'
                    ..'`/tell` : show your basical info or the info about the user you replied to\n'
                    ..'`/info` : show some useful informations about the bot\n'
                    ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
                    ..'`/help` : show this message.'
		            ..'\n\nIf you like this bot, please leave the vote you think it deserves [here](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'I\'m a simple bot created in order to help people to manage their groups.\n'
                    ..'\n*How can you help me?*\n'
                    ..'With me, you can define rules and description of your group, set up a moderators list, choose whether I have to display the regulation or the description when a new member join the group, set up the group link or a link to a poll, and other things like that.\nDiscover more by adding me to a group!\n'
                    ..'\nThe user that add me will be automatically set up as owner of the group. If you are not the real owner, you can set it by repliyng one of his messages with `/owner`.\n'
                    ..'\nYou can report bugs/send feedbacks/ask a question to my creator just using "`/c <feedback>`" command. EVERYTHING IS WELCOME! He will reply ASAP ;)',
            group = 'I\'ve sent you the help message in *private*.\nIf you have never used me, *start* me and ask for help here *again*.'
        },
        links = {
            no_link = '*No link* for this group. Ask the owner to generate one',
            link = '[&&&1](&&&2)',
            link_invalid = 'This link is *not valid!*',
            link_updated = 'The link have been updated.\n*Here\'s the new link*: [&&&1](&&&2)',
            link_setted = 'The link have been setted.\n*Here\'s the link*: [&&&1](&&&2)',
            link_usetted = 'Link *unsetted*',
            poll_unsetted = 'Poll *unsetted*',
            poll_updated = 'The poll have been updated.\n*Vote here*: [&&&1](&&&2)',
            poll_setted = 'The link have been setted.\n*Vote here*: [&&&1](&&&2)',
            no_poll = '*No active polls* for this group',
            poll = '*Vote here*: [&&&1](&&&2)'
        },
        luarun = {
            enter_string = 'Please enter a string to load',
            done = 'Done!'
        },
        mod = {
            not_owner = 'You are *not* the owner of this group.',
            reply_promote = 'Reply to someone to promote him',
            reply_demote = 'Reply to someone to demote him',
            reply_owner = 'Reply to someone to set him as owner',
            already_mod = '*&&&1* is already a moderator of *&&&2*',
            already_owner = 'You are already the owner of this group',
            not_mod = '*&&&1* is not a moderator of *&&&2*',
            promoted = '*&&&1* has been promoted as moderator of *&&&2*',
            demoted = '*&&&1* has been demoted',
            new_owner = '*&&&1* is the new owner of *&&&2*',
            modlist = '\nModerators list of &&&1:\n&&&2'
        },
        redisbackup = 'Backup saved as _redisbackup.json_',
        redisinfo = {
            hash_info = 'Info about the hash:\n\n&&&1',
            found = 'User found'
        },
        report = {
            no_input = 'Write your suggestions/bugs/doubt near "/contact"',
            sent = '*Feedback sent*:\n\n&&&1',
            reply = 'Reply to a feedback to reply to the user',
            reply_no_input = 'Write your reply next to "/reply"',
            feedback_reply = 'Hi *&&&1*, this is a reply to your feedback:\n"&&&2..."\n\n*Reply*:\n&&&3',
            reply_sent = '*Reply sent*:\n\n&&&1',
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
            bio = '*Bio of &&&1:*\n&&&2',
            no_bio_add = '*No bio for this group*.\nUse /setabout [bio] to set-up a new description',
            no_input_add = 'Please write something next this poor "/addabout"',
            added = '*Description added:*\n"&&&1"',
            no_input_set = 'Please write something next this poor "/setabout"',
            clean = 'The bio has been cleaned.',
            new = '*New bio:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*Total anarchy*!',
            rules = '*Rules for &&&1:*\n&&&2',
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
                wrong_input = 'Argument unavailable.\nUse `/disable [rules|about|welcome|modlist|flag|extra]` instead'
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
                wronf_input = 'Argument unavailable.\nUse `/enable [rules|about|welcome|modlist|flag|extra]` instead'
            },
            welcome = {
                no_input = 'Welcome and...?',
                a = 'New settings for the welcome message:\nRules\n*About*\nModerators list',
                r = 'New settings for the welcome message:\n*Rules*\nAbout\nModerators list',
                m = 'New settings for the welcome message:\nRules\nAbout\n*Moderators list*',
                ra = 'New settings for the welcome message:\n*Rules*\n*About*\nModerators list',
                rm = 'New settings for the welcome message:\n*Rules*\nAbout\n*Moderators list*',
                am = 'New settings for the welcome message:\nRules\n*About*\n*Moderators list*',
                ram = 'New settings for the welcome message:\n*Rules*\n*About*\n*Moderators list*',
                no = 'New settings for the welcome message:\nRules\nAbout\nModerators list',
                wrong_input = 'Argument unavailable.\nUse _/welcome [no|r|a|ra|ar]_ instead'
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
                w_no = '*Welcome type*: `welcome only`\n'
            },
            Rules = 'Rules',
            About = 'About',
            Welcome = 'Welcome message',
            Modlist = 'Modlist',
            Flag = 'Flag',
            Extra = 'Extra'
        },
        shell = {
            no_input = 'Please specify a command to run.',
            done = 'Done!',
            output = '```\n&&&1\n```'
        },
        tell = {
            first_name = '*First name*: &&&1\n',
            last_name = '*Last name*: &&&1\n',
            group_name = '\n*Group name*: &&&1\n',
            group_id = '*Group ID*: &&&1'
        },
        warn = {
            warn_reply = 'Reply to a message to warn the user',
            changed_type = 'New action on max number of warns received: *&&&1*',
            mod = 'A moderator can\'t be warned',
            warned_max_kick = 'User &&&1 *kicked*: reached the max number of warns',
            warned_max_ban = 'User &&&1 *banned*: reached the max number of warns*',
            warned = '*User* &&&1 *have been warned.*\n_Number of warnings_   *&&&2*\n_Max allowed_   *&&&3* (*-&&&4*)',
            warnmax = 'Max number of warnings changed.\n*Old* value: &&&1\n*New* max: &&&2',
            getwarns_reply = 'Reply to an user to check his numebr of warns',
            limit_reached = 'This usern has already reached the max number of warnings (*&&&1/&&&2*)',
            limit_lower = 'This user is under the max number of warnings.\n*&&&1* warnings missing on a total of *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Reply to an user to delete his warns',
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
            kicked = '&&&1 have been kicked! Is still able to join',
            banned = '&&&1 have been banned!',
            reply = 'Reply to someone'
        },
        floodmanager = {
            not_changed = 'The max number of messages that can be sent in 5 seconds is already &&&1',
            changed = 'The max number of messages that can be sent in 5 seconds changed from &&&1 to &&&2',
            enabled = 'Antiflood enabled',
            disabled = 'Antiflood disabled',
            kick = 'Now flooders will be kicked',
            ban = 'Now flooders will be banned'
        },
        mediasettings = {
            list_header = '*Here the list of the media you can block*:\n\n',
            settings_header = '*Current settings for media*:\n\n',
            already = 'The status for the media (`&&&1`) is already (`&&&2`)',
            changed = 'New status for (`&&&1`) = *&&&2*',
            wrong_input = 'Wrong input. Use `/media list` to see the available media',
        },
        preprocess = {
            flood_ban = '&&&1 *banned* for flood',
            flood_kick = '&&&1 *kicked* for flood',
            media_kick = '&&&1 *kicked*: media sent not allowed',
            media_ban = '&&&1 *banned*: media sent not allowed',
        },
        broadcast = {
            delivered = 'Broadcast delivered. Check the log for the list of reached ids',
            no_users = 'No users saved, no broadcast',
        },
    },
}

