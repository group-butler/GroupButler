local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function table_join(t1, t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end

    return t1
end

local function get_admin_mod_list(admins_list, chat_id)
    if not admins_list then
        admins_list = {}
    end

    local mods_have_hammer = db:hget('chat:'..chat_id..':modsettings', 'hammer') or config.chat_settings['modsettings']['hammer']
    if mods_have_hammer == 'yes' then
        local mods = db:smembers('chat:'..chat_id..':mods')
        if next(mods) then
            admins_list = table_join(admins_list, mods)
        end
    end

    if next(admins_list) then
        return admins_list
    else
        return nil
    end
end

local function seconds2minutes(seconds)
    seconds = tonumber(seconds)
    local minutes = math.floor(seconds/60)
    local seconds = seconds % 60
    return minutes, seconds
end

local function report(msg, description)
    local text = _('• <b>Message reported by</b>: %s (<code>%d</code>)'):format(u.getname_final(msg.from), msg.from.id)
    local chat_link = db:hget('chat:'..msg.chat.id..':links', 'link')
    if msg.reply.forward_from or msg.reply.forward_from_chat or msg.reply.sticker then
        text = text.._('\n• <b>Reported message sent by</b>: %s (<code>%d</code>)'):format(u.getname_final(msg.reply.from), msg.reply.from.id)
    end
    if chat_link then
        text = text.._('\n• <b>Group</b>: <a href="%s">%s</a>'):format(chat_link, msg.chat.title:escape_html())
    else
        text = text.._('\n• <b>Group</b>: %s'):format(msg.chat.title:escape_html())
    end
    if msg.chat.username then
        text = text.._('\n• <a href="%s">Go to the message</a>'):format('telegram.me/'..msg.chat.username..'/'..msg.message_id)
    end
    if description then
        text = text.._('\n• <b>Description</b>: <i>%s</i>'):format(description:escape_html())
    end

    local n = 0

    local admins_list = u.get_cached_admins_list(msg.chat.id)
    admins_list = get_admin_mod_list(admins_list, msg.chat.id)
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

local function user_is_abusing(chat_id, user_id)
    local hash = 'chat:'..chat_id..':report'
    local user_key = hash..':'..user_id
    local times = tonumber(db:get(user_key)) or 1
    local times_allowed = tonumber(db:hget(hash, 'times_allowed')) or config.bot_settings.report.times_allowed
    local duration = tonumber(db:hget(hash, 'duration')) or config.bot_settings.report.duration
    if times <= times_allowed then
        db:setex(user_key, duration, times + 1)
        return false
    else
        local ttl = db:ttl(user_key)
        db:setex(user_key, tonumber(ttl), times)
        return true
    end
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.id < 0 then
        if #blocks > 1 and u.is_allowed('config', msg.chat.id, msg.from) then
            local times_allowed, duration = tonumber(blocks[2]), tonumber(blocks[3])
            local text
            if times_allowed < 1 or times_allowed > 1000 then
                text = _("_Invalid value:_ number of times allowed (`input: %d`)"):format(times_allowed)
            elseif duration < 1 or duration > 10080 then
                text = _("_Invalid value:_ time (`input: %d`)"):format(duration)
            else
                local hash = 'chat:'..msg.chat.id..':report'
                db:hset(hash, 'times_allowed', times_allowed)
                db:hset(hash, 'duration', (duration * 60))
                text = _("*New parameters saved*.\nUsers will be able to use @admin %d times/%d minutes"):format(times_allowed, duration)
            end
            api.sendReply(msg, text, true)
        else
            if msg.from.admin
                or not msg.reply
                or u.is_mod(msg.chat.id, msg.reply.from.id) then
                return
            end

            local status = (db:hget('chat:'..msg.chat.id..':settings', 'Reports')) or config.chat_settings['settings']['Reports']
            if not status or status == 'off' then return end

            local text
            if user_is_abusing(msg.chat.id, msg.from.id) then
                local hash = 'chat:'..msg.chat.id..':report'
                local duration = tonumber(db:hget(hash, 'duration')) or config.bot_settings.report.duration
                local times_allowed = tonumber(db:hget(hash, 'times_allowed')) or config.bot_settings.report.times_allowed
                local ttl = db:ttl(hash..':'..msg.from.id)
                local minutes, seconds = seconds2minutes(ttl)
                text = _([[_Please, do not abuse this command. It can be used %d times every %d minutes_.
Wait other %d minutes, %d seconds.]]):format(times_allowed, (duration / 60), minutes, seconds)
                api.sendReply(msg, text, true)
            else
                local description
                if blocks[1] and blocks[1] ~= '@admin' and blocks[1] ~= config.cmd..'report' then
                    description = blocks[1]
                end

                local n_sent = report(msg, description) or 0

                text = _('_Reported to %d admin(s)_'):format(n_sent)

                u.logEvent('report', msg, {n_admins = n_sent})
                api.sendReply(msg, text, true)
            end
        end
    end
end

plugin.triggers = {
    onTextMessage = {
        '^@admin$',
        '^@admin (.+)',
        config.cmd..'report$',
        config.cmd..'report (.+)',
        config.cmd..'(reportflood) (%d+)[%s/:](%d+)'
    }
}

return plugin
