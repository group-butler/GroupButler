local null

if ngx and ngx.null then
	null = ngx.null
else
	null = require "cjson".null
end

return null
