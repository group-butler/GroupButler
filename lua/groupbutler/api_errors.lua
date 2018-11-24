local _M = {}

function _M:new(update_obj)
	local obj = {
		i18n = update_obj.i18n,
	}
	setmetatable(obj, {__index = self})
	return obj
end

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

local function replies(self)
	local i18n = self.i18n
	local replies_t = {
		unknown_error = i18n:_("An unknown error has ocurred"),
		not_enough_permissions = i18n:_("I don't have enough permissions to restrict users"),
		not_admin = i18n:_("I'm not an admin, I can't kick people"),
		cant_restrict_admins = i18n:_("I can't do that to admins!"),
		cant_unban_on_normal_groups = i18n:_("There is no need to unban in a normal group"),
		user_not_found = i18n:_("This user is not a chat member"),
		empty_message = i18n:_("Please input a text"),
		long_message = i18n:_("This message is too long. Max lenght allowed by Telegram: 4000 characters"),
		bad_inline_button_url = i18n:_("One of the inline buttons you are trying to set is missing the URL"),
		bad_hyperlink = i18n:_("Inline link formatted incorrectly. Check the text between brackets -> \\[]()\n%s"):format(i18n:_("More info [here](https://telegram.me/GB_tutorials/12)")), -- luacheck: ignore 631
		bad_markdown = i18n:_([[This text breaks the markdown.
More info about a proper use of markdown [here](https://telegram.me/GB_tutorials/10) and [here](https://telegram.me/GB_tutorials/12).]]), -- luacheck: ignore 631
		button_url_invalid = i18n:_("One of the URLs that should be placed in an inline button seems to be invalid (not an URL). Please check it"), -- luacheck: ignore 631
		bad_inline_button_name = i18n:_("One of the inline buttons you are trying to set doesn't have a name"),
	} set_default(replies_t, replies_t.unknown_error)
	return replies_t
end

local function errors(self)
	return {
		["not enough rights to kick/unban chat member"] = replies(self).not_admin, -- SUPERGROUP: bot is not admin
		["user_admin_invalid"] = replies(self).cant_restrict_admins, -- SUPERGROUP: trying to kick an admin
		["method is available for supergroup chats only"] = replies(self).cant_unban_on_normal_groups, -- NORMAL: trying to unban
		["only creator of the group can kick administrators from the group"] = replies(self).cant_restrict_admins, -- NORMAL: trying to kick an admin
		["need to be inviter of the user to kick it from the group"] = replies(self).not_admin, -- NORMAL: bot is not an admin or everyone is an admin
		["user_not_participant"] = replies(self).user_not_found, -- NORMAL: trying to kick a user that is not in the group
		["chat_admin_required"] = replies(self).not_admin, -- NORMAL: bot is not an admin or everyone is an admin
		-- ["there is no administrators in the private chat"] = replies(self).unknown_error, -- something asked in a private chat with the api methods 2.1
		["wrong url host"] = replies(self).bad_hyperlink, -- hyperlink not valid
		-- ["peer_id_invalid"] = replies(self).unknown_error, -- user never started the bot
		-- ["message is not modified"] = replies(self).unknown_error, -- the edit message method hasn't modified the message
		["can't parse entities in message text: can't find end of the entity starting at byte offset %d+"] = replies(self).bad_markdown, -- the markdown is wrong and breaks the delivery
		-- ["group chat is migrated to a supergroup chat"] = replies(self).unknown_error, -- group updated to supergroup
		-- ["message can't be forwarded"] = replies(self).unknown_error, -- unknown
		["message text is empty"] = replies(self).empty_message, -- empty message
		-- ["message not found"] = replies(self).unknown_error, -- message id invalid, I guess
		-- ["chat not found"] = replies(self).unknown_error, -- I don't know
		["message is too long"] = replies(self).long_message, -- over 4096 char
		["user not found"] = replies(self).user_not_found, -- unknown user_id
		-- ["can't parse reply keyboard markup json object"] = replies(self).unknown_error, -- keyboard table invalid
		-- ["field \"inline_keyboard\" of the inlinekeyboardmarkup should be an array of arrays"] = replies(self).unknown_error, -- inline keyboard is not an array of array
		-- ["can't parse inline keyboard button: inlinekeyboardbutton should be an object"] = replies(self).unknown_error,
		-- ["object expected as reply markup"] = replies(self).unknown_error, -- empty inline keyboard table
		-- ["query_id_invalid"] = replies(self).unknown_error, -- callback query id invalid
		-- ["channel_private"] = replies(self).unknown_error, -- I don't know
		-- ["message_too_long"] = replies(self).unknown_error, -- text of an inline callback answer is too long
		-- ["wrong user_id specified"] = replies(self).unknown_error, -- invalid user_id
		-- ["too big total timeout [%d%.]+"] = replies(self).unknown_error, --something about spam an inline keyboards
		-- ["button_data_invalid"] = replies(self).unknown_error, -- callback_data string invalid
		-- ["type of file to send mismatch"] = replies(self).unknown_error, -- trying to send a media with the wrong method
		-- ["message_id_invalid"] = replies(self).unknown_error, -- I don't know. Probably passing a string as message id
		-- ["can't parse inline keyboard button: can't find field \"text\""] = replies(self).unknown_error, -- the text of a button could be nil
		-- ["can't parse inline keyboard button: field \"text\" must be of type String"] = replies(self).unknown_error,
		["user_id_invalid"] = replies(self).user_not_found,
		-- ["chat_invalid"] = replies(self).unknown_error,
		["user_deactivated"] = replies(self).user_not_found, -- deleted account, probably
		["can't parse inline keyboard button: text buttons are unallowed in the inline keyboard"] = replies(self).bad_inline_button_url, -- luacheck: ignore 631
		-- ["message was not forwarded"] = replies(self).unknown_error,
		-- ["can't parse inline keyboard button: field \"text\" must be of type string"] = replies(self).unknown_error, -- "text" field in a button object is not a string
		-- ["channel invalid"] = replies(self).unknown_error, -- /shrug
		["wrong message entity: unsupproted url protocol"] = replies(self).bad_hyperlink, -- username in an inline link [word](@username) (only?)
		["wrong message entity: url host is empty"] = replies(self).bad_hyperlink, -- inline link without link [word]()
		-- ["there is no photo in the request"] = replies(self).unknown_error,
		-- ["can't parse message text: unsupported start tag \"%w+\" at byte offset %d+"] = replies(self).unknown_error,
		-- ["can't parse message text: expected end tag at byte offset %d+"] = replies(self).unknown_error,
		["button_url_invalid"] = replies(self).button_url_invalid, -- invalid url (inline buttons)
		-- ["message must be non%-empty"] = replies(self).unknown_error, --example: ```   ```
		-- ["can\'t parse message text: unmatched end tag at byte offset"] = replies(self).unknown_error,
		["reply_markup_invalid"] = replies(self).bad_inline_button_name, -- returned while trying to send an url button without text and with an invalid url
		-- ["message text must be encoded in utf%-8"] = replies(self).unknown_error,
		-- ["url host is empty"] = replies(self).unknown_error,
		-- ["requested data is unaccessible"] = replies(self).unknown_error, -- the request involves a private channel and the bot is not admin there
		-- ["unsupported url protocol"] = replies(self).unknown_error,
		-- ["can't parse message text: unexpected end tag at byte offset %d+"] = replies(self).unknown_error,
		-- ["message to edit not found"] = replies(self).unknown_error,
		-- ["group chat was migrated to a supergroup chat"] = replies(self).unknown_error,
		-- ["message to forward not found"] = replies(self).unknown_error,
		["user is an administrator of the chat"] = replies(self).cant_restrict_admins,
		["not enough rights to restrict/unrestrict chat member"] = replies(self).not_enough_permissions,
		-- ["have no rights to send a message"] = replies(self).unknown_error,
		-- ["user_is_bot"] = replies(self).unknown_error,
		-- ["bot was blocked by the user"] = replies(self).unknown_error, -- user blocked the bot
		-- ["too many requests: retry later"] = replies(self).unknown_error, -- the bot is hitting api limits
		-- ["too big total timeout"] = replies(self).unknown_error, -- too many callback_data requests
	}
end

function _M:trans(err) -- Translate API errors to text
	if not err or not err.description then
		return replies(self).unknown_error
	end

	err = err.description:lower()
	for k,v in pairs(errors(self)) do
		if err:match(k) then
			return v
		end
	end

	return replies(self).unknown_error
end

return _M
