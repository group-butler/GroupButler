local config = require "groupbutler.config"

local strings = {} -- internal array with translated strings

-- String functions
local function trim(str) -- Trims whitespace from a string
	return str:gsub('^%s*(.-)%s*$', '%1')
end

-- Evaluates the Lua's expression
local function eval(str)
	return loadstring('return ' .. str)()
end

-- Parses the file with translation and returns a table with English strings as
-- keys and translated strings as values. The keys are stored without a leading
-- linebreak for crawling bugs of xgettext. It adds needless linebreak to
-- string literals with long brackets. Fuzzy translations are ignored if flag
-- config.allow_fuzzy_translations isn't set.
local function parse(filename)
	local state = 'ign_msgstr' -- states of finite state machine
	local msgid, msgstr
	local result = {}

	for line in io.lines(filename) do
		line = trim(line)
		local input, argument = line:match('^(%w*)%s*(".*")$')
		if line:match('^#,.*fuzzy') then
			input = 'fuzzy'
		end

		assert(state == 'msgid' or state == 'msgstr' or state == 'ign_msgid' or state == 'ign_msgstr')
		assert(input == nil or input == '' or input == 'msgid' or input == 'msgstr' or input == 'fuzzy')

		if state == 'msgid' and input == '' then
			msgid = msgid .. eval(argument)
		elseif state == 'msgid' and input == 'msgstr' then
			msgstr = eval(argument)
			state = 'msgstr'
		elseif state == 'msgstr' and input == '' then
			msgstr = msgstr .. eval(argument)
		elseif state == 'msgstr' and input == 'msgid' then
			if msgstr ~= '' then result[msgid:gsub('^\n', '')] = msgstr end
			msgid = eval(argument)
			state = 'msgid'
		elseif state == 'msgstr' and input == 'fuzzy' then
			if msgstr ~= '' then result[msgid:gsub('^\n', '')] = msgstr end
			if not config.allow_fuzzy_translations then
				state = 'ign_msgid'
			end
		elseif state == 'ign_msgid' and input == 'msgstr' then
			state = 'ign_msgstr'
		elseif state == 'ign_msgstr' and input == 'msgid' then
			msgid = eval(argument)
			state = 'msgid'
		elseif state == 'ign_msgstr' and input == 'fuzzy' then
			state = 'ign_msgid'
		end
	end
	if state == 'msgstr' and msgstr ~= '' then
		result[msgid:gsub('^\n', '')] = msgstr
	end

	return result
end

local locale = {} -- table with exported functions

locale.language = config.lang -- default language

function locale.init(directory)
	directory = directory or "locales"

	for lang_code in pairs(config.available_languages) do
		strings[lang_code] = parse(string.format('%s/%s.po', directory, lang_code))
	end
end

function locale.translate(msgid)
	return strings[locale.language][msgid:gsub('^\n', '')] or msgid
end

locale.init()

return locale
