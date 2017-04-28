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
-- Name: chatuser; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE chatuser AS (
	chatid bigint,
	userid integer
);


ALTER TYPE chatuser OWNER TO postgres;

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
-- Name: chat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat (
    chatid bigint NOT NULL,
    lang text DEFAULT 'en'::text NOT NULL,
    lastmsg timestamp with time zone DEFAULT now() NOT NULL,
    timezone text DEFAULT 'UTC'::text NOT NULL,
    rtl text,
    arab text,
    warning_threshold integer DEFAULT 3 NOT NULL,
    warning_action text DEFAULT 'ban'::text NOT NULL,
    antibot boolean DEFAULT false NOT NULL,
    silent boolean DEFAULT false NOT NULL,
    extra boolean DEFAULT true NOT NULL,
    reports boolean DEFAULT false NOT NULL,
    welcome boolean DEFAULT false NOT NULL,
    welcome_content text[],
    welcome_button boolean DEFAULT false NOT NULL,
    goodbye boolean DEFAULT false NOT NULL,
    goodbye_content text[],
    rules text,
    rules_ongroup boolean DEFAULT false NOT NULL,
    CONSTRAINT chat_lastmsg_ts_check CHECK ((date_part('timezone'::text, lastmsg) = '0'::double precision))
);


ALTER TABLE chat OWNER TO postgres;

--
-- Name: chat_antiflood; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_antiflood (
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


ALTER TABLE chat_antiflood OWNER TO postgres;

--
-- Name: chat_antimedia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_antimedia (
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


ALTER TABLE chat_antimedia OWNER TO postgres;

--
-- Name: chat_antispam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_antispam (
    chatid bigint NOT NULL,
    link boolean DEFAULT false NOT NULL,
    forward boolean DEFAULT false NOT NULL,
    warnings integer DEFAULT 2 NOT NULL,
    action text DEFAULT 'ban'::text NOT NULL
);


ALTER TABLE chat_antispam OWNER TO postgres;

--
-- Name: chat_mod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_mod (
    chatid bigint NOT NULL,
    admin_promdem boolean DEFAULT true NOT NULL,
    hammer boolean DEFAULT true NOT NULL,
    config boolean DEFAULT false NOT NULL,
    texts boolean DEFAULT false NOT NULL
);


ALTER TABLE chat_mod OWNER TO postgres;

--
-- Name: chat_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_stats (
    chatid bigint NOT NULL,
    messages bigint DEFAULT 1 NOT NULL
);


ALTER TABLE chat_stats OWNER TO postgres;

--
-- Name: chat_tolog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_tolog (
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


ALTER TABLE chat_tolog OWNER TO postgres;

--
-- Name: karma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE karma (
    id chatuser NOT NULL,
    ban timestamp with time zone,
    ban_expiration timestamp with time zone,
    warning_flood integer DEFAULT 0 NOT NULL,
    warning_media integer DEFAULT 0 NOT NULL,
    warning_spam integer DEFAULT 0 NOT NULL,
    warning_mod integer DEFAULT 0 NOT NULL,
    lastmsg timestamp with time zone DEFAULT now() NOT NULL,
    rank text DEFAULT 'user'::text
);


ALTER TABLE karma OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    userid integer NOT NULL,
    username text NOT NULL,
    blocked boolean DEFAULT false NOT NULL,
    rules_on_join boolean DEFAULT false NOT NULL,
    reports boolean DEFAULT false NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: chat_antispam antispam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_antispam
    ADD CONSTRAINT antispam_pkey PRIMARY KEY (chatid);


--
-- Name: chat_antiflood chat_antiflood_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_antiflood
    ADD CONSTRAINT chat_antiflood_pkey PRIMARY KEY (chatid);


--
-- Name: chat_antimedia chat_antimedia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_antimedia
    ADD CONSTRAINT chat_antimedia_pkey PRIMARY KEY (chatid);


--
-- Name: chat_mod chat_mod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_mod
    ADD CONSTRAINT chat_mod_pkey PRIMARY KEY (chatid);


--
-- Name: chat chat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat
    ADD CONSTRAINT chat_pkey PRIMARY KEY (chatid);


--
-- Name: chat_stats chat_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_stats
    ADD CONSTRAINT chat_stats_pkey PRIMARY KEY (chatid);


--
-- Name: chat_tolog chat_tolog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_tolog
    ADD CONSTRAINT chat_tolog_pkey PRIMARY KEY (chatid);


--
-- Name: karma karma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY karma
    ADD CONSTRAINT karma_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- PostgreSQL database dump complete
--

