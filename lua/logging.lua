local JSON = require 'cjson'

local logging = {}

local loglevels = {
	[10] = "TRACE",
	[20] = "DEBUG",
	[30] = "INFO",
	[40] = "WARN",
	[50] = "ERROR",
	[60] = "CRITICAL",
}

for level, name in pairs(loglevels) do
	logging[name] = level
end

local function interpolate(s, tab)
	return (
		s:gsub('(%b{})', function(w)
			return assert(tab[w:sub(2, -2)],
				"missing formatting value: "..w)
		end
		)
	)
end

function logging.text_log_formatter(level, message, data)
	if not data then
		data = {}
	end
	local entry = {
		message=interpolate(message, data),
		time=os.date("%x %X"),
		level=loglevels[level],
	}
	return interpolate(logging.text_format, entry)
end

function logging.json_log_formatter(level, message, data)
	if not data then
		data = {}
	end
	data.message = message
	data.level = level
	data.timestamp = os.time(os.date("*t"))
	return JSON.encode(data)
end

function logging.print_log_handler(message)
	print(message)
end

function logging.log(level, message, data)
	if level < logging.loglevel then
		print("skip")
		return
	end

	logging.handler(logging.formatter(level, message, data))
end

for level, name in pairs(loglevels) do
	logging[name:lower()] = function(message, data)
		logging.log(level, message, data)
	end
end

-- DEFAULTS

logging.loglevel = logging.DEBUG
logging.formatter = logging.text_log_formatter
logging.handler = logging.print_log_handler
logging.text_format = "[{time}] {level}: {message}"

-- export for tests

logging._interpolate = interpolate

return logging
