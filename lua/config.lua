-- Editing this file directly is now highly disencouraged. You should instead use environment variables. This new method is a WIP, so if you need to change something which doesn't have a env var, you are encouraged to open an issue or a PR
return {
	-- Setting these is required in order to run, so no defaults
	bot_api_key = os.getenv("TG_TOKEN"),
	superadmins = json.decode(os.getenv("SUPERADMINS")),
	log = json.decode(os.getenv("LOG")),
	url = os.getenv("HOOK_URL"),

	-- Setting these is only required when running without Docker
	db_host = os.getenv("DB_HOST") or 'db',
	db_port = os.getenv("DB_PORT") or 5432,
	db_user = os.getenv("DB_USER") or 'postgres',
	db_pass = os.getenv("DB_PASS") or 'password',
	db_db = os.getenv("DB_DB") or 'groupbutler',

	redis_host = os.getenv("REDIS_HOST") or 'redis',
	redis_port = os.getenv("REDIS_PORT") or 6379,

	-- Setting these is optional, although recommend
	channel = os.getenv("CHANNEL") or '@RoboED', --channel username with the '@'
	source_code = os.getenv("SOURCE") or 'https://gitlab.com/Synko/GroupButler',
	help_groups_link = os.getenv("GROUP") or 'https://t.me/RoboED',
	lang = os.getenv("CORE_LANG"),
	max_connections = os.getenv("MAX_CONNECTIONS") or 40,

	-- Setting these is completely optional
	db_db = os.getenv("DB_DB") or 'groupbutler',
	redis_db = os.getenv("REDIS_DB") or 0,
	human_readable_version = '4.2.0',
	cmd = '^[/!#]',
	allowed_updates = {"message", "edited_message", "callback_query"},
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
		notify_bug = false, --Notify if a bug occurs!
		log_api_errors = true, --Log errors, which happening whilst interacting with the bot api.
		stream_commands = true,
		admin_mode = false,
		realm_max_members = 60,
		realm_max_subgroups = 6
	},
	plugins = {
		'onmessage', --THIS MUST BE THE FIRST: IF AN USER IS FLOODING/IS BLOCKED, THE BOT WON'T GO THROUGH PLUGINS
		'antispam', --SAME OF onmessage.lua
		--'realms', --must stay here
		'backup',
		'banhammer',
		'block',
		'configure',
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
	multipurpose_plugins = {},
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
		['nl'] = 'Dutch 🇱🇺'
		-- more languages will come
	}
}
