-- local curl = require 'cURL'
-- local config = require "groupbutler.config"

-- local BASE_URL = 'https://api.telegram.org/bot' .. config.telegram.token

local _M = {}

-- local curl_context = curl.easy{verbose = false}

-- function _M.sendDocument(chat_id, document, reply_to_message_id, caption)
-- 	local url = BASE_URL .. '/sendDocument'
-- 	curl_context:setopt_url(url)
-- 	local form = curl.form()
-- 	form:add_content("chat_id", chat_id)
-- 	form:add_file("document", document)
-- 	if reply_to_message_id then
-- 		form:add_content("reply_to_message_id", reply_to_message_id)
-- 	end
-- 	if caption then
-- 		form:add_content("caption", caption)
-- 	end
-- 	local data = {}
-- 	local c = curl_context:setopt_writefunction(table.insert, data)
-- 						:setopt_httppost(form)
-- 						:perform()
-- 						:reset()
-- 	return table.concat(data), c:getinfo_response_code()
-- end

return _M
