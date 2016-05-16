
local BASE_URL = 'https://api.telegram.org/bot' .. config.bot_api_key

if not config.bot_api_key then
	error('You did not set your bot token in config.lua!')
end

local function sendRequest(url, user_id)

	local dat, code = HTTPS.request(url)
	
	if not dat then 
		return false, code 
	end
	
	local tab = JSON.decode(dat)

	if code ~= 200 then
		if tab and tab.description then print(code, tab.description) end
		--403: bot blocked, 429: spam limit ...send a message to the admin, return the code
		if code == 400 then code = api.getCode(tab.description) end --error code 400 is general: try to specify
		db:hincrby('bot:errors', code, 1)
		if code ~= 403 and code ~= 429 and code ~= 110 and code ~= 111 then
			local out = vtext(dat)..'\n'..code..'\n(text in the log)'
			api.sendLog(out)
			return false, code
		end
		return false, false --if the message is not sent because the bot is blocked, then don't return the code
	end
	
	--actually, this rarely happens
	if not tab.ok then
		return false, tab.description
	end

	return tab

end

local function getMe()

	local url = BASE_URL .. '/getMe'

	return sendRequest(url)

end

local function getUpdates(offset)

	local url = BASE_URL .. '/getUpdates?timeout=20'

	if offset then
		url = url .. '&offset=' .. offset
	end

	return sendRequest(url)

end

local function getCode(error)
	--error = error:gsub('%[Error : %d%d%d : Bad Request: ', ''):gsub('%]', '')
	--error = error:gsub('%[Error : 400 : ', ''):gsub('%]', '')
	for k,v in pairs(config.api_errors) do
		if error:match(v) then
			return k
		end
	end
	return 107 --if unknown
end

local function unbanChatMember(chat_id, user_id)
	
	local url = BASE_URL .. '/unbanChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	--return sendRequest(url)
	
	local dat, res = HTTPS.request(url)
	
	local tab = JSON.decode(dat)
	
	if res ~= 200 then
		return false, res
	end

	if not tab.ok then
		return false, tab.description
	end

	return tab
	
end

local function kickChatMember(chat_id, user_id)

	local url = BASE_URL .. '/kickChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	--return sendRequest(url)
	
	local dat, res = HTTPS.request(url)

	local tab = JSON.decode(dat)

	if res ~= 200 then
		--if error, return false and the custom error code
		print(tab.description)
		return false, api.getCode(tab.description)
	end

	if not tab.ok then
		return false, tab.description
	end

	return tab

end

local function code2text(code, ln, chat_id)
	--the default error description can't be sent as output, so a translation is needed
	if code == 101 then
		return lang[ln].kick_errors[code]
	elseif code == 102 then
		return lang[ln].kick_errors[code]
	elseif code == 103 then
		return lang[ln].kick_errors[code]
	elseif code == 104 then
		return lang[ln].kick_errors[code]
	elseif code == 105 then
		return lang[ln].kick_errors[code]
	elseif code == 106 then
		return lang[ln].kick_errors[code]
	elseif code == 107 then
		return false
	end
end

local function unbanUser(msg, on_request, no_msg, username)
	local name, user_id, text
	local chat_id = msg.chat.id
	local ln = msg.lang
	if not username then
		if on_request then
		    user_id = msg.reply.from.id
		    name = getname(msg.reply)
		else
		    user_id = msg.from.id
		    name = getname(msg)
		end
	else
		user_id = res_user_group(username, chat_id)
		if not user_id then
			api.sendReply(msg, lang[ln].bonus.no_user)
			return
		end
		name = username
	end
	name = name:mEscape()
	
	if is_mod2(chat_id, user_id) then return end
	
	if msg.chat.type == 'group' then
	    local hash = 'chat:'..chat_id..':banned'
	    local removed = db:srem(hash, user_id)
	    if removed == 0 then
		    text = lang[ln].banhammer.not_banned
		    api.sendReply(msg, text, true)
		    return false
	    end
	end
	res, code = api.unbanChatMember(chat_id, user_id)
	--che succede se unbanno un non bannato?
	text = make_text(lang[ln].banhammer.unbanned, name)
	api.sendReply(msg, text, true)
	return true
end

