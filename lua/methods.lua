local curl = require 'cURL'
local URL = require 'socket.url'
local JSON = require 'cjson'
local config = require 'config'
local clr = require 'term.colors'
local api_errors = require 'api_bad_requests'
local db = require 'database'
local locale = require 'languages'
local _ = locale.translate

local BASE_URL = 'https://api.telegram.org/bot' .. config.telegram.token

local api = {}

local curl_context = curl.easy{verbose = false}

local function getCode(err)
	err = err:lower()
	for k,v in pairs(api_errors) do
		if err:match(v) then
			return k
		end
	end
	return 7 --if unknown
end

local function performRequest(url)
	local data = {}

	-- if multithreading is made, this request must be in critical section
	local c = curl_context:setopt_url(url)
		:setopt_writefunction(table.insert, data)
		:perform()

	return table.concat(data), c:getinfo_response_code()
end

local function sendRequest(url)
	local dat, code = performRequest(url)
	local tab = JSON.decode(dat)

	if not tab then
		print(clr.red..'Error while parsing JSON'..clr.reset, code)
		print(clr.yellow..'Data:'..clr.reset, dat)
		api.sendAdmin(dat..'\n'..code)
	end

	if code ~= 200 then

		if code == 400 then
			 --error code 400 is general: try to specify
			 code = getCode(tab.description)
		end

		print(clr.red..code, tab.description..clr.reset)
		db:hincrby('bot:errors', code, 1)

		local retry_after
		if code == 429 then
			retry_after = tab.parameters.retry_after
			print(('%sRate limited for %d seconds%s'):format(clr.yellow, retry_after, clr.reset))
		end

		return false, code, tab.description, retry_after
	end

	if not tab.ok then
		api.sendAdmin('Not tab.ok')
		return false, tab.description
	end

	return tab

end

local function log_error(method, code, extras, description)
	if not method or not code then return end

	local ignored_errors = {110, 111, 116, 118, 131, 150, 155, 403, 429}

	for _, ignored_code in pairs(ignored_errors) do
		if tonumber(code) == tonumber(ignored_code) then return end
	end

	local text = 'Type: #badrequest\nMethod: #'..method..'\nCode: #n'..code

	if description then
		text = text..'\nDesc: '..description
	end

	if extras then
		if next(extras) then
			for i, extra in pairs(extras) do
				text = text..'\n#more'..i..': '..extra
			end
		else
			text = text..'\n#more: empty'
		end
	else
		text = text..'\n#more: nil'
	end

	api.sendLog(text)
end

function api.getMe()

	local url = BASE_URL .. '/getMe'

	return sendRequest(url)

end

function api.getUpdates(offset)

	local url = BASE_URL .. '/getUpdates?timeout=20'

	if offset then
		url = url .. '&offset=' .. offset
	end

	return sendRequest(url)

end

function api.firstUpdate()
	local url = BASE_URL .. '/getUpdates?timeout=3600&limit=1&allowed_updates=' ..
		JSON.encode(config.telegram.allowed_updates)

	return sendRequest(url)
end

function api.unbanChatMember(chat_id, user_id)

	local url = BASE_URL .. '/unbanChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	return sendRequest(url)
end

function api.kickChatMember(chat_id, user_id, until_date)

	local url = BASE_URL .. '/kickChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	if until_date then
		url = url .. '&until_date=' ..until_date
	end

	local success, code, description = sendRequest(url)
	if success then
		db:srem(string.format('chat:%d:members', chat_id), user_id)
	end

	return success, code, description
end

local function code2text(code)
	--the default error description can't be sent as output, so a translation is needed
	if code == 159 then
		return _("I don't have enough permissions to restrict users")
	elseif code == 101 or code == 105 or code == 107 then
		return _("I'm not an admin, I can't kick people")
	elseif code == 102 or code == 104 then
		return _("I can't kick or ban an admin")
	elseif code == 103 then
		return _("There is no need to unban in a normal group")
	elseif code == 106 or code == 134 then
		return _("This user is not a chat member")
	elseif code == 7 then
		return false
	end
	return false
