-- redis_driver = require 'redis' -- Load redis client
-- db_driver = require "luasql.postgres" -- Load postgres client
json = require 'cjson' -- Load json library
config = require 'config' -- Load configuration file
i18n = require 'i18n' -- Load localization library
api = require 'methods' -- Load Telegram API
db = require 'database' -- Load database helper functions

i18n.loadFile('i18n/core.lua') -- Load core localization
