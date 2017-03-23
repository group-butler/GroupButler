local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local mod = { 
    promote = function(chat_id, user)
        assert(user.id, "mod.promote: user.id missing")
        
        db:hmset(('chat:%d:mod:%d'):format(chat_id, tonumber(user.id)), user)
        local added = db:sadd('chat:'..chat_id..':mods', user.id)
        
        return added == 1
    end,
    demote = function(chat_id, user)
        assert(user.id, "mod.demote: user.id missing")
        
        db:del(('chat:%d:mod:%d'):format(chat_id, tonumber(user.id)))
        local removed = db:srem('chat:'..chat_id..':mods', user.id)
        
        return removed == 1
    end
}

local function promdem_user(msg, blocks, action)
    if not msg.reply and not blocks[2] then
        return nil, _("Reply to someone, or mention him")
    else
        local user = {}
        if msg.reply then
            if msg.reply.from.id == bot.id then
                return nil, _("You can't promote or demote me")
            end
            user = msg.reply.from
        elseif msg.mention_id then
            for _, entity in pairs(msg.entities) do
			    if entity.user and entity.user.id == msg.mention_id then
				    user = entity.user
			    end
	        end
        elseif msg.text:match(config.cmd..action..' @%a[%w_]+$') then
            local username = msg.text:match(config.cmd..action..' (@%a[%w_]+)$')
            user.id = u.resolve_user(username)
            if not user.id then
                return nil, _("I've never seen this user before.\nIf you want to teach me who is he, forward me a message from him")
            end
            user.first_name = username
            user.username = username
        elseif msg.text:match(config.cmd..action..' %d+$') then
            user.id = msg.text:match(config.cmd..action..' (%d+)$')
            user.first_name = user.id
        else
            return nil, _("Reply to someone, or mention him")
        end
        
        if u.is_admin(msg.chat.id, user.id) then
            return nil, _("I'm sorry, you can't promote this user because he's already an admin")
        end
        
        return true, user, mod[action](msg.chat.id, user)
    end
end     

local function can_promdemote(chat_id, user, is_admin)
    if not is_admin then
        return false
    elseif u.is_owner(chat_id, user.id) then
        return true
    else
        local status = db:hget('chat:'..chat_id..':modsettings', 'promdem') or config.chat_settings['modsettings']['promdem']
        return status == 'yes'
    end
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.id < 0 then
        if can_promdemote(msg.chat.id, msg.from, msg.from.admin) then
            if blocks[1] == 'promote' then
                local res, extra, new_mod = promdem_user(msg, blocks, 'promote') --if success, 'extra' is an user object
                if not res then
                    api.sendReply(msg, extra)
                else
                    local text
                    local name = u.getname_final(extra)
                    if new_mod then
                        u.logEvent('promote', msg, {admin = u.getname_final(msg.from), user = name, user_id = extra.id})
                        text = _("%s now is a moderator"):format(name)
                    else
                        text = _("%s is already a moderator. I have updated his name."):format(name)
                    end
                    api.sendReply(msg, text, 'html')
                end
            end
            if blocks[1] == 'demote' then
                local res, extra, was_mod = promdem_user(msg, blocks, 'demote')
                if not res then
                    api.sendReply(msg, extra)
                else
                    local text
                    if was_mod then
                        local name = u.getname_final(extra)
                        u.logEvent('demote', msg, {admin = u.getname_final(msg.from), user = name, user_id = extra.id})
                        text = _("%s is no longer a moderator"):format(name)
                    else
                        text = _("<i>This user was not a moderator</i>")
                    end
                    api.sendReply(msg, text, 'html')
                end
            end
        end
        
        if blocks[1] == 'modlist' then
            local is_empty, text = u.getModlist(msg.chat.id)
            if is_empty then
                api.sendReply(msg, text, 'html')
            else
                if msg.from.mod then
                    api.sendReply(msg, text, 'html')
                else
                    api.sendMessage(msg.from.id, text, 'html')
                end
            end
        end
		if blocks[1] == 'clean' and blocks[2] == 'modlist' then
			local hash = 'chat:'..msg.chat.id..':mods'
			db:del(hash)
			api.sendReply(msg, _("The moderators list have been clean successfully."))
		end
    end    
end

local function toggleModeratorsSetting(chat_id, key)
    local hash = 'chat:'..chat_id..':modsettings'
    local current = (db:hget(hash, key)) or config.chat_settings['modsettings'][key]
    local new
    if current == 'yes' then new = 'no' else new = 'yes' end
    
    db:hset(hash, key, new)
    
    return '✅'