end

function api.banUser(chat_id, user_id, until_date)

	local res, code = api.kickChatMember(chat_id, user_id, until_date) --try to kick. "code" is already specific

	if res then --if the user has been kicked, then...
		return res --return res and not the text
	else ---else, the user haven't been kicked
		local text = code2text(code)
		return res, code, text --return the motivation too
	end
end

function api.kickUser(chat_id, user_id)

	local res, code = api.kickChatMember(chat_id, user_id) --try to kick

	if res then --if the user has been kicked, then...
		--unban
		api.unbanChatMember(chat_id, user_id)
		api.unbanChatMember(chat_id, user_id)
		api.unbanChatMember(chat_id, user_id)
		return res
	else
		local motivation = code2text(code)
		return res, code, motivation
	end
end

function api.muteUser(chat_id, user_id)

	local url = BASE_URL..'/restrictChatMember?chat_id='..chat_id..'&user_id='..user_id ..'&can_post_messages=false'

	return sendRequest(url)

end

function api.unbanUser(chat_id, user_id)
	api.unbanChatMember(chat_id, user_id)
	return true
end

function api.restrictChatMember(chat_id, user_id, permissions, until_date)

	local url = BASE_URL .. '/restrictChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	if until_date then
		url = url .. '&until_date=' .. until_date
	end

	for permission, value in pairs(permissions) do
		url = url..('&%s=%s'):format(permission, value)
	end

	return sendRequest(url)

end

function api.getChat(chat_id)

	local url = BASE_URL .. '/getChat?chat_id=' .. chat_id

	return sendRequest(url)

end

function api.getChatAdministrators(chat_id)

	local url = BASE_URL .. '/getChatAdministrators?chat_id=' .. chat_id

	local res, code, desc = sendRequest(url)

	if not res and code then --if the request failed and a code is returned (not 403 and 429)
		log_error('getChatAdministrators', code, nil, desc)
	end

	return res, code

end

function api.getChatMembersCount(chat_id)

	local url = BASE_URL .. '/getChatMembersCount?chat_id=' .. chat_id

	return sendRequest(url)

end

function api.getChatMember(chat_id, user_id)

	local url = BASE_URL .. '/getChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id

	return sendRequest(url)

end

function api.leaveChat(chat_id)

	local url = BASE_URL .. '/leaveChat?chat_id=' .. chat_id

	local res, code = sendRequest(url)

	if res then
		db:srem(string.format('chat:%d:members', chat_id), api.getMe().result.id)
	end

	if not res and code then --if the request failed and a code is returned (not 403 and 429)
		log_error('leaveChat', code)
	end

	return res, code

end

function api.exportChatInviteLink(chat_id)

	local url = BASE_URL .. '/exportChatInviteLink?chat_id=' .. chat_id

	return sendRequest(url)

end

function api.sendMessage(chat_id, text, parse_mode, reply_markup, reply_to_message_id, link_preview)
	--print(text)

	local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	if parse_mode then
		if type(parse_mode) == 'string' and parse_mode:lower() == 'html' then
			url = url .. '&parse_mode=HTML'
		else
			url = url .. '&parse_mode=Markdown'
		end
	end

	if reply_markup then
		url = url..'&reply_markup='..URL.escape(JSON.encode(reply_markup))
	end

	if not link_preview then
		url = url .. '&disable_web_page_preview=true'
	end

	local res, code, desc = sendRequest(url)

	if not res and code then --if the request failed and a code is returned (not 403 and 429)
		log_error('sendMessage', code, {text}, desc)
	end

	return res, code --return false, and the code

end

function api.sendReply(msg, text, markd, reply_markup, link_preview)

	return api.sendMessage(msg.chat.id, text, markd, reply_markup, msg.message_id, link_preview)

end

