redis = require 'resty.redis' -- Load redis client
pgmoon = require 'pgmoon' -- Load postgres client
json = require 'cjson' -- Load json library
http = require 'resty.http' -- Load resty http library
config = require 'config' -- Load configuration file
i18n = require 'i18n' -- Load localization library
api = require 'methods' -- Load Telegram API
db = require 'database' -- Load database helper functions
u = require 'utilities' -- Load miscellaneous and cross-plugin functions

i18n.loadFile('i18n/core.lua') -- Load core localization
i18n.setLocale(config.lang) -- Set core localization
