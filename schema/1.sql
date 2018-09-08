--
-- Tables
--

CREATE TABLE "user" (
    id integer NOT NULL,
    is_bot boolean NOT NULL,
    first_name text NOT NULL,
    last_name text,
    username text,
    language_code varchar(35) DEFAULT 'en-gb' NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE "chat" (
    id bigint NOT NULL,
    type varchar(10) NOT NULL,
    title text NOT NULL, -- Only private chats don't have titles, and we already store private info under "user"
    username text,
    invite_link text,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE "chat_user" (
    chat_id bigint NOT NULL,
    user_id integer NOT NULL,
    status varchar(13) NOT NULL,
    until_date timestamptz,

    can_be_edited boolean DEFAULT false NOT NULL, -- Administrators only
    can_change_info boolean DEFAULT false NOT NULL, -- Administrators only
    can_post_messages boolean DEFAULT false NOT NULL, -- Administrators only, channels only
    can_edit_messages boolean DEFAULT false NOT NULL, -- Administrators only, channels only
    can_delete_messages boolean DEFAULT false NOT NULL, -- Administrators only
    can_invite_users boolean DEFAULT false NOT NULL, -- Administrators only
    can_restrict_members boolean DEFAULT false NOT NULL, -- Administrators only
    can_pin_messages boolean DEFAULT false NOT NULL, -- Administrators only
    can_promote_members boolean DEFAULT false NOT NULL, -- Administrators only

    can_send_messages boolean DEFAULT true NOT NULL, -- Restricted only
    can_send_media_messages boolean DEFAULT true NOT NULL, -- Restricted only, implies can_send_messages
    can_send_other_messages boolean DEFAULT true NOT NULL, -- Restricted only, implies can_send_media_messages
    can_add_web_page_previews boolean DEFAULT true NOT NULL, -- Restricted only, implies can_send_media_messages

    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

--
-- Triggers
--

CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON "user"
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_updated_at();

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON "chat"
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_updated_at();

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON "chat_user"
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_updated_at();

--
-- Primary Keys
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "chat"
    ADD CONSTRAINT chat_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "chat_user"
    ADD CONSTRAINT chat_user_pkey PRIMARY KEY (chat_id, user_id);

--
-- Foreign Keys
--

ALTER TABLE ONLY chat_user
    ADD CONSTRAINT chat_user_chat_id_fkey FOREIGN KEY (chat_id)
    REFERENCES "chat"(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY chat_user
    ADD CONSTRAINT chat_user_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;

--
-- Indexes
--

CREATE UNIQUE INDEX user_username_lower_idx ON "user" (lower(username));
