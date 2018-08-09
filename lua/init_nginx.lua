local config = require "groupbutler.config"
local api = require "telegram-bot-api.methods".init(config.telegram.token)

local _M = {}

function _M.set_webhook()
	print("ok")
	if not config.telegram.webhook.url and not config.telegram.webhook.domain then
		ngx.log(ngx.WARN, "No webhook config detected. Check your config or set the webhook by yourself.")
		return
	end
	print("ok")

	local body = {
		certificate = config.telegram.webhook.certificate,
		max_connections = config.telegram.webhook.max_connections,
	}

	if config.telegram.webhook.url then
		ngx.log(ngx.INFO, "Using manual webhook setup. Token check will be disabled.")
		body.url = config.telegram.webhook.url
		api.set_webhook(body)
		return
	end

	ngx.log(ngx.INFO, "Using express webhook setup.")
	body.url = "https://"..config.telegram.webhook.domain.."/?token="..config.telegram.token
	api.set_webhook(body)
	return
end

return _M
