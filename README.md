#Group Butler
##MUST READ!

So, telegram added to the api methods some utils to allow bots to handle the group administration. The only two methods available are kickChatUser and unbanChatUser, that togheter allow us to kick and ban users with a telegram bot.

I've added some interesting abilities based on this two api methods to this bot, obviously, because it's aimed to help the group administration.

ANYWAY, WE STILL DON'T KNOW IF THE BOT COULD SEE IF A USER IS ADMIN OR NOT IN A GROUP. So for now, all the functions/plugins based on this two methods don't implement a check to filter admins from normal users.

We will be able to know how to handle this with future updates.

What have been added: ban/kick by reply, antiflood based on redis(with custom kick/ban), ban/kick when a certain media is sent, ban when the max number of warns is reached.

THE CODE SHOULD BE 95% WORKING, I tried to be fast but the code must for sure be refined, cause there are random redis hashes everywhere and empty tables here and there, and other awuful things you can see.

If you find a bug, please let me know.

Thanks a lot to Lucas Montuano for the support with languages and bugfixing

##Introduction

This bot has been created to help people in the administration of a group.

This bot is based on Otouto (Telegram bot: [@mokubot](https://telegram.me/mokubot), github page: [topkecleon/otouto](https://github.com/topkecleon/otouto).).

Otouto and Group Butler are licensed under the GNU General Public License. A copy of the license has been included in [LICENSE](https://github.com/topkecleon/otouto/blob/master/LICENSE).

##What is it?
Group Butler is a Telegram API bot written in Lua. It has been created to help the members of a group to keep it clean and regulated, from the point of view of administrators and normal users.

This bot takes its structure from Otouto: it's plugin-based. This makes easier to manage each function and command of the bot, and allows to split the different capabilities of it in different files for a more specific vision of what it should do.

* * *

##Plugins
Here is the list of commands.

| Command | Function | Privilege |
|---------|----------|-----------|
| /ping | Shows if the bot is running. | All |
| /lang | Show the vailable languages | Moderator |
| /lang <code> | Change the bot language | Moderator |
| /owner (by reply) | Set a new owner. | Owner |
| /promote (by reply) | Promote as moderator a member. | Owner |
| /demote (by reply) | Demote a member. | Owner |
| /kick (by reply) | Kick an user (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /ban (by reply) | Ban an user (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /kicked list | Show a list of kicked users (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /set rules <rules> | Write the new rules and overwrite the old. | Moderator |
| /add rules <rules> | Add at the end of the existing rules other text. | Moderator |
| /set about <bio> | Set a completly new description for the group. | Moderator |
| /add about <bio> | Add at the end of the existing description other informations. | Moderator |
| /flood <on/off> | Enable or disable the flood listener (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /flood <kick/ban> | Choose what to do when the antiflood is triggered  (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /flood <messages> | Number of messages in 5 sec to trigger the antiflood (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /kick/ban/allow <media> | Set what to do when the media is sent (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /media | See the current settings of what to do when a media is sent (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /disable <rules-about-modlist> | This commands will be available only for moderators. | Moderator |
| /enable <rules-about-modlist> | This commands will be available only for everyone. | Moderator |
| /enable <welcome-flag> | Turn on the welcome message/the ability to flag messages. | Moderator |
| /disable <welcome-flag> | Turn off the welcome message/the ability to flag messages. | Moderator |
| /setlink <link> | Save the group link, so mods can recall it. | Owner |
| /link | Get the group link. | Moderator |
| /setpoll <description> <link> | Save the link to a [pollbot](http://telegram.me/pollbot) poll. | Moderator |
| /poll | Get the poll link. | Moderator |
| /extra <#command> <text> | Set up a new custom command | Moderator |
| /extra list | Show the list of custom commands | Moderator |
| /extra del <#command> | Delete the custom command | Moderator |
| /warn <kick/ban> | Choose what to do when the max number is reached (WAITING FOR TELEGRAM UPDATE). | Moderator |
| /warn (by reply) | Warn an user (+1 to the user warns). | Moderator |
| /warnmax | Set the max number of warns a user can get. | Moderator |
| /getwarns (by reply) | See how many worns the user has. | Moderator |
| /nowarns (by reply) | Reset the number of warns of an user. | Moderator |
| /flag (by reply) | The message will be reported to moderators. | All |
| /flag block (by reply) | The user won't be able to report messages. | Moderator |
| /flag free (by reply) | The user will be able to report messages. | Moderator |
| /flag list | Show the list of users who can\'t flag messages. | Moderator |
| /welcome <no-r-a-ra-ma-rm-rma> | How the welcome message is composed. | Moderator |
| /rules | Show the group rules. | All |
| /about | Show the group description. | All |
| /modlist | Show the moderators of the group. | All |
| /settings | Show the group settings. | Moderator |
| /tell | Show your basical info or the info about the user you replied to. | All |
| /c <feedback> | Send a feedback/report a bug/ask a question to my creator. | All |
| /help | I really have to explain this? | All |
| /info | Show credits | All |
| /ping redis | Shows if redis is running. | Admin |
| /backup | Send to the admin a backup of the bot folder. | Admin |
| /bc <text> | Broadcast to users. | Admin |
| /bcg <text> | Broadcast to groups. | Admin |
| /get stats | Show statistics about the bot. | Admin |
| /get commands | Show statistics about commands used. | Admin |
| /reply <reply> | Reply to a feedback message. | Admin |
| /reload | Reloads all plugins, libraries, and configuration files. | Admin |
| /redis save | Save your redis database. | Admin |
| /moderation backup | Save your redis datas into a json file. | Admin |
| /halt | Stops the bot. If the bot was run with launch.sh, this will restart it. | Admin |
| /hash <hash> | Get the info stored under that hash. | Admin |
| /shell <command> | Runs a shell command and returns the output. Use with caution. | Admin |
| /lua <command> | Runs a string a Lua code and returns the output, if applicable. Use with caution. otouto does not use a sandbox. | Admin |


* * *

##Setup
You **must** have Lua (5.2+), LuaSocket, LuaSec and Redis-Lua installed.

How to install LuaRocks and set-up the modules:
```bash
# Download and install LuaSocket, LuaSec adn Redis-Lua

$ wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
$ tar zxpf luarocks-2.2.2.tar.gz
$ cd luarocks-2.2.2
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasocket
$ sudo luarocks install luasec
$ sudo luarocks install redis-lua
$ cd ..
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
> • Set admin as your Telegram ID.

Before start the bot, you have to start Redis. Open a new window and type:
```bash
# Start Redis

$ redis-server

# Don't close the window!
```

* * *

##MUST READ!!!

Before stop the bot, if you don't want to loose your redis datas (read: statistics and moderation), you have to perform a background saves.

There are three ways to do this: use `/halt` command to stop the bot (datas will be saved automatically), use `/redis save` command to save datas (and then stop the bot), or open a terminal window and run `redis-cli bgsave` (and then stop the bot).

Please remember to do one of this easy things in order to avoid to loose important informations.

I wrote this here cause is always better to say this stuffs before start the bot for the first time. Now you have been warned!

* * *

##Set a time offset and start the process

You may also want to set your time_offset (a positive or negative number, in seconds, representing your computer's difference from UTC).

To start the bot, run `./launch.sh`. To stop the bot, press Ctrl+c twice.

You may also start the bot with `lua bot.lua`, but then it will not restart automatically.

* * *

Interactions with the Telegram bot API are straightforward. Every function is named the same as the API method it utilizes. The order of expected arguments is laid out in bindings.lua.

There are three functions which are not API methods: sendRequest, curlRequest, and sendReply. The first two are used by the other functions. sendReply is used directly. It expects the "msg" table as its first argument, and a string of text as its second. It will send a reply without image preview to the initial message.

* * *

Several functions and methods used by multiple plugins and possibly the main script are kept in utilities.lua. Refer to that file for documentation.

Group Butler uses dkjson, a pure-Lua JSON parser. This is provided with the code and does not need to be downloaded or installed separately.

* * *

##Short general FAQs

*Q*: Why Lua?
*A*: I like Lua. It's an easy, poweful and fun language, and most important, one of the few languages I know. So why something else? :)

*Q*: Why Otouto?
*A*: In my opinion, Otouto has a really good plugins structure, and considering the amount if commands I've planned for Group Butler, I thought that its structure is perfect and fits my needs better than everything else. Using it means save a lot of time trying to do it by myself.
Bindings are ok and easy to understand for everyone, I like how the bot run, but I've edited some lines aswell. For example, I don't like how triggers match the text, so I've switched to something more familiar. And other secondary modifications here and there, take a look to the commits for further informations.

* * *

##Contributors
Everybody is free to contribute to otouto and to Group Butler.

The creator and maintainer of otouto is [topkecleon](http://github.com/topkecleon). He can be contacted via [Telegram](http://telegram.me/topkecleon), [Twitter](http://twitter.com/topkecleon), or [email](mailto:topkecleon@outlook.com).

The kanger who created Group Butler is [RememberTheAir](http://github.com/RememberTheAir). You can contact him via [Telegram](http://telegram.me/Rlotar).

The official [Group Butler](http://github.com/groupbutler_bot). Yes, if you are wondering, is off.