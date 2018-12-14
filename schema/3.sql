--
-- Types
--

CREATE TYPE chat_user_status AS ENUM ('creator', 'administrator', 'member', 'restricted', 'left', 'kicked');

--
-- Tables
--

CREATE TABLE "chat_user" (
    status chat_user_status NOT NULL DEFAULT 'member',
    chat_id bigint NOT NULL REFERENCES "chat"(id) ON DELETE CASCADE,
    user_id integer NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,

    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    CONSTRAINT chat_user_pkey PRIMARY KEY (chat_id, user_id)
);

CREATE TABLE "chat_admin" (
    chat_id bigint NOT NULL,
    user_id integer NOT NULL,

    can_be_edited boolean DEFAULT false NOT NULL,
    can_change_info boolean DEFAULT false NOT NULL,
    can_delete_messages boolean DEFAULT false NOT NULL,
    can_invite_users boolean DEFAULT false NOT NULL,
    can_restrict_members boolean DEFAULT false NOT NULL,
    can_pin_messages boolean DEFAULT false NOT NULL,
    can_promote_members boolean DEFAULT false NOT NULL,
    -- can_post_messages boolean DEFAULT false NOT NULL, -- Channels only
    -- can_edit_messages boolean DEFAULT false NOT NULL, -- Channels only

    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    CONSTRAINT chat_admin_fkey FOREIGN KEY (chat_id, user_id)
        REFERENCES "chat_user"(chat_id, user_id) ON DELETE CASCADE,

    CONSTRAINT chat_admin_pkey PRIMARY KEY (chat_id, user_id)
);

-- CREATE TABLE "chat_restricted_user" (
--     chat_id bigint NOT NULL REFERENCES "chat"(id),
--     user_id integer NOT NULL REFERENCES "user"(id),
--     until_date timestamptz, -- Restricted and kicked only. Date when restrictions will be lifted for this user, if ever

--     can_send_messages boolean DEFAULT true NOT NULL,
--     can_send_media_messages boolean DEFAULT true NOT NULL, -- implies can_send_messages
--     can_send_other_messages boolean DEFAULT true NOT NULL, -- implies can_send_media_messages
--     can_add_web_page_previews boolean DEFAULT true NOT NULL -- implies can_send_media_messages

--     created_at timestamptz DEFAULT now() NOT NULL,
--     updated_at timestamptz DEFAULT now() NOT NULL,

--     CONSTRAINT chat_restricted_user_pkey PRIMARY KEY (chat_id, user_id)
-- );


--
-- Triggers
--

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON "chat_user"
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_updated_at();

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON "chat_admin"
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_updated_at();