local function banUser(msg, on_request, no_msg, username)--no_msg: kick without message if kick is failed
	local name, user_id, text
	local chat_id = msg.chat.id
	local ln = msg.lang
	if not username then
		if on_request then
		    user_id = msg.reply.from.id
		    name = getname(msg.reply)
		else
		    user_id = msg.from.id
		    name = getname(msg)
		end
	else
		user_id = res_user_group(username, chat_id)
		if not user_id then
			api.sendReply(msg, lang[ln].bonus.no_user)
			return
		end
		name = username
	end	
	name = name:mEscape()
	
	if is_mod2(chat_id, user_id) then return end
	
	res, code = api.kickChatMember(chat_id, user_id) --try to kick
	
	if res then --if the user has been kicked, then...
	    db:hincrby('bot:general', 'ban', 1) --genreal: save how many kicks
		text = make_text(lang[ln].banhammer.banned, name)
		if msg.chat.type == 'group' then
		    local hash = 'chat:'..chat_id..':banned'
	        db:sadd(hash, user_id)
	    end
		--the kick went right: always display who have been kicked (and why, if included in the name)
		no_msg = false --if the bot kicked successfully, then send a message with the motivation
	else
		text = api.code2text(code, ln, chat_id)
	end
	
	--check if send a message after the kick. If a kick went successful, no_msg is always false: users need to know who and why
	if no_msg or code == 107 then --if no_msg (don't reply with the error) or the error is unknown then...
		return res
	else
		local sent, code_msg = api.sendMessage(chat_id, text, true)
		return res
	end
end

local function banUserId(chat_id, user_id, name, on_request, no_msg)
	local msg = {}
	msg.chat = {}
	msg.from = {}
	msg.chat.id = chat_id
	msg.from.id = user_id
	msg.from.first_name = name
	return api.banUser(msg, on_request, no_msg)
end

local function kickUser(msg, on_request, no_msg, username)-- no_msg: don't send the error message if kick is failed. If no_msg is false, it will return the motivation of the fail
	local name, user_id, text
	local chat_id = msg.chat.id
	local ln = msg.lang
	if not username then
		if on_request then
		    user_id = msg.reply.from.id
		    name = getname(msg.reply)
		else
		    user_id = msg.from.id
		    name = getname(msg)
		end
	else
		user_id = res_user_group(username, chat_id)
		if not user_id then
			api.sendReply(msg, lang[ln].bonus.no_user)
			return
		end
		name = username
	end
	name = name:mEscape()
	
	if is_mod2(chat_id, user_id) then return end
	
	res, code = api.kickChatMember(chat_id, user_id) --try to kick
	
	if res then --if the user has been kicked, then...
	    db:hincrby('bot:general', 'kick', 1) --genreal: save how many kicks
		--unban
		if msg.chat.type == 'supergroup' then
		    api.unbanChatMember(chat_id, user_id)
		end
		text = make_text(lang[ln].banhammer.kicked, name)
		--the kick went right: always display who have been kicked (and why, if included in the name)
		no_msg = false --if the bot kicked successfully, then send a message with the motivation
	else
		text = api.code2text(code, ln, chat_id)
	end
	
	--check if send a message after the kick. If a kick went successful, no_msg is always false: users need to know who and why
	if no_msg or code == 107 then --if no_msg (don't reply with the error) or the error is unknown then...
		return res
	else
		local sent, code_msg = api.sendMessage(chat_id, text, true)
		return res
	end
end

local function sendMessage(chat_id, text, use_markdown, disable_web_page_preview, reply_to_message_id, send_sound)
	--print(text)
	
	local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)

	url = url .. '&disable_web_page_preview=true'

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end
	
	if use_markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	if not send_sound then
		url = url..'&disable_notification=true'--messages are silent by default
	end
	
	local res, code = sendRequest(url)
	
	if not res and code then --if the request failed and a code is returned (not 403 and 429)
		print('Delivery failed')
		save_log('send_msg', text)
	end
	
	return res, code --return false, and the code

end

local function sendReply(msg, text, markd, send_sound)

	return sendMessage(msg.chat.id, text, markd, true, msg.message_id, send_sound)

end

local function editMessageText(chat_id, message_id, text, keyboard, markdown)
	
	local url = BASE_URL .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text)
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url .. '&disable_web_page_preview=true'
	
	if keyboard then
		url = url..'&reply_markup='..JSON.encode(keyboard)
	end
	
	return sendRequest(url)

end

local function answerCallbackQuery(callback_query_id, text, show_alert)
	
	local url = BASE_URL .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	
	if show_alert then
		url = url..'&show_alert=true'
	end
	
	return sendRequest(url)
	
end

local function sendKeyboard(chat_id, text, keyboard, markdown)
	
	local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url..'&text='..URL.escape(text)
	
	url = url..'&disable_web_page_preview=true'
	
	url = url..'&reply_markup='..JSON.encode(keyboard)
	
	return sendRequest(url)

end

local function sendChatAction(chat_id, action)
 -- Support actions are typing, upload_photo, record_video, upload_video, record_audio, upload_audio, upload_document, find_location

	local url = BASE_URL .. '/sendChatAction?chat_id=' .. chat_id .. '&action=' .. action
	return sendRequest(url)

