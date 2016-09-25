local function action(msg, blocks)
    if msg.chat.type ~= 'private' and roles.is_admin_cached(msg) then
        if not msg.reply then return end
        local text
        local res
        res, text = pcall(
            function()
                return msg.reply.text:gsub(blocks[1], blocks[2])
            end
        )
        if res == false then
            api.sendReply(msg, 'Malformed pattern!')
        else
            text = 'Did you mean:\n'..text
            api.sendReply(msg.reply, text)
        end
    end
end

return {
    action = action,
    triggers = {config.cmd..'?s/(.-)/(.-)$'}
}