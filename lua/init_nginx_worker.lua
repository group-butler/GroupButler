require 'resty.core' -- Replaces Lua C API bindings with LuaJIT bindings
local info = ngx.shared.info
local started = info:get('started')

local function bot_init()
	local config = require 'config'
	local api = require ('telegram-bot-api.methods').init(config.telegram.token)
	if config.telegram.webhook.url then
		api.setWebhook(config.telegram.webhook.url, config.telegram.webhook.certificate,
		config.telegram.webhook.max_connections, config.telegram.allowed_updates)
	else
		ngx.log(ngx.INFO, 'No $TG_WEBHOOK_URL detected. You may not receive updates unless you set your webhook manually.')
	end
end

if not started then -- Run init code only once
	info:set('started', bot.start_timestamp)
	local ok, err = ngx.timer.at(0, bot_init)
	if not ok then
	   ngx.log(ngx.ERR, "failed to create timer: ", err)
	   return
	end
end

-- Cron code shall go here
