#Group Butler

##Short introduction

This bot has been created to help people administrate their groups, and includes many useful tools.

This bot was born as an [otouto](otou.to) [v3.1](https://github.com/topkecleon/otouto/tree/26c1299374af130bbf8457af904cb4ea450caa51) ([@mokubot](https://telegram.me/mokubot)), but it has been turned into an administration bot.

Follow the [channel](https://telegram.me/groupbutler_ch), or the [beta channel](https://telegram.me/GroupButler_beta) if you want to be informed about new changes. The official (stable) bot is [@GroupButler_bot](https://telegram.me/GroupButler_Bot). The official beta bot is [@GBReborn_bot](https://telegram.me/GBReborn_bot).

* * *

##Setup
List of required packages:
- `libreadline-dev`
- `redis-server`
- `lua5.2`
- `liblua5.2dev`
- `libssl-dev`
- `git`
- `make`
- `unzip`
- `curl`
- `libcurl4-gnutls-dev`

You will need some other Lua modules too, which can be (and should be) installed through the Lua package manager LuaRocks.

**Installation**
```bash
# Tested on Ubuntu 14.04, Ubuntu 15.04, Debian 7, Linux Mint 17.2

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install libreadline-dev libssl-dev lua5.2 liblua5.2-dev git make unzip redis-server curl libcurl4-gnutls-dev

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
$ sudo luarocks install lanes
$ sudo luarocks install Lua-cURL
$ cd ..

# Clone the repository and give the launch script permissions to be executed

$ git clone https://github.com/RememberTheAir/GroupButler.git
$ cd GroupButler
$ sudo chmod 777 launch.sh
```

Other things to check before running the bot:

**First of all, take a look at your bot settings:**

> • Make sure privacy is disabled (more info can be found by heading to the [official Bots FAQ page](https://core.telegram.org/bots/faq#what-messages-will-my-bot-get)). Send `/setprivacy` to [@BotFather](http://telegram.me/BotFather) to check the current status of this setting.

**Before you do anything else, open config.lua (in a text editor) and make the following changes:**

> • Set `bot_api_key` to the authentication token that you received from [@BotFather](http://telegram.me/BotFather).
>
> • Insert your numerical Telegram ID into the `superadmins` table. Other superadmins can be added too. It is important that you insert the numerical ID and NOT a string.
>
> • Set your `log.chat` (the ID of the chat where the bot will send all the bad requests received from Telegram) and your `log.admin` (the ID of the user that will receive execution errors).

Before you start the bot, you have to start the Redis process.
```bash
# Start Redis

$ sudo service redis-server start
```

* * *

##Before you do anything, you MUST read THIS.!!!

Before you stop the bot, if you don't want to loose your redis data, you have to perform a save.

There are three ways of doing this: use `$stop` command to stop the bot (database will be saved automatically), use `$save` command to save database (and then stop the bot), or open a terminal and run `redis-cli bgsave` or `redis-cli save` (and then stop the bot).

Please remember to do one of this easy things in order to avoid to loose important informations.

You may want to perform a save each minute, for this you need to change the boolean value of the `cron` function in `plugins/admin.lua` from `false` to `cron` (or the name of the cron function).

This way, a cron job will run every minute and will perform a redis background save.

* * *

##Start the process

To start the bot, run `./launch.sh`. To stop the bot, press Control <kbd>CTRL</kbd>+<kbd>C</kbd> twice.

You may also start the bot with `lua bot.lua`, however it will not restart automatically.

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
    * `channel`: a channel where you can post something through the bot. Must be an username, `@` included. To post something, the bot must be administrator of the channel. Use `$post [text]` to post a message
    * `db`: the selected Redis database (if you are running Redis with the default config, the available databases are 16). The database will be selected on each start/reload. Default: 2
  * Other things that may be useful
    * Administrators commands start for `$`. They are not documented, look at the triggers of `plugins/admin.lua` plugin for the whole list
    * If the `action` function of a plugin returns `true`, the bot will continue to try to match the message text with the missing triggers of the `plugins` table
    * You can send yourself a backup of the zipped bot folder with the `$backup` command
    * The Telegram Bot API has some undocumented "weird behaviors" that you may notice while using this bot
       * In supergroups, the `kickChatMember` method returns always a positive response if the `user_id` has been part of the group at least once, it doesn't matter if the user is not in the group when you use this method
       * In supergroups, the `unbanChatMember` method returns always a positive response if the `user_id` has been part of the group at least once, it doesn't matter if the user is not in the group or is not in the group blacklist
       * Users kicked by the bot can join again a group from where they've been kicked out only if not banned and only via invite link. A administrator can't add them back

* * *
##Some notes about the database

*Everything* is stored on Redis, and the fastest way to edit your database is via the [Redis CLI](http://redis.io/topics/rediscli).

You can find a backup of your Redis database in `/etc/redis/dump.rdb`. The name of this file and the frequency of saves are dependent on your redis configuration file.

* * *

## Translators
If you want to help translate the bot, follow the instructions below. Parts of Group Butler use tools from [gettext](https://www.gnu.org/software/gettext/). However we don't use binary format `*.mo` for the sake of simplicity. The bot manually parses the `*.po` files in the `locales` directory.

If you want to improve an existing translation, run this command in the root
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

Note that this bot is not open source because I want everyone to be able to clone it and run its own copy. It's open source because everyone can take a look on how the bot works, see which data are stored, and decide if the bot is worth to be a group administrator. There are some installation instructions just because why not.

* * *

Please don't contact me via Telegram asking for help in the installation or about errors in your clone (I like to spam-report people). Contact me only if you find a bug or have a suggestion. I don't give any support in the installation or development of your own instance of the bot.
Basically because I'm a stupid noob that only knows the basics of Lua scripting, and I don't like to spend my free time in front of a monitor. I try to keep the time I waste on this project to a minimum.

If you are going to open a pull request, keep in mind that I don't know how to use GitHub well. I may overwrite commits and stuffs like that, this already happened. It's not because I'm bad, it's just because I'm an idiot.

* * *

##Credits

[Topkecleon](https://github.com/topkecleon), for the original [otouto](https://github.com/topkecleon/otouto)

[Iman Daneshi](https://github.com/imandaneshi) and [Tiago Danin](https://github.com/TiagoDanin), for [Jack-telegram-bot](https://github.com/Imandaneshi/jack-telegram-bot)

[Cosmonawt](https://github.com/cosmonawt), for his [Lua library](https://github.com/cosmonawt/lua-telegram-bot) for the Bot API

[Yago Pérez](https://github.com/yagop) for his [telegram-bot](https://github.com/yagop/telegram-bot)

The [Werewolf](https://github.com/parabola949/Werewolf) guys, for aiding the spread of the bot

Lucas Montuano, for helping me a lot in the debugging of the bot

All the Admins of our discussion groups about Group Butler

All the people who reported bugs and suggested new stuffs

Le Laide
