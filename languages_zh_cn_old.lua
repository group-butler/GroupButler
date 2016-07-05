    zh_cn = {
        status = {
            kicked = '&&&1 已被封禁',
            left = '&&&1 已离开或被移出了群组',
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
            reply = '通过*回复某人*或*@用户名*来使用这个指令',
            too_long = '这段文本太长了，我无法发送它。',
            msg_me = '_给我发条消息，我就能为您服务。_',
            tell = '*Group ID*: &&&1'
        },
        pv = '这条指令仅在群组中可以使用',
        not_mod = '你*不是*监督员',
        breaks_markdown = '这段文本不符合*markdown*语法。\n有关Markdown语言的正确使用方法，可见[此处](https://telegram.me/GroupButler_ch/46)。',
        credits = '*一些常用链接：*',
        not_admin = '_我只有在成为群组管理员时才能正常运作，否则我无法判断谁是管理员:(\n详情见_ [此处](https://telegram.me/GroupButler_ch/63)',
        extra = {
            setted = '&&&1 指令已保存！',
			usage = '在 /extra 后添加指令的标题和要提及的内容。\n例如：\n/extra #cat Meow~ 机器人将会在每次使用 #cat 的时候回复_\'Meow~\'_ ',
            new_command = '*新的指令已设置！*\n&&&1\n&&&2',
            no_commands = '还没有设置指令！',
            commands_list = '*自定义指令*列表：\n&&&1',
            command_deleted = '&&&1 指令已被删除',
            command_empty = '&&&1 指令不存在'
        },
        help = {
            mods = {
                banhammer = "*监督员权限: 禁令之锤*\n\n"
                            .."`/kick [通过回复|@用户名]` = 将某人移出群组。（可以被添加回群组）\n"
                            .."`/ban [通过回复|@用户名]` = 封禁某人。（包括普通群组）\n"
                            .."`/tempban [时长（分钟）]` = 将某人临时屏蔽一段时间（时长必须 < 10080 分钟 = 1周）. 目前仅支持通过回复执行此指令。\n"
                            .."`/unban [通过回复|@用户名]` = 将某人从黑名单中移除.\n"
                            .."`/status [@用户名]` = 显示某人的状态 `(群员|已离开/被移出|被封禁|管理员/创建者|不认识)`.\n"
                            .."`/banlist` = 显示被封禁的用户及原因（如果有记录）\n"
                            .."\n*注*：你可以在 `/ban` 指令后附上备注（如果你是通过 `@用户名` 封禁的，可以在用户名后附上）."
                            .." 这段备注将会作为封禁原因记录。",
                info = "*监督员权限: 群组介绍*\n\n"
                        .."`/setrules [群组规则]` = 设置新的群组规则。（旧规则将会被覆盖）\n"
                        .."`/addrules [文本]` = 在现有规则后添加文本。\n"
                        .."`/setabout [群组简介]` = 设置新的群组简介。（旧简介将会被覆盖）\n"
                        .."`/addabout [文本]` = 在现有简介后添加新的文本。\n"
                        .."\n*注*：支持markdown语言，如果您发送的文本里有语法错误，机器人将会提醒您。\n"
                        .."有关Markdown语言的正确使用方法，可见[此处](https://telegram.me/GroupButler_ch/46)。",
                flood = "*监督员权限: 刷屏控制*\n\n"
                        .."`/flood [开启/关闭]` = 开启/关闭防刷屏系统。\n"
                        .."`/flood [数字]` = 设置一个用户在 5 秒内可以发送多少条信息。\n"
                        .."_注_：数字必须 > 3 且 < 26。\n"
                        .."`/flood [移除/封禁]` = 达到限制值时机器人应执行什么指令？（移除/封禁）\n"
                        .."\n*注*：你可以在私聊中使用 `/menu` 指令获取内联菜单以管理防刷屏设置。",
                media = "*监督员权限: 媒体消息*\n\n"
                        .."`/media` = 在私聊中获取内联菜单以更改媒体消息设置。\n"
                        .."`/media [移除|封禁|放行] [媒体类型]` = 当特定媒体类型被发送时，机器人执行的指令。\n"
                        .."_如_ ： `/media kick sticker`.\n"
                        .."`/media list` = 列出目前的媒体消息设置。\n"
                        .."\n*支持的媒体类型列表*: _image, audio, video, sticker, gif, voice, contact, file, link_\n"
                        .."\n*注*：若有人第一次发送被禁止的媒体消息，机器人将会先进行警告。只有在第二次触犯时才会被移除/封禁。",
                welcome = "*监督员权限: 新用户欢迎*\n\n"
                            .."`/enable welcome` = 当有新用户加入时会发送欢迎语。\n"
                            .."`/disable welcome` = 欢迎语将不会被发送。\n"
                            .."\n*自定义欢迎语：*\n"
                            .."`/welcome 欢迎 $name，快和其他人打成一片吧！`\n"
                            .."在\"/welcome\" 指令后附上欢迎语，同时你也可以使用一些占位符来添加新群员的 name/username/id。\n"
                            .."占位符: _$username_ （将会被代入为用户名）; _$name_ （将会被代入为姓名）; _$id_ （将会被代入为ID）; _$title_ （将会被代入为群组名）。\n"
                            .."\n*将GIF/贴纸作为欢迎语*\n"
                            .."你可以使用特定的gif/贴纸作为欢迎语，你可以通过对gif/贴纸消息回复“/welcome” 来进行设置。\n"
                            .."\n*构造欢迎语*\n"
                            .."你可以借助 `群组规则`、 `群组介绍` 、 `监督员名单` 等素材来构造欢迎语。\n"
                            .."你可以依照 `/welcome` + `素材代号` 的格式，将必要的内容构造成欢迎语。\n"
                            .."_素材代号_ : *r* = 群组规则; *a* = 群组介绍; *m* = 监督员名单。\n"
                            .."举例来说：若您输入指令 \"`/welcome rm`\" ，欢迎语将会展示 群组规则 和 监督员名单。",
                extra = "*监督员权限: 附加指令*\n\n"
                        .."`/extra [#触发文本] [回复]` = 当某人的消息中涉及了指定触发文本时，设置机器人要回复的内容。\n"
                        .."_例如_ : 若输入指令 \"`/extra #早呀 早上好！`\"，那么在每次有人发送 #早呀 的文本时，机器人将回复 \"早上好！\"。\n"
                        .."你也可以使用 `/extra #触发文本` 回复一条媒体消息 (_包括图片、文件、语音、视频、音频、gif_)来保存这条回复规则，以让机器人每逢检测到此触发文本时，自动回复此媒体消息。\n"
                        .."`/extra list` = 列出目前已经设置的附加指令。\n"
                        .."`/extra del [#触发文本]` = 删除指定触发文本的回复规则。\n"
                        .."`/disable extra` = 只有管理员可以在群组里使用 For the other users, the bot will reply in private.\n"
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
