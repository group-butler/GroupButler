local plugin = {}

local function save_data(filename, data)
    local s = JSON.encode(data, {indent = true})
    local f = io.open(filename, 'w')
    f:write(s)
    f:close()
end

local function gen_backup(chat_id)
    chat_id = tostring(chat_id)
    local file_path = '/tmp/snap'..chat_id..'.json'
    local t = {[chat_id] = {}}
    local hash
    for i=1, #config.chat_custom_texts do
        hash = ('chat:%s:%s'):format(chat_id, config.chat_custom_texts[i])
        local content = db:hgetall(hash)
        if next(content) then
            t[chat_id][config.chat_custom_texts[i]] = {}
            for key, val in pairs(content) do
                t[chat_id][config.chat_custom_texts[i]][key] = val
            end
        end
    end
    save_data(file_path, t)
    
    return file_path
end

local function get_time_remaining(seconds)
	local final = ''
	local hours = math.floor(seconds/3600)
	seconds = seconds - (hours*60*60)
	local min = math.floor(seconds/60)
	seconds = seconds - (min*60)

	if hours and hours > 0 then
		final = final..hours..'h '
	end
	if min and min > 0 then
		final = final..min..'m '
	end
	if seconds and seconds > 0 then
		final = final..seconds..'s'
	end

	return final
end

function plugin.onTextMessage(msg, blocks)
    if roles.is_admin_cached(msg) then
        local key = 'chat:'..msg.chat.id..':lastsnap'
        local last_user = db:get(key)
        if last_user then
            local ttl = db:ttl(key)
            local time_remaining = get_time_remaining(ttl)
            local text = ("<i>I'm sorry, this command has been used for the last time less then 3 days ago by</i> %s (ask him for the file).\nWait [<code>%s</code>] to use it again"):format(last_user, time_remaining)
            api.sendReply(msg, text, 'html')
        else
            local name = misc.getname_final(msg.from)
            db:setex(key, 259200, name) --3 days
            local file_path = gen_backup(msg.chat.id)
            api.sendReply(msg, '*Sent in private*', true)
            api.sendDocument(msg.from.id, file_path, nil, 'You are safe from Riccardo\'s stupid ideas now\n#snap')
        end
    end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'snap$'
	}
}

return plugin