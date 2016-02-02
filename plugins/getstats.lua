local triggers = {
	'^/getstats[@'..bot.username..']*'
}

local action = function(msg)
    
    if msg.from.id ~= config.admin then
		return nil
	end
	statis = load_data('statsbot.json')
	local out
	local put
	local active
	local message = '*Command statistics*\n\n'
    for k,v in pairs(statis) do
        if tostring(k) == 'rls' then
            message = message..'*rules*: '..v..'\n'
        elseif tostring(k) == 'abt' then
            message = message..'*about*: '..v..'\n'
        elseif tostring(k) == 'mdl' then
            message = message..'*modlist*: '..v..'\n'
        elseif tostring(k) == 'tell' then
            message = message..'*tell*: '..v..'\n'
        elseif tostring(k) == 'wel' then
            message = message..'*welcome <etc>*: '..v..'\n'
        elseif tostring(k) == 'llmod' then
            message = message..'*disable modlist*: '..v..'\n'
        elseif tostring(k) == 'ulabt' then
            message = message..'*enable about*: '..v..'\n'
        elseif tostring(k) == 'own' then
            message = message..'*owner*: '..v..'\n'
        elseif tostring(k) == 'help' then
            message = message..'*help*: '..v..'\n'
        elseif tostring(k) == 'usrs' then
            message = message..'*users*: '..v..'\n'
        elseif tostring(k) == 'srls' then
            message = message..'*setrules*: '..v..'\n'
        elseif tostring(k) == 'sabt' then
            message = message..'*setabout*: '..v..'\n'
        elseif tostring(k) == 'aabt' then
            message = message..'*addabout*: '..v..'\n'
        elseif tostring(k) == 'urls' then
            message = message..'*enable rules*: '..v..'\n'
        elseif tostring(k) == 'lwel' then
            message = message..'*disable welcome*: '..v..'\n'
        elseif tostring(k) == 'ulwel' then
            message = message..'*enable welcome*: '..v..'\n'
        elseif tostring(k) == 'lrls' then
            message = message..'*disable rules*: '..v..'\n'
        elseif tostring(k) == 'prom' then
            message = message..'*promote*: '..v..'\n'
        elseif tostring(k) == 'rel' then
            message = message..'*reload*: '..v..'\n'
        elseif tostring(k) == 'ullmod' then
            message = message..'*enable modlist*: '..v..'\n'
        elseif tostring(k) == 'sett' then
            message = message..'*settings*: '..v..'\n'
        elseif tostring(k) == 'gps' then
            message = message..'*times added*: '..v..'\n'
            put = v
        elseif tostring(k) == 'rem' then
            message = message..'*times removed*: '..v..'\n'
            out = v
        elseif tostring(k) == 'arls' then
            message = message..'*addrules*: '..v..'\n'
        elseif tostring(k) == 'labt' then
            message = message..'*disable about*: '..v..'\n'
        elseif tostring(k) == 'lflag' then
            message = message..'*disable flag*: '..v..'\n'
        elseif tostring(k) == 'ulflag' then
            message = message..'*enable flag*: '..v..'\n'
        elseif tostring(k) == 'flmsg' then
            message = message..'*flagmsg*: '..v..'\n'
        elseif tostring(k) == 'flb' then
            message = message..'*flagblock*: '..v..'\n'
        elseif tostring(k) == 'flfre' then
            message = message..'*flagfree*: '..v..'\n'
        elseif tostring(k) == 'fllist' then
            message = message..'*flaglist*: '..v..'\n'
        elseif tostring(k) == 'dem' then
            message = message..'*demote*: '..v..'\n'
        elseif tostring(k) == 'con' then
            message = message..'*contact*: '..v..'\n'
        end
    end
	active = put-out
	message = message..'\nNow in '..active..' groups\n'
	sendMessage(msg.chat.id, message, true, false, true)
end

return {
	action = action,
	triggers = triggers
}