local _M = {
  VERSION = "3.5.0.2"
}

local json = require "cjson"
local mp = require "multipart-post"
local ltn12 = require "ltn12"
local resty_http, ssl_https

local function decode_reply(body, status, method)
  -- ngx.log(ngx.DEBUG, "Incoming reply:", ok.body)
  local tab = json.decode(body)

  if status ~= 200 or not tab.ok then
    -- ngx.log(ngx.WARN, method.."() failed: "..(tab.description or "unknown"))
    print("[WARN]", method.."() failed: "..(tab.description or "unknown"))
    return nil, tab
  end
  return tab.result
end

local function file_upload(_, body, file)
  body = body or {}

  for k,v in pairs(body) do
    body[k] = tostring(v)
  end

  if file and next(file) then
    local file_type, file_table = next(file)
    local file_name = file_table.path
    local file_file = io.open(file_name, "r")
    local file_data = {
      filename = file_name,
      data = file_file:read("*a")
    }
    file_file:close()
    body[file_type] = file_data
  end
  if next(body) == nil then
    body = {""}
  end

  local request_body, boundary = mp.encode(body)

  local arguments = {
    method = "POST",
    headers = {
      ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
      ["Content-Length"] = #request_body,
    },
  }
  return arguments, request_body
end

local function json_request(_, body)
  local arguments = {}
  local request_body
  if body then
    request_body = json.encode(body)
    arguments = {
      method = "POST",
      headers = {
        ["Content-Type"] = "application/json",
        ["Content-Length"] = #request_body,
      },
    }
    -- ngx.log(ngx.DEBUG, "Outgoing request: ", request_body)
  end
  return arguments, request_body
end

local function ngx_request(self, method, body, file)
  local arguments, request_body
  if file then
    arguments, request_body = file_upload(self, body, file)
  else
    arguments, request_body = json_request(self, body)
  end
  arguments.body = request_body
  local httpc = resty_http.new()
  local ok, err = httpc:request_uri((self._url..method), arguments)
  if not ok then
    local desc = "HTTP request failed: "..(err or "unknown")
    ngx.log(ngx.ERR, desc)
    return nil, {ok=false, error_code=0, description=desc}
  end
  return decode_reply(ok.body, ok.status, method)
end

local function lua_request(self, method, body, file)
  local arguments, request_body
  if file then
    arguments, request_body = file_upload(self, body, file)
  else
    arguments, request_body = json_request(self, body)
  end
  arguments.source = ltn12.source.string(request_body)
  arguments.url = self._url..method
  local response = {}
  arguments.sink = ltn12.sink.table(response)
  local ok, res = ssl_https.request(arguments)
  if not ok then
    local desc = "HTTP request failed: "..(res or "unknown")
    print("[ERROR]", desc)
    return nil, {ok=false, error_code=0, description=desc}
  end
  return decode_reply(table.concat(response), res, method)
end

local function is_table(value)
  if type(value) ~= "table" then
    return nil
  end
  return value
end

local function assert_var(body, ...)
  for _,v in ipairs({...}) do
    assert(body[v], "Missing required variable "..v)
  end
end

local function check_id(body)
  if not body.inline_message_id then
    assert_var(body, "chat_id", "message_id")
  end
end

local function read_config(self, config)
  local server = "api.telegram.org"
  local token = config
  if is_table(config) then
    token = config.token
    server = config.server or server
  end
  assert(token, "Missing Bot API token")
  self._url = "https://"..server.."/bot"..token.."/"
end

local function set_env(self)
  if ngx then
    local x = ngx.get_phase() -- Avoid using cosockets on unsupported contexts. See openresty/lua-nginx-module#1020
    if x ~= "init" and x ~= "init_worker" and x ~= "set" and x ~= "log" and x ~= "header_filter" and x ~= "body_filter" then
      resty_http = require "resty.http"
      self._request = ngx_request
    end
    return
  end
  ssl_https = require "ssl.https"
  self._request = lua_request
end

function _M:new(config)
  local obj = {}
  setmetatable(obj, {__index = self})
  read_config(obj, config)
  set_env(obj)
  return obj
end

-- Getting updates

function _M:getUpdates(...)
  local args = {...}
  local body = is_table(args[1]) or {
    offset = args[1],
    limit = args[2],
    timeout = args[3],
    allowed_updates = args[4]
  }
  return self._request(self, "getUpdates", body)
end

function _M:setWebhook(...)
  local args = {...}
  local body = is_table(args[1]) or {
    url = args[1],
    certificate = args[2],
    max_connections = args[3],
    allowed_updates = args[4]
  }
  assert_var(body, "url")
  return self._request(self, "setWebhook", body)
