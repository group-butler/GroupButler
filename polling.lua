#!/usr/bin/env lua
package.path=package.path .. ';./lua/?.lua'

local api = require 'methods'
local clr = require 'term.colors'
local plugins = require 'plugins'
local main = require 'main'

bot = api.getMe().result
local last_update, last_cron, current

function bot.init(on_reload) -- The function run when the bot is started or reloaded
	if on_reload then
		package.loaded.config = nil
		package.loaded.languages = nil
		package.loaded.utilities = nil
	end

	print('\n'..clr.blue..'BOT RUNNING:'..clr.reset,
		clr.red..'[@'..bot.username .. '] [' .. bot.first_name ..'] ['..bot.id..']'..clr.reset..'\n')

	last_update = last_update or -2 -- skip pending updates
	last_cron = last_cron or os.time() -- the time of the last cron job

	if on_reload then
		return #plugins
	else
		api.sendAdmin('*Bot started!*\n_'..os.date('On %A, %d %B %Y\nAt %X')..'_\n'..#plugins..' plugins loaded', true)
		bot.start_timestamp = os.time()
		current = {h = 0}
		bot.last = {h = 0}
	end
end

bot.init()

api.firstUpdate()
while true do -- Start a loop while the bot should be running.
	local status, err = pcall(
	function ()
		local res = api.getUpdates(last_update+1) -- Get the latest updates
		if res then
			-- clocktime_last_update = os.clock()
			for i=1, #res.result do -- Go through every new message.
				last_update = res.result[i].update_id
				--print(last_update)
				current.h = current.h + 1
				processUpdate(res.result[i])
			end
		else
			print('Connection error')
		end
	end)
	if err then 
		print(err)
		api.sendLog(err)
		if err:match('interrupted') then return end
	end
	if last_cron ~= os.date('%H') then -- Run cron jobs every hour.
		last_cron = os.date('%H')
		-- last.h = current.h
		current.h = 0
		print(clr.yellow..'Cron...'..clr.reset)
		for i=1, #plugins do
			if plugins[i].cron then -- Call each plugin's cron function, if it has one.
				local res2, err = pcall(plugins[i].cron)
				if not res2 then
					api.sendLog('An #error occurred (cron).\n'..err)
					return
				end
			end
		end
	end
end
