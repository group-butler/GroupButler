# Group Butler

## Short introduction

This bot has been created to help people administrate their groups, and includes many useful tools.

Group Butler was born as an [otouto](https://otou.to) [v3.1](https://github.com/topkecleon/otouto/tree/26c1299374af130bbf8457af904cb4ea450caa51) ([`@mokubot`](https://telegram.me/mokubot)), but it has been turned into an administration bot.

#### Group Butler on Telegram:

- [`@GroupButler_bot`](https://telegram.me/GroupButler_Bot)
	- **_branch_**: `production`
	- **_channel_**: [`@GroupButler_ch`](https://telegram.me/groupbutler_ch).

- [`@GBReborn_bot`](https://telegram.me/GBReborn_bot)
	- **_branch_**: `staging`
	- **_channel_**: [`@GroupButler_beta`](https://telegram.me/GroupButler_beta).

* * *

## Setup

**First of all, take a look at your bot settings**

> * Make sure privacy is disabled (more info can be found by heading to the [official Bots FAQ page](https://core.telegram.org/bots/faq#what-messages-will-my-bot-get)). Send `/setprivacy` to [@BotFather](http://telegram.me/BotFather) to check the current status of this setting.

**Create a plain text file named `.env` with the following:**

> * Set `TG_TOKEN` to the authentication token that you received from [`@BotFather`](http://telegram.me/BotFather).
>
> * Set `SUPERADMINS` as a JSON array containing your numerical Telegram ID. Other superadmins can be added too. It is important that you insert the numerical ID and NOT a string.
>
> * Set `LOG_CHAT` (the ID of the chat where the bot will send all the bad requests received from Telegram) and your `LOG_ADMIN` (the ID of the user that will receive execution errors).

Your `.env` file should now look somewhat like this:

```
TG_TOKEN=123456789:ABCDefGhw3gUmZOq36-D_46_AMwGBsfefbcQ
SUPERADMINS=[12345678]
LOG_CHAT=12345678
LOG_ADMIN=12345678
```


## Setup (using Docker)
Requirements:

- docker 17.06.0-ce
- docker-compose 1.14.0
- Optional: Docker Swarm cluster for deployment
- Optional: GitLab repository for CI/CD

### Running (dev mode)
Run `docker-compose up`. Docker will pull and build the required images, so the first time you run this command should take a little while. After that, the bot should be up and running.

Code is mounted on the bot container, so you can make changes and restart the bot as you normally would. There’s no need to use `docker-compose up --build` or `docker-compose build` unless you changed something on `Dockerfile`.

Redis default port is mounted to host, just in case you want to debug something using tools available at the host.

**The redis container is set to not persist data while in dev mode**.

### Running (production mode)
There’s a number of ways you can use docker for deploying into production.

Files named `docker-compose.*.yml` are gitignored, just in case you feel the need to override `docker-compose.yml` or write something else entirely. `docker-compose.override.yml` is used to store dev mode overrides since it’s read by default by docker-compose.

The bot also supports reading Docker Secrets (may work with other vaults too). Check `lua/config.lua` to see which variables can be read from secrets.

#### Compose Example
You would need to write another override file (i.e. `docker-compose.deploy.yml`) matching your needs (change restart policy to always, either add groupbutler to an external network or create a redis service with persistency, etc.).

You could deploy Group Butler by running something like this:

`docker-compose -f docker-compose.yml -f docker-compose.deploy.yml up`

#### Swarm Example
Assuming you have deployed redis into `staging` (`docker stack deploy …` or `docker service create …`) and exported the required environment variables (like `$TG_TOKEN`…), you could deploy Group Butler by running:

`docker stack deploy staging -c docker-compose.yml`

#### GitLab CI Example (uses swarm)
- Clone this repo to a GitLab server (could be gitlab.com or self hosted)
- Set Project Variables, paying attention to variable scope: the `.gitlab-ci.yml` bundled with this repo supports two environments: `staging` and `production`
- Disable shared runners and install GitLab CI runner on at least one of the manager nodes. Make sure to tag them as `manager` too
- Deploy (manually or using another repository) redis to `staging` and/or `production`
- Push to `staging` and/or `production` branches
- If everything went well, your very own Group Butler should be up and running

## Setup (without using Docker)
List of required packages:
- `libreadline-dev`
- `redis-server`
- `lua5.1`
- `liblua5.1dev`
- `libssl-dev`
- `git`
- `make`
- `unzip`
- `curl`
- `libcurl4-gnutls-dev`

You will need some other Lua modules too, which can be (and should be) installed through the Lua package manager LuaRocks.

**Installation**

You can easily install Group Butler by running the following commands:

```bash
# Tested on Ubuntu 16.04

$ wget https://raw.githubusercontent.com/RememberTheAir/GroupButler/master/install.sh
$ bash install.sh
```

or

```bash
# Tested on Ubuntu 14.04, 15.04 and 16.04, Debian 7, Linux Mint 17.2

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install libreadline-dev libssl-dev lua5.1 liblua5.1-dev git make unzip redis-server curl libcurl4-gnutls-dev

# We are going now to install LuaRocks and the required Lua modules

$ wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
$ tar zxpf luarocks-2.2.2.tar.gz
$ cd luarocks-2.2.2
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasec
$ sudo luarocks install luasocket
$ sudo luarocks install redis-lua
$ sudo luarocks install lua-term
$ sudo luarocks install serpent
$ sudo luarocks install lua-cjson
$ sudo luarocks install Lua-cURL
$ cd ..

# Clone the repository and give the launch script permissions to be executed
# If you want to clone the beta branch, use git clone with the [-b beta] option

$ git clone https://github.com/RememberTheAir/GroupButler.git
$ cd GroupButler
$ sudo chmod +x launch.sh
```

Before you start the bot, you have to start the Redis process.

```bash
# Start Redis

$ sudo service redis-server start
```

## Starting the process

To start the bot, run `./launch.sh`. To stop the bot, press Control <kbd>CTRL</kbd>+<kbd>C</kbd> twice.

You may also start the bot with `./polling.lua`, however it will not restart automatically. You will also need to find another way to export the required environment variables.

* * *
## Something that you should known before run the bot

* You can change some settings of the bot. All the settings are placed in `config.lua`, in the `bot_settings` table
	* `cache_time.adminlist`: the permanence in seconds of the adminlist in the cache. The bot caches the adminlist to avoid to hit Telegram limits
	* `notify_bug`: if `true`, the bot will send a message that notifies that a bug has occurred to the current user, when a plugin is executed and an error happens
	* `log_api_errors`: if `true`, the bot will send in the `LOG_CHAT` all the relevant errors returned by an api request toward Telegram
	* `stream_commands`: if `true`, when an update triggers a plugin, the match will be printed on the console
* There are some other useful fields that can be added to .env you can find in `config.lua`, for instance
	* `REDIS_DB`: the selected Redis database (if you are running Redis with the default config, the available databases are 16). The database will be selected on each start/reload. Default: 0
* Other things that may be useful
	* Administrators commands start for `$`. They are not documented, look at the triggers of `plugins/admin.lua` plugin for the whole list
	* If the main function of a plugin returns `true`, the bot will continue to try to match the message text with the missing triggers of the `plugins` table
	* You can send yourself a backup of the zipped bot folder with the `$backup` command
	* The Telegram Bot API has some undocumented "weird behaviours" that you may notice while using this bot
		* In supergroups, the `kickChatMember` method returns always a positive response if the `user_id` has been part of the group at least once, it doesn't matter if the user is not in the group when you use this method
		* In supergroups, the `unbanChatMember` method returns always a positive response if the `user_id` has been part of the group at least once, it doesn't matter if the user is not in the group or is not in the group blacklist


## Some notes about the database

*Everything* is stored on Redis, and the fastest way to edit your database is via the [Redis CLI](http://redis.io/topics/rediscli).

You can find a backup of your Redis database in `/etc/redis/dump.rdb`. The name of this file and the frequency of saves are dependent on your redis configuration file.

* * *

## Translators
If you want to help translate the bot, follow the instructions below. Parts of Group Butler use tools from [gettext](https://www.gnu.org/software/gettext/). However we don't use binary format `*.mo` for the sake of simplicity. The bot manually parses the `*.po` files in the `locales` directory.

If you want to improve an existing translation, run this command in the root directoy with the bot: `./launch.sh update-locale <name>` where &lt;name&gt; is two letters of your chosen locale. Further edit the file `locales/<name>.po`, make sure that the translation is done correctly and send your translation.

We recommend [Poedit](https://poedit.net/) as editor of `*.po` files. You must specify information about yourself in the settings; put the link to your Telegram account in the field Email if you have it.

If you want to create new locale, run `./launch.sh create-locale <name>`. This command creates the file `locales/<name>.po` with untranslated strings. You can also use Poedit to translate the bot. List of available locales see in [gettext manual](https://www.gnu.org/software/gettext/manual/gettext.html#Language-Codes).
After add your new locale in the file `config.lua`.

* * *

## Pull requests

If you are going to open a pull request, please use the [`beta` branch](https://github.com/RememberTheAir/GroupButler/tree/beta) as destination branch.

Pull requests in the `master` branch won't be considered, unless they are intended to solve a critical problem.

* * *

## Credits

[Topkecleon](https://github.com/topkecleon), for the original [otouto](https://github.com/topkecleon/otouto)

[Iman Daneshi](https://github.com/imandaneshi) and [Tiago Danin](https://github.com/TiagoDanin), for [Jack-telegram-bot](https://github.com/Imandaneshi/jack-telegram-bot)

[Cosmonawt](https://github.com/cosmonawt), for his [Lua library](https://github.com/cosmonawt/lua-telegram-bot) for the Bot API

[Yago Pérez](https://github.com/yagop) for his [telegram-bot](https://github.com/yagop/telegram-bot)

The [Werewolf](https://github.com/parabola949/Werewolf) guys, for aiding the spread of the bot

Lucas Montuano, for helping me a lot in the debugging of the bot

All the Admins of our [discussion groups](https://telegram.me/gbgroups) about Group Butler

All the people who reported bugs and suggested new stuff

Le Laide