end

function _M:deleteWebhook()
  return self._request(self, "deleteWebhook")
end

function _M:getWebhookInfo()
  return self._request(self, "getWebhookInfo")
end

-- Available methods

function _M:getMe()
  return self._request(self, "getMe")
end

function _M:sendMessage(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    text = args[2],
    parse_mode = args[3],
    disable_web_page_preview = args[4],
    disable_notification = args[5],
    reply_to_message_id = args[6],
    reply_markup = args[7]
  }
  assert_var(body, "chat_id", "text")
  return self._request(self, "sendMessage", body)
end

function _M:forwardMessage(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    from_chat_id = args[2],
    message_id = args[3],
    disable_notification = args[4]
  }
  assert_var(body, "chat_id", "from_chat_id", "message_id")
  return self._request(self, "forwardMessage", body)
end

function _M:sendPhoto(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    photo = args[2],
    caption = args[3],
    disable_notification = args[4],
    reply_to_message_id = args[5],
    reply_markup = args[6]
  }
  assert_var(body, "chat_id", "photo")
  if is_table(body.photo) then
    return self._request(self, "sendPhoto", body, {photo = body.photo})
  end
  return self._request(self, "sendPhoto", body)
end

function _M:sendAudio(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    audio = args[2],
    caption = args[3],
    duration = args[4],
    performer = args[5],
    title = args[6],
    disable_notification = args[7],
    reply_to_message_id = args[8],
    reply_markup = args[9]
  }
  assert_var(body, "chat_id", "audio")
  if is_table(body.audio) then
    return self._request(self, "sendAudio", body, {audio = body.audio})
  end
  return self._request(self, "sendAudio", body)
end

function _M:sendDocument(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    document = args[2],
    caption = args[3],
    disable_notification = args[4],
    reply_to_message_id = args[5],
    reply_markup = args[6]
  }
  assert_var(body, "chat_id", "document")
  if is_table(body.document) then
    return self._request(self, "sendDocument", body, {document = body.document})
  end
  return self._request(self, "sendDocument", body)
end

function _M:sendVideo(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    video = args[2],
    duration = args[3],
    width = args[4],
    height = args[5],
    caption = args[6],
    disable_notification = args[7],
    reply_to_message_id = args[8],
    reply_markup = args[9]
  }
  assert_var(body, "chat_id", "video")
  if is_table(body.video) then
    return self._request(self, "sendVideo", body, {video = body.video})
  end
  return self._request(self, "sendVideo", body)
end

function _M:sendVoice(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    voice = args[2],
    duration = args[3],
    caption = args[4],
    disable_notification = args[5],
    reply_to_message_id = args[6],
    reply_markup = args[7]
  }
  assert_var(body, "chat_id", "voice")
  if is_table(body.voice) then
    return self._request(self, "sendVoice", body, {voice = body.voice})
  end
  return self._request(self, "sendVoice", body)
end

function _M:sendVideoNote(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    video_note = args[2],
    duration = args[3],
    lenght = args[4],
    disable_notification = args[5],
    reply_to_message_id = args[6],
    reply_markup = args[7]
  }
  assert_var(body, "chat_id", "video_note")
  if is_table(body.video_note) then
    return self._request(self, "sendVideoNote", body, {video_note = body.video_note})
  end
  return self._request(self, "sendVideoNote", body)
end

function _M:sendMediaGroup(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    media = args[2],
    disable_notification = args[3],
    reply_to_message_id = args[4]
  }
  assert_var(body, "chat_id", "media")
  return self._request(self, "sendMediaGroup", body)
end

function _M:sendLocation(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    latitude = args[2],
    longitude = args[3],
    live_period = args[4],
    disable_notification = args[5],
    reply_to_message_id = args[6],
    reply_markup = args[7]
  }
  assert_var(body, "chat_id", "latitude", "longitude")
  return self._request(self, "sendLocation", body)
end

function _M:editMessageLiveLocation(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2],
    inline_message_id = args[3],
    latitude = args[4],
    longitude = args[5],
    reply_markup = args[6]
  }
  check_id(body)
  assert_var(body, "latitude", "longitude")
  return self._request(self, "editMessageLiveLocation", body)
end

function _M:stopMessageLiveLocation(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2],
    inline_message_id = args[3],
    reply_markup = args[4]
  }
  check_id(body)
  return self._request(self, "editMessageLiveLocation", body)
end

function _M:sendVenue(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    latitude = args[2],
    longitude = args[3],
    title = args[4],
    address = args[5],
    foursquare_id = args[6],
    disable_notification = args[7],
    reply_to_message_id = args[8],
    reply_markup = args[9]
  }
  assert_var(body, "chat_id", "latitude", "longitude", "title", "address")
  return self._request(self, "sendVenue", body)
