_G.TEST = true
local logging = require "groupbutler.logging"

-- logging.info("starting up")
-- logging.error("startup failed: {name} timed out ({timeout})", {name="telegram", timeout=5})
-- logging.debug("message from {user}", {user="abc"})

-- logging.formatter = logging.json_log_formatter

-- logging.info("starting up")
-- logging.error("startup failed: {name} timed out ({timeout})", {name="telegram", timeout=5})
-- logging.debug("message from {user}", {user="abc"})

describe("interpolation", function()
	it("should interpolate stuff", function()
		local str = "Hello, {name}!"
		local tbl = {name = "Busted"}
		local expected = "Hello, Busted!"
		local retval = logging._interpolate(str, tbl)
		assert.same(expected, retval)
	end)
end)
