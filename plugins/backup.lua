
local triggers = {
	"^/(backup)$"
}

local function action(msg)
    
    if msg.from.id ~= config.admin then
		print('\27[31mNil: not admin\27[39m')
		return
	end
    
    local cmd = io.popen('sudo tar -cpf GroupButler.tar *')
    cmd:read('*all')
    cmd:close()
    sendDocument(msg.from.id, './GroupButler.tar')
end

return {
	action = action,
	triggers = triggers
}