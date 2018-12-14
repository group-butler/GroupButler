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

--
-- Triggers
--

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON "chat"
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_updated_at();
