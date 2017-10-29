local config = require 'config'
local api = require ('telegram-bot-api.methods').init(config.telegram.token)

bot = api.getMe().result
bot.start_timestamp = os.time()
bot.last = {h = 0}

function bot.init()
	os.execute('killall nginx')
end
