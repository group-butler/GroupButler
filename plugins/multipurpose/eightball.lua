--from https://github.com/topkecleon/otouto/blob/26c1299374af130bbf8457af904cb4ea450caa51/plugins/eightball.lua

local ball_answers = {
	"It is certain.",
	"It is decidedly so.",
	"Without a doubt.",
	"Yes, definitely.",
	"You may rely on it.",
	"As I see it, yes.",
	"Most likely.",
	"Outlook: good.",
	"Yes.",
	"Signs point to yes.",
	"Reply hazy try again.",
	"Ask again later.",
	"Better not tell you now.",
	"Cannot predict now.",
	"Concentrate and ask again.",
	"Don't count on it.",
	"My reply is no.",
	"My sources say no.",
	"Outlook: not so good.",
	"Very doubtful.",
	"There is a time and place for everything, but not now."
}

local yesno_answers = {
	'Absolutely.',
	'In your dreams.',
	'No please.',
	'Go for it.',
	'Yes.',
	'No.'
}

local action = function(msg)
    if msg.chat.type ~= 'private' and roles.is_admin_cached(msg) then
	    if msg.reply then
	    	msg = msg.reply
	    end
    
	    local message
    
	    if msg.text:lower():match('y/n%p?$') then
	    	message = yesno_answers[math.random(#yesno_answers)]
	    else
	    	message = ball_answers[math.random(#ball_answers)]
	    end
	    
	    api.sendReply(msg, message)
	end
end

return {
	action = action,
	triggers = {
	    config.cmd..'8ball',
	    'y/n%p?$'
    }
}