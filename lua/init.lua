redis = require 'resty.redis' -- Load redis client
pgmoon = require 'pgmoon' -- Load postgres client
json = require 'cjson' -- Load json library
http = require 'resty.http' -- Load resty http library
config = require 'config' -- Load configuration file
i18n = require 'i18n' -- Load localization library

i18n.loadFile('i18n/core.lua') -- Load core localization
i18n.setLocale(config.lang) -- Set core localization

for i,plugin in ipairs(config.plugins) do -- Load plugins localization
	i18n.loadFile('i18n/' .. plugin .. '.lua')
end

plugins = {} -- Load plugins.
for i,v in ipairs(config.plugins) do
	local p = require('plugins.'..v)
	package.loaded['plugins.'..v] = nil
	if p.triggers then
		for funct, trgs in pairs(p.triggers) do
			for i = 1, #trgs do
				-- interpret any whitespace character in commands just as space
				trgs[i] = trgs[i]:gsub(' ', '%%s+')
			end
			if not p[funct] then
				p.trgs[funct] = nil
				print(funct..' triggers ignored in '..v..': '..funct..' function not defined')
			end
		end
	end
	table.insert(plugins, p)
end

-- Since cosocket API is not available at the init context, I had to improvise...
local URL = require 'socket.url'
local BASE_URL = 'https://api.telegram.org/bot' .. config.bot_api_key

-- Set Webhook endpoint
local url = BASE_URL .. '/setWebhook?url=' .. config.url .. '&max_connections=' .. config.max_connections .. '&allowed_updates=' .. json.encode(config.allowed_updates)
os.execute('curl -s '..url..' > /dev/null')

-- Warns the admin the bot has successfully started
local temp = os.date("*t")
temp["plugins"] = #plugins
local url = BASE_URL .. '/sendMessage'
os.execute('curl -s -d "parse_mode=Markdown&chat_id=' .. config.log.admin .. '&text=' .. i18n('bot_started',temp) .. '" ' .. url..' > /dev/null')
