#!/usr/bin/env lua

package.path="./lua/?.lua;./lua/vendor/?.lua;"..package.path
io.stdout:setvbuf "no" -- switch off buffering for stdout

ngx = { -- luacheck: ignore 121
	ctx = {}
}

local plugins = require "groupbutler.plugins"
local main = require "groupbutler.main"
local config = require "groupbutler.config"
local log = require "groupbutler.logging"
local methods = require "telegram-bot-api.methods"
local api = methods:new(config.telegram.token)

local bot = api:getMe()
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

api:getUpdates(nil, 1, 3600, config.telegram.allowed_updates) -- First update

local function process_update()
	local ok, err = api:getUpdates(last_update+1) -- Get the latest updates
	if not ok then
		log.error("Connection error: {description}", err)
		return
	end
	-- clocktime_last_update = os.clock()
	for i=1, #ok do -- Go through every new message.
		last_update = ok[i].update_id
		--print(last_update)
		current.h = current.h + 1
		local update_obj = main:new(ok[i])
		if not update_obj then
			log.error("update parser init failed")
		end
		update_obj:process()
	end
end

local function do_cron()
	if last_cron ~= os.date('%H') then -- Run cron jobs every hour.
		last_cron = os.date('%H')
		bot.last.h = current.h
		current.h = 0
		log.info("Cron...")
		for i=1, #plugins do
			if plugins[i].cron then -- Call each plugin's cron function, if it has one.
				plugins[i].cron()
			end
		end
	end
end

while true do -- Start a loop while the bot should be running.
	ngx.ctx = {}
	do
		local ok, err = pcall(process_update)
		if not ok then
			log.error("An #error occurred (process_update).\n{err}", {err = err})
		end
	end
	do
		local ok, err = pcall(do_cron)
		if not ok then
			log.error("An #error occurred (cron).\n{err}", {err = err})
		end
	end
end