function api.editMessageText(chat_id, message_id, text, parse_mode, keyboard)

	local url = BASE_URL..'/editMessageText?chat_id='..chat_id..'&message_id='..message_id..'&text='..URL.escape(text)

	if parse_mode then
		if type(parse_mode) == 'string' and parse_mode:lower() == 'html' then
			url = url .. '&parse_mode=HTML'
		else
			url = url .. '&parse_mode=Markdown'
		end
	end

	url = url .. '&disable_web_page_preview=true'

	if keyboard then
		url = url..'&reply_markup='..URL.escape(JSON.encode(keyboard))
	end

	return sendRequest(url)

end

function api.editMessageReplyMarkup(chat_id, message_id, reply_markup)

	local url = BASE_URL .. '/editMessageReplyMarkup?chat_id='..chat_id..
		'&message_id='..message_id..
		'&reply_markup='..URL.escape(JSON.encode(reply_markup))

	return sendRequest(url)

end

function api.deleteMessage(chat_id, message_id)

	local url = BASE_URL .. '/deleteMessage?chat_id=' .. chat_id .. '&message_id=' .. message_id

	return sendRequest(url)

end

function api.deleteMessages(chat_id, message_ids)

	for i=1, #message_ids do
		api.deleteMessage(chat_id, message_ids[i])
	end

end

function api.answerCallbackQuery(callback_query_id, text, show_alert, cache_time)

	local url = BASE_URL .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)

	if show_alert then
		url = url..'&show_alert=true'
	end

	if cache_time then
		local seconds = tonumber(cache_time) * 3600
		url = url..'&cache_time='..seconds
	end

	return sendRequest(url)

end

function api.sendChatAction(chat_id, action)
 -- Support actions are typing, upload_photo, record_video, upload_video, record_audio, upload_audio, upload_document, find_location

	local url = BASE_URL .. '/sendChatAction?chat_id=' .. chat_id .. '&action=' .. action
	return sendRequest(url)

end

function api.sendLocation(chat_id, latitude, longitude, reply_to_message_id)

	local url = BASE_URL .. '/sendLocation?chat_id=' .. chat_id .. '&latitude=' .. latitude .. '&longitude=' .. longitude

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	return sendRequest(url)

end

function api.forwardMessage(chat_id, from_chat_id, message_id)

	local url = BASE_URL..'/forwardMessage?chat_id='..chat_id..'&from_chat_id='..from_chat_id..'&message_id='..message_id

	local res, code, desc = sendRequest(url)

	if not res and code then --if the request failed and a code is returned (not 403 and 429)
		log_error('forwardMessage', code, nil, desc)
	end

	return res, code

end

function api.getFile(file_id)

	local url = BASE_URL .. '/getFile?file_id='..file_id

	return sendRequest(url)

end

------------------------Inline methods-----------------------------------------

function api.answerInlineQuery(inline_query_id, results, cache_time, is_personal, switch_pm_text, switch_pm_parameter)

	local url = BASE_URL .. '/answerInlineQuery?inline_query_id='..inline_query_id..'&results='..JSON.encode(results)

	if cache_time then
		url = url..'&cache_time='..cache_time
	end

	if is_personal then
		url = url..'&is_personal=True'
	end

	if switch_pm_text then
		url = url..'&switch_pm_text='..switch_pm_text
	end

	if switch_pm_parameter then
		url = url..'&switch_pm_parameter='..switch_pm_parameter
	end

	return sendRequest(url)

end

----------------------------By Id----------------------------------------------

function api.sendMediaId(chat_id, file_id, media, reply_to_message_id, caption)
	local url = BASE_URL
	if media == 'voice' then
		url = url..'/sendVoice?chat_id='..chat_id..'&voice='
	elseif media == 'video' then
		url = url..'/sendVideo?chat_id='..chat_id..'&video='
	elseif media == 'photo' then
		url = url..'/sendPhoto?chat_id='..chat_id..'&photo='
	else
		return false, 'Media passed is not voice/video/photo'
	end

	url = url..file_id

	if reply_to_message_id then
		url = url..'&reply_to_message_id='..reply_to_message_id
	end
	if caption then
		url = url..'&caption='..URL.escape(caption)
	end

	return sendRequest(url)
