-- Make telegram aware the update was received
ngx.status = ngx.HTTP_OK
ngx.say('{ }')

-- Init redis connection
local red = redis_client:new()
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(config.redis_host, config.redis_port)
if not ok then
	ngx.log(ngx.CRIT, "redis connection failed: ", err)
	return
end
red:select(config.redis_db) -- Select the redis db

-- Init postgres connection
local pg = pgmoon.new({
	host = config.db_host,
	port = config.db_port,
	user = config.db_user,
	database = config.db_db,
	password =  config.db_pass
})
assert(pg:connect())

-- read POST body
-- ngx.req.read_body()
-- local body = ngx.req.get_body_data()

-- ngx.log(ngx.ERR,body) -- Print received request to terminal

api.sendAdmin('aaaaaaaaaaaaaaa', true)
pg:keepalive() -- Allows this connection to be reused by future requests
