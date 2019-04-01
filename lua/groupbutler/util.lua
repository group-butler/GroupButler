local json = require("cjson")

-- Stateless utility functions
local Util = {}

function Util.Enum(t)
	local new_t = {}
	for k,v in pairs(t) do
		new_t[k] = v
		new_t[v] = k
	end
	return new_t
end

function Util.setDefaultTableValue(t, d)
	assert(t, debug.traceback())
	local mt = {__index = function() return d end}
	return setmetatable(t, mt)
end

function Util.mergeTables(t1, t2)
	local t3 = json.decode(json.encode(t1)) -- TODO: Copy t1 properly. This is ugly
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            t3[k] = Util.mergeTables(t1[k], t2[k])
        else
            t3[k] = v
        end
    end
    return t3
end

return Util
