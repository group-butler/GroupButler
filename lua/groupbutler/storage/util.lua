local Util = require("groupbutler.util")

local StorageUtil = {}

do
	StorageUtil.isUserPropertyRequired = {
		id = true,
		first_name = true,
	} Util.setDefaultTableValue(StorageUtil.isUserPropertyRequired, false)

	StorageUtil.isUserPropertyOptional = {
		last_name = true,
		is_bot = true,
		username = true,
		language_code = true,
	} Util.setDefaultTableValue(StorageUtil.isUserPropertyOptional, false)

	StorageUtil.isUserProperty = Util.mergeTables(
		StorageUtil.isUserPropertyRequired,
		StorageUtil.isUserPropertyOptional
	) Util.setDefaultTableValue(StorageUtil.isUserProperty, false)
end

do
	StorageUtil.isChatPropertyRequired = {
		id = true,
		type = true,
		title = true,
	} Util.setDefaultTableValue(StorageUtil.isChatPropertyRequired, false)

	StorageUtil.isChatPropertyOptional = {
		username = true,
		invite_link = true,
	} Util.setDefaultTableValue(StorageUtil.isChatPropertyOptional, false)

	StorageUtil.isChatProperty = Util.mergeTables(
		StorageUtil.isChatPropertyRequired,
		StorageUtil.isChatPropertyOptional
	) Util.setDefaultTableValue(StorageUtil.isChatProperty, false)
end

do
	StorageUtil.isChatMemberPropertyRequired = {
		status = true,
	} Util.setDefaultTableValue(StorageUtil.isChatMemberPropertyRequired, false)

	StorageUtil.isAdminPermission = {
		can_be_edited = true,
		can_change_info = true,
		can_delete_messages = true,
		can_invite_users = true,
		can_restrict_members = true,
		can_promote_members = true,
		can_pin_messages = true,
	} Util.setDefaultTableValue(StorageUtil.isAdminPermission, false)

	StorageUtil.isRestrictedMemberProperty = {
		until_date = true,
		can_send_messages = true,
		can_send_media_messages = true,
		can_send_other_messages = true,
		can_add_web_page_previews = true,
	} Util.setDefaultTableValue(StorageUtil.isRestrictedMemberProperty, false)

	StorageUtil.isChatMemberPropertyOptional = Util.mergeTables(
		StorageUtil.isAdminPermission,
		StorageUtil.isRestrictedMemberProperty
	) Util.setDefaultTableValue(StorageUtil.isChatMemberPropertyOptional, false)

	StorageUtil.isChatMemberProperty = Util.mergeTables(
		StorageUtil.isChatMemberPropertyRequired,
		StorageUtil.isChatMemberPropertyOptional
	) Util.setDefaultTableValue(StorageUtil.isChatMemberProperty, false)
end

return StorageUtil
