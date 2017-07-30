local json = require 'cjson'
local main = require 'main'

-- Decode the update
ngx.req.read_body()
local update = ngx.req.get_body_data()
ngx.log(ngx.DEBUG, 'Incoming update: '..update)
update = assert(json.decode(update))

local response_body = main.parseMessageFunction(update)

-- Finally, encode the response and send it to Telegram
response_body = json.encode(response_body or {})
ngx.status = ngx.HTTP_OK
ngx.header.content_type = "application/json; charset=utf-8"
ngx.header.content_length = #response_body
ngx.say(response_body)
ngx.log(ngx.DEBUG, 'Outgoing response: '..response_body)
