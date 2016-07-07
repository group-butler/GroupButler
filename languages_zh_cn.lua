    zh_cn = {
        status = {
            kicked = '&&&1 已被封禁',
            left = '&&&1 已离开或被移出了群组',
            administrator = '&&&1 是群组管理员',
            creator = '&&&1 是群组创建者',
            unknown = '此用户与本群没有关系',
            member = '&&&1 是本群群员'
        },
        userinfo = {
            header_1 = '*封禁信息（全局）*:\n',
            header_2 = '*常规信息*:\n',
            warns = '`警告`: ',
            media_warns = '`媒体消息警告`: ',
            group_msgs = '`Messages in the group`: ',
            group_media = '`Media sent in the group`: ',
            last_msg = '`Last message here`: ',
            global_msgs = '`Total number of messages`: ',
            global_media = '`Total number of media`: ',
            remwarns_kb = '移除警告'
        },
        getban = {
            header = '有关此人的*全局统计*： ',
            nothing = '`没有可以显示的信息`',
            kick = '移除: ',
            ban = '封禁: ',
            tempban = '临时屏蔽: ',
            flood = '因刷屏而移除: ',
            warn = '因多次警告而移除: ',
            media = 'Removed for forbidden media: ',
            arab = 'Removed for arab chars: ',
            rtl = 'Removed for RTL char: ',
            kicked = '_Kicked!_',
            banned = '_Banned!_'
        },
        bonus = {
            general_pm = '_我已经将消息私聊给您了_',
            no_user = '我不认识这位用户。\n如果您想告诉我他是谁，请转发一条他的消息给我。',
            the_group = '群组',
            adminlist_admin_required = '我还不是群组管理员。\n*只有群组管理员才能看见管理员名单*',
            settings_header = '当前*群组*的语言设定是:\n\n*简体中文*: `&&&1`\n',
            reply = '通过*回复某人*或*@用户名*来使用这个命令',
            too_long = '这段文本太长了，我无法发送它。',
            msg_me = '_给我发条消息，我就能为您服务。_',
            menu_cb_settings = 'Tap on an icon!',
            menu_cb_warns = 'Use the row below to change the warns settings!',
            menu_cb_media = 'Tap on a switch!',
            tell = '*群组ID*: &&&1',
        },
        not_mod = '您 *不是* 监督员',
        breaks_markdown = '这段文本不符合*markdown*语法。\n有关Markdown语言的正确使用方法，可参考[此文](https://telegram.me/GroupButler_ch/46)。',
        credits = '*一些常用链接：*',
        extra = {
            setted = '&&&1 命令已保存！',
			new_command = '*新的命令已设置！*\n&&&1\n&&&2',
            no_commands = '还没有设置命令！',
            commands_list = '*自定义命令*列表：\n&&&1',
            command_deleted = '&&&1 命令已被删除',
            command_empty = '&&&1 命令不存在'
        },
        help = {
            mods = {
                banhammer = "*监督员权限: 禁令之锤*\n\n"
                            .."`/kick [通过回复|@用户名]` = 将某人移出群组。（可以被添加回群组）\n"
                            .."`/ban [通过回复|@用户名]` = 封禁某人。（包括普通群组）\n"
                            .."`/tempban [时长（分钟）]` = 将某人临时屏蔽一段时间（时长必须 < 10080 分钟 = 1周）。目前仅支持通过回复执行此命令。\n"
                            .."`/unban [通过回复|@用户名]` = 将某人从黑名单中移除.\n"
                            .."`/user [通过回复|@用户名|id]` = 返回一条2页长的消息：第一页将显示此用户在 *所有群组中* 被封禁的次数(divided in sections), "
                            .."第二页将会显示一些有关此用户的常规统计，包括但不限于: 在群组内发送信息/媒体消息的次数、被警告的次数等。\n"
                            .."`/status [@用户名]` = 显示某人的状态 `(群员|已离开/被移出|被封禁|管理员/创建者|不认识)`.\n"
                            .."`/banlist` = 显示被封禁的用户及原因（如果有记录）\n"
                            .."`/banlist -` = 清空封禁列表。\n"
                            .."\n*注*：您可以在 `/ban` 命令后附上备注（如果您是通过 `@用户名` 封禁的，可以在用户名后附上）."
                            .." 这段备注将会作为封禁原因记录。",
                info = "*监督员权限: 群组介绍*\n\n"
                        .."`/setrules [群组规则]` = 设置新的群组规则。（旧规则将会被覆盖）\n"
                        .."`/addrules [文本]` = 在现有规则后添加文本。\n"
                        .."`/setabout [群组简介]` = 设置新的群组简介。（旧简介将会被覆盖）\n"
                        .."`/addabout [文本]` = 在现有简介后添加新的文本。\n"
                        .."\n*注*：支持markdown语言，如果您发送的文本里有语法错误，机器人将会提醒您。\n"
                        .."有关Markdown语言的正确使用方法，可参考[此文](https://telegram.me/GroupButler_ch/46)。",
                flood = "*监督员权限: 刷屏控制*\n\n"
                        .."`/antiflood` = 使用内联菜单以在私聊中管理防刷屏设置，包括：灵敏度、防刷屏措施（移除/封禁）、例外情况。\n"
                        .."`/antiflood [数字]` = 设置一个用户在 5 秒内可以发送多少条信息。\n"
                        .."_注_：数字必须 > 3 且 < 26。\n"
                media = "*监督员权限: 媒体消息*\n\n"
                        .."`/media` = 在私聊中获取内联菜单以更改媒体消息设置。\n"
                        .."`/warnmax media [数字]` = 设置容许用户发送被禁止的媒体消息的次数，当超过此次数时此用户将被移除/封禁。\n"
                        .."`/nowarns (通过回复)` = 重置指定成员的警告次数 (*注：包括常规警告和媒体消息警告*)。\n"
                        .."`/media list` = 列出目前的媒体消息设置。\n"
                        .."\n*支持的媒体类型列表*: _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*监督员权限: 新用户欢迎*\n\n"
                            .."`/menu` = 通过在私聊中操作菜单，您将会找到一个可以控制欢迎语开启与否的选项。\n"
                            .."\n*自定义欢迎语：*\n"
                            .."`/welcome 欢迎 $name，快和其他人打成一片吧！`\n"
                            .."在\"/welcome\" 命令后附上欢迎语，同时您也可以使用一些占位符来添加新群员的 name/username/id。\n"
                            .."占位符: _$username_ （将会被代入为用户名）; _$name_ （将会被代入为姓名）; _$id_ （将会被代入为ID）; _$title_ （将会被代入为群组名）。\n"
                            .."\n*将GIF/贴纸作为欢迎语*\n"
                            .."您可以使用特定的gif/贴纸作为欢迎语，您可以通过对gif/贴纸消息回复 \'/welcome\' 来进行设置。\n"
                            .."\n*构造欢迎语*\n"
                            .."您可以借助 `群组规则`、 `群组介绍` 、 `监督员名单` 等素材来构造欢迎语。\n"
                            .."您可以依照 `/welcome` + `素材代号` 的格式，将必要的内容构造成欢迎语。\n"
                            .."_素材代号_ : *r* = 群组规则; *a* = 群组介绍; *m* = 监督员名单。\n"
                            .."举例来说：若您输入命令 \"`/welcome rm`\" ，欢迎语将会显示 群组规则 和 监督员名单。",
                extra = "*监督员权限: 附加命令*\n\n"
                        .."`/extra [#触发文本] [回复]` = 当某人的消息中涉及了指定触发文本时，设置机器人要回复的内容。\n"
                        .."_例如_ : 若输入命令 \"`/extra #早呀 早上好！`\"，那么在每次有人发送 #早呀 的文本时，机器人将回复 \"早上好！\"。\n"
                        .."您也可以使用 `/extra #触发文本` 回复一条媒体消息 (_包括图片、文件、语音、视频、音频、gif_)来保存这条回复规则，以让机器人每逢检测到此触发文本时，自动回复此媒体消息。\n"
                        .."`/extra list` = 列出目前已经设置的附加命令。\n"
                        .."`/extra del [#触发文本]` = 删除指定触发文本的回复规则。\n"
                        .."\n*注：* 支持markdown语言，如果您发送的文本里有语法错误，机器人将会提醒您。\n"
                        .."有关Markdown语言的正确使用方法，可参考[此文](https://telegram.me/GroupButler_ch/46)",
                warns = "*监督员权限: 警告*\n\n"
                        .."`/warn [通过回复]` = 警告指定用户，若此用户达到最大警告数限制，他将被移除/封禁.\n"
                        .."`/warnmax` = 设置最大警告次数，若某用户获警告次数达到此数值，将被移除/封禁\n"
                        .."\n查看一名用户获警告次数的方法: 此数值在 `/user` 命令返回信息中第2页中出现。您也可以在这一页的内联菜单中重置警告次数。",
                char = "*监督员权限: 特殊字符*\n\n"
                        .."`/menu` = 您可以在私聊中通过菜单获取此设置。\n"
                        .."这里为您提供2个设置项: _阿拉伯字母 和 RTL字符_.\n"
                        .."\n*阿拉伯字母*: 若阿拉伯字母被禁止(🚫)，任何在消息中使用阿拉伯字母的行为，将导致此用户被移出群组。\n"
                        .."*Rtl字符*: 即'右向左'字符，它是造成“消息倒序显示”的怪诞现象的元凶。\n"
                        .."若Rtl字符被禁止(🚫)，任何在消息中使用此类字符（或在名字中使用）的行为，将导致此用户被移出群组。",
                links = "*监督员权限: 链接*\n\n"
                        .."`/setlink [链接地址|'no']` : set the group link, so it can be re-called by other admins, or unset it.\n"
                        .."`/link` = 获取群组链接（当群组创始人设置时）。\n"
                        .."\n*注*: 机器人能够识别链接是否有效。若链接是非法的，则不会回复任何信息。",
                lang = "*监督员权限: 群组语言*\n\n"
                        .."`/lang` = 选择群组语言（同样可以在私聊中设置）。\n"
                        .."\n*注*: 译者均为志愿翻译，因此我不能保证所有翻译的准确性。我也不能强迫他们在每次更新后翻译新的字符串（未被翻译的字符串将会以英语语言出现）."
                        .."\n无论如何，翻译的权利是开放给任何人的。使用 `/strings` 命令来获取一份包括所有字符串的 _.lua_ 文件（英语）。\n"
                        .."使用 `/strings [lang code]` 来获取特定语言的文件（如: _/strings es_ ）。\n"
                        .."在文件里您可以找到全部的操作指南：遵守它们，您翻译的语言将会被尽早投入使用;)",
                settings = "*监督员权限: 群组设置*\n\n"
                            .."`/menu` = 在私聊中通过方便的内联键盘来管理群组设置\n"
                            .."`/report [on/off]` (通过回复) = 指定用户不能使用(_off_)或可以使用(_on_) \"@admin\" 命令。\n",
            },
            all = '*公共命令*:\n'
                    ..'`/dashboard` : 通过私聊获取群组仪表盘\n'
                    ..'`/rules` (若未锁定) : 显示群组规则\n'
                    ..'`/about` (若未锁定) : 显示群组介绍\n'
                    ..'`/adminlist` (若未锁定) : 显示群组监督员\n'
                    ..'`@admin` (若未锁定) : 通过回复 = report the message replied to all the admins; no reply (with text)= send a feedback to all the admins\n'
                    ..'`/kickme` : 请求被机器人移出群组\n'
                    ..'`/faq` : 一些常见问题的回答\n'
                    ..'`/id` : 获取群组ID，或通过回复获取用户ID。\n'
                    ..'`/echo [文本]` : 机器人将会送回文本 (使用Markdown语言，对非管理员仅可通过私聊使用此命令)\n'
                    ..'`/info` : 显示有关机器人的一些信息\n'
                    ..'`/group` : 获取讨论群组邀请链接（限定英语）\n'
                    ..'`/c` <反馈内容> : （请使用英语）发送反馈/报告bug/向我的创建者提问。 _任何建议和功能请求都是欢迎的_。他将尽快回复。\n'
                    ..'`/help` : 显示本条消息。'
		            ..'\n\n如果您喜欢这个机器人，请在[这里](https://telegram.me/storebot?start=groupbutler_bot)给予我相应的评价。',
		    private = '嘿，*&&&1*！\n'
                    ..'我只是一个用来帮助人们管理他们的群组的机器人。\n'
                    ..'\n*我能为您做什么？*\n'
                    ..'哇哦，我可是有很多实用工具的！\n'
                    ..'• 您可以通过回复/@用户名来 *移除/封禁* 用户(即使在普通群组)\n'
                    ..'• 设置群组规则和简介\n'
                    ..'• 开启一个可配置的 *防刷屏* 系统\n'
                    ..'• 定制 *欢迎语*，亦能使用贴纸和gif\n'
                    ..'• 警告用户，并在达到最大警告次数将他们移除/封禁 \n'
                    ..'• 在用户发送特定媒体消息时发送警告或移出群组\n'
                    ..'……以及更多，您可以通过"All the commands"按钮来获取完整列表！\n'
                    ..'\n若要使用我，*您需要让我成为一个群组的管理员*，否则我无法正常为您提供服务！（如果您对此表示怀疑，请查看[此文](https://telegram.me/GroupButler_ch/63)）'
                    ..'\n仅需使用 "`/c <反馈内容>`" 命令，您就可以（在使用英语的前提下）报告bugs/发送反馈/向我的创建者提问。所有内容都是欢迎的！',
            group_success = '_我已经将消息私聊给您了_',
            group_not_success = '_给我发条消息，我就能为您服务_',
            initial = '选择一个*角色*以查看可用命令:',
            kb_header = '轻击一个按钮来查看 *相关命令*'
        },
        links = {
            no_link = '此群组尚未有*邀请链接*。快呼唤群组创建者生成一个',
            link = '[&&&1](&&&2)',
            link_no_input = '这里并不是*公共超级群组*，你需要在 /setlink 后附上群组邀请连接',
            link_invalid = '这个链接是*非法的*！',
            link_updated = '链接已更新。\n*这是新的链接*: [&&&1](&&&2)',
            link_setted = '链接已设置。\n*这是链接*: [&&&1](&&&2)',
            link_unsetted = '链接*已清除*',
            poll_unsetted = '投票*已清除*',
            poll_updated = '投票已更新.\n*请在此处投票*: [&&&1](&&&2)',
            poll_setted = '链接已设置.\n*请在此处投票*: [&&&1](&&&2)',
            no_poll = '这个群组*没有进行中的投票*',
            poll = '*请在此处投票*: [&&&1](&&&2)'
        },
        mod = {
            modlist = '*群组创建者*:\n&&&1\n\n*管理员*:\n&&&2'
        },
        report = {
            no_input = '请在 `!` 后写下您的建议/要报告的bugs/疑惑（请勿使用中文输入感叹号！，使用`!`而非`！`）',
            sent = '反馈已发送！',
            feedback_reply = '*你好，这是来自本机器人所有人的回复*：\n&&&1',
        },
        service = {
            welcome = '你好 &&&1，欢迎来到 *&&&2*!',
            welcome_rls = '乱死了！',
            welcome_abt = '这个群组没有简介。',
            welcome_modlist = '\n\n*群组创建人*:\n&&&1\n*管理员*:\n&&&2',
            abt = '\n\n*群组简介*:\n',
            rls = '\n\n*群组规则*:\n',
        },
        setabout = {
            no_bio = '这个群组*没有简介*。',
            no_bio_add = '*这个群组没有简介*。\n请使用 /setabout [群组简介] 来设置一个新的群组简介',
            no_input_add = '请在这可怜的"/addabout"后面写点什么吧',
            added = '*已追加新的群组简介：*\n"&&&1"',
            no_input_set = '请在这可怜的"/setabout"后面写点什么吧',
            clean = '群组简介已清除。',
            new = '*新的群组简介：*\n"&&&1"',
            about_setted = '新的群组简介*已成功记录*！'
        },
        setrules = {
            no_rules = '*乱死了*！',
            no_rules_add = '这个群组没有*群规*。\n请使用 /setrules [群组规则] 来设置一个新的群组规则',
            no_input_add = '请在这可怜的"/addrules"后面写点什么吧',
            added = '*已追加新的群组规则：*\n"&&&1"',
            no_input_set = '请在这可怜的"/setrules"后面写点什么吧',
            clean = '群组规则已清除.',
            new = '*新的群组规则：*\n"&&&1"',
            rules_setted = '新的群组规则*已成功记录*！'
        },
        settings = {
            disable = {
                rules_locked = '只有监督员可以使用 /rules 命令',
                about_locked = '只有监督员可以使用 /about 命令',
                welcome_locked = '从现在开始，欢迎语将不再显示',
                modlist_locked = '只有监督员可以使用 /adminlist 命令',
                flag_locked = '/flag 命令已停用',
                extra_locked = '只有监督员可以使用 #extra 命令',
                flood_locked = '防刷屏措施已停用',
                report_locked = '@admin 命令已停用',
                admin_mode_locked = '管理员模式已关闭',
            },
            enable = {
                rules_unlocked = '现在全员都可以使用 /rules 命令了',
                about_unlocked = '现在全员都可以使用 /about 命令了',
                welcome_unlocked = '已启用欢迎语',
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
            number_invalid = '`&&&1` 不是合法的值！\n这个值应该*高于* `3` 并*低于* `26`',
            not_changed = '消息的最大值为 &&&1',
            changed_plug = '消息的*最大值*（*5 秒*内）已改为_从_  &&&1 _到_  &&&2',
            kick = '刷屏者将被移除',
            ban = '刷屏者将被封禁',
            changed_cross = '&&&1 -> &&&2',
            text = '文本',
            image = '图片',
            sticker = '贴纸',
            gif = 'GIF',
            video = '视频',
            sent = '_防刷屏菜单已私聊_',
            ignored = '将忽略 [&&&1] 的刷屏',
            not_ignored = '将重新管理 [&&&1] 的刷屏',
            number_cb = '当前灵敏度。点击“+”或“-”',
            header = '你可以在这里管理群组防刷屏设置。\n'
                ..'\n*第一列*\n'
                ..'• *开/关*：防刷屏系统当前状态\n'
                ..'• *移除/封禁*：对刷屏者的操作\n'
                ..'\n*第二列*\n'
                ..'• 你可以使用 *+/-* 来改变防刷屏系统的灵敏度\n'
                ..'• 数值是 _5 秒_内能发送的信息阈值\n'
                ..'• 最大值：_25_ - 最小值：_4_\n'
                ..'\n*第三列*及以下\n'
                ..'你可以设置防刷屏的例外规则：\n'
                ..'• ✅: 此类消息将被防刷屏系统忽略\n'
                ..'• ❌: 此类消息将不被防刷屏系统忽略\n'
                ..'• *备注*：“_文本_”包括其他所有类型的消息（例如文件、语音……）'
        },
        mediasettings = {
			warn = '这类消息在本群*不被允许*。\n_下一次_你会被移除或封禁。',
            settings_header = '*当前消息类型设置*：\n\n',
            changed = '[&&&1] 的新状态为 &&&2',
        },
        preprocess = {
            flood_ban = '&&&1 因刷屏*被封禁*！',
            flood_kick = '&&&1 因刷屏*被移除*！',
            media_kick = '&&&1 因发送不允许的消息*被移除*！',
            media_ban = '&&&1 因发送不允许的消息*被封禁*！',
            rtl_kicked = '&&&1 因名字或消息中含有 Unicode 从右至左标志*被移除*！',
            arab_kicked = '&&&1 因消息中含有阿拉伯文*被移除*！',
            rtl_banned = '&&&1 因名字或消息中含有 Unicode 从右至左标志*被封禁*！',
            arab_banned = '&&&1 因消息中含有阿拉伯文*被封禁*！',
            flood_motivation = '因刷屏而被封禁',
            media_motivation = '发送不被允许类型的消息',
            first_warn = '此类消息在*本群*不被允许。'
        },
        kick_errors = {
            [1] = '非管理员不能移除用户',
            [2] = '不能移除或封禁管理员',
            [3] = '普通群组不需要解除封禁',
            [4] = '此用户不是本群成员',
        },
        flag = {
            no_input = '回复某条消息以报告管理员，或在 \'@admin\' 旁写条消息以向他们发送反馈',
            reported = '已报告！',
            no_reply = '请回复用户的消息！',
            blocked = '此用户从现在开始不能使用 \'@admin\'',
            already_blocked = '此用户不能使用 \'@admin\'',
            unblocked = '此用户从现在开始可以使用 \'@admin\'',
            already_unblocked = '此用户能使用 \'@admin\'',
        },
        all = {
            dashboard = {
                private = '_群组仪表板已私聊_',
                first = '导航到这条消息以查看关于这个群组的一切！',
                antiflood = '- *状态*: `&&&1`\n- *操作* 当一个用户刷屏时： `&&&2`\n- *每 5 秒*允许的消息阈值： `&&&3`\n- *忽略的消息类型*:\n&&&4',
                settings = '设置',
                admins = '管理员',
                rules = '规则',
                about = '描述',
                welcome = '欢迎语',
                extra = '额外命令',
                media = '消息类型设置',
                flood = '防刷屏设置'
            },
            menu = '_设置菜单已私聊_',
            menu_first = '管理群组设置。\n'
                ..'\n一些命令 (_/rules, /about, /adminlist, #extra commands_) 可以*对非管理员禁用*\n'
                ..'当一个命令对非管理员禁用时会发生什么\n'
                ..'• 如果命令被管理员触发，Bot 会在*群内*回复\n'
                ..'• 如果命令被普通用户触发，Bot 会在*与用户的私聊*回复(显然，仅当用户启用了机器人时)\n'
                ..'\n命令旁的图标会显示当前状态\n'
                ..'• 👥：Bot 会对所有人在*群内*回复\n'
                ..'• 👤：Bot 会对普通用户*私聊*回复，对管理员在*群内*回复\n'
                ..'\n*其他设置*：其他设置，图标和 Bot 介绍\n',
            media_first = '点击冒号右侧的语音以*修改设置*\n'
                        ..'你可以使用最后一行修改 Bot 在因发送不允许的消息而移除/封禁用户前应警告多少次\n'
                        ..'这个数值与普通 `/warn` 命令无关',
        },
    },