end

function api.sendPhotoId(chat_id, file_id, reply_to_message_id, caption)

	local url = BASE_URL .. '/sendPhoto?chat_id=' .. chat_id .. '&photo=' .. file_id

	if reply_to_message_id then
		url = url..'&reply_to_message_id='..reply_to_message_id
	end
	if caption then
		url = url..'&caption='..URL.escape(caption)
	end

	return sendRequest(url)

end

function api.sendDocumentId(chat_id, file_id, reply_to_message_id, caption, reply_markup)

	local url = BASE_URL .. '/sendDocument?chat_id=' .. chat_id .. '&document=' .. file_id

	if reply_to_message_id then
		url = url..'&reply_to_message_id='..reply_to_message_id
	end
	if caption then
		url = url..'&caption='..URL.escape(caption)
	end
	if reply_markup then
		url = url..'&reply_markup='..URL.escape(JSON.encode(reply_markup))
	end

	return sendRequest(url)

end

function api.sendStickerId(chat_id, file_id, reply_to_message_id)

	local url = BASE_URL .. '/sendSticker?chat_id=' .. chat_id .. '&sticker=' .. file_id

	if reply_to_message_id then
		url = url..'&reply_to_message_id='..reply_to_message_id
	end

	return sendRequest(url)

end

---------------------------- File Uploads -------------------------------------

function api.sendPhoto(chat_id, photo, caption, reply_to_message_id)

	local url = BASE_URL .. '/sendPhoto'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("photo", photo)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if caption then
		form:add_content("caption", caption)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()
						  :reset()

	return table.concat(data), c:getinfo_response_code()
end

function api.sendDocument(chat_id, document, reply_to_message_id, caption)

	local url = BASE_URL .. '/sendDocument'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("document", document)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if caption then
		form:add_content("caption", caption)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()
						  :reset()

	return table.concat(data), c:getinfo_response_code()

end

function api.sendSticker(chat_id, sticker, reply_to_message_id)

	local url = BASE_URL .. '/sendSticker'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("sticker", sticker)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()
						  :reset()

	return table.concat(data), c:getinfo_response_code()

end

function api.sendAudio(chat_id, audio, reply_to_message_id, duration, performer, title)

	local url = BASE_URL .. '/sendAudio'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("audio", audio)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if duration then
		form:add_content("duration", duration)
	end

	if performer then
		form:add_content("performer", performer)
	end

	if title then
		form:add_content("title", title)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()
						  :reset()

	return table.concat(data), c:getinfo_response_code()

end

function api.sendVideo(chat_id, video, duration, caption, reply_to_message_id)

	local url = BASE_URL .. '/sendVideo'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("video", video)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if duration then
		form:add_content("duration", duration)
	end

	if caption then
		form:add_content("caption", caption)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()
						  :reset()

	return table.concat(data), c:getinfo_response_code()

end


function api.sendVideoNote(chat_id, video_note, duration, reply_to_message_id)

	local url = BASE_URL .. '/sendVideoNote'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("video_note", video_note)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	if duration then
		form:add_content("duration", duration)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()

	return table.concat(data), c:getinfo_response_code()

end

function api.sendVoice(chat_id, voice, reply_to_message_id)

	local url = BASE_URL .. '/sendVoice'
	curl_context:setopt_url(url)

	local form = curl.form()
	form:add_content("chat_id", chat_id)
	form:add_file("voice", voice)

	if reply_to_message_id then
		form:add_content("reply_to_message_id", reply_to_message_id)
	end

	local data = {}

	local c = curl_context:setopt_writefunction(table.insert, data)
						  :setopt_httppost(form)
						  :perform()

	return table.concat(data), c:getinfo_response_code()

end

function api.sendAdmin(text, markdown)
	return api.sendMessage(config.log.admin, text, markdown)
end

function api.sendLog(text, markdown)
	return api.sendMessage(config.log.chat or config.log.admin, text, markdown)
end

return api
