return {
	bot_api_key = '198733539:AAGV9pV-ry2He6PozSlAWRPXW3tO5DoNSe4',
	time_offset = 0,
	admin = 23646077,
	channel = '',
	languages = 'languages.lua',
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
		'mediasettings.lua',
		'test.lua',
		--'flag2.lua'
		
	},
	available_languages = {
		'en',
		'it',
		'es',
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

--AVAILABLE HASHES

--General
--Users (id + username)     bot:users (3D)
--Groups     bot:groupsid (2D)
--Commands stat     commands:stats (3D)
--General stats + admin mode     bot:general (3D)
--Blocked users     bot:blocked (2D)
--Usernames     bot:usernames (3D)
--Requests errors     bot:errors (3D)

--Groups
--About     bot:chat_id:about (1D)
--Rules     bot:chat_id:rules (1D)
--Settings     bot:chat_id:2Dtings (3D)
--Kicked list     kicked:chat_id (3D)
--extra commands     extra:chat_id (3D)
--report blocked     chat:chat_id:reportblocked (2D)
--Flood     chat:chat_id:flood (3D, Maxflood, ActionFlood)
--Links     chat:chat_idlinks (3D)
--Media settings     medis:chat_id (3D)
--Mods     bot:chat_id:mod (3D)
--Owner     bot:chat_id:owner (3D)
--Antispam     spam:chat_id:user_id (1D)
--Welcome settings     chat:chat_id:welcome (3D)
--Language     lang:chat_id (1D)
--Type warn     warns:chat_id:type (1D)
--Max warns     warns:chat_id:max (1D)
--Warns number     warns:chat_id (3D)