end

local function get_alert_text(key)
    if key == 'hammer' then
        return _("If enabled, moderators will be able to use their banhammer powers")
    elseif key == 'config' then
        return _("If enabled, moderators will be able to use the /config command (and change the group settings)")
    elseif key == 'texts' then
        return _("If enabled, moderators will be able to change the rules, save a new link, or set/delete #extra commands")
    elseif key == 'promdem' then
        return _("The group administrators will be able to promote or demote new moderators, and also to see this section of the setting (but not this switch)")
    else
        return _("Description not available")
    end
end

local function doKeyboard_mods_rights(chat_id, is_owner)
    local keyboard = {inline_keyboard = {}}
    local humanizations = {
        ['promdem'] = _('Admins can manage mods'),
        ['hammer'] = _('Banhammer'),
        ['config'] = _('Group configuration'),
        ['texts'] = _('Group info'),
    }
    for field, value in pairs(config.chat_settings['modsettings']) do
        local line, status, icon
        if field ~= 'promdem' then
            icon = '✅'
            status = (db:hget('chat:'..chat_id..':modsettings', field)) or config.chat_settings['modsettings'][field]
            if status == 'no' then icon = '❌' end
            line = {
                {text = _(humanizations[field] or field), callback_data = 'modsettings:alert:'..field..':'..locale.language},
                {text = icon, callback_data = 'modsettings:toggle:'..field..':'..chat_id}
            }
            table.insert(keyboard.inline_keyboard, line)
        elseif field == 'promdem' and is_owner then
            icon = '✅'
            status = (db:hget('chat:'..chat_id..':modsettings', field)) or config.chat_settings['modsettings'][field]
            if status == 'no' then icon = '❌' end
            line = {
                {text = _(humanizations[field] or field), callback_data = 'modsettings:alert:'..field..':'..locale.language},
                {text = icon, callback_data = 'modsettings:toggle:'..field..':'..chat_id}
            }
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

function plugin.onCallbackQuery(msg, blocks)
    if blocks[1] == 'alert' then
		if config.available_languages[blocks[3]] then
			locale.language = blocks[3]
		end
	    local text = get_alert_text(blocks[2])
	    api.answerCallbackQuery(msg.cb_id, text, true, config.bot_settings.cache_time.alert_help)
	else
	    
	    local chat_id = msg.target_id
	    if not u.is_allowed('config', chat_id, msg.from) then
	    	api.answerCallbackQuery(msg.cb_id, _("You're no longer an admin"))
	    else
	        local mod_first = _([[*Moderators settings*
Choose what a moderator can do.
When one or more of the permissions below are given to the moderators, they will be able to use the associated commands.

• ✅ = *enabled*
• ❌ = *not enabled*

• *Banhammer* permissions - mods will be allowed to use: /ban, /kick, /unban, /tempban, /user, /status, /warn, /nowarn, /block, /unblock.
• *Group info* permissions - mods will be allowed to use: /setrules, /welcome, /extra, /link, /setlink, /blockedlist. Also, they will be seen as admins when /rules, /adminlist, /modlist, /id or an #extra command are used.
• *Group configuration* permissions - mods will be able to use the /config command, and change the group settings. Obviously, they won't be able to see the "Moderators" section. They can also use /setlang and /reportflood

Moderators will be never able to use: /cache, /leave, /snap, /import, /setlog and /unsetlog
]])
        
            local reply_markup, text, is_owner
            
            if blocks[1] == 'toggle' then
                text = toggleModeratorsSetting(chat_id, blocks[2])
            end
            
            is_owner = u.is_owner(chat_id, msg.from.id)
            reply_markup = doKeyboard_mods_rights(chat_id, is_owner)
            api.editMessageText(msg.chat.id, msg.message_id, mod_first, true, reply_markup)
            if text then api.answerCallbackQuery(msg.cb_id, text) end
        end
    end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(promote)$',
		config.cmd..'(promote) (.+)$',
		config.cmd..'(demote)$',
		config.cmd..'(demote) (.+)$',
		config.cmd..'(modlist)$'
		config.cmd..'(clean) (modlist)$'
	},
	onCallbackQuery = {
		'^###cb:config:mods:(-%d+)$',
		'^###cb:modsettings:(toggle):(%w+):(-%d+)$',
        '^###cb:modsettings:(alert):(%w+):([%w_]+)$',
	}
}

return plugin
