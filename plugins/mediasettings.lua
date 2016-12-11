local config = require 'config'
local misc = require 'utilities'.misc
local roles = require 'utilities'.roles
local api = require 'methods'

local plugin = {}

local function doKeyboard_media(chat_id)
	if not ln then ln = 'en' end
    local keyboard = {}
    keyboard.inline_keyboard = {}
    for media, default_status in pairs(config.chat_settings['media']) do
    	local status = (db:hget('chat:'..chat_id..':media', media)) or default_status
        if status == 'ok' then
            status = '✅'
        else
            status = '❌'
        end

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
			location = _("Locations")
		}
        local media_text = media_texts[media] or media
        local line = {
            {text = media_text, callback_data = 'mediallert:'..chat_id},
            {text = status, callback_data = 'media:'..media..':'..chat_id}
        }
        table.insert(keyboard.inline_keyboard, line)
    end
    
    --MEDIA WARN
    --action line
    local max = (db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or config.chat_settings['warnsettings']['mediamax']
    local action = (db:hget('chat:'..chat_id..':warnsettings', 'mediatype')) or config.chat_settings['warnsettings']['mediatype']
	local caption
	if action == 'kick' then
		caption = _("Warns (media) 📍 %d | kick"):format(tonumber(max))
	else
		caption = _("Warns (media) 📍 %d | ban"):format(tonumber(max))
	end
    table.insert(keyboard.inline_keyboard, {{text = caption, callback_data = 'mediatype:'..chat_id}})
    --buttons line
    local warn = {
        {text = '➖', callback_data = 'mediawarn:dim:'..chat_id},
        {text = '➕', callback_data = 'mediawarn:raise:'..chat_id},
    }
    table.insert(keyboard.inline_keyboard, warn)
    
    --back button
    table.insert(keyboard.inline_keyboard, {{text = '🔙', callback_data = 'config:back:'..chat_id}})
    
    return keyboard
end

function plugin.onCallbackQuery(msg, blocks)
	local chat_id = msg.target_id
	if not chat_id then
		api.sendAdmin('msg.target_id missing -> mediasettings') return
	end
	
	if not roles.is_admin_cached(chat_id, msg.from.id) then
		api.answerCallbackQuery(msg.cb_id, _("You're no longer an admin"))
	else
		local media_first = _([[
Tap on a voice in the right colon to *change the setting*
You can use the last line to change how many warnings should the bot give before kick / ban someone for a forbidden media
The number is not related the the normal `/warn` command
]])
	
		if  blocks[1] == 'config' then
			local keyboard = doKeyboard_media(chat_id)
		    api.editMessageText(msg.chat.id, msg.message_id, media_first, true, keyboard)
		else
			if blocks[1] == 'mediallert' then
				api.answerCallbackQuery(msg.cb_id, _("⚠️ Tap on the right column"))
				return
			end
			local cb_text
			if blocks[1] == 'mediawarn' then
				local current = tonumber(db:hget('chat:'..chat_id..':warnsettings', 'mediamax')) or 2
				if blocks[2] == 'dim' then
					if current < 2 then
						cb_text = _("⚙ The new value is too low ( < 1)")
					else
						local new = db:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', -1)
						cb_text = string.format('⚙ %d → %d', current, new)
					end
				elseif blocks[2] == 'raise' then
					if current > 11 then
						cb_text = _("⚙ The new value is too high ( > 12)")
					else
						local new = db:hincrby('chat:'..chat_id..':warnsettings', 'mediamax', 1)
						cb_text = string.format('⚙ %d → %d', current, new)
					end
				end
			end
			if blocks[1] == 'mediatype' then
				local hash = 'chat:'..chat_id..':warnsettings'
				local current = (db:hget(hash, 'mediatype')) or config.chat_settings['warnsettings']['mediatype']
				if current == 'ban' then
					db:hset(hash, 'mediatype', 'kick')
					cb_text = _("🔨 New status is kick")
				else
					db:hset(hash, 'mediatype', 'ban')
					cb_text = _("🔨 New status is ban")
				end
			end
			if blocks[1] == 'media' then
				local media = blocks[2]
		    	cb_text = '⚡️ '..misc.changeMediaStatus(chat_id, media, 'next')
    	    end
    	    local keyboard = doKeyboard_media(chat_id)
			api.editMessageText(msg.chat.id, msg.message_id, media_first, true, keyboard)
    	    api.answerCallbackQuery(msg.cb_id, cb_text)
    	end
	end
end

plugin.triggers = {
	onCallbackQuery = {
		'^###cb:(media):(%a+):(-?%d+)',
		'^###cb:(mediatype):(-?%d+)',
		'^###cb:(mediawarn):(%a+):(-?%d+)',
		'^###cb:(mediallert)',
		
		'^###cb:(config):media:(-?%d+)$'
	}
}

return plugin
