local _M = {}

_M.InlineKeyboardMarkup = {}
-- _M.ReplyKeyboardMarkup = {}
-- _M.ReplyKeyboardRemove = {}
-- _M.ForceReply = {}

function _M.InlineKeyboardMarkup:new(obj)
  obj = obj or {inline_keyboard = {}}
  setmetatable(obj, {__index = self})
  return obj
end

function _M.InlineKeyboardMarkup:row(...)
  table.insert(self.inline_keyboard, {...})
  return self
end

return _M
