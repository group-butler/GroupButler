local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

local function report(msg, description)
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
    
    local admins_list = misc.get_cached_admins_list(msg.chat.id)
    if not admins_list then return false end
    
    for i=1, #admins_list do
        local receive_reports = db:hget('user:'..admins_list[i]..':settings', 'reports')
        if receive_reports and receive_reports == 'on' then
            local res_fwd = api.forwardMessage(admins_list[i], msg.chat.id, msg.reply.message_id)
            if res_fwd then
                api.sendMessage(admins_list[i], text, 'html', nil, res_fwd.result.message_id)
                n = n + 1
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
    
    local description
    if blocks[1] and blocks[1] ~= '@admin' and blocks[1] ~= config.cmd..'report' then
        description = blocks[1]
    end
    
    local n_sent = report(msg, description) or 0
    
    local text = _('_Reported to %d admin(s)_'):format(n_sent)
    
    misc.logEvent('report', msg, {n_admins = n_sent})
    api.sendReply(msg, text, true)
end

plugin.triggers = {
    onTextMessage = {
        '^@admin$',
        '^@admin (.+)',
        config.cmd..'report$',
        config.cmd..'report (.+)',
    }
}

return plugin
