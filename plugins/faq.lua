local function action(msg, blocks, ln)
    
    if not(msg.chat.type == 'private') then return end
    
    local questions = {
        'Can you make a command to delete <insert what you would like to delete here>?',
        'Can you add a function to kick/ban who writes a specific word?',
        'How do I promote the bot as a group Admin?',
        'What does the "wrong markdown" message mean?',
        'Why I can\'t global ban users?',
        'Why sometimes commands by username are sooo slow?',
        'How can I clone the bot? I\'m getting <insert error> error, I need help',
        'Why I can\'t contact you in private?',
        'Can you please create a support group?',
        'Why I\'m warned by the bot to reply to someone, even if I\'ve replied to a message?',
        'Can you add <insert the language here> language?',
        'What does this bot store? Why can he access all the messages?',
        'Can you advertise my channel/bot in your channel/bot?',
        'How do I report a bug? Which informations do you need?',
        'How many groups does the bot administrate?',
        'What can the bot owner do?',
        'Some strings of my language are not updated. What can I do?',
        'Why this faq are not translated in the supported languages?',
        'Why this faq are not sent with an inline keyboard?',
        'Why the bot doesn\'t report something flagged with the @admin command to all the group admins?',
        'A bot is spamming, why the antiflood can\'t kick it?',
        'Would you like to collaborate to a project? Like a groups network?',
        'Where are you from?',
        'Can I move my group info to another group?',
        'Will you ever add other plugins not related to the group administration? Like something to search on google, to get a definition from UD..?',
        'Please add an anti-emoji system',
        'Can you make the "anti media" directly kick/ban instead of warn? Or can you make the number of warns configurable?',
        'Why when someone is flooding, the bot sends twice/three times/more times the "User xxx kicked/banned for flood" message?',
        'Can you make something to block only Telegram links?',
    }
    
    local answer = {
        'The Bot Api doesn\'t offer a method to delete message, but the Bot Support said that this feature will arrive. You can read the conversation [here](https://telegram.me/GroupButler_ch/32)',
        'I\'ve received many requests about this feature, I\'m sorry but I think everyone could avoid the words check just by changing an "_E_ " with a "_3_ ", or in general every character can be replaced with any other character. This function will probably added when bots can delete messages, but is not 100% confirmed',
        'You can promote the bot as you would do with every other normal user. Make sure your client is updated to the latest version. If you are trying to promote the bot in a supergroup and you can\'t find the bot username, well, I really don\'t know how to solve this problem :)',
        'It means that the message can\'t be sent back to you, because of a wrong number of \\_ or \\* or other markdown symbols. More info [here](https://telegram.me/GroupButler_ch/46)',
        'This is a public bot, this means that everyone can use it and add it to their group. A user you don\'t like to see in your groups, could be not be a problem in others. Or maybe he\'s using the bot too. A global ban would be pointless.',
        'Commands by username are so slower than commands by reply because a bot can\'t retrieve a user id from a username. I need to store a table of ids and usernames, then I have to search the username and get the related id. Each group has its own table of usernames, but if a username is not found locally, it is searched in the global one. So in this case the research could be a bit slow. Tables are updated on each message.',
        'All the instructions are in the github page [here](https://github.com//RememberTheAir). I won\'t give any kind of support in the installation/configuartion/manteinence of the bot. For four reasons: I\'m a noob, I have few time, the bot is easy to install and Lua is a very friendly language. If you need support, there are tons of bot development groups around Telegram. You can ask there, you could find me, and probably you will find a lof of more competent people than me.',
        'Because the "_/c_ " command can do everything we need to communicate. And I don\'t want to be reported when talking to other people. And I don\'t want to be directly reachable 24/7 too. The bot command will group all the questions in one handy chat, and I can reply when I have time without worries about the double tics. As always, I\'ll try to reply to every question.',
        'The reply is similar to the faq #7. But maybe a test group could be a good idea, actually at the moment only two users test the new functions before an update: me, and still me from my second account. Obviously, I can\'t test it in all the conditions of a normal group. That\'s why I love user feedbacks :)',
        'This usually happens if you reply to a message of an user that contains the username of another bot. So the message can\'t be seen by GroupButler.',
        'I can\'t, I know only my native language (_italian_ ) and my English, as you can see, it\'s not good.\nBut you can :) Translations are open to everyone: if you need the bot to talk in your native language, you are free to translate all (or only partially) the strings of the bot.\n To see how, send /help in the private chat with the bot, tap on "all commands", then on "admin", and then on "languages". There you will find all the instructions.',
        'The bot has the acces to all the messages because it needs to see replied messages. And, another thing: when a bot is promoted as admin, it has always access to all the messages, no matter of the settings of BotFather.\nAbout what the bot stores:\n- Description, rules, #extra commands, welcome message if customized\n- It stores the ID associated with its username of every user it find: this is needed for commands by username\n- It stores the number of messages sent by a user in a group and the number of commands used by a user\n\nMedia and messages are not stored by the bot, it\'s something it will never do.',
        '*No*. I don\'t care if you will return the favor or how many subscribers you channel has.\nI\'m saying this because I\'m tired to receive all this kind of requests.',
        'I really appreciate any kind of bug report. It would be great if you provide some extra info to the message, for example: if the bot has replied something, if it happened more than one time, if you are facing the problme in other groups too, if the group is a normal group or a supergroup. I really like screenshots too, you can forward me an image by sending it to the bot and then replying to it with "/c".\nAh, an "hello" to start the message will be really appreciated :)',
        'Wew, I don\'t know the right answer. Probably around 1500 groups. My counter shows 3600, but considering the bot sometimes doesn\'t know when it is removed from a group, I assume that I should take for good 1/2 of the number displayed.\nOther numbers: the bot has been started by almost 10.000 users, and has processed more or less 8 milion messages, and received almost 300.000 queries',
        'Well, not much, all the privileged functions are made for debugging purpose.\nThe most rilevant functions I can use: see the bot stats, query the database, broadcast to groups and users (even if I never do it, i find it annoiyng for users), send a message in a group/to an user, post in the selected channel with the bot, make the bot leave a chat, turn on the admin mode (the bot can\'t be added to new groups), migrate the group info to a new group, global ban an user (even if I won\'t never use this function), block an user (will be ignored by the bot). And some other useless things',
        'If you want to translate them, you can run "/strings [your language code]" to get the most updated file with all the translated and untranslated strings. The steps to follow are the same of a normal translation',
        'Because I\'m lazy :P',
        'Will arrive ;)',
        'Probably, they haven\'t started the bot yet. Bots can\'t write to an user if not started first',
        'Bots can\'t see the messages sent by other bots, so it\'s not possible to detect the spam from other bots',
        'No, sorry but I\'m not interested in ths kind of things. I don\'t want to associate the bot with small/big Telegram Networks or with other bots which do the same thing.',
        'This could sound wierd, but a lot of people start a conversation with this question. I\'m from Italy. And, just to put the record straight, the "/c" command is not intended to start a random conversation with me. It shoud be a fast way to get direct support, nothing else.',
        'Yes, yes you can. But you need to contact me with "/c" command, and provide the ids of both the old and the new groups. And you need to be the creator of both the groups, or at leat creator of the old and admin of the new one.',
        'No, I\'m not going to add recreative things. I want to keep the bot focused on what is doing now, and less invasive as possible in the group chat.',
        'I\'m not going to add this dictatorial things. In my opinion, the bot already allows you to block everything could be source of spam or off-topic in a group, and for me it already feels like an Hitlerian weapon for a paranoid admin.',
        'This "media warns" system will change as soon as I have some time to make some tests. For now it will stay as it is. My idea is to allow Admins to choose how many warns are needed to kick someone for posting a forbidden media. I\'ll see',
        'This is something related on how the anti-flood system works.\nFor example, with the flood limit at 5: if an user sends the 6th message in less then 5 seconds, the bot will detect it as spam and will try to kick the user. But in the time between the delivery of the 6th messages and the moment when the bot receives the message and try to kick the user, this user could have the time to send other few messages.\nThe bot will receive this messages (for example, the 6th, the 7th and the 8th messages), and because they all exceed the limit of 5, it will send the "user is flooding" message. I\'ll fix this problem, but it will take some time due to tests.',
        'No, the current system uses a nice field in the messages object given by the api that includes all the links in a message, I\'m not going to add other plugins with arranged triggers only for Telegram links. I\'m sorry :(',
        
    }
    
    local text
    
    if not blocks[2] then
        local i = 1
        text = '*All the available questions*. Type `/faq [question number]`  to get the anwer\n\n'
        for k,v in pairs(questions) do
            text = text..'*'..i..'* - `'..v..'`\n'
            i = i + 1
        end
        api.sendMessage(msg.chat.id, text, true)
    end
    if blocks[2] then
        local n = tonumber(blocks[2])
        if n > #answer or n == 0 then
            api.sendMessage(msg.chat.id, '_Number not valid_', true)
        else
            text = '*'..questions[n]..'*\n\n'..answer[n]
            api.sendMessage(msg.chat.id, text, true)
        end
    end
end
    
return {
    action = action,
    triggers = {
        '^/(faq)$',
        '^/(faq) (%d%d?)',
    }
}