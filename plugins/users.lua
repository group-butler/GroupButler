local function tell(msg)
	if msg.reply then
		msg = msg.reply
	end
	
	local text = ''
	text = text..make_text(lang[ln].tell.first_name, msg.from.first_name:mEscape())
	
	--check if the user has a last name
	if msg.from.last_name then
		text = text..make_text(lang[ln].tell.last_name, msg.from.last_name:mEscape())
	end
	
	--check if the user has a username
	if msg.from.username then
		text = text..'*Username*: @'..msg.from.username:mEscape()..'\n'
	end
	
	--add the id
	text = text..'*ID*: '..msg.from.id..'\n'
	
	--if in a group, build group info
	if msg.chat.type == 'group' or msg.chat.type == 'supergroup' then
		text = text..make_text(lang[ln].tell.group_name, msg.chat.title:mEscape())
		text = text..make_text(lang[ln].tell.group_id, msg.chat.id)
		return text
	else
		return text
	end
end

local action = function(msg, blocks, ln)
	if blocks[1] == 'ping' then
		api.sendMessage(msg.from.id, lang[ln].ping)
		mystat('/ping') --save stats
	end
	if blocks[1] == 'helpme' then
		if not is_owner(msg) or msg.chat.type == 'private' then
			return
		end
		db:sadd('bot:tofix', msg.chat.id)
		change_one_header(msg.chat.id)
		api.sendReply(msg, 'All should be ok now.\nIf not, contact the bot owner! (with _/c_ command)', true)
	end
	if blocks[1] == 'fixextra' then
		if not is_owner(msg) or msg.chat.type == 'private' then
			return
		end
		db:sadd('bot:tofixextra', msg.chat.id)
		change_extra_header(msg.chat.id)
		api.sendReply(msg, 'All should be ok now.\nIf not, contact the bot owner! (with _/c_ command)', true)
	end
	if blocks[1] == 'strings' then
		if not blocks[2] then
			local file_id = db:get('trfile:EN')
			if not file_id then return end
			api.sendDocumentId(msg.chat.id, file_id, msg.message_id)
		else
			local l_code = blocks[2]
			local exists = is_lang_supported(l_code)
			if exists then
				local file_id = db:get('trfile:'..l_code:upper())
				if not file_id then return end
				api.sendDocumentId(msg.chat.id, file_id, msg.message_id)
			else
				api.sendReply(msg, lang[ln].setlang.error, true)
			end
		end
	end
	if blocks[1] == 'tell' then
		local text = tell(msg)
		api.sendReply(msg, text, true)
		mystat('/tell')
	end
	if blocks[1] == 'echo' then
		local res = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			api.sendMessage(msg.chat.id, lang[ln].breaks_markdown, true)
		end
	end
	if blocks[1] == 'c' then
		if msg.chat.type ~= 'private' then
        	return
    	end
        local input = blocks[2]
        local receiver = msg.from.id
        
        --allert if not feedback
        if not input and not msg.reply then
        	local out = make_text(lang[ln].report.no_input)
            api.sendMessage(msg.from.id, out)
            return nil
        end
        
        if msg.reply then
        	msg = msg.reply
        end
	    
	    api.forwardMessage (config.admin, msg.from.id, msg.message_id)
	    api.sendMessage(receiver, lang[ln].report.sent)
	    mystat('/c')
	end
end

return {
	action = action,
	triggers = {
		'^/(ping)$',
		'^/(helpme)$',
		'^/(fixextra)$',
		'^/(strings)$',
		'^/(strings) (%a%a)$',
		'^/(tell)$',
		'^/(echo) (.*)$',
		'^/(c)$',
		'^/(c) (.*)',
	}
}