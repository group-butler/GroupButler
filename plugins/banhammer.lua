local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

local function get_motivation(msg)
	if msg.reply then
		return msg.text:match(("%sban (.+)"):format(config.cmd))
			or msg.text:match(("%skick (.+)"):format(config.cmd))
			or msg.text:match(("%stempban .+\n(.+)"):format(config.cmd))
	else
		if msg.text:find(config.cmd.."ban @%w[%w_]+ ") or msg.text:find(config.cmd.."kick @%w[%w_]+ ") then
			return msg.text:match(config.cmd.."ban @%w[%w_]+ (.+)") or msg.text:match(config.cmd.."kick @%w[%w_]+ (.+)")
		elseif msg.text:find(config.cmd.."ban %d+ ") or msg.text:find(config.cmd.."kick %d+ ") then
			return msg.text:match(config.cmd.."ban %d+ (.+)") or msg.text:match(config.cmd.."kick %d+ (.+)")
		elseif msg.entities then
			return msg.text:match(config.cmd.."ban .+\n(.+)") or msg.text:match(config.cmd.."kick .+\n(.+)")
		end
	end			
end	

function plugin.cron()
	local all = db:hgetall('tempbanned')
	if next(all) then
		for unban_time, info in pairs(all) do
			if os.time() > tonumber(unban_time) then
				local chat_id, user_id = info:match('(-%d+):(%d+)')
				api.unbanUser(chat_id, user_id)
				db:hdel('tempbanned', unban_time)
				db:srem('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
			end
		end
	end
end

local function check_valid_time(temp)
	temp = tonumber(temp)
	if temp == 0 then
		return false, 1
	elseif temp > 168 then --1 week
		return false, 2
	else
		return temp
	end
end

local function get_hours_from_string(input)
	if input:match('^%d+$') then
		return tonumber(input)
	else
		local days = input:match('(%d)%s?d')
		if not days then days = 0 end
		local hours = input:match('(%d%d?)%s?h')
		if not hours then hours = 0 end
		if not days and not hours then
			return input:match('(%d+)')
		else
			return ((tonumber(days))*24)+(tonumber(hours))
		end
	end
end

local function get_time_reply(hours)
	local time_string = ''
	local time_table = {}
	time_table.days = math.floor(hours/24)
	time_table.hours = hours - (time_table.days*24)
	if time_table.days ~= 0 then
		time_string = time_table.days..'d'
	end
	if time_table.hours ~= 0 then
		time_string = time_string..' '..time_table.hours..'h'
	end
	return time_string, time_table
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type ~= 'private' then
		if roles.is_admin_cached(msg) then
		    
		    local user_id, error_translation_key = misc.get_user_id(msg, blocks)
		    
		    if not user_id then
		    	api.sendReply(msg, _(error_translation_key), true) return
		    end
		    if msg.reply and msg.reply.from.id == bot.id then return end
		 	
		 	local res
		 	local chat_id = msg.chat.id
		 	local admin, kicked = misc.getnames_complete(msg, blocks)
		 	
		 	--print(get_motivation(msg))
		 	
		 	if blocks[1] == 'tempban' then
				if not msg.reply then
					api.sendReply(msg, _("_Reply to someone_"), true)
					return
				end
				local user_id = msg.reply.from.id
				local hours = get_hours_from_string(blocks[2])
				if not hours then return end
				local temp, code = check_valid_time(hours)
				if not temp then
					if code == 1 then
						api.sendReply(msg, _("For this, you can directly use /ban"))
					else
						api.sendReply(msg, _("_The time limit is one week (168 hours)_"), true)
					end
					return
				end
				local val = msg.chat.id..':'..user_id
				local unban_time = os.time() + (temp * 60 * 60)
				
				--try to kick
				local res, code, motivation = api.banUser(chat_id, user_id)
		    	if not res then
		    		if not motivation then
		    			motivation = _("I can't kick this user.\n"
								.. "Either I'm not an admin, or the targeted user is!")
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		misc.saveBan(user_id, 'tempban') --save the ban
		    		db:hset('tempbanned', unban_time, val) --set the hash
					local time_reply, time_table = get_time_reply(temp)
					local is_already_tempbanned = db:sismember('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
					local text
					if is_already_tempbanned then
						text = _("Ban time updated for %s. Ban expiration: %s\n<b>Admin</b>: %s"):format(kicked, time_reply, admin)
					else
						text = _("User %s banned by %s.\n<i>Ban expiration:</i> %s"):format(kicked, admin, time_reply)
						db:sadd('chat:'..chat_id..':tempbanned', user_id) --hash needed to check if an user is already tempbanned or not
					end
					misc.logEvent('tempban', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id, h = time_table.hours, d = time_table.days})
					api.sendMessage(chat_id, text, 'html')
				end
			end
		 	if blocks[1] == 'kick' then
		    	local res, code, motivation = api.kickUser(chat_id, user_id)
		    	if not res then
		    		if not motivation then
		    			motivation = _("I can't kick this user.\n"
								.. "Either I'm not an admin, or the targeted user is!")
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		misc.saveBan(user_id, 'kick')
		    		misc.logEvent('kick', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
		    		api.sendMessage(msg.chat.id, _("%s kicked %s!"):format(admin, kicked), 'html')
		    	end
	    	end
	   		if blocks[1] == 'ban' then
	   			local res, code, motivation = api.banUser(chat_id, user_id)
		    	if not res then
		    		if not motivation then
		    			motivation = _("I can't kick this user.\n"
								.. "Either I'm not an admin, or the targeted user is!")
		    		end
		    		api.sendReply(msg, motivation, true)
		    	else
		    		--save the ban
		    		misc.saveBan(user_id, 'ban')
		    		misc.logEvent('ban', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
		    		api.sendMessage(msg.chat.id, _("%s banned %s!"):format(admin, kicked), 'html')
		    	end
    		end
   			if blocks[1] == 'unban' then
   				api.unbanUser(chat_id, user_id)
   				misc.logEvent('unban', msg, {motivation = get_motivation(msg), admin = admin, user = kicked, user_id = user_id})
   				local text = _("%s unbanned by %s!"):format(kicked, admin)
   				api.sendReply(msg, text, 'html')
   			end
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(kick) (.+)',
		config.cmd..'(kick)$',
		config.cmd..'(ban) (.+)',
		config.cmd..'(ban)$',
		config.cmd..'(tempban) (.+)',
		config.cmd..'(unban) (.+)',
		config.cmd..'(unban)$',
	}
}

return plugin
