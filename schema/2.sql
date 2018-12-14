--
-- Tables
--

CREATE TABLE "chat" (
    id bigint NOT NULL,
    type smallint NOT NULL,
    title text NOT NULL, -- Only private chats don't have titles, and we already store private info under "user"

    username text,
    -- photo jsonb,
    -- description text,
    invite_link text,
    -- pinned_message jsonb,
    -- sticker_set_name text, -- Supergroups only
    -- can_set_sticker_set bool, -- Supergroups only

    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    CONSTRAINT chat_pkey PRIMARY KEY (id)
);

-- CREATE TABLE "chat_user" (
--     chat_id bigint NOT NULL REFERENCES "chat"(id),
--     user_id integer NOT NULL REFERENCES "user"(id),
--     status smallint NOT NULL,

--     created_at timestamptz DEFAULT now() NOT NULL,
--     updated_at timestamptz DEFAULT now() NOT NULL,

--     CONSTRAINT chat_user_pkey PRIMARY KEY (chat_id, user_id)
-- );

-- CREATE TABLE "chat_user_admin" (
--     chat_id bigint NOT NULL REFERENCES "chat"(id),
--     user_id integer NOT NULL REFERENCES "user"(id),

--     can_be_edited boolean DEFAULT false NOT NULL,
--     can_change_info boolean DEFAULT false NOT NULL,
--     can_delete_messages boolean DEFAULT false NOT NULL,
--     can_invite_users boolean DEFAULT false NOT NULL,
--     can_restrict_members boolean DEFAULT false NOT NULL,
--     can_pin_messages boolean DEFAULT false NOT NULL,
--     can_promote_members boolean DEFAULT false NOT NULL,
--     can_post_messages boolean DEFAULT false NOT NULL, -- Channels only
--     can_edit_messages boolean DEFAULT false NOT NULL, -- Channels only

--     created_at timestamptz DEFAULT now() NOT NULL,
--     updated_at timestamptz DEFAULT now() NOT NULL,

--     CONSTRAINT chat_user_admin_pkey PRIMARY KEY (chat_id, user_id)
-- );

-- CREATE TABLE "chat_user_restricted" (
--     chat_id bigint NOT NULL REFERENCES "chat"(id),
--     user_id integer NOT NULL REFERENCES "user"(id),

--     until_date timestamptz, -- Date when restrictions will be lifted for this user, if ever
--     can_send_messages boolean DEFAULT true NOT NULL,
--     can_send_media_messages boolean DEFAULT true NOT NULL, -- implies can_send_messages
--     can_send_other_messages boolean DEFAULT true NOT NULL, -- implies can_send_media_messages
--     can_add_web_page_previews boolean DEFAULT true NOT NULL -- implies can_send_media_messages

--     created_at timestamptz DEFAULT now() NOT NULL,
--     updated_at timestamptz DEFAULT now() NOT NULL,

--     CONSTRAINT chat_user_restricted_pkey PRIMARY KEY (chat_id, user_id)
-- );

--
-- Triggers
--

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON "chat"
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_updated_at();

-- CREATE TRIGGER set_updated_at
--     BEFORE UPDATE ON "chat_user"
--     FOR EACH ROW
--     EXECUTE PROCEDURE trigger_set_updated_at();

--
-- Foreign Keys
--

-- ALTER TABLE chat_user
--     ADD CONSTRAINT chat_user_chat_id_fkey FOREIGN KEY (chat_id)
--     REFERENCES "chat"(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- ALTER TABLE chat_user
--     ADD CONSTRAINT chat_user_user_id_fkey FOREIGN KEY (user_id)
--     REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;
