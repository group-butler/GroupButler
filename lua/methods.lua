local curl = require 'cURL'
local config = require 'config'
local db = require 'database'
local locale = require 'languages'
local i18n = locale.translate
local api = require ('telegram-bot-api.methods').init(config.telegram.token)

local BASE_URL = 'https://api.telegram.org/bot' .. config.telegram.token

local _M = {}

local curl_context = curl.easy{verbose = false}

function _M.getMe()
	return api.getMe()
end

function _M.getUpdates(offset)
	return api.getUpdates(offset)
end

function _M.firstUpdate()
	return api.getUpdates(nil, 1, 3600, config.telegram.allowed_updates)
end

function _M.unbanChatMember(chat_id, user_id)
	return api.unbanChatMember(chat_id, user_id)
end

function _M.kickChatMember(chat_id, user_id, until_date)
	local success, code = api.kickChatMember(chat_id, user_id, until_date)
	if success then
		db:srem(string.format('chat:%d:members', chat_id), user_id)
	end
	return success, code
end

local function code2text(code)
	--the default error description can't be sent as output, so a translation is needed
	if code == 159 then
		return i18n("I don't have enough permissions to restrict users")
	elseif code == 101 or code == 105 or code == 107 then
		return i18n("I'm not an admin, I can't kick people")
	elseif code == 102 or code == 104 then
		return i18n("I can't kick or ban an admin")
	elseif code == 103 then
		return i18n("There is no need to unban in a normal group")
	elseif code == 106 or code == 134 then
		return i18n("This user is not a chat member")
	elseif code == 7 then
		return false
	end
	return false
end

function _M.banUser(chat_id, user_id, until_date)
	local res, code = _M.kickChatMember(chat_id, user_id, until_date) --try to kick. "code" is already specific
	if res then --if the user has been kicked, then...
		return res --return res and not the text
	else ---else, the user haven't been kicked
		local text = code2text(code)
		return res, code, text --return the motivation too
	end
end

function _M.kickUser(chat_id, user_id)
	local res, code = _M.kickChatMember(chat_id, user_id) --try to kick
	if res then --if the user has been kicked, then...
		--unban
		_M.unbanChatMember(chat_id, user_id)
		_M.unbanChatMember(chat_id, user_id)
		_M.unbanChatMember(chat_id, user_id)
		return res
	else
		local motivation = code2text(code)
		return res, code, motivation
	end
end

function _M.muteUser(chat_id, user_id)
	return api.restrictChatMember(chat_id, user_id, nil, {can_send_messages=false})
end

function _M.unbanUser(chat_id, user_id)
	_M.unbanChatMember(chat_id, user_id)
	return true
end

function _M.restrictChatMember(chat_id, user_id, permissions, until_date)
	return api.restrictChatMember(chat_id, user_id, until_date, permissions)
end

function _M.getChat(chat_id)
	return api.getChat(chat_id)
end
function _M.getChatAdministrators(chat_id)

	return api.getChatAdministrators(chat_id)
end

function _M.getChatMembersCount(chat_id)
	return api.getChatMembersCount(chat_id)
end

function _M.getChatMember(chat_id, user_id)
	return api.getChatMember(chat_id, user_id)
end

function _M.leaveChat(chat_id)
	local res, code = api.leaveChat(chat_id)
	if res then
		db:srem(string.format('chat:%d:members', chat_id), _M.getMe().result.id)
	end
	return res, code
end

function _M.exportChatInviteLink(chat_id)
	return api.exportChatInviteLink(chat_id)
end

function _M.sendMessage(chat_id, text, parse_mode, reply_markup, reply_to_message_id, link_preview)
	if parse_mode then
		if type(parse_mode) == 'string' and parse_mode:lower() == 'html' then
			parse_mode = 'HTML'
		else
			parse_mode = 'Markdown'
		end
	end
	local disable_web_page_preview
	if not link_preview then
		disable_web_page_preview = true
	end
	local res, code = api.sendMessage(chat_id, text, parse_mode, disable_web_page_preview, nil,
		reply_to_message_id, reply_markup)
	return res, code --return false, and the code