end

local function sendLocation(chat_id, latitude, longitude, reply_to_message_id)

	local url = BASE_URL .. '/sendLocation?chat_id=' .. chat_id .. '&latitude=' .. latitude .. '&longitude=' .. longitude

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	return sendRequest(url)

end

local function forwardMessage(chat_id, from_chat_id, message_id)

	local url = BASE_URL .. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id

	return sendRequest(url)
	
end

local function curlRequest(curl_command)
 -- Use at your own risk. Will not check for success.

	local res = io.popen(curl_command)

end

local function sendPhoto(chat_id, photo, caption, reply_to_message_id)

	local url = BASE_URL .. '/sendPhoto'

	local curl_command = 'curl "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "photo=@' .. photo .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end

	if caption then
		curl_command = curl_command .. ' -F "caption=' .. caption .. '"'
	end

	return curlRequest(curl_command)

end

local function sendDocumentId(chat_id, file_id, reply_to_message_id)
	
	local url = BASE_URL .. '/sendDocument?chat_id=' .. chat_id .. '&document=' .. file_id
	
	if reply_to_message_id then
		url = url..'&reply_to_message_id='..reply_to_message_id
	end

	return sendRequest(url)
	
end

local function sendDocument(chat_id, document, reply_to_message_id)

	local url = BASE_URL .. '/sendDocument'

	local curl_command = 'curl "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "document=@' .. document .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end

	return curlRequest(curl_command)

end

local function sendSticker(chat_id, sticker, reply_to_message_id)

	local url = BASE_URL .. '/sendSticker'

	local curl_command = 'curl "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "sticker=@' .. sticker .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end

	return curlRequest(curl_command)

end

local function sendStickerId(chat_id, file_id, reply_to_message_id)
	
	local url = BASE_URL .. '/sendSticker?chat_id=' .. chat_id .. '&sticker=' .. file_id
	
	if reply_to_message_id then
		url = url..'&reply_to_message_id='..reply_to_message_id
	end

	return sendRequest(url)
	
end

local function sendAudio(chat_id, audio, reply_to_message_id, duration, performer, title)

	local url = BASE_URL .. '/sendAudio'

	local curl_command = 'curl "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "audio=@' .. audio .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end

	if duration then
		curl_command = curl_command .. ' -F "duration=' .. duration .. '"'
	end

	if performer then
		curl_command = curl_command .. ' -F "performer=' .. performer .. '"'
	end

	if title then
		curl_command = curl_command .. ' -F "title=' .. title .. '"'
	end

	return curlRequest(curl_command)

end

local function sendVideo(chat_id, video, reply_to_message_id, duration, performer, title)

	local url = BASE_URL .. '/sendVideo'

	local curl_command = 'curl "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "video=@' .. video .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end

	if caption then
		curl_command = curl_command .. ' -F "caption=' .. caption .. '"'
	end

	if duration then
		curl_command = curl_command .. ' -F "duration=' .. duration .. '"'
	end

	return curlRequest(curl_command)

end

local function sendVoice(chat_id, voice, reply_to_message_id)

	local url = BASE_URL .. '/sendVoice'

	local curl_command = 'curl "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "voice=@' .. voice .. '"'

	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end

	if duration then
		curl_command = curl_command .. ' -F "duration=' .. duration .. '"'
	end

	return curlRequest(curl_command)

end

local function sendAdmin(text, markdown)
	return api.sendMessage(config.admin, text, markdown)
end

local function sendLog(text, markdown)
	return api.sendMessage(config.log_chat or config.admin, text, markdown)
end

return {
	sendMessage = sendMessage,
	sendRequest = sendRequest,
	getMe = getMe,
	getUpdates = getUpdates,
	sendVoice = sendVoice,
	sendVideo = sendVideo,
	sendAudio = sendAudio,
	sendSticker = sendSticker,
	sendDocument = sendDocument,
	sendPhoto = sendPhoto,
	curlRequest = curlRequest,
	forwardMessage = forwardMessage,
	sendLocation = sendLocation,
	sendChatAction = sendChatAction,
	unbanChatMember = unbanChatMember,
	kickChatMember = kickChatMember,
	banUser = banUser,
	kickUser = kickUser,
	sendReply = sendReply,
	code2text = code2text,
	sendKeyboard = sendKeyboard,
	editMessageText = editMessageText,
	answerCallbackQuery = answerCallbackQuery,
	unbanUser = unbanUser,
	getCode = getCode,
	sendAdmin = sendAdmin,
	sendLog = sendLog,
	banUserId= banUserId,
	sendDocumentId = sendDocumentId,
	sendStickerId = sendStickerId
}	