end

function _M:sendContact(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    phone_number = args[2],
    first_name = args[3],
    last_name = args[4],
    disable_notification = args[5],
    reply_to_message_id = args[6],
    reply_markup = args[7]
  }
  assert_var(body, "chat_id", "phone_number", "first_name")
  return self._request(self, "sendContact", body)
end

function _M:sendChatAction(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    action = args[2]
  }
  assert_var(body, "chat_id", "action")
  return self._request(self, "sendChatAction", body)
end

function _M:getUserProfilePhotos(...)
  local args = {...}
  local body = is_table(args[1]) or {
    user_id = args[1],
    offset = args[2],
    limit = args[3]
  }
  assert_var(body, "user_id")
  return self._request(self, "getUserProfilePhotos", body)
end

function _M:getFile(file_id)
  local body = is_table(file_id) or {
    file_id = file_id
  }
  assert_var(body, "file_id")
  return self._request(self, "getFile", body)
end

function _M:kickChatMember(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    user_id = args[2],
    until_date = args[3]
  }
  assert_var(body, "chat_id", "user_id")
  return self._request(self, "kickChatMember", body)
end

function _M:unbanChatMember(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    user_id = args[2]
  }
  assert_var(body, "chat_id", "user_id")
  return self._request(self, "unbanChatMember", body)
end

function _M:restrictChatMember(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    user_id = args[2],
    until_date = args[3],
    can_send_messages = args[4],
    can_send_media_messages = args[5],
    can_send_other_messages = args[6],
    can_add_web_page_previews = args[7]
  }
  assert_var(body, "chat_id", "user_id")
  return self._request(self, "restrictChatMember", body)
end

function _M:promoteChatMember(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    user_id = args[2],
    can_change_info = args[3],
    can_post_messages = args[4],
    can_edit_messages = args[5],
    can_delete_messages = args[6],
    can_invite_users = args[7],
    can_restrict_members = args[8],
    can_pin_messages = args[9],
    can_promote_members = args[10]
  }
  assert_var(body, "chat_id", "user_id")
  return self._request(self, "promoteChatMember", body)
end

function _M:exportChatInviteLink(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "exportChatInviteLink", body)
end

function _M:setChatPhoto(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    photo = args[2]
  }
  assert_var(body, "chat_id", "photo")
  return self._request(self, "setChatPhoto", body)
end

function _M:deleteChatPhoto(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "deleteChatPhoto", body)
end

function _M:setChatTitle(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    title = args[2]
  }
  assert_var(body, "chat_id", "title")
  return self._request(self, "setChatTitle", body)
end

function _M:setChatDescription(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    description = args[2]
  }
  assert_var(body, "chat_id", "description")
  return self._request(self, "setChatDescription", body)
end

function _M:pinChatMessage(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2],
    disable_notification = args[3]
  }
  assert_var(body, "chat_id", "message_id")
  return self._request(self, "pinChatMessage", body)
end

function _M:unpinChatMessage(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "unpinChatMessage", body)
end

function _M:leaveChat(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "leaveChat", body)
end

function _M:getChat(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "getChat", body)
end

function _M:getChatAdministrators(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "getChatAdministrators", body)
end

function _M:getChatMembersCount(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id
  }
  assert_var(body, "chat_id")
  return self._request(self, "getChatMembersCount", body)
end

function _M:getChatMember(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    user_id = args[2]
  }
  assert_var(body, "chat_id", "user_id")
  return self._request(self, "getChatMember", body)
end

function _M:setChatStickerSet(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    sticker_set_name = args[2]
  }
  assert_var(body, "chat_id", "sticker_set_name")
  return self._request(self, "setChatStickerSet", body)
end

function _M:deleteChatStickerSet(chat_id)
  local body = is_table(chat_id) or {
    chat_id = chat_id,
  }
  assert_var(body, "chat_id")
  return self._request(self, "setChatStickerSet", body)
end

function _M:answerCallbackQuery(...)
  local args = {...}
  local body = is_table(args[1]) or {
    callback_query_id = args[1],
    text = args[2],
    show_alert = args[3],
    cache_time = args[4]
  }
  assert_var(body, "callback_query_id")
  return self._request(self, "answerCallbackQuery", body)
end

-- Updating messages

function _M:editMessageText(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2],
    inline_message_id = args[3],
    text = args[4],
    parse_mode = args[5],
    disable_web_page_preview = args[6],
    reply_markup = args[7]
  }
  check_id(body)
  assert_var(body, "text")
  return self._request(self, "editMessageText", body)
