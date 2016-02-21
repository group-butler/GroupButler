return {
	bot_api_key = '',
	yandex_api_key = '',
	time_offset = 0,
	cli_port = 4567,
	admin = 23646077,
	admin_name = 'Big Dick Is Back To Town',

	errors = {
		connection = 'Connection error.',
		results = 'No results found.',
		argument = 'Invalid argument.',
		syntax = 'Invalid syntax.',
		not_admin = 'This command must be run by an administrator.'
	},
	moderation = {
		admins = {
			['23646077'] = 'You'
		},
		admin_group = -00000000,
		realm_name = 'My Realm'
	},
	plugins = {
		'control.lua',
		'mod.lua',
		'service.lua',
		'ping.lua',
		'tell.lua',
		'help.lua',
		'setrules.lua',
		'settings.lua',
		'setabout.lua',
		'getstats.lua',
		'report.lua',
		'flag.lua'
		
	}
}
