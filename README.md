#Group Butler

##Short introduction

This bot has been created to help people in the administration of a group, with a lot of useful tools.

This bot born as an [Otouto](https://github.com/topkecleon/otouto) [v3.1](https://github.com/topkecleon/otouto/tree/26c1299374af130bbf8457af904cb4ea450caa51) ([@mokubot](https://telegram.me/mokubot)), but has been turned in an administration bot.

Follow the [channel](https://telegram.me/groupbutler_ch) if you want to be updated about new changes. The official bot is [@GroupButler_bot](http://github.com/groupbutler_bot).

* * *

##Setup
List of required packages:
- _libreadline-dev_
- _redis-server_
- _lua5.2_
- _liblua5.2dev_
- _libssl-dev_
- _git_
- _make_
- _unzip_
- _curl_

You will need some Lua modules that can be installed via the Lua package manager LuaRocks

**Installation**
```bash
# Tested on Ubuntu 14.04, Ubuntu 15.04, Debian 7, Linux Mint 17.2

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install libreadline-dev libssl-dev lua5.2 liblua5.2-dev git make unzip redis-server curl

# We are going now to install LuaRocks and the required Lua modules

$ wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
$ tar zxpf luarocks-2.2.2.tar.gz
$ cd luarocks-2.2.2
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasocket
$ sudo luarocks install luasec
$ sudo luarocks install redis-lua
$ sudo luarocks install lua-term
$ sudo luarocks install serpent
$ sudo luarocks install dkjson
$ cd ..

# Clone the repository and give the permissions to start the launch script

$ git clone https://github.com/RememberTheAir/GroupButler.git
$ cd GroupButler
$ sudo chmod 777 launch.sh
```

Other things to check before run the bot:

**First of all, take a look to your bot settings:**

> • Make sure that privacy is disabled (more info in the [official Bots FAQ page](https://core.telegram.org/bots/faq#what-messages-will-my-bot-get)). Write `/setprivacy` to [BotFather](http://telegram.me/BotFather) to check the current setting.

**Before you do anything, open config.lua in a text editor and make the following changes:**

> • Set `bot_api_key` to the authentication token you received from the [BotFather](http://telegram.me/BotFather).
>
> • Add your Telegram ID the `superadmins` table. Other superadmins can be added. IDs must be a number, and not a string.

Before start the bot, you have to start the Redis process.
```bash
# Start Redis

$ sudo service redis-server start
```

* * *

##MUST READ!!!

Before stop the bot, if you don't want to loose your redis datas, you have to perform a save.

There are three ways to do this: use `$stop` command to stop the bot (datas will be saved automatically), use `$save` command to save datas (and then stop the bot), or open a terminal and run `redis-cli bgsave` or `redis-cli save` (and then stop the bot).

Please remember to do one of this easy things in order to avoid to loose important informations.

You may want to perform a save each minute, for this you need to change the boolean value of the `cron` function in `plugins/admin.lua` from `false` to `cron` (or the name of the cron function).

In this way, a cron job will run every minute and will perform a redis background save.

* * *

##Start the process

To start the bot, run `./launch.sh`. To stop the bot, press Ctrl+c twice.

You may also start the bot with `lua bot.lua`, but then it will not restart automatically.

* * *
##Something that you should known before run the bot

  * You can change some settings of the bot. All the settings are placed in `config.lua`, in the `bot_settings` table
    * `cache_time.adminlist`: the permanence in seconds of the adminlist in the cache. The bot caches the adminlist to avoid to hit Telegram limits
    * `testing_mode`: set it to `false` if you want the bot to ignore testing plugins. A plugin is a test plugin when the `test` key in the returned table is not a `nil` value or a `false` boolean value
    * `multipurpose_mode`: set it to `true` if you want to load the plugins placed in `plugins/multipurpose` folder. At the moment, this directory is empty
    * `notify_bug`: if `true`, the bot will send a message that notifies that a bug has occured to the current user, when a plugin is executed and an error happens
    * `log_api_errors`: if `true`, the bot will send in the `log_chat` (`config.lua`) all the relevant errors returned by an api request toward Telegram
    * `stream_commands`: if `true`, when an update triggers a plugin, the match will be printed on the console
  * There are some other useful fields that can be filled in `config.lua`
    * `log.chat`: if `log_api_errors` is set on `true`, this must be the chat id where the bot will log the errors. If `nil` or empty, they will be sent directly to the bot owner
    * `log.admin`: this must be the id of the admin that will receive the errors that happen during the execution of the bot
    * `channel`: a channel where you can post something through the bot. Must be an username, `@` included. To post something, the bot must be admin of the channel. Use `$post [text]` to post a message
    * `db`: the selected Redis database (if you are running Redis with the default config, the available databases are 16). The database will be selected on each start/reload. Default: 2
  * Other things that may be useful
    * Admin commands start for `$`. They are not documented, look at the triggers of `plugins/admin.lua` plugin for the whole list
    * If the `action` function of a plugin returns `true`, the bot will continue to try to match the message text with the missing triggers of the `plugins` table
    * You can send yourself a backup of the zipped bot folder with the `$backup` command
    * The Telegram Bot API has some undocumented "weird behaviours" that you may notice while using this bot
       * In supergroups, the `kickChatMember` method returns always a positive response if the `user_id` has been part of the group at least once, it doesn't matter if the user is not in the group when you use this method
       * In supergroups, the `unbanChatMember` method returns always a positive response if the `user_id` has been part of the group at least once, it doesn't matter if the user is not in the group or is not in the group blacklist
       * Users kicked by the bot can join again a group from where they've been kicked out only if not banned and only via invite link. An admin can't add them back

* * *
##Some notes about the database

*Everything* is stored on Redis, and the faster way to edit your database is the [Redis command line interface](http://redis.io/topics/rediscli).

You can find a backup of your Redis database under `/etc/redis/dump.rdb`. The name of this file and the frequency of the saves depend on your redis configuration file.

* * *

## Translators
If you want to help translate the bot, follow below instructions. Group Butler
partially uses some tools from [gettext](https://www.gnu.org/software/gettext/).
However we don't use binary format `*.mo` for the sake of simplicity. The bot
manually parses the files `*.po` in directory `locales`.

If you want to improve exsist translation, run this command in the root
directoy with the bot: `./launch.sh update-locale <name>` where &lt;name&gt;
is two letters of your chosen locale. Further edit the file
`locales/<name>.po`, make sure that the translation is done correctly and send
us your translation.

We recommend [Poedit](https://poedit.net/) as editor of `*.po` files. You must
specify information about yourself in the settings; put your link to Telegram
account in the field Email if you have it.

If you want to create new locale, run `./launch.sh create-locale <name>`. This
command create the file `locales/<name>.po` with untranslated strings. You can
also use Poedit to translate the bot. List of avaible locales see in [gettext
manual](https://www.gnu.org/software/gettext/manual/gettext.html#Language-Codes).
After add your new locale in the file `config.lua`.

* * *

###Notes about this repository

Note that this bot is not opensource because I want everyone to be able to clone it and run its own copy. It's opensource because everyone can take a look on how the bot works, see which data are stored, and decide if the bot is worth to be a group admin. There are some installation intructions just because why not.

* * *

Please don't contact me via Telegram asking for help in the installation or about errors in your clone (I like to spamreport people). Contact me only if you find a bug or have a suggestion. I don't give any support in the installation or development of your own instance of the bot.
Basicly because I'm a stupid noob that only knows the basics of Lua scripting, and I don't like to spend my free time in front of a monitor. I try to keep the time I waste on this project to a minimum.

If you are going to open a pull request, keep in mind that I don't know how to use GitHub well. I may overwrite commits and stuffs like that, this already happened. It's not because I'm bad, it's just because I'm an idiot.

* * *

##Credits

Topkecleon, for the original [otouto](https://github.com/topkecleon/otouto)

Iman Daneshi and Tiago Danin, for [Jack-telegram-bot](https://github.com/Imandaneshi/jack-telegram-bot)

Yago Pérez for his [telegram-bot](https://github.com/yagop/telegram-bot)

The [Werewolf](https://github.com/parabola949/Werewolf) guys, for aiding the spread of the bot

Lucas Montuano, for helping me a lot in the debugging of the bot

All the people who reported bugs and suggested new stuffs

Le Laide
