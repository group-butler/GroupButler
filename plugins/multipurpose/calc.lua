local function expr(a)
 		local result = "expr "..a
 		local final_result = result:gsub('+', ' + '):gsub('*', ' \\* '):gsub('/', ' / '):gsub('-', ' - ')
 		local action = io.popen(final_result)
 		local read = action:read("*a")
 		return read
 end
 
local action = function(msg, blocks)
 	if blocks[1] == 'calc' then
 		if blocks[2] then
 			local expression = expr(blocks[2])
 			api.sendReply(msg, 'Result: *'..expression..'*', true)
    else
      api.sendReply(msg, 'calc what?', true)
 		end
 	end
end

return {
	action = action,
	triggers = {
		config.cmd..'(calc) (.+)$',
	}
}
