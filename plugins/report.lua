local plugin = {}

local function report(msg, description, realm_id)
    local text = _('• <b>Message reported by</b>: %s (<code>%d</code>)\n• <b>Group</b>: %s'):format(misc.getname_final(msg.from), msg.from.id, msg.chat.title:escape_html())
    if msg.reply.sticker then
        text = text.._('\n• <b>Sticker sent by</b>: %s [<code>%d</code>]'):format(misc.getname_final(msg.reply.from), msg.reply.from.id)
    end
    if msg.chat.username then
        text = text.._('\n• <a href="%s">Go to the message</a>'):format('telegram.me/'..msg.chat.username..'/'..msg.message_id)
    end
    if description then
        text = text.._('\n• <b>Description</b>: <i>%s</i>'):format(description:escape_html())
    end
    
    local n = 0
    
    if realm_id then
        local res_fwd = api.forwardMessage(realm_id, msg.chat.id, msg.reply.message_id)
        if res_fwd then
            api.sendMessage(realm_id, text, 'html', nil, res_fwd.result.message_id)
        end
        n = -1
    else
        local res = api.getChatAdministrators(msg.chat.id)
        if not res then return false end
        
        for i, admin in pairs(res.result) do
            local receive_reports = db:hget('user:'..admin.user.id..':settings', 'reports')
            if receive_reports and receive_reports == 'on' then
                local res_fwd = api.forwardMessage(admin.user.id, msg.chat.id, msg.reply.message_id)
                if res_fwd then
                    api.sendMessage(admin.user.id, text, 'html', nil, res_fwd.result.message_id)
                    n = n + 1
                end
            end
        end
    end
    
    return n
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type == 'private' or roles.is_admin_cached(msg) or not msg.reply then return end
    if roles.is_admin_cached(msg.reply) then return end
    local status = (db:hget('chat:'..msg.chat.id..':settings', 'Reports')) or config.chat_settings['settings']['Reports']
    if not status or status == 'off' then return end
    
    local realm_id = db:get('chat:'..msg.chat.id..':realm')
    local n_sent = report(msg, blocks[1], realm_id) or 0
    
    local text
    
    if n_sent < 0 then
        text = _('_Reported in the admins group_')
    else
        text = _('_Reported to %d admin(s)_'):format(n_sent)
    end
    
    api.sendReply(msg, text, true)
end

plugin.triggers = {
    onTextMessage = {
        '^@admin$',
        '^@admin (.*)',
        config.cmd..'report$',
        config.cmd..'report (.*)',
    }
}

return plugin
