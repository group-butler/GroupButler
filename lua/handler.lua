-- Make telegram aware the update was received
ngx.status = ngx.HTTP_OK
ngx.say('{ }')

-- read POST body
-- ngx.req.read_body()
-- local body = ngx.req.get_body_data()

-- ngx.log(ngx.ERR,body) -- Print received request to terminal

api.sendAdmin('aaaaaaaaaaaaaaa', true)
