local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

local function do_keyboard_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = _("Channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = _("GitHub"), url = config.source_code},
    		{text = _("Rate me!"), url = 'https://telegram.me/storebot?start='..bot.username},
		},
		{
			{text = _("👥 Groups"), callback_data = 'private:groups'}
		}
	}
	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type ~= 'private' then return end

	if blocks[1] == 'echo' then
		local res, code = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			api.sendMessage(msg.chat.id, u.get_sm_error_string(code), true)
		end
	end
	if blocks[1] == 'about' then
		local keyboard = do_keyboard_credits()
		local text = _("This bot is based on [GroupButler](https://github.com/RememberTheAir/GroupButler) (AKA @GroupButler_bot, channel: @GroupButler_ch), a multipurpose Lua bot.\nBarrePolice wouldn't exist without it.\n\nThe owner of this bot is @barreeeiroo, do not pm him: use /groups command instead.\n\nBot version: `%s`\n*Some useful links:*"):format(config.human_readable_version .. ' rev.' .. bot.revision)
		api.sendMessage(msg.chat.id, text, true, keyboard)
	end
	if blocks[1] == 'group' then
		if config.help_groups_link and config.help_groups_link ~= '' then
			api.sendMessage(msg.chat.id, _("You can find the list of our support groups in [this channel](%s)"):format(config.help_groups_link), true)
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'about' then
		local keyboard = do_keyboard_credits()
		local text = _("This bot is based on [GroupButler](https://github.com/RememberTheAir/GroupButler) (AKA @GroupButler_bot, channel: @GroupButler_ch), a multipurpose Lua bot.\nBarrePolice wouldn't exist without it.\n\nThe owner of this bot is @barreeeiroo, do not pm him: use /groups command instead.\n\nBot version: `%s`\n*Some useful links:*"):format(config.human_readable_version .. ' rev.' .. bot.revision)
		api.editMessageText(msg.chat.id, msg.message_id, text, true, keyboard)
	end
	if blocks[1] == 'groups' then
		if config.help_groups_link and config.help_groups_link ~= '' then
			api.editMessageText(msg.chat.id, msg.message_id, _("You can find the list of our support groups in [this channel](%s)"):format(config.help_groups_link), true, keyboard)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(echo) (.*)$',
		config.cmd..'(about)$',
		config.cmd..'(group)s?$',
		'^/start (group)s$'
	},
	onCallbackQuery = {
		'^###cb:fromhelp:(about)$',
		'^###cb:private:(groups)$',
	}
}

return plugin
