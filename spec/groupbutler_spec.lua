_G.TEST = true
local groupbutler = require("groupbutler")
local json = require("cjson")

describe("mock", function()
	it("should deal with mock updates", function()
		local update = json.decode([[
{
  "update_id": 100,
  "message": {
    "message_id": 200,
    "from": {
      "id": 300,
      "is_bot": false,
      "first_name": "Name"
    },
    "chat": {
      "id": 300,
      "first_name": "Name",
      "type": "private"
    },
    "date": 0,
    "text": "Test"
  }
}
]])
		local retval = groupbutler.test(update)
		assert.same(nil, retval)
	end)
end)
