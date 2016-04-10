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
                        ..'`/setrules <rules>` : set a completly new list of rules\n'
                        ..'`/addrules <rules>` : add at the tile of the existing rules a new set of rules\n'
                        ..'`/setabout <bio>` : set a completly new description for the group\n'
                        ..'`/addabout <bio>` : add at the end of the existing description other relevant informations\n'
                        ..'With this four commands above, you can use asterisks (*bold*), uderscores (_italic_) or the oblique accent (`monospace`) to markup your rules/description.\n'
                        ..'`/link` : get the group link, if setted\n'
                        ..'`/lang` : see the list of available languages\n'
                        ..'`/lang` [code] : change the language of the bot\n'
                        ..'`/settings` : show the group settings\n'
                        ..'`/warn` (by reply) : warn an user\n'
                        ..'`/getwarns` (by reply) : see how many times an user have been warned\n'
                        ..'`/nowarns` (by reply) : reset to zero the warns of an user\n'
                        ..'`/warnmax` : set the max number of the warns before show a warning message\n'
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
                a = 'New settings for the welcome message:\n❌Rules\n✅*About*\n❌Moderators list',
                r = 'New settings for the welcome message:\n✅*Rules*\n❌About\n❌Moderators list',
                m = 'New settings for the welcome message:\n❌Rules\n❌About\n✅*Moderators list*',
                ra = 'New settings for the welcome message:\n✅*Rules*\n✅*About*\n❌Moderators list',
                rm = 'New settings for the welcome message:\n✅*Rules*\n❌About\n✅*Moderators list*',
                am = 'New settings for the welcome message:\n❌Rules\n✅*About*\n✅*Moderators list*',
                ram = 'New settings for the welcome message:\n✅*Rules*\n✅*About*\n✅*Moderators list*',
                no = 'New settings for the welcome message:\n❌Rules\n❌About\n❌Moderators list',
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
            mod = 'A moderator can\'t be warned',
            warned_max = '❌ *User* &&&1 *reached the max number of warns*❌',
            warned = '⚠*️User* &&&1 *have been warned.*\n🔰_Number of warnings_   *&&&2*\n⛔️_Max allowed_   *&&&3* (*-&&&4*)',
            warnmax = '🔄 Max number of warnings changed.\n🔹*Old* value: &&&1\n🔺*New* max: &&&2',
            getwarns_reply = 'Reply to an user to check his numebr of warns',
            limit_reached = '⛔️This usern has already reached the max number of warnings (*&&&1/&&&2*)',
            limit_lower = '✅ This user is under the max number of warnings.\n🔰 *&&&1* warnings missing on a total of *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Reply to an user to delete his warns',
            nowarn = '🔰 The number of warns received by this user have been *resetted*'
        },
        setlang = {
            list = '*List of available languages:*\n\n&&&1\nUse `/lang xx` to change you language',
            error = 'The language setted is *not supported*. Use `/lang` to see the list of the available languages',
            success = '*New language setted:* &&&1'
        }
    },
    it = {
        pv = 'Questo comando è disponibile solo in un gruppo',
        not_mod = '*Non* sei un moderatore',
        breaks_markdown = 'Il test inviato corrompe il markdown.\nControlla quante volte hai usato * oppure _ oppure `',
        ping= 'Pong!',
        control = {
            reload = '*Bot ricaricato!*',
            stop = '*Bot arrestato!*'
        },
        credits = 'Questo bot è basato su [GroupButler bot](https://github.com/RememberTheAir/GroupButler), un bot *opensource* il cui codice è disponibile su [Github](https://github.com/). Apri il link per visionare come il bot funziona o quali informazioni sono raccolte.\n\nRicordati che puoi sempre usare il comando /c pe chiedere qualcosa.',
        extra = {
            new_command = '*Nuovo comando impostato!*\n&&&1\n&&&2',
            no_commands = 'Nessun comando impostato!',
            commands_list = 'Lista dei *comandi personalizzati*:\n&&&1',
            command_deleted = 'Il comando &&&1 è stato eliminato',
            command_empty = '&&&1 non esiste'
        },
        flag = {
            reply_flag = 'Rispondi al messaggio per segnalarlo ad un moderatore',
            mod_msg = '&&&1&&&2 ha segnalato &&&3&&&4\nDescrizione: &&&5\nMessaggio in questione:\n\n&&&6',
            group_msg = '*Segnalato!*',
            reply_block = 'Rispondi ad un utente per privarlo del comando /flag',
            mod_cant_flag = 'I moderatori non possono segnalare',
            already_unable = '*&&&1* è già inabilitato ad usare /flag',
            blocked = '*&&&1* è ora *inabilitato* ad usare /flag',
            reply_unblock = 'Rispondi ad un utente per permettegli di usare /flag',
            already_able = '*&&&1* è già *abilitato* ad usare /flag',
            unblocked = '*&&&1* è ora *abilitato* ad usare /flag',
            list_empty = 'Non ci sono utenti inabilitati ad usare /flag in questo gruppo',
            list = '\nUtenti che non possono usare /flag:\n&&&1'
        },
        getstats = {
            redis = 'Redis aggiornato',
            stats = '&&&1'
        },
        help = {
            owner = '*Commandi per il proprietario*:\n'
                    ..'`/owner` (by reply) : imposta un nuovo proprietario\n'
                    ..'`/promote` (by reply) : promuovi un membro a moderatore\n'
                    ..'`/demote` (by reply) : rimuovi un membro dai moderatori\n'
                    ..'`/setlink [link|\'no\']` : imposta il link del gruppo, in modo che possa essere visualizzato a richiesta, o rimuovilo\n'
                    ..'(Ovviamente, la possibilità di nominare dei moderatori serve per permettere ai membri di avere un elenco di chi può rimuove altri utenti.\nQuindi è caldamente consigliato di nominare come moderatore solo chi lo è reakmente)\n\n',
            moderator = '*Commandi per moderatori*:\n'
                        ..'`/setrules <regole>` : imposta le nuove regole del gruppo\n'
                        ..'`/addrules <regole>` : aggiungi una regola a quelle già esistenti\n'
                        ..'`/setabout <bio>` : imposta una nuova descrizione del gruppo\n'
                        ..'`/addabout <bio>` : aggiungi altre informazioni alla descrizione già esistente\n'
                        ..'Regole e descrizione permettono il markdown, con asterischi (*bold*), uderscores (_italic_) e accenti obliqui (`monospace`).\n'
                        ..'`/link` : mosta il link del gruppo, se impostato\n'
                        ..'`/lang` : mostra l\'elenco delle lingue supportate\n'
                        ..'`/lang` [codice] : cambia la lingua del bot nel gruppo\n'
                        ..'`/settings` : mostra le impostazioni del gruppo\n'
                        ..'`/warn` (by reply) : ammonisci un utente\n'
                        ..'`/getwarns` (by reply) : mostra quante volte un utente è stato ammonito\n'
                        ..'`/nowarns` (by reply) : reimposta a zero le ammonizioni di un utente\n'
                        ..'`/warnmax` : mostra il massimo numero di ammonizioni, raggiunto il quale sarà mostrato un avviso\n'
                        ..'`/extra` [#comando] [risposta] : crea un nuovo comando tramite un #hashtag, settando quale dovrà essere la risposta del bot (markdown supportato)\n'
                        ..'`/extra list` : mostra la lista dei comandi personalizzati\n'
                        ..'`/extra del` [#comando] : elimina un comando personalizzato\n'
                        ..'`/setpoll [link|\'no\']` : salva un sondaggio di @pollbot, in modo che possa essere richiamato dai moderatori, o rimuovilo\n'
                        ..'`/poll` : mostra il sondaggio corrente\n'
                        ..'`/disable <rules|about|modlist|extra>` : questi comandi saranno utilizzabili solo dai moderatori\n'
                        ..'`/enable <rules|about|modlist|extra>` : questi comandi saranno utilizzabili da tutti\n'
                        ..'`/enable|/disable <welcome|flag>` : abilita/diabilita il messaggio di benvenuto/la possibilità di segnalare i messaggi\n'
                        ..'`/flag block|/flag free` (by reply) : l\'utente non potrà/potrà segnalare messaggi\n'
                        ..'`/flag list` : mostra l\'elenco degli utenti che non possono segnalare messaggi\n'
                        ..'`/welcome <no|r|a|ra|ma|rm|rma>` : modifica la composizione del messaggio di benvenuto\n'
                        ..'_no_ : messaggio di benvenuto semplice\n'
                        ..'_r_ : il messaggio di benvenuto comprenderà le regole\n'
                        ..'_a_ : il messaggio di benvenuto comprenderà la descrizione\n'
                        ..'_m_ : il messaggio di benvenuto comprenderà la lista dei moderatori\n'
                        ..'_ra|ar_ : il messaggio di benvenuto comprenderà regole e descrizione\n'
                        ..'_ma|am_ : il messaggio di benvenuto comprenderà descrizione e lista moderatori\n'
                        ..'_rm|mr_ : il messaggio di benvenuto comprenderà regole e lista moderatori\n'
                        ..'_ram|rma|mar|mra|arm|amr_ : il messaggio di benvenuto comprenderà descrizione, regole e lista moderatori\n\n',
            all = '*Commandi per tutti*:\n'
                    ..'`/rules` (se sbloccato) : mostra le regole del gruppo\n'
                    ..'`/about` (se sbloccato) : mostra la descrizione del gruppo\n'
                    ..'`/modlist` (se sbloccato) : mostra la lista dei moderatori del gruppo\n'
                    ..'`/flag msg` (by reply e se sbloccato) `[descrizione opzionale]` : segnala il messaggio ai moderatori\n'
                    ..'`/tell` : mostra le tue info/le info dell\'utente a cui hai risposto\n'
                    ..'`/info` : alcune utili informazioni sul bot\n'
                    ..'`/c` <feedback> : invia un feedback/segnala un bug/fai una domanda al mio creatore. _OGNI GENERE DI RICHIESTA E\' BENVENUTA_. Risponderà ASAP\n'
                    ..'`/help` : mostra questo messaggio.'
		            ..'\n\nSe ti piace il bot, lascia [qui](https://telegram.me/storebot?start=groupbutler_bot) il voto che credi che si meriti',
		    private = 'Hey, *&&&1*!\n'
                    ..'Sono un semplice bot creato con lo scopo di aiutare ad amministrare un gruppo.\n'
                    ..'\n*Come puoi aiutarmi?*\n'
                    ..'Con me, puoi impostare descrizione e regole di un gruppo, impostare una lista di moderatori, creare comandi personalizzati, ammonire gli utenti, scegliere cosa il messaggio di benvenuto debba mostrare, impostare il link di invito o il link ad un sondaggio, ed altre cose del genere.\nScopri di più aggiungendomi ad un gruppo!\n'
                    ..'\nL\'utente che mi ha aggiunto viene impostato automaticamente come proprietario. Se non sei il vero proprietario, impostalo rispondndo ad un suo messaggio con  `/owner`.\n'
                    ..'\nPuoi segnalare bug/inviare un feedback/fare una domanda al mio creatore usando "`/c <il tuo feedback>`". Risponderà al più presto ;)',
            group = 'Ti ho inviato il messaggio di aiuto in *privato*.\nSe non mi hai mai avviato, *accendimi* e chiedi aiuto qui *nuovamente*.'
        },
        links = {
            no_link = '*Nessun link* per questo gruppo. Chiedi al proprietario di generarne uno',
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
            enter_string = 'Inserisci uno script da eseguire',
            done = 'Fatto!'
        },
        mod = {
            not_owner = '*Non* sei il proprietario di questo gruppo.',
            reply_promote = 'Rispondi a qualcuno per promuoverlo',
            reply_demote = 'Rispondi a qualcuno per rimuoverlo dai moderatori',
            reply_owner = 'Rispondi a qualcuno per renderlo il proprietario',
            already_mod = '*&&&1* è già moderatore di *&&&2*',
            already_owner = 'Sei già il proprietario di questo gruppo',
            not_mod = '*&&&1* non è un moderatore di *&&&2*',
            promoted = '*&&&1* è stato promosso a moderatore di *&&&2*',
            demoted = '*&&&1* è stato rimosso dai moderatori',
            new_owner = '*&&&1* è il nuovo proprietario di *&&&2*',
            modlist = '\nLista dei moderatori di &&&1:\n&&&2'
        },
        redisbackup = 'Backup salvato come _redisbackup.json_',
        redisinfo = {
            hash_info = 'Informazioni sull\'hash:\n\n&&&1',
            found = 'Utente trovato'
        },
        report = {
            no_input = 'Scrivi il tuo suggerimento/bug/dubbio accanto a "/c"',
            sent = '*Feedback inviato*:\n\n&&&1',
            reply = 'Rispondi ad un feedback per rispondere all\'utente',
            reply_no_input = 'Scrivi la tua risposta affianco a "/reply"',
            feedback_reply = 'Ciao *&&&1*, questa è una risposta al tuo feedback:\n"&&&2..."\n\n*Risposta*:\n&&&3',
            reply_sent = '*Risposta inviata*:\n\n&&&1',
        },
        service = {
            new_group = 'Ciao a tutti!\n*&&&1* mi ha aggiunto per aiutare ad amministrare il gruppo.\nSe vuoi sapere come funziono, per favore avviami in privato o scrivi /help  :)',
            welcome = 'Ciao &&&1, e benvenuto in *&&&2*!',
            welcome_rls = 'Anarchia totale!',
            welcome_abt = 'Nessuna descrizione disponibile.',
            welcome_modlist = '\n\n*Lista dei moderatori*:\n',
            abt = '\n\n*Descrizione*:\n',
            rls = '\n\n*Regole*:\n',
            bot_removed = 'I dati su *&&&1* sonostati eliminati.\nGrazie di avermi utilizzato!\nSono sempre qui, se ti serve una mano ;)'
        },
        setabout = {
            no_bio = '*Nessuna descrizione* per questo gruppo.',
            bio = '*Descrizione di &&&1:*\n&&&2',
            no_bio_add = '*Nessuna descrizione per questo gruppo*.\nUsa /setabout [descrizione] per impostare una nuova descrizione',
            no_input_add = 'Scrivi qualcosa a fianco di "/addabout"',
            added = '*Descrizione aggiunta:*\n"&&&1"',
            no_input_set = 'Scrivi qualcosa a fianco di "/setabout"',
            clean = 'Descrizione eliminata.',
            new = '*Nuova descrizione:*\n"&&&1"'
        },
        setrules = {
            no_rules = '*Anarchia totale*!',
            rules = '*Regole di &&&1:*\n&&&2',
            no_rules_add = '*Nessuna regola* per questo gruppo.\nUsa /setrules [regole] per impostare delle nuove regole',
            no_input_add = 'Scrivi qualcosa a fianco di "/addrules"',
            added = '*Rules added:*\n"&&&1"',
            no_input_set = 'Scrivi qualcosa a fianco di "/setrules"',
            clean = 'Regole eliminate..',
            new = '*Nuove regole:*\n"&&&1"'
        },
        settings = {
            disable = {
                no_input = 'Disabilitare cosa?',
                rules_already = '`/rules` già *bloccato* (solo mod)',
                rules_locked = '`/rules` è ora utilizzabile *solo dai moderatori*',
                about_already = '`/about` già *bloccato* (solo mod)',
                about_locked = '`/about` è ora utilizzabile *solo dai moderatori*',
                welcome_already = 'Welcome già *bloccato* (non viene visualizzato)',
                welcome_locked = 'Il messaggio di benvenuto non verrà mostrato*',
                modlist_already = '`/modlist` già *bloccato* (solo mod)',
                modlist_locked = '`/modlist` è ora utilizzabile *solo dai moderatori*',
                flag_already = '`/flag` già *bloccato* (non può essere utilizzato)',
                flag_locked = '`/flag` non potrà essere utilizzato',
                extra_already = 'I comandi #extra sono già *bloccati* (solo i moderatori possono usarli)',
                extra_locked = 'I comandi #extra potranno essere usati solo dai moderatori',
                wrong_input = 'Parametro non disponibile.\nUsa invece `/disable [rules|about|welcome|modlist|flag|extra]`'
            },
            enable = {
                no_input = 'Abilitare cosa?',
                rules_already = '`/rules` già *sbloccato* (per tutti)',
                rules_unlocked = '`/rules` è ora utilizzabile *da tutti*',
                about_already = '`/about` già *sbloccato* (per tutti)',
                about_unlocked = '`/about` è ora utilizzabile *da tutti*',
                welcome_already = 'Il messaggio di benvenuto viene già visualizzato',
                welcome_unlocked = 'Il messaggio di benvenuto verrà visualizzato',
                modlist_already = '`/modlist` già *sbloccato* (per tutti)',
                modlist_unlocked = '`/modlist` è ora utilizzabile *da tutti*',
                flag_already = '`/flag` già *sbloccato* (per tutti)',
                flag_unlocked = '`/flag` è ora utilizzabile *da tutti*',
                extra_already = 'I comandi #extra sono già consultabili *da tutti*',
                extra_unlocked = 'I comandi #extra sono ora consultabili *da tutti*',
                wronf_input = 'Parametro non disponibile.\nUsa invece `/enable [rules|about|welcome|modlist|flag|extra]`'
            },
            welcome = {
                no_input = 'Welcome and...?',
                a = 'Nuove impostazioni per il messaggio di benvenuto:\n❌Regole\n✅*Descrizione*\n❌Lista dei moderatori',
                r = 'Nuove impostazioni per il messaggio di benvenuto:\n✅*Regole*\n❌Descrizione\n❌Lista dei moderatori',
                m = 'Nuove impostazioni per il messaggio di benvenuto:\n❌Regole\n❌Descrizione\n✅*Lista dei moderatori*',
                ra = 'Nuove impostazioni per il messaggio di benvenuto:\n✅*Regole*\n✅*Descrizione*\n❌Lista dei moderatori',
                rm = 'Nuove impostazioni per il messaggio di benvenuto:\n✅*Regole*\n❌Descrizione\n✅*Lista dei moderatori*',
                am = 'Nuove impostazioni per il messaggio di benvenuto:\n❌Regole\n✅*Descrizione*\n✅*Lista dei moderatori*',
                ram = 'Nuove impostazioni per il messaggio di benvenuto:\n✅*Regole*\n✅*Descrizione*\n✅*Lista dei moderatori*',
                no = 'Nuove impostazioni per il messaggio di benvenuto:\n❌Regole\n❌Descrizione\n❌Lista dei moderatori',
                wrong_input = 'Paramentro non disponibile.\nUsa invece _/welcome [no|r|a|ra|ar]_'
            },
            resume = {
                header = 'Impostazioni correnti di *&&&1*:\n\n*Lingua*: `&&&2`\n',
                w_a = '*Tipo di benvenuto*: `benvenuto + descrizione`\n',
                w_r = '*Tipo di benvenuto*: `benvenuto + regole`\n',
                w_m = '*Tipo di benvenuto*: `benvenuto + lista dei moderatori`\n',
                w_ra = '*Tipo di benvenuto*: `benvenuto + regole + descrizione`\n',
                w_rm = '*Tipo di benvenuto*: `benvenuto + regole + lista dei moderatori`\n',
                w_am = '*Tipo di benvenuto*: `benvenuto + descrizione + lista dei moderatori`\n',
                w_ram = '*Tipo di benvenuto*: `benvenuto + regole + descrizione + lista dei moderatori`\n',
                w_no = '*Tipo di benvenuto*: `benvenuto semplice`\n'
            },
            Rules = 'Regole',
            About = 'Descrizione',
            Welcome = 'Messaggio di benvenuto',
            Modlist = 'Lista dei moderatori',
            Flag = 'Flag',
            Extra = 'Extra'
        },
        shell = {
            no_input = 'Specifica un comando da eseguire.',
            done = 'Fatto!',
            output = '```\n&&&1\n```'
        },
        tell = {
            first_name = '*Nome*: &&&1\n',
            last_name = '*Cognome*: &&&1\n',
            group_name = '\n*Nome del gruppo*: &&&1\n',
            group_id = '*ID del gruppo*: &&&1'
        },
        warn = {
            warn_reply = 'Rispondi ad un messaggio per ammonire un utente',
            mod = 'Un moderatore non può essere ammonito',
            warned_max = '❌ *L\'utente* &&&1 *ha raggiunto il numero massimo di ammonizioni*❌',
            warned = '⚠*️L\'utente* &&&1 *è stato ammonito.*\n🔰_Numero di ammonizioni_   *&&&2*\n⛔️_Massimo consentito_   *&&&3* (*-&&&4*)',
            warnmax = '🔄 Massimo numero di ammonizioni cambiato.\n🔹*Vecchio* valore: &&&1\n🔺*Nuovo* limite: &&&2',
            getwarns_reply = 'Rispondi ad un utente per visualizzare il suo numero di ammonizioni',
            limit_reached = '⛔️Questo utente ha già raggiunto il numero massimo di ammonizioni (*&&&1/&&&2*)',
            limit_lower = '✅ Questo utente è sotto il limite massimo di ammonizioni.\n🔰 *&&&1* ammonizioni rimanenti su un totale di *&&&2* (*&&&3/&&&4*)',
            nowarn_reply = 'Rispondi ad un utente per eliminarne le ammonizioni',
            nowarn = '🔰 Il numero di ammonizioni ricevute da questo utente è stato *azzerato*'
        },
        setlang = {
            list = '*Lista delle lingue disponibili:*\n\n&&&1\nUsa `/lang codice` per cambiare la lingua del bot',
            error = 'La lingua scelta *non è supportata o non esiste*. Usa `/lang` per consultare la lista delle lingue disponibili',
            success = '*Nuova lingua impostata:* &&&1'
        }
    }
}
