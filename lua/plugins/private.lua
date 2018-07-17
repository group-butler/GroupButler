local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local locale = require 'languages'
local i18n = locale.translate

local plugin = {}

local function do_keyboard_credits()
	local keyboard = {}
	keyboard.inline_keyboard = {
		{
			{text = i18n("Channel"), url = 'https://telegram.me/'..config.channel:gsub('@', '')},
			{text = i18n("GitHub"), url = config.source_code},
			{text = i18n("Rate me!"), url = 'https://telegram.me/storebot?start='..bot.username},
		},
		{
			{text = i18n("👥 Groups"), callback_data = 'private:groups'}
		}
	}
	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type ~= 'private' then return end

	if blocks[1] == 'ping' then
		api.sendMessage(msg.from.id, i18n("Pong!"), true)
		-- local res = api.sendMessage(msg.from.id, i18n("Pong!"), true)
		--[[if res then
			api.editMessageText(msg.chat.id, res.result.message_id, 'Response time: '..(os.clock() - clocktime_last_update))
		end]]
	end
	if blocks[1] == 'echo' then
		local res, code = api.sendMessage(msg.chat.id, blocks[2], true)
		if not res then
			api.sendMessage(msg.chat.id, u.get_sm_error_string(code), true)
		end
	end
	if blocks[1] == 'about' then
		local keyboard = do_keyboard_credits()
		local text = i18n([[
This bot is based on [otouto](https://github.com/topkecleon/otouto) (AKA @mokubot, channel: @otouto), a multipurpose Lua bot.\nGroup Butler wouldn't exist without it.\n\nYou can contact the owners of this bot using the /groups command.\n\nBot version: `%s`\n*Some useful links:*
]]):format(config.human_readable_version)
		api.sendMessage(msg.chat.id, text, true, keyboard)
	end
	if blocks[1] == 'group' then
		if config.help_group and config.help_group ~= '' then
			api.sendMessage(msg.chat.id,
				i18n('You can find the list of our support groups in [this channel](%s)'):format(config.help_group), true)
		end
	end
end

function plugin.onCallbackQuery(msg, blocks)
	if blocks[1] == 'about' then
		local keyboard = do_keyboard_credits()
		local text = i18n([[
This bot is based on [otouto](https://github.com/topkecleon/otouto) (AKA @mokubot, channel: @otouto), a multipurpose Lua bot.\nGroup Butler wouldn't exist without it.\n\nThe owner of this bot is @baconn, do not pm him: use /groups command instead.\n\nBot version: `%s`\n*Some useful links:*
]]):format(config.human_readable_version)
		api.editMessageText(msg.chat.id, msg.message_id, text, true, keyboard)
	end
	if blocks[1] == 'group' then
		if config.help_group and config.help_group ~= '' then
			local markup = {inline_keyboard={{{text = i18n('🔙 back'), callback_data = 'fromhelp:about'}}}}
			api.editMessageText(msg.chat.id, msg.message_id,
				i18n("You can find the list of our support groups in [this channel](%s)"):format(config.help_group), true, markup)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(ping)$',
		config.cmd..'(echo) (.*)$',
		config.cmd..'(about)$',
		config.cmd..'(group)s?$',
		'^/start (group)s$'
	},
	onCallbackQuery = {
		'^###cb:fromhelp:(about)$',
		'^###cb:private:(group)s$'
	}
}

return plugin
