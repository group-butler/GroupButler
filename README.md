#Group Butler

##Introduction

This bot has been created to help people in the administration of a group, with a lot of useful tools 8you can see them in the command list below).

This bot takes the main loop and bindings from [Otouto](https://github.com/topkecleon/otouto) ([@mokubot](https://telegram.me/mokubot)).

Otouto and Group Butler are licensed under the GNU General Public License. A copy of the license has been included in [LICENSE](https://github.com/RememberTheAir/GroupButler/blob/master/LICENSE).

##What is it?
Group Butler is a Telegram API bot written in Lua. It has been created to help the members of a group to keep it clean and regulated, from the point of view of administrators and normal users.

This bot takes its long-polling loop and its structure from Otouto (3.0 or lower, iirc) and it's plugin-based. This makes easier to manage each function and command of the bot, and allows to split the different capabilities of it in different files for a more specific vision of what it should do.

Follow the [channel](https://telegram.me/groupbutler_ch) if you want to be updated about new changes.
* * *

##Commands
Here you have the list of the available commands.

###Everyone
>/ping | check if the bot is running
>
>/help | show the help message (in private)
>
>/dasboard | receive in private a message delivered with an inline keyboard, to surf all the group info (rules/about/modlist/settings/extra commands list)
>
>/c [feedback] | talk with the bot admin
>
>/info | show some info about the bot (as the link to this repo)
>
>/about (if unlocked) | will return the group descriptions
>
>/rules (if unlocked) | show the group rules
>
>@admin [reply optional] | send a feedback to all the admins or, if by reply, forward the replied message to the admins
>
>/modlist (if unlocked) | show the moderators list
>
>/tell | show the basical info of the user/group. Can work by reply
>
>/echo | I use it to see if the markdown is correct (repeats the text, with parse mode on)

###Moderators
>/kick [reply|username] | kick an user (it's still able to join)
>
>/ban [reply|username] | ban an user (not able to join again)
>
>/unban [reply|username] | unban an user
>
>/menu | receive in private an inline keyboard to manage all the settings of the bot
>
>/flood [number] | set the max number of messages allowed within 5 seconds before kick/ban
>
>/flood [on/off] | turn the anti-flood on/off
>
>/flood [kick/ban] | choose what to do when a user is flooding
>
>/lang | see the supported languages
>
>/lang [code] | change the bot language (in the group)
>
>/kick [media type] | the bot will kick who send that media
>
>/ban [media type] | the bot will ban who send that media
>
>/allow [media type] | the media can be sent freely
>
>/media | show the current status for each media via an inline keyboard, that allow ro edit media settings in private
>
>/media list | show the list of the media you can manage
>
>/warn [reply] | warn an user. He will be kicked/banned when the max number of warns will be reached
>
>/warn [kick/ban] | choose what to do when the max number of warns is reached
>
>/warnmax [number] | choose the max number of warns to reach to be kicked/banned
>
>/getwarns [reply] | show how many warns has an user
>
>/nowarns [reply] | reset the warns of an user
>
>/settings | show the current settings of the group
>
>/disable [rules/about/modlist/extra] | this commands will be available only for moderators
>
>/enable [rules/about/modlist/extra] | this commands will be available only for moderators
>
>/[disable/enable] welcome | turn on/off the welcome message
>
>/[disable/enable] wreport | turn on/off the possibility to use @admin command by the users
>
>/disable [arab/rtl] | everyone with have rtl character in the name/in a message will be kicked, same for who write with arab characters
>
>/enable [arab/rtl] | rtl character/arab will be allowed
>
>/welcome [a/r/m/ar/am/rm/arm] | change the welcome composition (a: about, r: rules, m:modlist)
>
>/extra [#command] [reply] | set up a reply to an hashtag
>
>/extra list | show the list of hashtag commands
>
>/extra del [#command] | delete that custom command
>
>/link | show the group link (if setted)
>
>/setpoll [link/no] | set up a @pollbot poll link (so moderators can see it with /poll). Use 'no' to remove it
>
>/poll | show the current poll link (if setted)
>
>/setabout [description] | set a description for the group
>
>/addabout [text to add] | add some text to the decription
>
>/setrules [rules] | set the group rules
>
>/addrules [rules] | add some rules
>
>/report off [reply] | the user won't be able to report a message/send a feedback to the admins
>
>/report on [reply] | the user will be able to report a message/send a feedback to the admins

###Owner
>/setlink [link/no] | set the group link (so moderators can see it with /link). Use 'no' to remove it
>
>/owner [reply] | change the ownership of the group (not really, the bot will se the replied user as the owner)
>
>/promote [reply|username] | promote the user as moderators
>
>/demote [reply|username] | demote the user

###Admin
>/init | to reload the bot
>
>/backup | will send to the admin the bot folder, zipped
>
>/stop | will stop the bot
>
>/leave [group id] | the bot will leave the group. If launched in a group, no [id] needed
>
>/adminmode [on/off] | when on, only the admin will be able to add the bot to a group
>
>/bc [text] | will send a broadcast to users
>
>/bcg [text] | will send a broadcast to groups
>
>/post [post text] | post a message in the setted channel (config.lua)
>
>/stats | will return some statistics (messages, groups, users, commands)
>
>/commands | will show how many times each command have been used
>
>/usernames | send a file with all the usernames that the bot has found
>
>/rediscli [query] [parameters] | execute a redis command and get the output (tables and not tables)
>
>/movechat [new chat id] | move the chat info of the current chat to the target id
>
>/redis backup | save all the info of all the groups administrated in a json file
>
>/group info [id] | get a text file with all the info of a group (table view)
>
>/save | perform a redis background save
>
>/reset [field] | reset a specific general statistic
>
>/log [of what] | will send the log of the event inserted
>
>/log del [which] | will delete the log
>
>/block [reply/id] | will block the user ( the user won't be able to use the bot)
>
>/unblock [id/reply] | will unblock the user
>
>/isblocked [reply] | check if an user is blocked
>
>/movechat [new chat id] | move the current chat info to another group
>
>/group info | sends back a txt file with a lua table printed, with allthe info about that group
>
>/redis backup | backup all the groups info in a serialized json file
>
>/reply [text] | reply to a feedback
>
>/trfile [by reply] (language code optional, default: en) | set a lua file as the default file that will be sent when a user asks for the stings file
>
>/sendplug [plugin name] | send the plugin
>
>/sendfile [path] | send the file
>
>/ping redis | check if redis is on
>
>/download [by reply] | Download a file from Telegram servers (under 50 mb)
>
>/admin | returns the admin.lua plugin triggers


If the bot doesn't receive some updates (it could happen when there are more than one bot in the chat), mention it in the message. The bot username will be removed before match the plugin triggers.
* * *

##Setup
You **must** have Lua (5.2+), LuaSocket, LuaSec, Redis-Lua, Lua ansicolors, Lua serpent and Curl installed.

How to install LuaRocks and set-up the modules:
```bash
# Download and install LuaSocket, LuaSec, Redis-Lua, ansicolors and serpent

$ wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
$ tar zxpf luarocks-2.2.2.tar.gz
$ cd luarocks-2.2.2
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasocket
$ sudo luarocks install luasec
$ sudo luarocks install redis-lua
$ sudo luarocks install lua-term
$ sudo luarocks install serpent
$ cd ..
```

Install Curl, only if is missing:
```bash
$ sudo apt-get install curl
```

Clone the github repository:
```bash
# Clone the repo and give the permission to start the launch script

$ git clone https://github.com/RememberTheAir/GroupButler.git
$ cd GroupButler && sudo chmod 777 launch.sh
```

**First of all, take a look to your bot settings:**

> • Make sure that privacy is disabled, otherwise the bot won't see replied messages unless they starts with '/'. Write `/setprivacy` to [BotFather](http://telegram.me/BotFather) to check the current setting.

**Before you do anything, open config.lua in a text editor and make the following changes:**

> • Set bot_api_key to the authentication token you received from the [BotFather](http://telegram.me/BotFather).
>
> • Set admin as your Telegram ID. You can set up a log group where error messages will be sent: this allows to split errors from user feedbacks
>
> • Set your bot channel (if you have one) in config.lua, under "channel".
>
> • If it asks for the sudo password during the installation or after, insert it.

Before start the bot, you have to start Redis. Open a new window and type:
```bash
# Start Redis

$ sudo service redis-server start
```

* * *

##MUST READ!!!

Before stop the bot, if you don't want to loose your redis datas (read: statistics and moderation), you have to perform a background saves.

There are three ways to do this: use `/stop` command to stop the bot (datas will be saved automatically), use `/redis save` command to save datas (and then stop the bot), or open a terminal window and run `redis-cli bgsave` (and then stop the bot).

Please remember to do one of this easy things in order to avoid to loose important informations.

I wrote this here cause is always better to say this stuffs before start the bot for the first time. Now you have been warned!

* * *

##Start the process

To start the bot, run `./launch.sh`. To stop the bot, press Ctrl+c twice.

You may also start the bot with `lua bot.lua`, but then it will not restart automatically.

* * *

Interactions with the Telegram bot API are straightforward. Every function is named the same as the API method it utilies (plus some shortcuts). The order of expected arguments is laid out in bindings.lua.

* * *

Several functions and methods used by multiple plugins and possibly the main script are kept in utilities.lua. Refer to that file for documentation.

Group Butler uses dkjson, a pure-Lua JSON parser. This is provided with the code and does not need to be downloaded or installed separately.

Strings are in languages.lua, admin commands are not trasnlated.

* * *

##Short general FAQs

*Q*: Why Lua?

*A*: I like Lua. It's an easy, poweful and fun language, and most important, one of the few languages I know. So why something else? :)

*Q*: Why Otouto?

*A*: Lazy + noob it's a magic combo. I could have tried to made the loop by myself, but 100% it would have been a crap compared to otouto polling and msgs processing loop. It was already there, why not?

* * *

##Contributors
Everybody is free to contribute to otouto and to Group Butler.

The official [Group Butler](http://github.com/groupbutler_bot).

##Credits
Topkecleon, for the original otouto

Iman Daneshi and Tiago Danin, because I like to take a look to Jack sometimes :^). Same for Yago Pérez and his telegram-bot

Lucas Montuano, for helping me a lot in the debugging of the bot

All the people who reported bugs and suggested new stuffs

Le Laide

##Final

I hate when I break a plugin main function with a return. I have to change all, one day or another
