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
        local hash = 'bot:general'
        local num = client:hincrby(hash, 'users', 1)
        print('Stats saved', 'Users: '..num)
		hash = 'bot:users'
		local savename = msg.from.first_name
		if msg.from.username then
			savename = savename..' [@'..msg.from.username..']'
		end
		client:hset(hash, msg.from.id, savename)
    end
    
    local text = ''
    if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
        if is_owner(msg) then
            text = text..'*Commands for the owner*:\n'
            ..'`/owner` (by reply) : set a new owner\n'
            ..'`/promote` (by reply) : promote as moderator a member\n'
            ..'`/demote` (by reply) : demote a member\n'
            ..'`/setlink [link|\'no\']` : set the group link, so it can be re-called by mods, or unset it\n'
            ..'(obviuosly, the ability to appoint moderators is aimed to let users know who are the real moderators in the group, and so who can add and kick people.\nSo it\'s hardly suggested to point as moderator only who really is a moderator)\n\n'
        end
        if is_mod(msg) then
            text = text..'*Commands for moderators*:\n'
            ..'`/setrules <rules>` : set a completly new list of rules\n'
            ..'`/addrules <rules>` : add at the tile of the existing rules a new set of rules\n'
            ..'`/setabout <bio>` : set a completly new description for the group\n'
            ..'`/addabout <bio>` : add at the end of the existing description other relevant informations\n'
            ..'With this four commands above, you can use asterisks (*bold*), uderscores (_italic_) or the oblique accent (`monospace`) to markup your rules/description.\n'
            ..'`/link` : get the group link, if setted\n'
            ..'`/settings` : show the group settings\n'
            ..'`/warn` (by reply) : warn an user\n'
            ..'`/getwarns` (by reply) : see how many times an user have been warned\n'
            ..'`/nowarns` (by reply) : reset to zero the warns of an user\n'
            ..'`/warnmax` : set the max number of the warns before show a warning message\n'
            ..'`/setpoll [link|\'no\']` : save a poll link from @pollbot, so it can be re-called by mods, or unset it\n'
            ..'`/poll` : get the current poll link\n'
            ..'`/disable <rules|about|modlist>` : this commands will be available only for moderators\n'
            ..'`/enable <rules|about|modlist>` : this commands will be available for all\n'
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
            ..'_ram|rma|mar|mra|arm|amr_ : the welcome message will be integrated with rules, about text and moderators list\n\n'
        end
        text = text..'*Commands for all*:\n'
        ..'`/rules` (if unlocked) : show the group rules\n'
        ..'`/about` (if unlocked) : show the group description\n'
        ..'`/modlist` (if unlocked) : show the moderators of the group\n'
        ..'`/flag msg` (by reply and if unlocked) `[optional description]` : report the message to administrators\n'
        ..'`/tell` : show your basical info or the info about the user you replied to\n'
        ..'`/info` : show some useful informations about the bot\n'
        ..'`/c` <feedback> : send a feedback/report a bug/ask a question to my creator. _ANY KIND OF SUGGESTION OR FEATURE REQUEST IS WELCOME_. He will reply ASAP\n'
        ..'`/help` : show this message.'
		..'\n\nIf you like this bot, please leave the vote you think it deserves [here](https://telegram.me/storebot?start=groupbutler_bot)'
        
        sendReply(msg, 'I\'ve sent you the help message in *private*.\nIf you have never used me, *start* me and ask for help here *again*.', true)
    end
    
    if msg.chat.type == 'private' then
        text = text..'Hey, *'..msg.from.first_name..'*!\n'
        ..'I\'m a simple bot created in order to help people to manage their groups.\n'
        ..'\n*How can you help me?*\n'
        ..'With me, you can define rules and description of your group, set up a moderators list, choose whether I have to display the regulation or the description when a new member join the group, set up the group link or a link to a poll, and other things like that.\nDiscover more by adding me to a group!\n'
        ..'\nThe user that add me will be automatically set up as owner of the group. If you are not the real owner, you can set it by repliyng one of his messages with `/owner`.\n'
        ..'\nYou can report bugs/send feedbacks/ask a question to my creator just using "`/c <feedback>`" command. EVERYTHING IS WELCOME! He will reply ASAP ;)'
    end
    
    sendMessage(msg.from.id, text, true, false, true)
end

return {
	action = action,
	triggers = triggers
}