end

function _M:editMessageCaption(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2],
    inline_message_id = args[3],
    caption = args[4],
    reply_markup = args[5]
  }
  check_id(body)
  return self._request(self, "editMessageCaption", body)
end

function _M:editMessageReplyMarkup(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2],
    inline_message_id = args[3],
    reply_markup = args[4]
  }
  check_id(body)
  return self._request(self, "editMessageReplyMarkup", body)
end

function _M:deleteMessage(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    message_id = args[2]
  }
  assert_var(body, "chat_id", "message_id")
  return self._request(self, "deleteMessage", body)
end

-- Stickers

function _M:sendSticker(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    sticker = args[2],
    caption = args[3],
    disable_notification = args[4],
    reply_to_message_id = args[5],
    reply_markup = args[6]
  }
  assert_var(body, "chat_id", "sticker")
  return self._request(self, "sendSticker", body)
end

function _M:getStickerSet(name)
  local body = is_table(name) or {
    name = name
  }
  assert_var(body, "name")
  return self._request(self, "getSticker", body)
end

function _M:uploadStickerFile(...)
  local args = {...}
  local body = is_table(args[1]) or {
    user_id = args[1],
    png_sticker = args[2]
  }
  assert_var(body, "user_id", "png_sticker")
  return self._request(self, "uploadStickerFile", body)
end

function _M:createNewStickerSet(...)
  local args = {...}
  local body = is_table(args[1]) or {
    user_id = args[1],
    name = args[2],
    title = args[3],
    png_sticker = args[4],
    emojis = args[5],
    contains_masks = args[6],
    mask_position = args[7]
  }
  assert_var(body, "user_id", "name", "title", "png_sticker", "emojis")
  return self._request(self, "createNewStickerSet", body)
end

function _M:addStickerToSet(...)
  local args = {...}
  local body = is_table(args[1]) or {
    user_id = args[1],
    name = args[2],
    png_sticker = args[3],
    emojis = args[4],
    mask_position = args[5]
  }
  assert_var(body, "user_id", "name", "png_sticker", "emojis")
  return self._request(self, "addStickerToSet", body)
end

function _M:setStickerPositionInSet(...)
  local args = {...}
  local body = is_table(args[1]) or {
    sticker = args[1],
    position = args[2]
  }
  assert_var(body, "sticker", "position")
  return self._request(self, "setStickerPositionInSet", body)
end

function _M:deleteStickerFromSet(sticker)
  local body = is_table(sticker) or {
    sticker = sticker
  }
  assert_var(body, "sticker")
  return self._request(self, "deleteStickerFromSet", body)
end

-- Inline mode

function _M:answerInlineQuery(...)
  local args = {...}
  local body = is_table(args[1]) or {
    inline_query_id = args[1],
    results = args[2],
    cache_time = args[3],
    is_personal = args[4],
    switch_pm_text = args[5],
    switch_pm_parameter = args[6]
  }
  assert_var(body, "inline_query_id", "results")
  return self._request(self, "answerInlineQuery", body)
end

-- Payments

function _M:sendInvoice(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    title = args[2],
    description = args[3],
    payload = args[4],
    provider_token = args[5],
    start_parameter = args[6],
    currency = args[7],
    prices = args[8],
    photo_url = args[9],
    photo_width = args[10],
    photo_height = args[11],
    need_name = args[12],
    need_phone_number = args[13],
    need_email = args[14],
    need_shipping_address = args[15],
    send_phone_number_to_provider = args[16],
    send_email_to_provider = args[17],
    is_flexible = args[18],
    disable_notification = args[19],
    reply_to_message_id = args[20],
    reply_markup = args[21]
  }
  assert_var(body, "chat_id", "title", "description", "payload", "provider_token", "start_parameter", "currency", "prices")
  return self._request(self, "sendInvoice", body)
end

function _M:answerShippingQuery(...)
  local args = {...}
  local body = is_table(args[1]) or {
    shipping_query_id = args[1],
    ok = args[2],
    shipping_options = args[3],
    error_message = args[4]
  }
  assert_var(body, "shipping_query_id")
  if body.ok then
    assert_var(body, "shipping_options")
  else
    assert_var(body, "error_message")
  end
  return self._request(self, "answerShippingQuery", body)
end

function _M:answerPreCheckoutQuery(...)
  local args = {...}
  local body = is_table(args[1]) or {
    pre_checkout_query_id = args[1],
    ok = args[2],
    error_message = args[3]
  }
  assert_var(body, "pre_checkout_query_id")
  if not body.ok then
    assert(body.error_message, "Missing required variable error_message")
  end
  return self._request(self, "answerPreCheckoutQuery", body)
