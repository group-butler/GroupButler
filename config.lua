return {
	bot_api_key = '',
	time_offset = 0,
	admin = 23646077,
	channel = '@GroupButler_ch',
	plugins = {
		'onmessage.lua', --THIS HAVE TO BE THE FIRST: IF AN USER IS SPAMMING/IS BLOCKED, THE BOT WON'T GO THROUGH PLUGINS
		'admin.lua',
		'mod.lua',
		'credits.lua',
		'ping.lua',
		'tell.lua',
		'help.lua',
		'rules.lua',
		'settings.lua',
		'about.lua',
		'report.lua',
		'flag.lua',
		'service.lua',
		'links.lua',
		'warn.lua',
		'extra.lua',
		'setlang.lua',
		'banhammer.lua',
		'floodmanager.lua',
		'mediasettings.lua'
		
	},
	available_languages = {
		'en',
		--'it',
		--'br'
		--more to come
	},
	settings = {
		'Rules',
		'About',
		'Flag',
		'Modlist',
		'Welcome',
		'Extra',
		'Kicklist',
		'Video',
		'Gif',
		'Photo',
		'Sticker'
		}
}
