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
            header_1 = '*封禁信息（全局）*：\n',
            header_2 = '*常规信息*：\n',
            warns = '`警告`： ',
            media_warns = '`媒体消息警告`： ',
            group_msgs = '`在群组中发送的消息`： ',
            group_media = '`在本群组中发送的媒体消息`： ',
            last_msg = '`上一条消息是`： ',
            global_msgs = '`消息总数`： ',
            global_media = '`媒体消息总数`： ',
            remwarns_kb = '移除警告'
        },
        getban = {
            header = '有关此人的*全局统计*：',
            nothing = '`没有可以显示的信息`',
            kick = '移除：',
            ban = '封禁：',
            tempban = '临时屏蔽：',
            flood = '因刷屏而移除：',
            warn = '因多次警告而移除：',
            media = '因发送被禁止的媒体消息而移除：',
            arab = '因发送阿拉伯语字符而移除：',
            rtl = '因使用RTL字符而移除：',
            kicked = '_已移除！_',
            banned = '_已封禁！_'
        },
        bonus = {
            general_pm = '_我已经将消息私聊给您了_',
            no_user = '我不认识这位用户。\n如果您想告诉我他是谁，请转发一条他的消息给我。',
            the_group = '群组',
            adminlist_admin_required = '我还不是群组管理员。\n*只有群组管理员才能看见管理员名单*',
            settings_header = '当前*群组*的设定是：\n\n*语言*： `&&&1`\n',
            reply = '通过*回复某人*或*@用户名*来使用这个命令',
            too_long = '这段文本太长了，我无法发送它。',
            msg_me = '_给我发条消息，我就能为您服务。_',
            menu_cb_settings = '点击图标以更改设定！',
            menu_cb_warns = '使用下方按钮来更改警告设置！',
            menu_cb_media = '点击开关以更改设定！',
            tell = '*群组ID*： &&&1',
        },
        not_mod = '您 *不是* 监督员',
        breaks_markdown = '这段文本不符合*markdown*语法。\n有关Markdown语言的正确使用方法，可参考[此文](https：//telegram.me/GroupButler_ch/46)。',
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
                banhammer = "*监督员权限： 禁令之锤*\n\n"
                            .."`/kick [通过回复|@用户名]` = 将某人移出群组。（可以被添加回群组）\n"
                            .."`/ban [通过回复|@用户名]` = 封禁某人。（包括普通群组）\n"
                            .."`/tempban [时长（分钟）]` = 将某人临时屏蔽一段时间（时长必须 < 10080 分钟 = 1周）。目前仅支持通过回复执行此命令。\n"
                            .."`/unban [通过回复|@用户名]` = 将某人从黑名单中移除。\n"
                            .."`/user [通过回复|@用户名|id]` = 返回一条2页长的消息：第一页将显示此用户在 *所有群组中* 被封禁的次数（分段显示）, "
                            .."第二页将会显示一些有关此用户的常规统计，包括但不限于： 在群组内发送信息/媒体消息的次数、被警告的次数等。\n"
                            .."`/status [@用户名]` = 显示某人的状态 `(群员|已离开/被移出|被封禁|管理员/创建者|不认识)`。\n"
                            .."`/banlist` = 显示被封禁的用户及原因（如果有记录）\n"
                            .."`/banlist -` = 清空封禁列表。\n"
                            .."\n*注*：您可以在 `/ban` 命令后附上备注（如果您是通过 `@用户名` 封禁的，可以在用户名后附上）。"
                            .." 这段备注将会作为封禁原因记录。",
                info = "*监督员权限： 群组介绍*\n\n"
                        .."`/setrules [群组规则]` = 设置新的群组规则。（旧规则将会被覆盖）\n"
                        .."`/addrules [文本]` = 在现有规则后添加文本。\n"
                        .."`/setabout [群组简介]` = 设置新的群组简介。（旧简介将会被覆盖）\n"
                        .."`/addabout [文本]` = 在现有简介后添加新的文本。\n"
                        .."\n*注*：支持markdown语言，如果您发送的文本里有语法错误，机器人将会提醒您。\n"
                        .."有关Markdown语言的正确使用方法，可参考[此文](https：//telegram.me/GroupButler_ch/46)。",
                flood = "*监督员权限： 刷屏控制*\n\n"
                        .."`/antiflood` = 使用内联菜单以在私聊中管理防刷屏设置，包括：灵敏度、防刷屏措施（移除/封禁）、例外情况。\n"
                        .."`/antiflood [数字]` = 设置一个用户在 5 秒内可以发送多少条信息。\n"
                        .."_注_：数字必须 > 3 且 < 26。\n"
                media = "*监督员权限： 媒体消息*\n\n"
                        .."`/media` = 在私聊中获取内联菜单以更改媒体消息设置。\n"
                        .."`/warnmax media [数字]` = 设置容许用户发送被禁止的媒体消息的次数，当超过此次数时此用户将被移除/封禁。\n"
                        .."`/nowarns (通过回复)` = 重置指定成员的警告次数 (*注：包括常规警告和媒体消息警告*)。\n"
                        .."`/media list` = 列出目前的媒体消息设置。\n"
                        .."\n*支持的媒体类型列表*： _image, audio, video, sticker, gif, voice, contact, file, link_\n",
                welcome = "*监督员权限： 新用户欢迎*\n\n"
                            .."`/menu` = 通过在私聊中操作菜单，您将会找到一个可以控制欢迎语开启与否的选项。\n"
                            .."\n*自定义欢迎语：*\n"
                            .."`/welcome 欢迎 $name，快和其他人打成一片吧！`\n"
                            .."在\"/welcome\" 命令后附上欢迎语，同时您也可以使用一些占位符来添加新群员的 name/username/id。\n"
                            .."占位符： _$username_ （将会被代入为用户名）; _$name_ （将会被代入为姓名）; _$id_ （将会被代入为ID）; _$title_ （将会被代入为群组名）。\n"
                            .."\n*将GIF/贴纸作为欢迎语*\n"
                            .."您可以使用特定的GIF/贴纸作为欢迎语，您可以通过对GIF/贴纸消息回复 \'/welcome\' 来进行设置。\n"
                            .."\n*构造欢迎语*\n"
                            .."您可以借助 `群组规则`、 `群组介绍` 、 `监督员名单` 等素材来构造欢迎语。\n"
                            .."您可以依照 `/welcome` + `素材代号` 的格式，将必要的内容构造成欢迎语。\n"
                            .."_素材代号_ ： *r* = 群组规则; *a* = 群组介绍; *m* = 监督员名单。\n"
                            .."举例来说：若您输入命令 \"`/welcome rm`\" ，欢迎语将会显示 群组规则 和 监督员名单。",
                extra = "*监督员权限： 附加命令*\n\n"
                        .."`/extra [#触发文本] [回复]` = 当某人的消息中涉及了指定触发文本时，设置机器人要回复的内容。\n"
                        .."_例如_ ： 若输入命令 \"`/extra #早呀 早上好！`\"，那么在每次有人发送 #早呀 的文本时，机器人将回复 \"早上好！\"。\n"
                        .."您也可以使用 `/extra #触发文本` 回复一条媒体消息 (_包括图片、文件、语音、视频、音频、GIF_)来保存这条回复规则，以让机器人每逢检测到此触发文本时，自动回复此媒体消息。\n"
                        .."`/extra list` = 列出目前已经设置的附加命令。\n"
                        .."`/extra del [#触发文本]` = 删除指定触发文本的回复规则。\n"
                        .."\n*注：* 支持markdown语言，如果您发送的文本里有语法错误，机器人将会提醒您。\n"
                        .."有关Markdown语言的正确使用方法，可参考[此文](https：//telegram.me/GroupButler_ch/46)",
                warns = "*监督员权限： 警告*\n\n"
                        .."`/warn [通过回复]` = 警告指定用户，若此用户达到最大警告数限制，他将被移除/封禁.\n"
                        .."`/warnmax` = 设置最大警告次数，若某用户获警告次数达到此数值，将被移除/封禁\n"
                        .."\n查看一名用户获警告次数的方法： 此数值在 `/user` 命令返回信息中第2页中出现。您也可以在这一页的内联菜单中重置警告次数。",
                char = "*监督员权限： 特殊字符*\n\n"
                        .."`/menu` = 您可以在私聊中通过菜单获取此设置。\n"
                        .."这里为您提供2个设置项： _阿拉伯语字符_ 和 _RTL字符_。\n"
                        .."\n*阿拉伯语字符*： 若阿拉伯语字符被禁止(🚫)，任何在消息中使用阿拉伯语字符的行为，将导致此用户被移出群组。\n"
                        .."*Rtl字符*： 即‘右向左’字符，它是造成“消息倒序显示”的怪诞现象的元凶。\n"
                        .."若Rtl字符被禁止(🚫)，任何在消息中使用此类字符（或在名字中使用）的行为，将导致此用户被移出群组。",
                links = "*监督员权限： 链接*\n\n"
                        .."`/setlink [链接地址|'no']` ：设置群组链接，让其它管理员能够随时使用或移除。\n"
                        .."`/link` = 获取群组链接（当群组创始人设置时）。\n"
                        .."\n*注*： 机器人能够识别链接是否有效。若链接是非法的，则不会回复任何信息。",
                lang = "*监督员权限： 群组语言*\n\n"
                        .."`/lang` = 选择群组语言（同样可以在私聊中设置）。\n"
                        .."\n*注*： 译者均为志愿翻译，因此我不能保证所有翻译的准确性。我也不能强迫他们在每次更新后翻译新的字符串（未被翻译的字符串将会以英语语言出现）."
                        .."\n无论如何，翻译的权利是开放给任何人的。使用 `/strings` 命令来获取一份包括所有字符串的 _.lua_ 文件（英语）。\n"
                        .."使用 `/strings [lang code]` 来获取特定语言的文件（如： _/strings es_ ）。\n"
                        .."若您想要向本汉化递交相关意见，您可以通过issue的形式发送至我们的[Github仓库](https://github.com/KochiyaNoro/GroupButler_zh_cn/issues)（注：此项目与GroupButler官方没有关联）。\n"
                        .."在文件里您可以找到全部的操作指南：遵守它们，您翻译的语言将会被尽早投入使用;)",
                settings = "*监督员权限： 群组设置*\n\n"
                            .."`/menu` = 在私聊中通过方便的内联键盘来管理群组设置\n"
                            .."`/report [on/off]` (通过回复) = 指定用户不能使用(_off_)或可以使用(_on_) \"@admin\" 命令。\n",
            },
            all = '*公共命令*：\n'
                    ..'`/dashboard` ： 通过私聊获取群组仪表盘\n'
                    ..'`/rules` (如允许) ： 显示群组规则\n'
                    ..'`/about` (如允许) ： 显示群组介绍\n'
                    ..'`/adminlist` (如允许) ： 显示群组监督员\n'
                    ..'`@admin` (如允许) ： 通过回复 = 向管理员报告信息; 不通过回复（但通过在命令后输入文字）= 向管理员发送建议\n'
                    ..'`/kickme` ： 请求被机器人移出群组\n'
                    ..'`/faq` ： 一些常见问题的回答\n'
                    ..'`/id` ： 获取群组ID，或通过回复获取用户ID。\n'
                    ..'`/echo [文本]` ： 机器人将会送回文本 (使用Markdown语言，对非管理员仅可通过私聊使用此命令)\n'
                    ..'`/info` ： 显示有关机器人的一些信息\n'
                    ..'`/group` ： 获取讨论群组邀请链接（限定英语）\n'
                    ..'`/c` <反馈内容> ： （请使用英语）发送反馈/报告bug/向我的创建者提问。 _任何建议和功能请求都是欢迎的_。他将尽快回复。\n'
                    ..'`/help` ： 显示本条消息。'
		            ..'\n\n如果您喜欢这个机器人，请在[这里](https：//telegram.me/storebot?start=groupbutler_bot)给予我相应的评价。',
		    private = '嘿，*&&&1*！\n'
                    ..'我只是一个用来帮助人们管理他们的群组的机器人。\n'
                    ..'\n*我能为您做什么？*\n'
                    ..'哇哦，我可是有很多实用工具的！\n'
                    ..'• 您可以通过回复/@用户名来 *移除/封禁* 用户(即使在普通群组)\n'
                    ..'• 设置群组规则和简介\n'
                    ..'• 开启一个可配置的 *防刷屏* 系统\n'
                    ..'• 定制 *欢迎语*，亦能使用贴纸和GIF\n'
                    ..'• 警告用户，并在达到最大警告次数将他们移除/封禁 \n'
                    ..'• 在用户发送特定媒体消息时发送警告或移出群组\n'
                    ..'……以及更多，您可以通过"All the commands"按钮来获取完整列表！\n'
                    ..'\n若要使用我，*您需要让我成为一个群组的管理员*，否则我无法正常为您提供服务！（如果您对此表示怀疑，请查看[此文](https：//telegram.me/GroupButler_ch/63)）'
                    ..'\n仅需使用 "`/c <反馈内容>`" 命令，您就可以（在使用英语的前提下）报告bugs/发送反馈/向我的创建者提问。所有内容都是欢迎的！',
            group_success = '_我已经将消息私聊给您了_',
            group_not_success = '_给我发条消息，我就能为您服务_',
            initial = '选择一个*角色*以查看可用命令：',
            kb_header = '点击一个按钮来查看 *相关命令*'
        },
        links = {
            no_link = '此群组尚未有*邀请链接*。快呼唤群组创建者生成一个',
            link = '[&&&1](&&&2)',
            link_no_input = '这里并不是*公共超级群组*，您需要在 /setlink 后附上群组邀请连接',
            link_invalid = '这个链接是*非法的*！',
            link_updated = '链接已更新。\n*这是新的链接*： [&&&1](&&&2)',
            link_setted = '链接已设置。\n*这是链接*： [&&&1](&&&2)',
            link_unsetted = '链接*已清除*',
            poll_unsetted = '投票*已清除*',
            poll_updated = '投票已更新.\n*请在此处投票*： [&&&1](&&&2)',
            poll_setted = '链接已设置.\n*请在此处投票*： [&&&1](&&&2)',
            no_poll = '这个群组*没有进行中的投票*',
            poll = '*请在此处投票*： [&&&1](&&&2)'
        },
        mod = {
            modlist = '*群组创建者*：\n&&&1\n\n*管理员*：\n&&&2'
        },
        report = {
            no_input = '请在 `!` 后写下您的建议/要报告的bugs/疑惑（请勿使用中文输入感叹号！，使用`!`而非`！`）',
            sent = '反馈已发送！',
            feedback_reply = '*您好，这是来自本机器人所有人的回复*：\n&&&1',
        },
        service = {
            welcome = '您好 &&&1，欢迎来到 *&&&2*！',
            welcome_rls = '太乱了！',
            welcome_abt = '这个群组没有简介。',
            welcome_modlist = '\n\n*群组创建人*：\n&&&1\n*管理员*：\n&&&2',
            abt = '\n\n*群组简介*：\n',
            rls = '\n\n*群组规则*：\n',
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
            no_rules = '*太乱了*！',
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
                welcome_unlocked = '已启用欢迎语',
                modlist_unlocked = '现在全员都可以使用 /adminlist 命令了',
                flag_unlocked = '/flag 命令已可用',
                extra_unlocked = '现在全员都可以使用 /Extra # 命令了',
                flood_unlocked = '防刷屏措施已启用',
                report_unlocked = '@admin command 命令已可用',
                admin_mode_unlocked = '管理员模式已开启',
            },
            welcome = {
                no_input = '欢迎，然后...?',
                media_setted = '新的媒体消息已被设置成欢迎语： ',
                reply_media = '只需对 `贴纸` 或 `GIF` 回复，就可以把它们设置成 *欢迎语*',
                a = '新的欢迎语已设置：\n群组规则\n_群组介绍_\n监督员名单',
                r = '新的欢迎语已设置：\n_群组规则_\n群组介绍\n监督员名单',
                m = '新的欢迎语已设置：\n群组规则\n群组介绍\n_监督员名单_',
                ra = '新的欢迎语已设置：\n_群组规则_\n_群组介绍_\n监督员名单',
                rm = '新的欢迎语已设置：\n_群组规则_\n群组介绍\n_监督员名单_',
                am = '新的欢迎语已设置：\n群组规则\n_群组介绍_\n_监督员名单_',
                ram = '新的欢迎语已设置：\n_群组规则_\n_群组介绍_\n_监督员名单_',
                no = '新的欢迎语已设置：\n群组规则\n群组介绍\n监督员名单',
                wrong_input = '参数无效。\n请使用 _/welcome [no|r|a|ra|ar]_ 来替代。',
                custom = '*自定义欢迎语* 已设置！\n\n&&&1',
                custom_setted = '*自定义欢迎语已保存！*',
                wrong_markdown = '_未能成功设置_ ： 我无法将此消息返回给您，markdown语法可能出现了 *错误*。\n请检查您发送的文本是否合法',
            },
            resume = {
                header = '对 *&&&1* 的自定义设置： \n\n*语言*： `&&&2`\n',
                w_a = '*欢迎类型*： `欢迎 + 关于本群`\n',
                w_r = '*欢迎类型*： `欢迎 + 群规`\n',
                w_m = '*欢迎类型*： `欢迎 + 管理员列表`\n',
                w_ra = '*欢迎类型*： `欢迎 + 群规 + 关于`\n',
                w_rm = '*欢迎类型*： `欢迎 + 群规 + 管理员列表`\n',
                w_am = '*欢迎类型*： `欢迎 + 关于 + 管理员列表`\n',
                w_ram = '*欢迎类型*： `欢迎 + 群规 + 关于 + 管理员列表`\n',
                w_no = '*欢迎类型*： `仅欢迎信息`\n',
                w_media = '*欢迎类型*： `GIF / 表情贴图 (Striker)`\n',
                w_custom = '*欢迎类型*： `自定义信息`\n',
                legenda = '✅ = _启用 / 允许_\n🚫 = _停用 / 禁止_\n👥 = _在群组里发送 (总是对管理员启用)_\n👤 = _在私聊里发送_'
            },
            char = {
                arab_kick = '阿拉伯语消息发送者将会被移除',
                arab_ban = '阿拉伯语消息发送者将会被封禁',
                arab_allow = '允许阿拉伯语消息',
                rtl_kick = '使用RTL字符将导致被移除出群',
                rtl_ban = '使用RTL字符将导致被封禁',
                rtl_allow = '允许使用RTL字符',
            },
            broken_group = '还没有针对本群的设置。\n请通过执行 /initgroup 命令来解决这一问题 ：)',
            Rules = '/rules',
            About = '/about',
            Welcome = '欢迎信息',
            Modlist = '/adminlist',
            Flag = '标记',
            Extra = '附加',
            Flood = '防刷屏',
            Rtl = 'RTL',
            Arab = '阿拉伯语',
            Report = '举报',
            Admin_mode = '管理员模式',
        },
        warn = {
            warn_reply = '通过回复消息警告该用户',
            changed_type = '当一位用户收到的警告数量达到上限时执行新操作： *&&&1*',
            mod = '不能警告审核员',
            warned_max_kick = '用户 &&&1 *已移除出群*： 收到的警告数量达到上限',
            warned_max_ban = 'User &&&1 *已封禁*： 收到的警告数量达到上限',
            warned = '&&&1 *被警告了。*\n_警告数量_   *&&&2*\n_允许上限_   *&&&3*',
            warnmax = '警告消息允许上限已调整 &&&3。\n*原数值*： &&&1\n*新数值*： &&&2',
            getwarns_reply = '回复一个用户以检查他收到的警告数量',
            getwarns = '&&&1 (*&&&2/&&&3*)\nMedia： (*&&&4/&&&5*)',
            nowarn_reply = '回复一个用户以删除警告',
            warn_removed = '*警告已删除！*\n_警告数量_   *&&&1*\n_允许上限_   *&&&2*',
            ban_motivation = '警告过多',
            inline_high = '新数值过高 (>12)',
            inline_low = '新数值过低 (<1)',
            zero = '没有 _任何_ 关于该用户的警告',
            nowarn = '该用户收到的警告数量已经被 *重置*'
        },
        setlang = {
            list = '*可用的语言列表：*',
            success = '*已设置新语言：* &&&1',
            error = '暂不支持该语言'
        },
		banhammer = {
            kicked = '`&&&1` 移除了 `&&&2`！',
            banned = '`&&&1` 封禁了 `&&&2`！',
            already_banned_normal = '&&&1 *已经被封禁了！*',
            unbanned = '该用户已解封！',
            reply = '回复某人',
            globally_banned = '&&&1 已被全局解封！',
            not_banned = '该用户没有被封禁',
            banlist_header = '*被封禁的用户*：\n\n',
            banlist_empty = '_没有被封禁的用户_',
            banlist_error = '_在清除封禁列表时发生错误_',
            banlist_cleaned = '_封禁列表已清除_',
            tempban_zero = '对于此需求，您可以直接使用 /ban 命令',
            tempban_week = '封禁时间限制为一星期 (10,080 分钟)',
            tempban_banned = '用户 &&&1 被封禁。解封时间： ',
            tempban_updated = '对 &&&1 的封禁已调整。解封时间：',
            general_motivation = '我无法移除该用户。\n很有可能是由于我没有管理员权限，或目标用户是管理员'
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
            sent = '_已将防刷屏菜单私聊给您_',
            ignored = '将忽略 [&&&1] 的刷屏',
            not_ignored = '将重新管理 [&&&1] 的刷屏',
            number_cb = '当前灵敏度。点击“+”或“-”',
            header = '您可以在这里管理群组防刷屏设置。\n'
                ..'\n*第一列*\n'
                ..'• *开/关*：防刷屏系统当前状态\n'
                ..'• *移除/封禁*：对刷屏者的操作\n'
                ..'\n*第二列*\n'
                ..'• 您可以使用 *+/-* 来改变防刷屏系统的灵敏度\n'
                ..'• 数值是 _5 秒_内能发送的信息阈值\n'
                ..'• 最大值：_25_ - 最小值：_4_\n'
                ..'\n*第三列*及以下\n'
                ..'您可以设置防刷屏的例外规则：\n'
                ..'• ✅： 此类消息将被防刷屏系统忽略\n'
                ..'• ❌： 此类消息将不被防刷屏系统忽略\n'
                ..'• *备注*：“_文本_”包括其他所有类型的消息（例如文件、语音……）'
        },
        mediasettings = {
			warn = '这类消息在本群*不被允许*。\n_下一次_您会被移除或封禁。',
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
            no_input = '回复某条消息以报告管理员，或在 \'@admin\' 后写条消息以向他们发送反馈',
            reported = '已递交报告！',
            no_reply = '请回复一位用户的消息以便继续操作！',
            blocked = '此用户从现在开始不能使用 \'@admin\'',
            already_blocked = '此用户不能使用 \'@admin\'',
            unblocked = '此用户从现在开始可以使用 \'@admin\'',
            already_unblocked = '此用户能使用 \'@admin\'',
        },
        all = {
            dashboard = {
                private = '_已将群组仪表盘私聊给您了_',
                first = '导航到这条消息以查看关于这个群组的一切！',
                antiflood = '- *状态*： `&&&1`\n- *操作* 当一个用户刷屏时： `&&&2`\n- *每 5 秒*允许的消息阈值： `&&&3`\n- *忽略的消息类型*：\n&&&4',
                settings = '设置',
                admins = '管理员',
                rules = '规则',
                about = '描述',
                welcome = '欢迎语',
                extra = '额外命令',
                media = '消息类型设置',
                flood = '防刷屏设置'
            },
            menu = '_已将设置菜单私聊给您了_',
            menu_first = '管理群组设置。\n'
                ..'\n一些命令 (_/rules, /about, /adminlist, #extra commands_) 可以*对非管理员禁用*\n'
                ..'当一个命令对非管理员禁用时会发生什么\n'
                ..'• 如果命令被管理员触发，机器人会在*群内*回复\n'
                ..'• 如果命令被普通用户触发，机器人会在*与用户的私聊*回复(显然，仅当用户启用了机器人时)\n'
                ..'\n命令旁的图标会显示当前状态\n'
                ..'• 👥：机器人会对所有人在*群内*回复\n'
                ..'• 👤：机器人会对普通用户*私聊*回复，对管理员在*群内*回复\n'
                ..'\n*其他设置*：其他设置，图标和机器人介绍\n',
            media_first = '点击冒号右侧的语音以*修改设置*\n'
                        ..'您可以使用最后一行修改机器人在因发送不允许的消息而移除/封禁用户前应警告多少次\n'
                        ..'这个数值与普通 `/warn` 命令无关',
        },
    }