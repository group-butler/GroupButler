local triggers = {
	'^/help[@'..bot.username..']*',
	'^/start[@'..bot.username..']*'
}

local action = function(msg)
    
    print('\n/help or /start', msg.from.first_name..' ['..msg.from.id..']')
    
    -- save stats
    if string.match(msg.text, '^/help') then
        mystat('help')
    else
        mystat('usrs')
    end
    
    local text = ''
    if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
        if is_owner(msg) then
            text = text..'*Commands for the owner*:\n'
            ..'/owner (by reply) : set a new owner\n'
            ..'/promote (by reply) : promote as moderator a member\n'
            ..'/demote (by reply) : demote a member\n'
            ..'(obviuosly, the ability to appoint moderators is aimed to let users know who are the real moderators in the group, scilicet who can add and kick people.\nSo it\'s hardly suggested to point as moderator only who really is a moderator)\n\n'
        end
        if is_mod(msg) then
            text = text..'*Commands for moderators*:\n'
            ..'/setrules <rules> : set a completly new list of rules\n'
            ..'/addrules <rules> : add at the tile of the existing rules a new set of rules\n'
            ..'/setabout <bio> : set a completly new description for the group\n'
            ..'/addabout <bio> : add at the end of the existing description other relevant informations\n'
            ..'With this four commands above, you can use asterisks (bold) or uderscores (italic) to markup your rules/description. But remember: the number of asterisks and underscores used must be an EVEN NUMBER for both, or I won\'t be able to display the rules.\n'
            ..'/disable <rules|about|modlist> : this commands will be available only for moderators\n'
            ..'/enable <rules|about|modlist> : this commands will be available for all\n'
            ..'/enable|/disable <welcome|flag> : switch on/off the welcome message/the ability to flag messages\n'
            ..'/flagblock|/flagfree (by reply) : the user won\'t be able/will be able to report messages\n'
            ..'/flaglist : show the list of users who can\'t flag messages\n'
            ..'/welcome <no|r|a|ra|ma|rm|rma> : how the welcome message is composed\n'
            ..'no: only the simple welcome message\n'
            ..'r: the welcome message will be integrated with rules\n'
            ..'a: the welcome message will be integrated with the about text\n'
            ..'m: the welcome message will be integrated with the moderators list\n'
            ..'ra|ar: the welcome message will be integrated with rules and bio\n'
            ..'ma|am: the welcome message will be integrated with about text and moderators list\n'
            ..'rm|mr: the welcome message will be integrated with rules and moderators list\n'
            ..'ram|rma|mar|mra|arm|amr: the welcome message will be integrated with rules, about text and moderators list\n\n'
        end
        text = text..'*Commands for all*:\n'
        ..'/rules (if unlocked) : show the group rules\n'
        ..'/about (if unlocked) : show the group description\n'
        ..'/modlist (if unlocked) : show the moderators of the group\n'
        ..'/flagmsg (by reply) : report the message to administrators\n'
        ..'/settings : show the group settings\n'
        ..'/tell : show your basical info or the info about the user you replied to\n'
        ..'/c <feedback> : send a feedback/report a bug/ask a question to my creator. He will reply ASAP\n'
        ..'/help : show this message. If requested in private, it will send a little presentation about how I work'
        
        sendReply(msg, 'I\'ve sent you the requested information in private.\nIf you have never used me before, please start a conversation with me and ask for help here again.')
    end
    
    if msg.chat.type == 'private' then
        text = text..'Hey, *'..msg.from.first_name..'*!\n'
        ..'I\'m a simple bot created in order to help people to manage their groups by using some simple commands.\n'
        ..'\n*How can you help me?*\n'
        ..'With me, you can define rules and description of your groups, set up a moderators list and choose whether I have to display the regulation or the description when a new member join the group.\n'
        ..'\n*How can I use you in my groups*?\n'
        ..'Just... add me! The user that add me will be automatically set up as owner of the group. If you are not the real owner, you can set it by repliyng one of his messages with "/owner".\n'
        ..'If you don\'t do this, you won\'t have extra powers and you won\'t be able rule the group: a moderator can simply kick me if you use me to set up your own rules/description/moderators.\n'
        ..'Please remember, I have been created to make the group a better place where discuss and share your opinions and ideas.\n'
        ..'\nOnce the owner is properly setted, he can set up the moderators list that can be consulted by everyone in the group.\n'
        ..'The ability to appoint moderators is aimed to let users know who are the real moderators in the group, scilicet who can add and kick people.\nSo it\'s hardly suggested to appoint as moderator only who really is.\n'
        ..'\nFeel free to ask me assistance once I joined your group, using "/help".\nYou will receive via private message the list of the available commands in relation to your role in the group.\n'
        ..'For example, you can ask for the rules list, for the group bio (unless they are locked by moderators), or enable/disable the welcome message and decide what it should include (if it must show rules or description, or both, when a new member join the chat).\n'
        ..'People can also report a message: moderators will be privately notified with the message reported. Useful in crowded and active chats, or when moderators are offline, to report the wrong behavior of a member. Moderators can also lock the ability to report messages for all/for specific users.'
        ..'\n\nYou can report bugs/send feedbacks/ask a question to my creator just using "/c <feedback>" command. He will reply ASAP ;)'
    end
    
    sendMessage(msg.from.id, text, true, false, true)
end

return {
	action = action,
	triggers = triggers
}