local api_old = require 'methods'

bot = api_old.getMe().result
bot.start_timestamp = os.time()
bot.last = {h = 0}

function bot.init()
	os.execute('killall nginx')
end
