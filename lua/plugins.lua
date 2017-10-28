local config = require 'config'

local plugins = {}

for _, v in ipairs(config.plugins) do
	local p = require('plugins.'..v)
	package.loaded['plugins.'..v] = nil
	if p.triggers then
		for funct, trgs in pairs(p.triggers) do
			for i = 1, #trgs do
				-- interpret any whitespace character in commands just as space
				trgs[i] = trgs[i]:gsub(' ', '%%s+')
			end
			if not p[funct] then
				p.trgs[funct] = nil
				print(funct..' triggers ignored in '..v..': '..funct..' function not defined')
			end
		end
	end
	table.insert(plugins, p)
end

return plugins
