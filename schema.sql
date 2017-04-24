--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: array_distinct(anyarray); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION array_distinct(anyarray) RETURNS anyarray
    LANGUAGE sql IMMUTABLE
    AS $_$
  SELECT array_agg(DISTINCT x) FROM unnest($1) t(x);
$_$;


ALTER FUNCTION public.array_distinct(anyarray) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: antiflood; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE antiflood (
    chatid bigint NOT NULL,
    text boolean DEFAULT true NOT NULL,
    photo boolean DEFAULT true NOT NULL,
    forward boolean DEFAULT true NOT NULL,
    video boolean DEFAULT true NOT NULL,
    sticker boolean DEFAULT true NOT NULL,
    gif boolean DEFAULT true NOT NULL,
    threshold integer DEFAULT 5 NOT NULL,
    action text DEFAULT 'kick'::text NOT NULL,
    exceptions text[]
);


ALTER TABLE antiflood OWNER TO postgres;

--
-- Name: antimedia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE antimedia (
    chatid bigint NOT NULL,
    photo boolean DEFAULT false NOT NULL,
    audio boolean DEFAULT false NOT NULL,
    video boolean DEFAULT false NOT NULL,
    sticker boolean DEFAULT false NOT NULL,
    gif boolean DEFAULT false NOT NULL,
    voice boolean DEFAULT false NOT NULL,
    contact boolean DEFAULT false NOT NULL,
    document boolean DEFAULT false NOT NULL,
    link boolean DEFAULT false NOT NULL,
    game boolean DEFAULT false NOT NULL,
    location boolean DEFAULT false NOT NULL,
    warnings integer DEFAULT 2 NOT NULL,
    action text DEFAULT 'ban'::text NOT NULL
);


ALTER TABLE antimedia OWNER TO postgres;

--
-- Name: antispam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE antispam (
    chatid bigint NOT NULL,
    link boolean DEFAULT false NOT NULL,
    forward boolean DEFAULT false NOT NULL,
    warnings integer DEFAULT 2 NOT NULL,
    action text DEFAULT 'ban'::text NOT NULL
);


ALTER TABLE antispam OWNER TO postgres;

--
-- Name: chat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat (
    chatid bigint NOT NULL,
    lang text DEFAULT 'en'::text NOT NULL,
    owner integer,
    admins integer[],
    mods integer[],
    lastmsg timestamp with time zone DEFAULT now() NOT NULL,
    timezone text DEFAULT 'UTC'::text NOT NULL,
    members integer[],
    rtl text,
    arab text,
    warning_threshold integer DEFAULT 3 NOT NULL,
    warning_action text DEFAULT 'ban'::text NOT NULL,
    CONSTRAINT chat_lastmsg_ts_check CHECK ((date_part('timezone'::text, lastmsg) = '0'::double precision))
);


ALTER TABLE chat OWNER TO postgres;

--
-- Name: stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stats (
    chatid bigint NOT NULL,
    messages bigint DEFAULT 1 NOT NULL
);


ALTER TABLE stats OWNER TO postgres;

--
-- Name: tolog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tolog (
    chatid bigint NOT NULL,
    ban boolean DEFAULT false NOT NULL,
    kick boolean DEFAULT false NOT NULL,
    unban boolean DEFAULT false NOT NULL,
    tempban boolean DEFAULT false NOT NULL,
    report boolean DEFAULT false NOT NULL,
    warn boolean DEFAULT false NOT NULL,
    nowarn boolean DEFAULT false NOT NULL,
    mediawarn boolean DEFAULT false NOT NULL,
    spamwarn boolean DEFAULT false NOT NULL,
    flood boolean DEFAULT false NOT NULL,
    promote boolean DEFAULT false NOT NULL,
    demote boolean DEFAULT false NOT NULL,
    cleanmods boolean DEFAULT false NOT NULL,
    new_chat_member boolean DEFAULT false NOT NULL,
    new_chat_photo boolean DEFAULT false NOT NULL,
    delete_chat_photo boolean DEFAULT false NOT NULL,
    new_chat_title boolean DEFAULT false NOT NULL,
    pinned_message boolean DEFAULT false NOT NULL,
    blockban boolean DEFAULT false NOT NULL,
    block boolean DEFAULT false NOT NULL,
    unblock boolean DEFAULT false NOT NULL
);


ALTER TABLE tolog OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    userid integer NOT NULL,
    username text NOT NULL,
    blocked boolean DEFAULT false NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: antiflood antiflood_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY antiflood
    ADD CONSTRAINT antiflood_pkey PRIMARY KEY (chatid);


--
-- Name: antispam antispam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY antispam
    ADD CONSTRAINT antispam_pkey PRIMARY KEY (chatid);


--
-- Name: chat chat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat
    ADD CONSTRAINT chat_pkey PRIMARY KEY (chatid);


--
-- Name: antimedia media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY antimedia
    ADD CONSTRAINT media_pkey PRIMARY KEY (chatid);


--
-- Name: stats stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (chatid);


--
-- Name: tolog tolog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tolog
    ADD CONSTRAINT tolog_pkey PRIMARY KEY (chatid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- PostgreSQL database dump complete
--

