#Group Butler

##Introduction

This bot has been created to help people in the administration of a group, with a lot of useful tools.

This bot born as an [Otouto](https://github.com/topkecleon/otouto) [v3.1](https://github.com/topkecleon/otouto/tree/26c1299374af130bbf8457af904cb4ea450caa51) ([@mokubot](https://telegram.me/mokubot)), but has been turned in an administration bot.

##What is it?
Group Butler is a Telegram API bot written in Lua. It has been created to help the members of a group to keep it clean and regulated, from the point of view of administrators and normal users.

This bot takes its long-polling loop and its structure from Otouto 3.1 and it's plugin-based. This makes easier to manage each function and command of the bot, and allows to split the different capabilities of it in different files for a more specific vision of what it should do.

Follow the [channel](https://telegram.me/groupbutler_ch) if you want to be updated about new changes. The official bot is [@GroupButler_bot](http://github.com/groupbutler_bot).

* * *

##Setup
You **must** have Lua (5.2+) installed, plus some modules: LuaSocket, LuaSec, Redis-Lua, Lua term and Lua serpent. And, to upload files, you need Curl installed too.

How to install LuaRocks and set-up the modules:

```bash
# Download and install LuaSocket, LuaSec, Redis-Lua, Lua-term and serpent

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

> • Make sure that privacy is disabled (more info in the [official Bots FAQ page](https://core.telegram.org/bots/faq#what-messages-will-my-bot-get)). Write `/setprivacy` to [BotFather](http://telegram.me/BotFather) to check the current setting.

**Before you do anything, open config.lua in a text editor and make the following changes:**

> • Set bot_api_key to the authentication token you received from the [BotFather](http://telegram.me/BotFather).
>
> • Set admin as your Telegram ID (under `admin.owner` field). You can set up a log group where error messages will be sent: this allows to split errors from user feedbacks. Replace the current id with the id of your designed group, otherwise remove it.
>
> • Set your bot channel (if you have one) in config.lua, under `channel` field. You should add the bot to the channel admins, if you want to post something through it.
>
> • If it asks for the sudo password during the installation or after, insert it.

Before start the bot, you have to start Redis. Open a new window and type:
```bash
# Start Redis

$ sudo service redis-server start
```

* * *

##MUST READ!!!

Before stop the bot, if you don't want to loose your redis datas, you have to perform a save.

There are three ways to do this: use `/astop` command to stop the bot (datas will be saved automatically), use `/asave` command to save datas (and then stop the bot), or open a terminal window and run `redis-cli bgsave` or `redis-cli save` (and then stop the bot).

Please remember to do one of this easy things in order to avoid to loose important informations.

You may want to perform a save each minute, for this you need to change the boolean value of the `cron` function in `plugins/admin.lua` from `false` to `cron` (or the name of the cron function).

In this way, a cron job will run every minute and will perform a redis background save.

* * *

##Start the process

To start the bot, run `./launch.sh`. To stop the bot, press Ctrl+c twice.

You may also start the bot with `lua bot.lua`, but then it will not restart automatically.

* * *

Everyone who will try to reach me via Telegram will be instantly blocked. I'm sorry but I won't give any kind of tecnical support, bacause of four reasons: I'm a noob, I have few time, the bot is very easy to install and lua is a very friendly programming language.

There is a ton of great Telegram groups about bot developing, just find one and ask your question there. I could be a member and reply to you, or more probably someone who knows the answer better than me will reply.

At this point, trying to contact me = haven't read the whole readme, and this is a valid motivation to ignore the message.

* * *

##Credits

Topkecleon, for the original otouto

Iman Daneshi and Tiago Danin, because I like to take a look to Jack sometimes :^). Same for Yago Pérez and his telegram-bot

Lucas Montuano, for helping me a lot in the debugging of the bot

All the people who reported bugs and suggested new stuffs

Le Laide
