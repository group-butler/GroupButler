require 'resty.core' -- replaces Lua C API bindings with LuaJIT bindings
redis = require 'resty.redis' -- Load redis client
json = require 'cjson' -- Load json library
http = require 'resty.http' -- Load resty http library
config = require 'config' -- Load configuration file
i18n = require 'i18n' -- Load localization library
api = require 'methods' -- Load Telegram API

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
