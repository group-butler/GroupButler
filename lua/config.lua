-- Editing this file directly is now highly disencouraged. You should instead use environment variables. This new method is a WIP, so if you need to change something which doesn't have a env var, you are encouraged to open an issue or a PR
local json = require 'cjson'
local open = io.open

local function read_secret(path)
	local file = open('/run/secrets/'..path, "rb")
	if not file then return nil end
	local content = file:read "*a"
	file:close()
	return content
end

local _M =
{
	-- Getting updates
	telegram =
	{
		token = assert(read_secret('telegram/token') or os.getenv('TG_TOKEN'),
			'You must export $TG_TOKEN with your Telegram Bot API token'),
		allowed_updates = os.getenv('TG_UPDATES') or {'message', 'edited_message', 'callback_query'},
		polling =
		{
			limit = os.getenv('TG_POLLING_LIMIT'), -- Not implemented
			timeout = os.getenv('TG_POLLING_TIMEOUT') -- Not implemented
		},
		webhook = -- Not implemented
		{
			url = os.getenv('TG_WEBHOOK_URL'),
			certificate = read_secret('telegram/webhook/certificate') or os.getenv('TG_WEBHOOK_CERT'),
			max_connections = os.getenv('TG_WEBHOOK_MAX_CON')
		}
	},

	-- Data
	postgres = -- Not implemented
	{
		host = os.getenv('POSTGRES_HOST') or 'localhost',
		port = os.getenv('POSTGRES_PORT') or 5432,
		user = os.getenv('POSTGRES_USER') or 'postgres',
		password = read_secret('postgres/password') or os.getenv('POSTGRES_PASSWORD') or 'postgres',
		database = os.getenv('POSTGRES_DB') or 'groupbutler',
	},
	redis =
	{
		host = os.getenv('REDIS_HOST') or 'localhost',
		port = os.getenv('REDIS_PORT') or 6379,
		db = os.getenv('REDIS_DB') or 0
	},

	-- Aesthetic
	lang = os.getenv('DEFAULT_LANG') or 'en',
	human_readable_version = os.getenv('VERSION') or 'unknown',
	channel = os.getenv('CHANNEL') or '@groupbutler_beta',
	source_code = os.getenv('SOURCE') or 'https://github.com/RememberTheAir/GroupButler/tree/beta',
	help_group = os.getenv('HELP_GROUP') or 'telegram.me/GBgroups',

	-- Core
	log =
	{
		chat = assert(os.getenv('LOG_CHAT'), 'You must export $LOG_CHAT with the numerical ID of the log chat'),
		admin = assert(os.getenv('LOG_ADMIN'), 'You must export $LOG_ADMIN with your Telegram ID'),
		stats = os.getenv('LOG_STATS')
	},
	superadmins = assert(json.decode(os.getenv('SUPERADMINS')),
		'You must export $SUPERADMINS with a JSON array containing at least your Telegram ID'),
	cmd = '^[/!#]',
	bot_settings = {
		cache_time = {
			adminlist = 18000, --5 hours (18000s) Admin Cache time, in seconds.
			alert_help = 72,  -- amount of hours for cache help alerts
			chat_titles = 18000
		},
		report = {
			duration = 1200,
			times_allowed = 2
		},
		notify_bug = false, -- notify if a bug occurs!
		log_api_errors = true, -- log errors, which happening whilst interacting with the bot api.
		stream_commands = true,
		admin_mode = os.getenv('GB_ADMIN_MODE') or false
	},
	plugins = {
		'onmessage', --THIS MUST BE THE FIRST: IF AN USER IS FLOODING/IS BLOCKED, THE BOT WON'T GO THROUGH PLUGINS
		'antispam', --SAME OF onmessage.lua
		'backup',
		'banhammer',
		'block',
		'configure',
		'defaultpermissions',
		'dashboard',
		'floodmanager',
		'help',
		'links',
		'logchannel',
		'mediasettings',
		'menu',
		'moderators',
		'pin',
		'private',
		'private_settings',
		'report',
		'rules',
		'service',
		'setlang',
		'users',
		'warn',
		'welcome',
		'admin',
		'extra', --must be the last plugin in the list.
	},
	available_languages = {
		['en'] = 'English 🇬🇧',
		['it'] = 'Italiano 🇮🇹',
		['es'] = 'Español 🇪🇸',
		['pt_BR'] = 'Português 🇧🇷',
		['ru'] = 'Русский 🇷🇺',
		['de'] = 'Deutsch 🇩🇪',
		--['sv'] = 'Svensk 🇸🇪',
		['ar'] = 'العربية 🇸🇩',
		--['fr'] = 'Français 🇫🇷',
		['zh'] = '中文 🇨🇳',
		['fa'] = 'فارسی 🇮🇷',
		['id'] = 'Bahasa Indonesia 🇮🇩',
		['nl'] = 'Nederlands 🇱🇺',
		['tr'] = 'Turkish 🇹🇷'
		-- more languages will come
	},
	allow_fuzzy_translations = false,
	chat_settings = {
		['settings'] = {
			['Welcome'] = 'off',
			['Extra'] = 'on',
			--['Flood'] = 'off',
			['Silent'] = 'off',
			['Rules'] = 'off',
			['Reports'] = 'off',
			['Welbut'] = 'off', -- "read the rules" button under the welcome message
			['Weldelchain'] = 'off', -- delete the previously sent welcome message when a new welcome message is sent
			['Antibot'] = 'off'
		},
		['antispam'] = {
			['links'] = 'alwd',
			['forwards'] = 'alwd',
			['warns'] = 2,
			['action'] = 'mute'
		},
		['flood'] = {
			['MaxFlood'] = 5,
			['ActionFlood'] = 'mute'
		},
		['char'] = {
			['Arab'] = 'allowed', --'kick'/'ban'
			['Rtl'] = 'allowed'
		},
		['floodexceptions'] = {
			['text'] = 'no',
			['photo'] = 'no', -- image
			['forward'] = 'no',
			['video'] = 'no',
			['sticker'] = 'no',
			['gif'] = 'no',
		},
		['warnsettings'] = {
			['type'] = 'mute',
			['mediatype'] = 'mute',
			['max'] = 3,
			['mediamax'] = 2
		},
		['welcome'] = {
			['type'] = 'no',
			['content'] = 'no'
		},
		['goodbye'] = {
			['type'] = 'custom',
		},
		['media'] = {
			['photo'] = 'ok', --'notok' | image
			['audio'] = 'ok',
			['video'] = 'ok',
			['video_note'] = 'ok',
			['sticker'] = 'ok',
			['gif'] = 'ok',
			['voice'] = 'ok',
			['contact'] = 'ok',
			['document'] = 'ok', -- file
			['link'] = 'ok',
			['game'] = 'ok',
			['location'] = 'ok'
		},
		['tolog'] = {
			['ban'] = 'no',
			['kick'] = 'no',
			['unban'] = 'no',
			['tempban'] = 'no',
			['report'] = 'no',
			['warn'] = 'no',
			['nowarn'] = 'no',
			['mediawarn'] = 'no',
			['spamwarn'] = 'no',
			['flood'] = 'no',
			['new_chat_member'] = 'no',
			['new_chat_photo'] = 'no',
			['delete_chat_photo'] = 'no',
			['new_chat_title'] = 'no',
			['pinned_message'] = 'no'
		},
		['defpermissions'] = {
			['can_send_messages'] = 'true',
			['can_send_media_messages'] = 'true',
			['can_send_other_messages'] = 'true',
			['can_add_web_page_previews'] = 'true'
		},
		['defpermduration'] = {
			['timeframe'] = 'd',
			['duration'] = 1
		},
	},
	private_settings = {
		rules_on_join = 'off',
		reports = 'off'
	},
	chat_hashes = {'extra', 'info', 'links', 'warns', 'mediawarn', 'spamwarns', 'blocked', 'report', 'defpermissions',
		'defpermduration'},
	chat_sets = {'whitelist'},--, 'mods'},
	bot_keys = {
		d3 = {'bot:general', 'bot:usernames', 'bot:chat:latsmsg'},
		d2 = {'bot:groupsid', 'bot:groupsid:removed', 'tempbanned', 'bot:blocked', 'remolden_chats'} --remolden_chats: chat removed with $remold command
	}
}

local multipurpose_plugins = os.getenv('MULTIPURPOSE_PLUGINS')
if multipurpose_plugins then
	_M.multipurpose_plugins = assert(json.decode(multipurpose_plugins),
		'$MULTIPURPOSE_PLUGINS must be a JSON array or empty')
end

return _M
