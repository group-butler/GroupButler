local plugin = {}

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
	}
}

return plugin