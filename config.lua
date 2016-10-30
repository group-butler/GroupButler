return {
	bot_api_key = "", --Please add your bot api key here!
	cmd = '^[/!#]',
	db = 2, --default redis db: 0
	superadmins = {23646077, 278941742},
	log = {
		chat = -1001057801239, --Your log chat, where your bot must be added!
		admin = 23646077, --The admin.
		stats = nil
	},
	human_readable_version = '4.2.0',
	bot_settings = {
		cache_time = {
			adminlist = 18000, --5 hours (18000s) Admin Cache time, in seconds.
		},
		multipurpose_mode = false, --If this is enabled, the bot will activate the plugins from plugins/multipurpose
		notify_bug = true, --Notify if a bug occurs!
		log_api_errors = true, --Log errors, which happening whilst interacting with the bot api.
		stream_commands = true,
		admin_mode = false,
		debug_connections = false,
		realm_max_members = 60
	},
	channel = '@groupbutler_ch', --channel username with the '@'
	source_code = 'https://github.com/RememberTheAir/GroupButler',
	help_groups = {
		['Internatonal (English)'] = 'https://telegram.me/joinchat/EKBQLj7Zf6lE2K_Pk0Epcg', --group link, not (at)username! If you have your own support group, modify here!
		['Italian'] = 'https://telegram.me/joinchat/ITAgroupbutler',
		['Persian'] = 'https://telegram.me/joinchat/CTDUTkCOsEt4DZT-SUQdBQ',
		['Russian'] = 'https://telegram.me/rubutler',
		['Spanish'] = 'https://telegram.me/ESgroupbutler'
	},
	plugins = {
		'onmessage.lua', --THIS MUST BE THE FIRST: IF AN USER IS SPAMMING/IS BLOCKED, THE BOT WON'T GO THROUGH PLUGINS
		--'realms.lua',
		'configure.lua',
		'menu.lua',
		'dashboard.lua',
		'banhammer.lua',
		'users.lua',
		'help.lua',
		'rules.lua',
		'service.lua',
		'links.lua',
		'warn.lua',
		'setlang.lua',
		'floodmanager.lua',
		'welcome.lua',
		'pin.lua',
		'mediasettings.lua',
		'private.lua',
		'admin.lua',
		--'test.lua',
		--'logchannel.lua',
		'report.lua',
		'private_settings.lua',
		'extra.lua', --must be the last plugin in the list.
	},
	multipurpose_plugins = {},
	available_languages = {
		['en'] = 'English 🇬🇧',
		['it'] = 'Italiano 🇮🇹',
		['es'] = 'Español 🇪🇸',
		['pt_BR'] = 'Português 🇧🇷',
		['ru'] = 'Русский 🇷🇺',
		['de'] = 'Deutsch 🇩🇪',
		['sv'] = 'Svensk 🇸🇪',
		['ar'] = 'العربية 🇸🇩',
		['fr'] = 'Français 🇫🇷',
		['zh'] = '中文 🇨🇳',
		['fa'] = 'فارسی 🇮🇷',
		['id'] = 'Bahasa Indonesia 🇮🇩'
		-- more languages will come
	},
	allow_fuzzy_translations = false,
	chat_settings = { --default chat_settings for groups.
		['settings'] = {
			['Welcome'] = 'off',
			['Goodbye'] = 'off',
			['Extra'] = 'on',
			['Flood'] = 'off',
			['Silent'] = 'off',
			['Rules'] = 'off',
			['Reports'] = 'off',
			['Welbut'] = 'off'
		},
		['flood'] = {
			['MaxFlood'] = 5,
			['ActionFlood'] = 'kick'
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
			['forward'] = 'no'
		},
		['warnsettings'] = {
			['type'] = 'ban',
			['mediatype'] = 'ban',
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
			['sticker'] = 'ok',
			['gif'] = 'ok',
			['voice'] = 'ok',
			['contact'] = 'ok',
			['document'] = 'ok', -- file
			['link'] = 'ok',
			['TGlink'] = 'ok',
			['game'] = 'ok',
			['location'] = 'ok'
		},
		['tolog'] = {
			['ban'] = 'yes',
			['kick'] = 'yes',
			['warn'] = 'yes',
			['join'] = 'yes',
			['mediawarn'] = 'yes',
			['flood'] = 'yes',
		},
	},
	private_settings = {
		rules_on_join = 'off',
		reports = 'off'
	},
	chat_custom_texts = {'extra', 'info', 'links', 'warns', 'mediawarn'},
	bot_keys = {
		d3 = {'bot:general', 'bot:usernames', 'bot:chat:latsmsg'},
		d2 = {'bot:groupsid', 'bot:groupsid:removed', 'tempbanned', 'bot:blocked', 'remolden_chats'} --remolden_chats: chat removed with $remold command
	},
	api_errors = {
		[101] = 'Not enough rights to kick/unban chat member', --SUPERGROUP: bot is not admin
		[102] = 'USER_ADMIN_INVALID', --SUPERGROUP: trying to kick an admin
		[103] = 'method is available for supergroup chats only', --NORMAL: trying to unban
		[104] = 'Only creator of the group can kick administrators from the group', --NORMAL: trying to kick an admin
		[105] = 'Bad Request: Need to be inviter of the user to kick it from the group', --NORMAL: bot is not an admin or everyone is an admin
		[106] = 'USER_NOT_PARTICIPANT', --NORMAL: trying to kick an user that is not in the group
		[107] = 'CHAT_ADMIN_REQUIRED', --NORMAL: bot is not an admin or everyone is an admin
		[108] = 'there is no administrators in the private chat', --something asked in a private chat with the api methods 2.1
		[109] = 'Wrong URL host', --hyperlink not valid
		[110] = 'PEER_ID_INVALID', --user never started the bot
		[111] = 'message is not modified', --the edit message method hasn't modified the message
		[112] = 'Can\'t parse message text: Can\'t find end of the entity starting at byte offset %d+', --the markdown is wrong and breaks the delivery
		[113] = 'group chat is migrated to a supergroup chat', --group updated to supergroup
		[114] = 'Message can\'t be forwarded', --unknown
		[115] = 'Message text is empty', --empty message
		[116] = 'message not found', --message id invalid, I guess
		[117] = 'chat not found', --I don't know
		[118] = 'Message is too long', --over 4096 char
		[119] = 'User not found', --unknown user_id
		[120] = 'Can\'t parse reply keyboard markup JSON object', --keyboard table invalid
		[121] = 'Field \\\"inline_keyboard\\\" of the InlineKeyboardMarkup should be an Array of Arrays', --inline keyboard is not an array of array
		[122] = 'Can\'t parse inline keyboard button: InlineKeyboardButton should be an Object',
		[123] = 'Bad Request: Object expected as reply markup', --empty inline keyboard table
		[124] = 'QUERY_ID_INVALID', --callback query id invalid
		[125] = 'CHANNEL_PRIVATE', --I don't know
		[126] = 'MESSAGE_TOO_LONG', --text of an inline callback answer is too long
		[127] = 'wrong user_id specified', --invalid user_id
		[128] = 'Too big total timeout [%d%.]+', --something about spam an inline keyboards
		[129] = 'BUTTON_DATA_INVALID', --callback_data string invalid
		[130] = 'Type of file to send mismatch', --trying to send a media with the wrong method
		[131] = 'MESSAGE_ID_INVALID', --I don't know
		[132] = 'Can\'t parse inline keyboard button: Can\'t find field "text"', --the text of a button could be nil
		[133] = 'Can\'t parse inline keyboard button: Field "text" must be of type String',
		[134] = 'USER_ID_INVALID',
		[135] = 'CHAT_INVALID',
		[136] = 'USER_DEACTIVATED', --deleted account, probably
		[137] = 'Can\'t parse inline keyboard button: Text buttons are unallowed in the inline keyboard',
		[138] = 'Message was not forwarded',
		[139] = 'Can\'t parse inline keyboard button: Field \\\"text\\\" must be of type String', --"text" field in a button object is not a string
		[140] = 'Channel invalid', --/shrug
		[141] = 'Wrong message entity: Unsupproted URL protocol', --username in an inline link [word](@username) (only?)
		[142] = 'Wrong message entity: URL host is empty', --inline link without link [word]()
		[403] = 'Bot was blocked by the user', --user blocked the bot
		[429] = 'Too many requests: retry later', --the bot is hitting api limits
		[430] = 'Too big total timeout', --too many callback_data requests
	}
}
