require 'resty.core' -- replaces Lua C API bindings with LuaJIT bindings
config = require 'config' -- Load configuration file
i18n = require 'i18n' -- Load localization library

i18n.loadFile('i18n/core.lua') -- Load core localization
i18n.setLocale(config.lang) -- Set core localization

for i,plugin in ipairs(config.plugins) do -- Load plugins localization
	i18n.loadFile('i18n/' .. plugin .. '.lua')
end
