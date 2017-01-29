local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function get_alert_text(key)
	if key == 'new_chat_member' then
		return _("Log every time an user join the group")
	elseif key == 'ban' then
		return _("Bans will be logged. I can't log manual bans")
	elseif key == 'kick' then
		return _("Kicks will be logged. I can't log manual kicks")
	elseif key == 'warn' then
		return _("Manual warns will be logged")
	elseif key == 'mediawarn' then
		return _("Forbidden media will be logged in the channel")
	elseif key == 'spamwarn' then
		return _("Spam links/forwards from channels will be logged in the channel, only if forbidden")
	elseif key == 'flood' then
		return _("Log when an user is flooding (new log message every 5 flood messages)")
	elseif key == 'new_chat_photo' then
		return _("Log when an admin changes the group icon")
	elseif key == 'delete_chat_photo' then
		return _("Log when an admin deletes the group icon")
	elseif key == 'new_chat_title' then
		return _("Log when an admin change the group title")
	elseif key == 'pinned_message' then
		return _("Log pinned messages")
	elseif key == 'blockban' then
		return _("Log when an user who has been blocked is banned from the group (when he join)")
	elseif key == 'promote' then
		return _("Log when a new user is promoted to moderator")
	elseif key == 'demote' then
		return _("Log when an user looses the role of moderator")
	elseif key == 'nowarn' then
		return _("Log when an admin removes the warning received by an user")
	elseif key == 'report' then
		return _("Log when an user reports a message with the @admin command")
	else
		return _("Description not available")
	end
end

local function toggle_event(chat_id, event)
	local hash = ('chat:%s:tolog'):format(chat_id)
	local current_status = db:hget(hash, event) or config.chat_settings['tolog'][event]
	
	if current_status == 'yes' then
		db:hset(hash, event, 'no')
	else
		db:hset(hash, event, 'yes')
	end
end	