end

function _M.sendReply(msg, text, markd, reply_markup, link_preview)
	return _M.sendMessage(msg.chat.id, text, markd, reply_markup, msg.message_id, link_preview)
end

function _M.editMessageText(chat_id, message_id, text, parse_mode, reply_markup)
	if parse_mode then
		if type(parse_mode) == 'string' and parse_mode:lower() == 'html' then
			parse_mode = 'HTML'
		else
			parse_mode = 'Markdown'
		end
	end
	return api.editMessageText(chat_id, message_id, nil, text, parse_mode, true,
	reply_markup)
end

function _M.editMessageReplyMarkup(chat_id, message_id, reply_markup)
	return api.editMessageReplyMarkup(chat_id, message_id, nil, reply_markup)
end

function _M.deleteMessage(chat_id, message_id)
	return api.deleteMessage(chat_id, message_id)
end
function _M.deleteMessages(chat_id, message_ids)

	for i=1, #message_ids do
		_M.deleteMessage(chat_id, message_ids[i])
	end
end

function _M.answerCallbackQuery(callback_query_id, text, show_alert, cache_time)
	if cache_time then
		cache_time = tonumber(cache_time) * 3600
	end
	return api.answerCallbackQuery(callback_query_id, text, show_alert, cache_time)
end

function _M.sendChatAction(chat_id, action)
	return api.sendChatAction(chat_id, action)
end

function _M.sendLocation(chat_id, latitude, longitude, reply_to_message_id)
	return api.sendLocation(chat_id, latitude, longitude, reply_to_message_id)
end

function _M.forwardMessage(chat_id, from_chat_id, message_id)
	return api.forwardMessage(chat_id, from_chat_id, nil, message_id)
end

function _M.getFile(file_id)
	return api.getFile(file_id)
end

------------------------Inline methods-----------------------------------------

function _M.answerInlineQuery(inline_query_id, results, cache_time, is_personal, switch_pm_text, switch_pm_parameter)
	return api.answerInlineQuery(inline_query_id, results, cache_time, is_personal, switch_pm_text, switch_pm_parameter)
end

----------------------------By Id----------------------------------------------

function _M.sendMediaId(chat_id, file_id, media, reply_to_message_id, caption)
	if media == 'voice' then
		return api.sendVoice(chat_id, file_id, caption, nil, nil, reply_to_message_id)
	elseif media == 'video' then
		return api.sendVideo(chat_id, file_id, nil, nil, nil, caption, nil, reply_to_message_id)
	elseif media == 'photo' then
		return api.sendPhoto(chat_id, file_id, caption, nil, reply_to_message_id)
	else
		return false, 'Media passed is not voice/video/photo'
	end
end

function _M.sendPhotoId(chat_id, file_id, reply_to_message_id, caption)
	return api.sendPhoto(chat_id, file_id, caption, nil, reply_to_message_id)
end

function _M.sendDocumentId(chat_id, file_id, reply_to_message_id, caption, reply_markup)
	return api.sendDocument(chat_id, file_id, caption, nil, reply_to_message_id, reply_markup)
end

function _M.sendStickerId(chat_id, file_id, reply_to_message_id)
	return api.sendSticker(chat_id, file_id, nil, nil, reply_to_message_id)
end

---------------------------- File Uploads -------------------------------------

function _M.sendPhoto(chat_id, photo, caption, reply_to_message_id)
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

function _M.sendDocument(chat_id, document, reply_to_message_id, caption)
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

function _M.sendSticker(chat_id, sticker, reply_to_message_id)
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

function _M.sendAudio(chat_id, audio, reply_to_message_id, duration, performer, title)
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

function _M.sendVideo(chat_id, video, duration, caption, reply_to_message_id)
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
function _M.sendVideoNote(chat_id, video_note, duration, reply_to_message_id)

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

function _M.sendVoice(chat_id, voice, reply_to_message_id)
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

return _M
