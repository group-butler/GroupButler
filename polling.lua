#!/usr/bin/env lua

-- local ZBS="/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio"
-- local LUA_PATH=ZBS.."/lualibs/?/?.lua;"..ZBS.."/lualibs/?.lua;"
-- local LUA_CPATH=ZBS.."/bin/?.dylib;"..ZBS.."/bin/clibs/?.dylib;"

-- package.path=LUA_PATH.."./lua/?.lua;./lua/vendor/?.lua;"..package.path
-- package.cpath=LUA_CPATH..package.cpath
-- require('mobdebug').start()

package.path="./lua/?.lua;./lua/vendor/?.lua;"..package.path
io.stdout:setvbuf "no" -- switch off buffering for stdout

local plugins = require "groupbutler.plugins"
local main = require "groupbutler.main"
local config = require "groupbutler.config"
local log = require "groupbutler.logging"
local api = require "telegram-bot-api.methods".init(config.telegram.token)

local bot = api.getMe()
local last_update, last_cron, current

function bot.init(on_reload) -- The function run when the bot is started or reloaded
	if on_reload then
		package.loaded.config = nil
		package.loaded.languages = nil
		package.loaded.utilities = nil
	end

	log.info('BOT RUNNING: [@{username}] [{first_name}] [{bot_id}]',
		{
			username = bot.username,
			first_name = bot.first_name,
			bot_id = ("%d"):format(bot.id),
		})

	last_update = last_update or -2 -- skip pending updates
	last_cron = last_cron or os.time() -- the time of the last cron job

	if on_reload then
		return #plugins
	else
		bot.start_timestamp = os.time()
		current = {h = 0}
		bot.last = {h = 0}
	end
end

bot.init()

api.getUpdates(nil, 1, 3600, config.telegram.allowed_updates) -- First update

while true do -- Start a loop while the bot should be running.
	local res = api.getUpdates(last_update+1) -- Get the latest updates
	if res then
		-- clocktime_last_update = os.clock()
		for i=1, #res do -- Go through every new message.
			last_update = res[i].update_id
			--print(last_update)
			current.h = current.h + 1
			local update_obj = main.new(res[i])
			if not update_obj then
				log.error("bot init failed")
			end
			update_obj:parseMessageFunction()
		end
	else
		log.error('Connection error')
	end
	if last_cron ~= os.date('%H') then -- Run cron jobs every hour.
		last_cron = os.date('%H')
		bot.last.h = current.h
		current.h = 0
		log.info('Cron...')
		for i=1, #plugins do
			if plugins[i].cron then -- Call each plugin's cron function, if it has one.
				local res2, err = pcall(plugins[i].cron)
				if not res2 then
					log.error('An #error occurred (cron).\n{err}', {err = err})
					return
				end
			end
		end
	end
end
