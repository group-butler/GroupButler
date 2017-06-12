local bot = ngx.shared.bot

local function bot_init(url, max_connections, allowed_updates)
	api.setWebhook(url, max_connections, allowed_updates)

	-- Warn the admin the bot has started
	local temp = os.date("*t")
	temp["plugins"] = #plugins
	api.sendAdmin(i18n('bot_started',temp), 'Markdown')

	-- Store bot properties on a shared dictonary
	local res = api.getMe().result
	bot:set('username', res.username)
	bot:set('id', res.id)
	bot:set('first_name', res.first_name)
end

local started = bot:get('started')
if not started then
	bot:set('started', true)
	local ok, err = ngx.timer.at(0, bot_init, config.url, config.max_connections, config.allowed_updates)
	if not ok then
		ngx.log(ngx.ERR, "failed to create timer: ", err)
		return
	end
end