end

-- Games

function _M:sendGame(...)
  local args = {...}
  local body = is_table(args[1]) or {
    chat_id = args[1],
    game_short_name = args[2],
    disable_notification = args[3],
    reply_to_message_id = args[4],
    reply_markup = args[5]
  }
  assert_var(body, "chat_id", "game_short_name")
  return self._request(self, "sendGame", body)
end

function _M:setGameScore(...)
  local args = {...}
  local body = is_table(args[1]) or {
    user_id = args[1],
    score = args[2],
    force = args[3],
    disable_edit_message = args[4],
    chat_id = args[5],
    message_id = args[6],
    inline_message_id = args[7]
  }
  check_id(body)
  assert_var(body, "user_id", "score")
  return self._request(self, "setGameScore", body)
end

function _M:getGameHighScores(...)
  local args = {...}
  local body = is_table(args[1]) or {
    user_id = args[1],
    chat_id = args[2],
    message_id = args[3],
    inline_message_id = args[4]
  }
  check_id(body)
  assert_var(body, "user_id")
  return self._request(self, "getGameHighScores", body)
end

-- Passthrough unknown methods

local function custom(_, method)
  -- Remember custom methods
  _M[method] = function(self, body, file)
    return self._request(self, method, body, file)
  end
  return _M[method]
end

setmetatable(_M, { __index = custom })

-- Snake case shortcuts for known methods

_M.get_updates = _M.getUpdates
_M.set_webhook = _M.setWebhook
_M.delete_webhook = _M.deleteWebhook
_M.get_webhook_info = _M.getWebhookInfo
_M.get_me = _M.getMe
_M.send_message = _M.sendMessage
_M.forward_message = _M.forwardMessage
_M.send_photo = _M.sendPhoto
_M.send_audio = _M.sendAudio
_M.send_document = _M.sendDocument
_M.send_video = _M.sendVideo
_M.send_voice = _M.sendVoice
_M.send_video_note = _M.sendVideoNote
_M.send_media_group = _M.sendMediaGroup
_M.send_location = _M.sendLocation
_M.edit_message_live_location = _M.editMessageLiveLocation
_M.stop_message_live_location = _M.stopMessageLiveLocation
_M.send_venue = _M.sendVenue
_M.send_contact = _M.sendContact
_M.send_chat_action = _M.sendChatAction
_M.get_user_profile_photos = _M.getUserProfilePhotos
_M.get_file = _M.getFile
_M.kick_chat_member = _M.kickChatMember
_M.unban_chat_member = _M.unbanChatMember
_M.restrict_chat_member = _M.restrictChatMember
_M.promote_chat_member = _M.promoteChatMember
_M.export_chat_invite_link = _M.exportChatInviteLink
_M.set_chat_photo = _M.setChatPhoto
_M.delete_chat_photo = _M.deleteChatPhoto
_M.set_chat_title = _M.setChatTitle
_M.set_chat_description = _M.setChatDescription
_M.pin_chat_message = _M.pinChatMessage
_M.unpin_chat_message = _M.unpinChatMessage
_M.leave_chat = _M.leaveChat
_M.get_chat = _M.getChat
_M.get_chat_administrators = _M.getChatAdministrators
_M.get_chat_members_count = _M.getChatMembersCount
_M.get_chat_member = _M.getChatMember
_M.set_chat_sticker_set = _M.setChatStickerSet
_M.delete_chat_sticker_set = _M.deleteChatStickerSet
_M.answer_callback_query = _M.answerCallbackQuery
_M.edit_message_text = _M.editMessageText
_M.edit_message_caption = _M.editMessageCaption
_M.edit_message_reply_markup = _M.editMessageReplyMarkup
_M.delete_message = _M.deleteMessage
_M.send_sticker = _M.sendSticker
_M.get_sticker_set = _M.getStickerSet
_M.upload_sticker_file = _M.uploadStickerFile
_M.create_new_sticker_set = _M.createNewStickerSet
_M.add_sticker_to_set = _M.addStickerToSet
_M.set_sticker_position_in_set = _M.setStickerPositionInSet
_M.delete_sticker_from_set = _M.deleteStickerFromSet
_M.answer_inline_query = _M.answerInlineQuery
_M.send_invoice = _M.sendInvoice
_M.answer_shipping_query = _M.answerShippingQuery
_M.answer_pre_checkout_query = _M.answerPreCheckoutQuery
_M.send_game = _M.sendGame
_M.set_game_score = _M.setGameScore
_M.get_game_high_scores = _M.getGameHighScores

return _M
