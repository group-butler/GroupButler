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

Everyone who will try to reach me via Telegram will be instantly blocked. I'm sorry but I won't give any kind of tecnical support, bacause of four reasonss: I'm a noob, I have few time, the bot is very easy to install and lua is a very friendly programming language.

There is a ton of great Telegram groups about bot developing, just find one and make your question there. I could be a member and reply to you, or more probably someone who knows the answer better than me will reply.

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
