--
-- Tables
--

CREATE TABLE "user" (
    id integer NOT NULL,
    is_bot boolean NOT NULL,
    first_name text NOT NULL,

    last_name text,
    username text,
    language_code varchar(35), -- BCP47/RFC5646 section 4.4.1 recommended maximum IETF tag length
    -- photo jsonb,

    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,

    CONSTRAINT user_pkey PRIMARY KEY (id)
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

--
-- Indexes
--

CREATE UNIQUE INDEX user_username_lower_idx ON "user" (lower(username));
