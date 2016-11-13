local plugin = {}

local function get_alert_text(key)
	if key == 'join' then
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
		['warn'] = _('Warns'),
		['join'] = _('New members'),
		['mediawarn'] = _('Media warns'),
		['spamwarn'] = _('Spam warns'),
		['flood'] = _('Flood'),
		['new_chat_photo'] = _('New group icon'),
		['delete_chat_photo'] = _('Group icon removed'),
		['new_chat_title'] = _('New group title'),
		['pinned_message'] = _('Pinned messages')
	}
	
	local keyboard = {inline_keyboard={}}
	local icon
	
	for event, default_status in pairs(config.chat_settings['tolog']) do
		local current_status = db:hget('chat:'..chat_id..':tolog', event) or default_status
		icon = '✅'
		if current_status == 'no' then icon = '☑️' end
		table.insert(keyboard.inline_keyboard, {{text = event_pretty[event] or event, callback_data = 'logchannel:alert:'..event}, {text = icon, callback_data = 'logchannel:toggle:'..event..':'..chat_id}})
	end
	
	--back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end	

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'alert' then
	    local text = get_alert_text(blocks[2])
	    api.answerCallbackQuery(msg.cb_id, text, true)
	else
	    
	    local chat_id = msg.target_id
	    if not roles.is_admin_cached(chat_id, msg.from.id) then
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
☑️ = won't be logged]])
            	api.editMessageText(msg.chat.id, msg.message_id, logchannel_first, true, reply_markup)
            else
            	api.editMarkup(msg.chat.id, msg.message_id, reply_markup)
            end
            
            if text then api.answerCallbackQuery(msg.cb_id, text) end
        end
    end
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type ~= 'private' then
	    if blocks[1] == 'setlog' then
	    	if msg.forward_from_chat.type == 'channel' then
	    		if roles.is_admin_cached(msg) then
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
	    	end
        end
    	if blocks[1] == 'unsetlog' then
    		if roles.is_admin_cached(msg) then
    			local log_channel = db:hget('bot:chatlogs', msg.chat.id)
    			if not log_channel then
    				api.sendReply(msg, _("_This groups is not using a log channel_"), true)
    			else
    				db:hdel('bot:chatlogs', msg.chat.id)
    				api.sendReply(msg, _("*Log channel removed*"), true)
    			end
			end
		end
		if blocks[1] == 'logchannel' then
			if roles.is_admin_cached(msg) then
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
    	end
    end
end

plugin.triggers = {
	onTextMessage = {
		'^/(setlog)$',
		'^/(unsetlog)$',
		'^/(logchannel)$'
	},
	onCallbackQuery = {
        '^###cb:logchannel:(toggle):([%w_]+):(-?%d+)$',
        '^###cb:logchannel:(alert):([%w_]+)$',
        '^###cb:(config):logchannel:(-?%d+)$'
    }
}

return plugin