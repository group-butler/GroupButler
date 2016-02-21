#Group Butler
This bot has been created to help people in the administration of a group.

This bot is based on Otouto (Telegram bot: [@mokubot](https://telegram.me/mokubot), github page: [topkecleon/otouto](https://github.com/topkecleon/otouto).).

otouto and group butler are licensed under the GNU General Public License. A copy of the license has been included in [LICENSE](https://github.com/topkecleon/otouto/blob/master/LICENSE).

##What is it?
Group butler is a Telegram API bot written in Lua. It has been created to help the members of a group to keep it clean and regulated, from the point of view of administrators and normal users.

This bot takes its structure from otouto: it's plugin-based. This makes easier to manage each functions and commands of the bot, and allows to split the different capabilities of it in different files for a more specific vision of what it should do.

* * *

##Plugins
Here is the list of commands.

| Command | Function |
|---------|----------|
| /ping | Shows if the bot is running. |
| /owner (by reply) | Set a new owner. |
| /promote (by reply) | Promote as moderator a member. |
| /demote (by reply) | Demote a member. |
| /setrules <rules> | Write the new rules and overwrite the old. |
| /addrules <rules> | Add at the end of the existing rules other text. |
| /setabout <bio> | Set a completly new description for the group. |
| /addabout <bio> | Add at the end of the existing description other informations. |
| /disable <rules-about-modlist> | This commands will be available only for moderators. |
| /enable <rules-about-modlist> | Returns the summary of a Wikipedia article. |
| /enable <welcome-flag> | Turn on the welcome message/the ability to flag messages. |
| /disable <welcome-flag> | Turn off the welcome message/the ability to flag messages. |
| /flagblock | The user won't be able to report messages. |
| /flagfree | The user will be able to report messages. |
| /flaglist | Show the list of users who can\'t flag messages. |
| /welcome <no-r-a-ra-ma-rm-rma> | How the welcome message is composed. |
| /rules | Show the group rules. |
| /about | Show the group description. |
| /modlist | Show the moderators of the group. |
| /flagmsg (by reply) | Report the message to administrators. |
| /settings | Show the group settings. |
| /tell | Show your basical info or the info about the user you replied to. |
| /c <feedback> | Send a feedback/report a bug/ask a question to my creator. |
| /help | I really have to explain this? |
| /getstats | Show bot statistics. |
| /reload | Reloads all plugins, libraries, and configuration files. |
| /halt | Stops the bot. If the bot was run with launch.sh, this will restart it. |
| /shell <command> | Runs a shell command and returns the output. Use with caution. |
| /lua <command> | Runs a string a Lua code and returns the output, if applicable. Use with caution. otouto does not use a sandbox. |


* * *

##Setup
You **must** have Lua (5.2+), LuaSocket, and LuaSec installed.

How to install LuaRocks:
```bash
# Download and install LuaSocket and LuaSec

$ wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
$ tar zxpf luarocks-2.2.2.tar.gz
$ cd luarocks-2.2.2
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasocket
$ sudo luarocks install luasec
$ cd ..
```
Clone the github repository:
```bash
# Clone the repo

$ git clone https://github.com/RememberTheAir/GroupButler.git
$ cd GroupButler
```

**Before you do anything, open config.lua in a text editor and make the following changes:**

> • Make sure that privacy is disabled, otherwise the bot won't see replied messages unless they starts with '/'. Write `/setprivacy` to [BotFather](http://telegram.me/BotFather) to check the current setting.
>
> • Set bot_api_key to the authentication token you received from the [BotFather](http://telegram.me/BotFather).
>
> • Set admin as your Telegram ID.
>
> • Set your Yandex api key if you would like to set up translate plugin. (*soon*)

You may also want to set your time_offset (a positive or negative number, in seconds, representing your computer's difference from UTC).

To start the bot, run `./launch.sh`. To stop the bot, press Ctrl+c twice.

You may also start the bot with `lua bot.lua`, but then it will not restart automatically.

* * *

Interactions with the Telegram bot API are straightforward. Every function is named the same as the API method it utilizes. The order of expected arguments is laid out in bindings.lua.

There are three functions which are not API methods: sendRequest, curlRequest, and sendReply. The first two are used by the other functions. sendReply is used directly. It expects the "msg" table as its first argument, and a string of text as its second. It will send a reply without image preview to the initial message.

* * *

Several functions and methods used by multiple plugins and possibly the main script are kept in utilities.lua. Refer to that file for documentation.

Group butler uses dkjson, a pure-Lua JSON parser. This is provided with the code and does not need to be downloaded or installed separately.

* * *

##Contributors
Everybody is free to contribute to otouto and to group butler.

The creator and maintainer of otouto is [topkecleon](http://github.com/topkecleon). He can be contacted via [Telegram](http://telegram.me/topkecleon), [Twitter](http://twitter.com/topkecleon), or [email](mailto:topkecleon@outlook.com).

The kanger who created group butler is [RememberTheAir](http://github.com/RememberTheAir). You can contact him via [Telegram](http://telegram.me/Rlotar).

