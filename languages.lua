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
        credits = 'This bot is based on [GroupButler bot](https://github.com/RememberTheAir/GroupButler), an *opensource* bot available on [Github](https://github.com/). Follow the link to know how the bot works or which data are stored.\n\nRemember you can always use /c command to ask something.',
        extra = {
			usage = 'Write next to /extra the title of the command and the text associated.\nFor example:\n/extra #motm stay positive. The bot will reply _\'Stay positive\'_ each time someone writes #motm',
            new_command = '*New command setted!*\n&&&1\n&&&2',
            no_commands = 'No commands setted!',
            commands_list = 'List of *custom commands*:\n&&&1',
            command_deleted = '&&&1 command have been deleted',
            command_empty = '&&&1 command does not exist'
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
                        ..'`/unban` (by reply) : unban a user from the group\n'
                        ..'`/kicked list` :see a list of kicked users\n'
                        ..'`/flood [kick/ban]` : choose what the bot should do when the flood limit is triggered\n'
                        ..'`/flood [on/off]` : turn on/off the flood listener\n'
                        ..'`/flood [number]` : set how many messages a user can write in 5 seconds\n'
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
                        ..'`/disable [arab|rtl]` : everyone with RTL character in the name/everyone who send a text with arab characters will be kicked\n'
                        ..'`/enable [arab|rtl]` : allow RTL character/arab texts\n'
                        ..'`/disable <rules|about|modlist|extra>` : this commands will be available only for moderators\n'
                        ..'`/enable <rules|about|modlist|extra>` : this commands will be available for all\n'
                        ..'`/enable|/disable <welcome|report>` : switch on/off the welcome message or the ability to use \'@admin\' shortcut\n'
                        ..'`/report [on/off]` (by reply) : the user won\'t be able/will be able to use \'@admin\' shortcut\n'
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
                    ..'`@admin` (if unlocked) : by reply= report the message replied to all the admins; no reply (with text)= send a feedback to all the admins\n'
                    ..'`/tell` : show your basical info or the info about the user you replied to\n'
                    ..'`/info` : show some useful informations about the bot\n'
                    ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
                    ..'`/help` : show this message.'
		            ..'\n\nIf you like this bot, please leave the vote you think it deserves [here](https://telegram.me/storebot?start=groupbutler_bot)',
		    private = 'Hey, *&&&1*!\n'
                    ..'I\'m a simple bot created in order to help people to manage their groups.\n'
                    ..'\n*How can you help me?*\n'
                    ..'Wew, I have a lot of useful tools! You can *kick or ban* users, set rules and a description, warn users, set some parameters to kick someone when something happens (read: *antiflood*/RTL/media...)\nDiscover more by adding me to a group!\n'
                    ..'\nThe user who adds me will be set up as owner of the group. If you are not the real owner, you can set it by repliyng one of his messages with `/owner`.'
                    ..'\nTo use my moderation powers (kick/ban), *you need to add me as administrator of the group*.\nRemember: moderator commands can be used only by who have been promoted with `/promote`. I can\'t see the real admins of the group, this is the only way for now.\n'
                    ..'\nYou can report bugs/send feedbacks/ask a question to my creator just using "`/c <feedback>`" command. EVERYTHING IS WELCOME!'
                    ..'\n\n[Official channel](https://telegram.me/GroupButler_ch) and [vote link](https://telegram.me/storebot?start=groupbutler_bot)',
            group = 'I\'ve sent you the help message in *private*.\nIf you have never used me, *start* me and ask for help here *again*.'
        },
        links = {
            no_link = '*No link* for this group. Ask the owner to generate one',
            link = '[&&&1](&&&2)',
            link_invalid = 'This link is *not valid!*',
            link_updated = 'The link has been updated.\n*Here\'s the new link*: [&&&1](&&&2)',
            link_setted = 'The link has been setted.\n*Here\'s the link*: [&&&1](&&&2)',
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
        report = {
            no_input = 'Write your suggestions/bugs/doubt near "/c"',
            sent = 'Feedback sent:\n\n&&&1',
            reply = 'Reply to a feedback to reply to the user',
            reply_no_input = 'Write your reply next to "/reply"',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
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
                rtl_already = 'Anti-RTL is already *on*',
                rtl_locked = 'Anti-RTL is now *on*',
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
                arab_already = 'Anti-arab characters is already *off*',
                arab_unlocked = 'Anti-arab characters is now *off*',
                report_already = '@admin command is already *available*',
                report_unlocked = '@admin command is now *available*',
                wrong_input = 'Argument unavailable.\nUse `/enable [rules|about|welcome|modlist|report|extra|rtl|arab]` instead'
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
                w_no = '*Welcome type*: `welcome only`\n',
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
            Report = 'Report'
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
            warned_max_kick = 'User &&&1 *kicked*: reached the max number of warnings',
            warned_max_ban = 'User &&&1 *banned*: reached the max number of warnings',
            warned = '*User* &&&1 *have been warned.*\n_Number of warnings_   *&&&2*\n_Max allowed_   *&&&3* (*-&&&4*)',
            warnmax = 'Max number of warnings changed.\n*Old* value: &&&1\n*New* max: &&&2',
            getwarns_reply = 'Reply to an user to check his numebr of warns',
            limit_reached = 'This user has already reached the max number of warnings (*&&&1/&&&2*)',
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
            kicked = '&&&1 have been kicked! (but is still able to join)',
            banned = '&&&1 have been banned!',
            unbanned = '&&&1 have been unbanned!',
            reply = 'Reply to someone',
            globally_banned = '&&&1 have been globally banned!',
            no_unbanned = 'This is a normal group, people is not blocked when kicked'
        },
        floodmanager = {
            number_invalid = '`&&&1` is not a valid value!\nThe value should be *higher* than `3` and *lower* then `26`',
            not_changed = 'The max number of messages that can be sent in 5 seconds is already &&&1',
            changed = 'The max number of messages that can be sent in 5 seconds changed from &&&1 to &&&2',
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
            flood_ban = '&&&1 *banned* for flood',
            flood_kick = '&&&1 *kicked* for flood',
            media_kick = '&&&1 *kicked*: media sent not allowed',
            media_ban = '&&&1 *banned*: media sent not allowed',
            rtl = '&&&1 *kicked*: rtl character in names/messages not allowed',
            arab = '&&&1 *kicked*: arab message detected'
        },
        broadcast = {
            delivered = 'Broadcast delivered. Check the log for the list of reached ids',
            no_users = 'No users saved, no broadcast',
        },
        admin = {
            no_reply = 'This command need a reply',
            blocked = '&&&1 have been blocked',
            unblocked = '&&&1 have been unblocked',
            already_blocked = '&&&1 was already blocked',
            already_unblocked = '&&&1 was already unblocked',
            bcg_no_groups = 'No (groups) id saved',
            leave_id_missing = 'ID missing',
            leave_chat_leaved = 'Chat leaved!',
            leave_error = 'Check the id, it could be wrong'
            
        },
        kick_errors = {
            [101] = 'I\'m not an admin, I can\'t kick people',
            [102] = 'I can\'t kick or ban an admin',
            [103] = 'There is no need to unban in a normal group',
            [104] = 'I can\'t kick or ban an admin', --yes, I need two
            [105] = 'I\'m not an admin, I can\'t kick people',
            [106] = 'An unknown error occurred while kicking'
        },
        flag = {
            no_input = 'Reply to a message to report it to an admin, or write something next \'@admin\' to send a feedback to them',
            reported = 'Reported!',
            no_reply = 'Reply to an user!',
            blocked = 'The user from now can\'t use \'@admin\'',
            already_blocked = 'The user is already unable to use \'@admin\'',
            unblocked = 'The user now can use \'@admin\'',
            already_unblocked = 'The user is already able to use \'@admin\'',
        },
    },
	it = {
        pv = 'Questo comando è disponibile solo in un gruppo!',
        not_mod = '*Non sei* un moderatore!',
        breaks_markdown = 'Questo messaggio impedisce il markdown.\nControlla quante volte hai usato * oppure _ oppure `',
        ping= 'Funziono!',
        control = {
            reload = '*Bot ricaricato!*',
            stop = '*Bot arrestato!*'
        },
        credits = 'Questo bot è basato su [GroupButler bot](https://github.com/RememberTheAir/GroupButler), un bot *opensource* disponibile su [Github](https://github.com/). Segui il link per sapere come il bot funziona e per conoscere quali dati vengono salvati.\n\nRicordati che puoi sempre usare il comando "/c <scrivi qui qualcosa da suggerire>" per segnalare un bug o suggerire qualcosa.',
        extra = {
			usage = 'Scrivi accanto a /extra il titolo del comando ed il testo associato.\nAd esempio:\n/extra #ciao Hey, ciao!. Il bot risponderà _\'Hey, ciao!\'_ ogni volta che qualcuno scriverà #ciao',
            new_command = '*Nuovo comando impostato!*\n&&&1\n&&&2',
            no_commands = 'Nessun comando impostato!',
            commands_list = 'Lista dei *comandi personalizzati*:\n&&&1',
            command_deleted = 'Il comando personalizzato &&&1 è stato eliminato',
            command_empty = 'Il comando &&&1 non esiste'
        },
        getstats = {
            redis = 'Redis aggiornato',
            stats = '&&&1'
        },
        help = {
            owner = '*Comandi per il proprietario*:\n'
                    ..'`/owner` (by reply) : imposta un nuovo proprietario\n'
                    ..'`/promote` (by reply) : promuovi a moderatore un membro\n'
                    ..'`/demote` (by reply) : rimuovi un membro dai moderatori\n'
                    ..'`/setlink [link|\'no\']` : imposta il link al gruppo, in modo tale che i moderatori possano mostrarlo. O rimuovilo con "no"\n'
                    ..'(ovviamente, la possibilità di nominare dei moderatori serve a far sapere al bot chi sono i reali admin del gruppo, e quindi chi può usare comandi sensibili per kickare e bannare.\nQuindi è caldamente consigliato di nominare admin solo chi lo è realmente)\n\n',
            moderator = '*Comandi per i moderatori*:\n'
                        ..'`/kick` (by reply) : rimuovi un utente dal gruppo (può entrare nuovamente)\n'
                        ..'`/ban` (by reply) : banna un utente da un gruppo\n'
                        ..'`/unban` (by reply) : unbanna un utente da un gruppo\n'
                        ..'`/kicked list` : mostra una lista degli utenti kickati\n'
                        ..'`/flood [kick/ban]` : scegli se kickare o bannare se un utente sta floodando\n'
                        ..'`/flood [on/off]` : attiva o disattiva l\'anti-flood\n'
                        ..'`/flood [numero]` : imposta quanti messaggi un utente può inviare in 5 secondi senza attivare l\'antiflood\n'
                        ..'`/setrules <regole>` : definisci le regole. Usa \'clear\' per rimuoverle\n'
                        ..'`/addrules <regole>` : aggiungi del testo alle regole già esistenti\n'
                        ..'`/setabout <descrizione>` : imposta una nuova descrizione. Usa \'clear\' per rimuoverla\n'
                        ..'`/addabout <descrizione>` : aggiungi del testo alla descrizione già esistente\n'
                        ..'Con i comandi descritti sopra, puoi usare asterischi (*bold*), uderscores (_italic_) o l\'accento obliquo (`monospace`) per usare la formattazione per le tue regole/descrizione.\n'
                        ..'`/[kick|ban|allow] [media]` : scegli cosa deve fare il bot quando un media specifico viene inviato\n'
                        ..'`/media` : mostra le attuali impostazioni dei media\n'
                        ..'`/link` : ottieni il link del gruppo, se impostato\n'
                        ..'`/lang` : mostra la lista dei linguaggi disponibili\n'
                        ..'`/lang` [codice] : cambia la lingua del bot\n'
                        ..'`/settings` : mostra le impostazioni del gruppo\n'
                        ..'`/warn [kick/ban]` : scegli se kickare o bannare quando un utente ha raggiunto il numero massimo di warnings\n'
                        ..'`/warn` (by reply) : avvisa un utente. Al raggiungimento del numero massimo di warn consentiti, verrà kickato/bannato\n'
                        ..'`/getwarns` (by reply) : mostra quanti warn ha accumulato un utente\n'
                        ..'`/nowarns` (by reply) : azzera i warn di un utente\n'
                        ..'`/warnmax` : imposta il numero massimo di warn che un utente può ricevere\n'
                        ..'`/extra` [#comando] [risposta] : imposta un nuovo comando persoanlizzato che risponde agli #hashtags (markdown suppostato). Usa /extra per maggiori info\n'
                        ..'`/extra list` : mostra la lista dei comandi personalizzati\n'
                        ..'`/extra del` [#comando] : elimina il comando\n'
                        ..'`/setpoll [link|\'no\']` : salva il link ad un sondaggio creato con @pollbot, in modo che possa essere richiamato dai moderatori (usa \'no\' per rimuoverlo)\n'
                        ..'`/poll` : mostra il link al sondaggio\n'
                        ..'`/disable [arab|rtl]` : chiunque con il carattere RTL/chiunque invii un messaggio in lingua araba, verrà kickato\n'
                        ..'`/enable [arab|rtl]` : permetti l\'uso del carattere RTL nel nome/l\'invio di testo in arabo\n'
                        ..'`/disable <rules|about|modlist|extra>` : questi comandi potranno essere utilizzati solo dai moderatori\n'
                        ..'`/enable <rules|about|modlist|extra>` : questi comandi potranno essere utilizzati da chiunque\n'
                        ..'`/enable|/disable <welcome|report>` : abilita/disabilita il messaggio di benvenuto oppure la possibilità di usare \'@admin\' per contattare i moderatori\n'
                        ..'`/report [on/off]` (by reply) : l\'utente non potrà usare il comando \'@admin\'\n'
                        ..'`/welcome <no|r|a|ra|ma|rm|rma>` : componi il messaggio di benvenuto con alcuni elementi\n'
                        ..'_no_ : solo il messaggio di benvenuto semplice\n'
                        ..'_r_ : il messaggio di benvenuto verrà integrato con le regole\n'
                        ..'_a_ : il messaggio di benvenuto verrà integrato con la descrizione\n'
                        ..'_m_ : il messaggio di benvenuto verrà integrato con la lista dei moderatori\n'
                        ..'_ra|ar_ : il messaggio di benvenuto verrà integrato con la descrizione e le regole\n'
                        ..'_ma|am_ : il messaggio di benvenuto verrà integrato con la descrizione e la lista dei moderatori\n'
                        ..'_rm|mr_ : il messaggio di benvenuto verrà integrato con le regole e la lista dei moderatori\n'
                        ..'_ram|rma|mar|mra|arm|amr_ : il messaggio di benvenuto verrà integrato con la descrizione, le regole e la lista dei moderatori\n\n',
            all = '*Comandi per tutti*:\n'
                    ..'`/rules` (se sbloccato) : mostra le regole del gruppo\n'
                    ..'`/about` (se sbloccato) : mostra la descrizione del gruppo\n'
                    ..'`/modlist` (se sbloccato) : mostra la lista dei moderatori\n'
                    ..'`@admin` (se sbloccato) : by reply= inoltra il messaggio a cui hai risposto agli admin; no reply (con descrizione)= inoltra un feedback agli admin\n'
                    ..'`/tell` : mostra le tue informazioni basilari o quelle dell\'utente a cui hai risposto\n'
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
            group = 'Ti ho inviato il messaggio in *privato*.\nSe non mi hai mai usato, *avviami* e chiedi l\'/help *nuovamente*.'
        },
        links = {
            no_link = '*Nessun link* per questo gruppo. Chiedi al proprietario di settarne uno',
            link = '[&&&1](&&&2)',
            link_invalid = 'Questo link *non è valido!*',
            link_updated = 'Il link è stato aggiornato.\n*Ecco il nuovo link*: [&&&1](&&&2)',
            link_setted = 'Il link è stato impostato.\n*Ecco il link*: [&&&1](&&&2)',
            link_usetted = 'Link *rimosso*',
            poll_unsetted = 'Sondaggio *rimosso*',
            poll_updated = 'Il sondaggio è stato aggiornato.\n*Vota qui*: [&&&1](&&&2)',
            poll_setted = 'Il sondaggio è stato impostato.\n*Vota qui*: [&&&1](&&&2)',
            no_poll = '*Nessun sondaggio attivo* in questo gruppo',
            poll = '*Vota qui*: [&&&1](&&&2)'
        },
        luarun = {
            enter_string = 'Please enter a string to load',
            done = 'Done!'
        },
        mod = {
            not_owner = '*Non sei* il proprietario di questo gruppo.',
            reply_promote = 'Rispondi a qualcuno per promuoverlo',
            reply_demote = 'Rispondi a qualcuno per rimuovrlo dai moderatori',
            reply_owner = 'Rispondi a qualcuno per impostarlo come proprietario',
            already_mod = '*&&&1* è già un moderatore di *&&&2*',
            already_owner = 'Sei già il proprietario di questo gruppo',
            not_mod = '*&&&1* non è un moderatore di *&&&2*',
            promoted = '*&&&1* è stato promosso a moderatore di *&&&2*',
            demoted = '*&&&1* è stato rimosso dai moderatori',
            new_owner = '*&&&1* è il nuovo proprietario di *&&&2*',
            modlist = '\nLista dei moderatori di &&&1:\n&&&2'
        },
        report = {
            no_input = 'Scrivi il tuo suggerimento/bug/dubbio accanto a "/c"',
            sent = 'Feedback inviato:\n\n&&&1',
            reply = 'Reply to a feedback to reply to the user',
            reply_no_input = 'Write your reply next to "/reply"',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
            reply_sent = '*Reply sent*:\n\n&&&1',
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
            bio = '*Descrizione di &&&1:*\n&&&2',
            no_bio_add = '*Nessuna descrizione per questo gruppo*.\nUsa /setabout [descrizione] per impostare una nuova descrizione',
            no_input_add = 'Per favore, scrivi qualcosa accanto a "/addabout"',
            added = '*Descrzione aggiunta:*\n"&&&1"',
            no_input_set = 'Per favore, scrivi qualcosa accanto a "/setabout"',
            clean = 'La descrizione è stata eliminata.',
            new = '*Nuova descrizione:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*Anarchia totale*!',
            rules = '*Regole di &&&1:*\n&&&2',
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
                arab_already = 'Anti-caratteri arabi è già *off*',
                arab_unlocked = 'Anti-caratteri arabi è ora *off*',
                report_already = '@admin è già *disponibile*',
                report_unlocked = '@admin è ora *disponibile*',
                wrong_input = 'Argomento non disponibile.\nUsa invece `/enable [rules|about|welcome|modlist|report|extra|rtl|arab]`'
            },
            welcome = {
                no_input = 'Welcome e...?',
                a = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\n*Descrizione*\nLista dei moderatori',
                r = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\nDescrizione\nLista dei moderatori',
                m = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\nDescrizione\n*Lista dei moderatori*',
                ra = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\n*Descrizione*\nLista dei moderatori',
                rm = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\nDescrizione\n*Lista dei moderatori*',
                am = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\n*Descrizione*\n*Lista dei moderatori*',
                ram = 'Nuove impostazioni per il messaggio di benvenuto:\n*Regole*\n*Descrizione*\n*Lista dei moderatori*',
                no = 'Nuove impostazioni per il messaggio di benvenuto:\nRegole\nDescrizione\nLista dei moderatori',
                wrong_input = 'Argomento non disponibile.\nUsa invece _/welcome [no|r|a|ra|ar]_'
            },
            resume = {
                header = 'Impostazioni correnti di *&&&1*:\n\n*Lingua*: `&&&2`\n',
                w_a = '*Tipo di benvenuto*: `benvenuto + descrizione`\n',
                w_r = '*Tipo di benvenuto*: `benvenuto + regole`\n',
                w_m = '*Tipo di benvenuto*: `benvenuto + moderatori`\n',
                w_ra = '*Tipo di benvenuto*: `benvenuto + regole + descrizione`\n',
                w_rm = '*Tipo di benvenuto*: `benvenuto + regole + moderatori`\n',
                w_am = '*Tipo di benvenuto*: `benvenuto + descrizione + moderatori`\n',
                w_ram = '*Tipo di benvenuto*: `benvenuto + regole + descrizione + moderatori`\n',
                w_no = '*Tipo di benvenuto*: `solo benvenuto`\n',
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
        shell = {
            no_input = 'Please specify a command to run.',
            done = 'Done!',
            output = '```\n&&&1\n```'
        },
        tell = {
            first_name = '*Nome*: &&&1\n',
            last_name = '*Cognome*: &&&1\n',
            group_name = '\n*nome gruppo*: &&&1\n',
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
            unbanned = '&&&1 è stato unbannato!',
            reply = 'Rispondi a qualcuno',
            globally_banned = '&&&1 è stato bannato globalmente!',
            no_unbanned = 'Questo è un gruppo normale, gli utenti non vengono bloccati se kickati'
        },
        floodmanager = {
            number_invalid = '`&&&1` non è un valore valido!\nil valore deve essere *maggiore* di `3` e *minore* di `26`',
            not_changed = 'il massimo numero di messaggi che può essere inviato in 5 secondi è già &&&1',
            changed = 'Il numero massimo di messaggi che possono essere inviato in 5 secondi è passato da &&&1 a &&&2',
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
            arab = '&&&1 *kickato*: caratteri arabi non consentiti'
        },
        broadcast = {
            delivered = 'Broadcast delivered. Check the log for the list of reached ids',
            no_users = 'No users saved, no broadcast',
        },
        admin = {
            no_reply = 'This command need a reply',
            blocked = '&&&1 have been blocked',
            unblocked = '&&&1 have been unblocked',
            already_blocked = '&&&1 was already blocked',
            already_unblocked = '&&&1 was already unblocked',
            bcg_no_groups = 'No (groups) id saved',
            leave_id_missing = 'ID missing',
            leave_chat_leaved = 'Chat leaved!',
            leave_error = 'Check the id, it could be wrong'
            
        },
        kick_errors = {
            [101] = 'Non sono admin, non posso kickare utenti',
            [102] = 'Non posso kickare o bannare un admin',
            [103] = 'non c\'è bisogno di unbannare in un gruppo normale',
            [104] = 'Non posso kickare/bannare un admin', --yes, I need two
            [105] = 'Non sono admin, non posso kickare utenti',
            [106] = 'Errore sconosciuto durante il kick'
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
    },
	es = {
        pv = 'Este comando solo esta disponible en los grupos',
        not_mod = 'Tu *no* eres moderador',
        breaks_markdown = 'Este texto interrumpe.\nComprueba cuantas veces lo has usado * o _ o `',
        ping= '¡Pong!',
        control = {
            reload = '*¡Bot reiniciado!*',
            stop = '*¡Bot detenido!*'
        },
        credits = 'Este bot esta basado en [GroupButler bot](https://github.com/RememberTheAir/GroupButler), de software libre, disponible en [Github](https://github.com/). Follow the link to know how the bot works or which data are stored.\n\nRecuerda que siempre puedes usar el comando /c para preguntar cualquier cosa.',
        extra = {
			usage = 'Escribe seguido de /extra el titulo del comando y el texto asociado.\nPor ejemplo:\n/extra #motm esta positivo. El bot respondera _\'Esta positivo\'_ cada vez que alguien escriba #motm',
            new_command = '*Nuevo comando programado!*\n&&&1\n&&&2',
            no_commands = 'No hay comandos programados!',
            commands_list = 'Lista de *comandos personalizados*:\n&&&1',
            command_deleted = 'El comando &&&1 ha sido eliminado',
            command_empty = 'El comando &&&1 no existe'
        },
        getstats = {
            redis = 'Redis actualizado',
            stats = '&&&1'
        },
        help = {
            owner = '*Comandos para el propietario*:\n'
                    ..'`/owner` (mencionar) : Añade nuevo propietario\n'
                    ..'`/promote` (mencionar) : Ascender como moderador a un miembro\n'
                    ..'`/demote` (mencionar) : Degradar a un miembro\n'
                    ..'`/setlink [link|\'no\']` : Ajustar el link del grupo\n'
                    ..'(Obviamente, la capacidad de nombrar moderadores pretende que los usuarios sepan que son los moderadores reales en el grupo, y así pueden añadir y echar a la gente.)\n\n',
            moderator = '*Comandos para moderadores*:\n'
                        ..'`/kick` (mencionar) : Expulsar a un miembro del grupo (puede volver a ser añadido)\n'
                        ..'`/ban` (mencionar) : Banear a un miembro del grupo\n'
                        ..'`/unban` (mencionar) : Desbanear a un miembro del grupo\n'
                        ..'`/kicked list` : Ver la lista de la gente expulsada del grupo\n'
                        ..'`/flood [kick/ban]` : Elegir que se desea que el bot haga cuando el limite de flood es alcanzado\n'
                        ..'`/flood [on/off]` : Enciende/Apaga el control de flood\n'
                        ..'`/flood [number]` : Establece cuantos mensajes puede escribir un miembro en 5 segundos\n'
                        ..'`/setrules <rules>` : Establecer las reglas\n'
                        ..'`/addrules <rules>` : Añadir reglas a las reglas existentes\n'
                        ..'`/setabout <bio>` : Establecer la descripcion del grupo\n'
                        ..'`/addabout <bio>` : Añadir información a la descripcion del grupo existente\n'
                        ..'Con estos 4 comandos anteriores, puedes usar asteriscos (*negrita*), barra-bajas (_cursiva_) o acentos (`monospace`) para remarcar tus reglas/descripcion.\n'
                        ..'`/[kick|ban|allow] [media]` : choose the action to perform when the media is sent\n'
                        ..'`/media` : Ver el estado de los ajustes\n'
                        ..'`/link` : Devolver el link del grupo, si esta establecido\n'
                        ..'`/lang` : Ver la lista de los idiomas disponibles\n'
                        ..'`/lang` [code] : Cambiar el idioma del bot\n'
                        ..'`/settings` : Ver los ajustes del grupo\n'
                        ..'`/warn [kick/ban]` : Elige que hacer cuando un miembro alcanza el numero maximo de advertencias establecido. Expulsar/Banear\n'
                        ..'`/warn` (mencionar) : Advertir a un miembro. Al alcanzar X advertencias sera expulsado/baneado\n'
                        ..'`/getwarns` (mencionar) : Ver numero de advertencias de un miembro\n'
                        ..'`/nowarns` (mencionar) : Resetear a cero en numero de advertencias de un miembro\n'
                        ..'`/warnmax` : Establecer el numero de advertencias para ser baneado/expulsado\n'
                        ..'`/extra` [#trigger] [reply] : Establecer un nuevo comando personalizado que se activará con #hashtags\n'
                        ..'`/extra list` : Ver la lista de comandos personalizados\n'
                        ..'`/extra del` [#trigger] : Eliminar comando personalizado\n'
                        ..'`/setpoll [link|\'no\']` : Guardar el enlace de una encuesta de @pollbot, para que pueda ser re-llamado por mods\n'
                        ..'`/poll` : Ver el enlace de la actual encuesta\n'
                        ..'`/disable [arab|rtl]` : Todo el que tenga caracteres RTL en el nombre o el que envie mensajes con caracteres en arabe sera expulsado\n'
                        ..'`/enable [arab|rtl]` : Permitir caracteres RTL y arabes\n'
                        ..'`/disable <rules|about|modlist|extra>` : Estos comandos solo estaran disponibles para moderadores\n'
                        ..'`/enable <rules|about|modlist|extra>` : Estos comandos estaran disponibles para todos\n'
                        ..'`/enable|/disable <welcome|report>` : Activar/Desactivar el mensaje de bienvenida o la capacidad de usar el atajo \'@admin\'\n'
                        ..'`/report [on/off]` (mencionar) : El miembro no podra/sera capaz de utilizar el atajo \'@admin\'\n'
                        ..'`/flag list` : Mostrar la lista de usuarios que no pueden marcar mensajes\n'
                        ..'`/welcome <no|r|a|ra|ma|rm|rma>` : Composicion de la bienvenida\n'
                        ..'_no_ : Solo mensaje de bienvenida\n'
                        ..'_r_ : Mensaje de bienvenida y reglas\n'
                        ..'_a_ : Mensaje de bienvenida y descripcion del grupo\n'
                        ..'_m_ : Mensaje de bienvenida y lista de moderadores\n'
                        ..'_ra|ar_ : Mensaje de bienvenida, reglas y descripcion de grupo\n'
                        ..'_ma|am_ : Mensaje de bienvenida, descripcion del grupo y lista de moderadores\n'
                        ..'_rm|mr_ : Mensaje de bienvenida, reglas y lista de moderadores\n'
                        ..'_ram|rma|mar|mra|arm|amr_ : Mensaje de bienvenida, reglas, descripcion del grupo y lista de moderadores\n\n',
            all = '*Comandos para todos*:\n'
                    ..'`/rules` (si desbloqueado) : Ver reglas del grupo\n'
                    ..'`/about` (si desbloqueado) : Ver descripcion de grupo\n'
                    ..'`/modlist` (si desbloqueado) : Ver los moderadores del grupo\n'
                    ..'`@admin` (si desbloqueado) : mencionar= informar del mensaje contestado a todos los administradores; sin respuesta (con texto)= enviar el mensaje a todos los administradores\n'
                    ..'`/tell` : Ver tu información básica o la información sobre el usuario que ha respondido\n'
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
            group = 'Te he mandado un mensaje por *privado*.\nSi nunca me has usado, *Iniciame* y usa de nuevo el comando */help*.'
        },
        links = {
            no_link = '*No hay enlace* para este grupo. Pidele al admin que lo añada',
            link = '[&&&1](&&&2)',
            link_invalid = 'Este enlace *no* es valido.',
            link_updated = 'El enlace ha sido actualizado.\n*Este es el nuevo enlace*: [&&&1](&&&2)',
            link_setted = 'El link ha sido configurado.\n*Este es el enlace*: [&&&1](&&&2)',
            link_usetted = 'Enlace *sin establecer*',
            poll_unsetted = 'Encuesta *sin establecer*',
            poll_updated = 'La encuesta ha sido actualizada.\n*Vota aqui*: [&&&1](&&&2)',
            poll_setted = 'El enlace ha sido configurado.\n*Vota aqui*: [&&&1](&&&2)',
            no_poll = '*No hay encuestas activas* en este grupo',
            poll = '*Vota aqui*: [&&&1](&&&2)'
        },
        luarun = {
            enter_string = 'Por favor, introduce una cadena',
            done = 'Hecho!'
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
            modlist = '\nLista de moderadores de &&&1:\n&&&2'
        },
        report = {
            no_input = 'Escribe tus comentarios/bugs/dudas despues de "/c"',
            sent = 'Mensaje enviado:\n\n&&&1',
            reply = 'Responde al mensaje mencionando al miembro',
            reply_no_input = 'Escribe tu respuesta despues de "/reply"',
            feedback_reply = '*Hello, this is a reply from the bot owner*:\n&&&1',
            reply_sent = '*Respuesta enviada*:\n\n&&&1',
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
            bio = '*Descripcion sobre &&&1:*\n&&&2',
            no_bio_add = '*No hay descripcion* de este grupo.\nUsa /setabout [bio] para añadir una descripcion',
            no_input_add = 'Por favor, escribe algo despues de "/addabout"',
            added = '*Descripcion añadida:*\n"&&&1"',
            no_input_set = 'Por favor, escribe algo despues de "/setabout"',
            clean = 'La descripcion ha sido eliminada.',
            new = '*Nueva descripcion:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*¡Anarquia total*!',
            rules = '*Reglas para &&&1:*\n&&&2',
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
                arab_already = 'Anti-caracteres arabe ya *desactivado*',
                arab_locked = 'Anti-caracteres arabe *desactivado*',
                report_already = 'Comando @admin ya *desactivado*',
                report_locked = 'Comando @admin *no disponible*',
                wrong_input = 'Argumento no valido.\nUsa `/disable [rules|about|welcome|modlist|report|extra|rtl|arab]`',
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
                arab_already = 'Anti-caracteres arabe ya *apagado*',
                arab_unlocked = 'Anti-caracteres arabe *apagado*',
                report_already = 'Comando @admin ya *disponible*',
                report_unlocked = 'Comando @admin *disponible*',
                wrong_input = 'Argumento no disponible.\nUsa `/enable [rules|about|welcome|modlist|report|extra|rtl|arab]`'
            },
            welcome = {
                no_input = 'Bienvenida y...?',
                a = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\n*Descripcion*\nModeradores',
                r = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\nDescripcion\nModeradores',
                m = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\nDescripcion\n*Moderadores*',
                ra = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\n*Descripcion*\nModeradores',
                rm = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\nDescripcion\n*Moderadores*',
                am = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\n*Descripcion*\n*Moderadores*',
                ram = 'Nuevos ajustes para el mensaje de bienvenida:\n*Reglas*\n*Descripcion*\n*Moderadores*',
                no = 'Nuevos ajustes para el mensaje de bienvenida:\nReglas\nDescripcion\nModeradores',
                wrong_input = 'Argumento no disponible.\nUsa _/welcome [no|r|a|ra|ar]_'
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
            Report = 'Reportar'
        },
        shell = {
            no_input = 'Escribe un comando para ejecutarlo.',
            done = '¡Hecho!',
            output = '```\n&&&1\n```'
        },
        tell = {
            first_name = '*Nombre*: &&&1\n',
            last_name = '*Apellido*: &&&1\n',
            group_name = '\n*Nombre del grupo*: &&&1\n',
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
            getwarns_reply = 'Reply to an user to check his numebr of warns',
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
            unbanned = '&&&1 ha sido desbaneado!',
            reply = 'Responder a alguien',
            globally_banned = '&&&1 ha sido baneado globalmente!',
            no_unbanned = 'Este es un grupo normal, los miembros no son bloqueados al expulsarlos'
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
            arab = '&&&1 *expulsado*: mensaje arabe detectado'
        },
        broadcast = {
            delivered = 'Emision enviada. Compruebe el registro de la lista de ids',
            no_users = 'No hay miembros guardados, sin emision',
        },
        admin = {
            no_reply = 'Este comando necesita respuesta',
            blocked = '&&&1 bloqueado',
            unblocked = '&&&1 ha sido desbloqueado',
            already_blocked = '&&&1 bloqueado',
            already_unblocked = '&&&1 desbloqueado',
            bcg_no_groups = 'No se han guardado IDs de grupo',
            leave_id_missing = 'Falta el ID',
            leave_chat_leaved = 'Chat leaved!',
            leave_error = 'Mira la ID, puede estar mal'
            
        },
        kick_errors = {
            [101] = 'No soy administrador, no puedo expulsar miembros',
            [102] = 'No puedo expulsar ni banear administradores',
            [103] = 'No hay necesidad de desbanear en un grupo normal',
            [104] = 'No puedo expulsar ni banear administradores', --Si, necesito dos
            [105] = 'o soy administrador, no puedo expulsar miembros',
            [106] = 'Ha ocurrido un error al expulsar a un miembro'
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
    },
}