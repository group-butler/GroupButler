local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

local function getFloodSettings_text(chat_id)
    local status = db:hget('chat:'..chat_id..':settings', 'Flood') or 'yes' --check (default: disabled)
    if status == 'no' or status == 'on' then
        status = _("✅ | ON")
    elseif status == 'yes' or status == 'off' then
        status = _("❌ | OFF")
    end
    local hash = 'chat:'..chat_id..':flood'
    local action = (db:hget(hash, 'ActionFlood')) or 'kick'
    if action == 'kick' then
        action = _("👞 kick")
    else
        action = _("🔨️ ️ban")
    end
    local num = (db:hget(hash, 'MaxFlood')) or 5
    local exceptions = {
        text = _("Texts"),
		forward = _("Forwards"),
        sticker = _("Stickers"),
        photo = _("Images"),
        gif = _("GIFs"),
        video = _("Videos"),
    }
    hash = 'chat:'..chat_id..':floodexceptions'
    local list_exc = ''
    for media, translation in pairs(exceptions) do
        --ignored by the antiflood-> yes, no
        local exc_status = (db:hget(hash, media)) or 'no'
        if exc_status == 'yes' then
            exc_status = '✅'
        else
            exc_status = '❌'
        end
        list_exc = list_exc..'• `'..translation..'`: '..exc_status..'\n'
    end
    return _("- *Status*: `%s`\n"):format(status)
			.. _("- *Action* to perform when an user floods: `%s`\n"):format(action)
			.. _("- Number of messages allowed *every 5 seconds*: `%d`\n"):format(num)
			.. _("- *Ignored media*:\n%s"):format(list_exc)
end

local function doKeyboard_dashboard(chat_id)
    local keyboard = {}
    keyboard.inline_keyboard = {
	    {
            {text = _("Settings"), callback_data = 'dashboard:settings:'..chat_id},
            {text = _("Admins"), callback_data = 'dashboard:adminlist:'..chat_id}
		},
	    {
		    {text = _("Rules"), callback_data = 'dashboard:rules:'..chat_id},
		    {text = _("Extra commands"), callback_data = 'dashboard:extra:'..chat_id}
        },
	    {
	   	    {text = _("Flood settings"), callback_data = 'dashboard:flood:'..chat_id},
	   	    {text = _("Media settings"), callback_data = 'dashboard:media:'..chat_id}
	    },
    }
    
    return keyboard
end

function plugin.onTextMessage(msg, blocks)
    if msg.chat.type ~= 'private' then
        local chat_id = msg.chat.id
        local keyboard = doKeyboard_dashboard(chat_id)
        local res = api.sendMessage(msg.from.id, _("Navigate this message to see *all the info* about this group!"), true, keyboard)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                api.sendMessage(msg.chat.id, _("_I've sent you the group dashboard via private message_"), true)
            else
                misc.sendStartMe(msg)
            end
        end
    end
end

function plugin.onCallbackQuery(msg, blocks)
    local chat_id = msg.target_id
    local request = blocks[2]
    local text, notification
    local parse_mode = true
	local res = api.getChat(chat_id)
	if not res then
		api.answerCallbackQuery(msg.cb_id, _("🚫 This group does not exist"))
		return
	end
	-- Private chats don't have an username
	local private = not res.result.username
	local res = api.getChatMember(chat_id, msg.from.id)
	if not res or (res.result.status == 'left' or res.result.status == 'kicked') and private then
		api.editMessageText(msg.from.id, msg.message_id, _("🚷 You are not a member of the chat. " ..
			"You can't see the settings of a private group."))
		return
	end
    local keyboard = doKeyboard_dashboard(chat_id)
    if request == 'settings' then
        text = misc.getSettings(chat_id)
        notification = _("ℹ️ Group ► Settings")
    end
    if request == 'rules' then
        text = misc.getRules(chat_id)
        notification = _("ℹ️ Group ► Rules")
    end
    if request == 'adminlist' then
        parse_mode = 'html'
        local creator, admins = misc.getAdminlist(chat_id)
        if not creator then
            -- creator is false, admins is the error code
            text = _("I got kicked out of this group 😓")
        else
            text = _("<b>Creator</b>:\n%s\n\n<b>Admins</b>:\n%s"):format(creator, admins)
        end
        notification = _("ℹ️ Group ► Admin list")
    end
    if request == 'extra' then
        text = misc.getExtraList(chat_id)
        notification = _("ℹ️ Group ► Extra")
    end
    if request == 'flood' then
        text = getFloodSettings_text(chat_id)
        notification = _("ℹ️ Group ► Flood")
    end
    if request == 'media' then
		local media_texts = {
			photo = _("Images"),
			gif = _("GIFs"),
			video = _("Videos"),
			document = _("Documents"),
			TGlink = _("telegram.me links"),
			voice = _("Vocal messages"),
			link = _("Links"),
			audio = _("Music"),
			sticker = _("Stickers"),
			contact = _("Contacts"),
			game = _("Games"),
			location = _("Locations"),
		}
        text = _("*Current media settings*:\n\n")
        for media, default_status in pairs(config.chat_settings['media']) do
            local status = (db:hget('chat:'..chat_id..':media', media)) or default_status
            if status == 'ok' then
                status = '✅'
            else
                status = '🚫'
            end
            local media_cute_name = media_texts[media] or media
            text = text..'`'..media_cute_name..'` ≡ '..status..'\n'
        end
        notification = _("ℹ️ Group ► Media")
    end
    api.editMessageText(msg.from.id, msg.message_id, text, parse_mode, keyboard)
    api.answerCallbackQuery(msg.cb_id, notification)
end

plugin.triggers = {
    onTextMessage = {config.cmd..'(dashboard)$'},
    onCallbackQuery = {'^###cb:(dashboard):(%a+):(-%d+)'}
}
        
return plugin