local function doKeyboard_logchannel(chat_id)
	local event_pretty = {
		['ban'] = _('Ban'),
		['kick'] = _('Kick'),
		['unban'] = _('Unban'),
		['tempban'] = _('Tempban'),
		['report'] = _('Report'),
		['warn'] = _('Warns'),
		['nowarn'] = _('Warns resets'),
		['new_chat_member'] = _('New members'),
		['mediawarn'] = _('Media warns'),
		['spamwarn'] = _('Spam warns'),
		['flood'] = _('Flood'),
		['promote'] = _('Promotions'),
		['demote'] = _('Demotions'),
		['new_chat_photo'] = _('New group icon'),
		['delete_chat_photo'] = _('Group icon removed'),
		['new_chat_title'] = _('New group title'),
		['pinned_message'] = _('Pinned messages'),
		['blockban'] = _("Users blocked and banned"),
		['block'] = _("Users blocked"),
		['unblock'] = _("Users unblocked")
	}
	
	local keyboard = {inline_keyboard={}}
	local icon
	
	for event, default_status in pairs(config.chat_settings['tolog']) do
		local current_status = db:hget('chat:'..chat_id..':tolog', event) or default_status
		icon = '✅'
		if current_status == 'no' then icon = '☑️' end
		table.insert(keyboard.inline_keyboard, {{text = event_pretty[event] or event, callback_data = 'logchannel:alert:'..event..':'..locale.language}, {text = icon, callback_data = 'logchannel:toggle:'..event..':'..chat_id}})
	end
	
	--back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end	

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'logcb' then
		local chat_id = msg.target_id
		if not msg.from.admin then
			api.answerCallbackQuery(msg.cb_id, _("You are not admin of this group"), true)
		else
			if blocks[2] == 'unban' or blocks[2] == 'untempban' then
				local user_id = blocks[3]
				api.unbanUser(chat_id, user_id)
				api.answerCallbackQuery(msg.cb_id, _("User unbanned!"), true)
			end
		end
	else
		if blocks[1] == 'alert' then
			if config.available_languages[blocks[3]] then
				locale.language = blocks[3]
			end
		    local text = get_alert_text(blocks[2])
		    api.answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
		else
		    local chat_id = msg.target_id
		    if not u.is_allowed('config', chat_id, msg.from) then
		    	api.answerCallbackQuery(msg.cb_id, _("You're no longer an admin"))
		    else
    	        local text
    	        
    	        if blocks[1] == 'toggle' then
    	            toggle_event(chat_id, blocks[2])
    	            text = '👌🏼'
    	        end
    	        
    	        local reply_markup = doKeyboard_logchannel(chat_id)
    	        if blocks[1] == 'config' then
    	        	local logchannel_first = _([[*Select the events the will be logged in the channel*
✅ = will be logged
☑️ = won't be logged

Tap on a voice to get further informations]])
    	        	api.editMessageText(msg.chat.id, msg.message_id, logchannel_first, true, reply_markup)
    	        else
    	        	api.editMarkup(msg.chat.id, msg.message_id, reply_markup)
    	        end
    	        
    	        if text then api.answerCallbackQuery(msg.cb_id, text) end
    	    end
    	end
	end
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type ~= 'private' then
    	if not msg.from.admin then return end
	    
	    if blocks[1] == 'setlog' then
	    	if msg.forward_from_chat then
	    		if msg.forward_from_chat.type == 'channel' then
	    			if not msg.forward_from_chat.username then
	    				local res, code = api.getChatMember(msg.forward_from_chat.id, msg.from.id)
	    				if not res then
	    					if code == 429 then
	    						api.sendReply(msg, _('_Too many requests. Retry later_'), true)
	    					else
	    						api.sendReply(msg, _('_I need to be admin in the channel_'), true)
	    					end
	    			    else
	    					if res.result.status == 'creator' then
	    						local text
	    						local old_log = db:hget('bot:chatlogs', msg.chat.id)
	    						if old_log == tostring(msg.forward_from_chat.id) then
	    							text = _('_Already using this channel_')
	    						else
	    							db:hset('bot:chatlogs', msg.chat.id,  msg.forward_from_chat.id)
	    							text = _('*Log channel added!*')
	    							if old_log then
	    								api.sendMessage(old_log, _("<i>%s</i> changed its log channel"):format(msg.chat.title:escape_html()), 'html')
	    							end
	    							api.sendMessage(msg.forward_from_chat.id, _("Logs of <i>%s</i> will be posted here"):format(msg.chat.title:escape_html()), 'html')
	    						end
	    						api.sendReply(msg, text, true)
	    					else
	    						api.sendReply(msg, _('_Only the channel creator can pair the chat with a channel_'), true)
	    					end
	    				end
	    			else
	    				api.sendReply(msg, _('_I\'m sorry, only private channels are supported for now_'), true)
	    			end
	    		end
			else
				api.sendReply(msg, _("You have to *forward* the message from the channel"), true)
			end
    	end
    	if blocks[1] == 'unsetlog' then
    		local log_channel = db:hget('bot:chatlogs', msg.chat.id)
    		if not log_channel then
    			api.sendReply(msg, _("_This groups is not using a log channel_"), true)
    		else
    			db:hdel('bot:chatlogs', msg.chat.id)
    			api.sendReply(msg, _("*Log channel removed*"), true)
    		end
		end
		if blocks[1] == 'logchannel' then
			local log_channel = db:hget('bot:chatlogs', msg.chat.id)
    		if not log_channel then
    			api.sendReply(msg, _("_This groups is not using a log channel_"), true)
    		else
    			local channel_info, code = api.getChat(log_channel)
    			if not channel_info and code == 403 then
    				api.sendReply(msg, _("_This group has a log channel saved, but I'm not a member there, so I can't post/retrieve its info_"), true)
    			else
    				local channel_identifier = log_channel
    				if channel_info and channel_info.result then
    					channel_identifier = channel_info.result.title
    				end
    				api.sendReply(msg, _("<b>This group has a log channel</b>\nChannel: <code>%s</code>"):format(channel_identifier:escape_html()), 'html')
    			end
    		end
    	end
	else
		if blocks[1] == 'photo' then
			api.sendPhotoId(msg.chat.id, blocks[2])
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		'^/(setlog)$',
		'^/(unsetlog)$',
		'^/(logchannel)$',
		
		--deeplinking from log buttons
		'^/start (photo):(.*)$'
	},
	onCallbackQuery = {
		 --callbacks from the log channel
		'^###cb:(logcb):(%w-):(%d+):(-%d+)$',
		
		--callbacks from the configuration keyboard
        '^###cb:logchannel:(toggle):([%w_]+):(-?%d+)$',
        '^###cb:logchannel:(alert):([%w_]+):([%w_]+)$',
        '^###cb:(config):logchannel:(-?%d+)$'
    }
}

return plugin
