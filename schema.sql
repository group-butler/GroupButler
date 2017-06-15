--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: chat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat (
    chat_id bigint NOT NULL,
    lang text DEFAULT 'en'::text NOT NULL,
    lastmsg timestamp with time zone DEFAULT now() NOT NULL,
    timezone text DEFAULT 'UTC'::text NOT NULL,
    rtl text,
    arab text,
    warning_threshold integer DEFAULT 3 NOT NULL,
    warning_action text DEFAULT 'ban'::text NOT NULL,
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
    antibot boolean DEFAULT false NOT NULL,
    antiflood_action text DEFAULT 'kick'::text NOT NULL,
    antiflood_threshold integer DEFAULT 5 NOT NULL,
    antiflood_document boolean DEFAULT true NOT NULL,
    antiflood_link boolean DEFAULT true NOT NULL,
    antiflood_text boolean DEFAULT true NOT NULL,
    antiflood_photo boolean DEFAULT true NOT NULL,
    antiflood_forward boolean DEFAULT true NOT NULL,
    antiflood_video boolean DEFAULT true NOT NULL,
    antiflood_sticker boolean DEFAULT true NOT NULL,
    antiflood_gif boolean DEFAULT true NOT NULL,
    antimedia_action text DEFAULT 'ban'::text NOT NULL,
    antimedia_warnings integer DEFAULT 2 NOT NULL,
    antimedia_allowed_links text[],
    antimedia_photo boolean DEFAULT false NOT NULL,
    antimedia_audio boolean DEFAULT false NOT NULL,
    antimedia_video boolean DEFAULT false NOT NULL,
    antimedia_sticker boolean DEFAULT false NOT NULL,
    antimedia_gif boolean DEFAULT false NOT NULL,
    antimedia_voice boolean DEFAULT false NOT NULL,
    antimedia_contact boolean DEFAULT false NOT NULL,
    antimedia_document boolean DEFAULT false NOT NULL,
    antimedia_link boolean DEFAULT false NOT NULL,
    antimedia_game boolean DEFAULT false NOT NULL,
    antimedia_location boolean DEFAULT false NOT NULL,
    antispam_action text DEFAULT 'ban'::text NOT NULL,
    antispam_warnings integer DEFAULT 2 NOT NULL,
    antispam_link boolean DEFAULT false NOT NULL,
    antispam_forward boolean DEFAULT false NOT NULL,
    mod_admin_promdem boolean DEFAULT true NOT NULL,
    mod_hammer boolean DEFAULT true NOT NULL,
    mod_config boolean DEFAULT false NOT NULL,
    mod_texts boolean DEFAULT false NOT NULL,
    tolog_ban boolean DEFAULT false NOT NULL,
    tolog_kick boolean DEFAULT false NOT NULL,
    tolog_unban boolean DEFAULT false NOT NULL,
    tolog_tempban boolean DEFAULT false NOT NULL,
    tolog_report boolean DEFAULT false NOT NULL,
    tolog_warn boolean DEFAULT false NOT NULL,
    tolog_nowarn boolean DEFAULT false NOT NULL,
    tolog_mediawarn boolean DEFAULT false NOT NULL,
    tolog_spamwarn boolean DEFAULT false NOT NULL,
    tolog_flood boolean DEFAULT false NOT NULL,
    tolog_promote boolean DEFAULT false NOT NULL,
    tolog_demote boolean DEFAULT false NOT NULL,
    tolog_cleanmods boolean DEFAULT false NOT NULL,
    tolog_new_chat_member boolean DEFAULT false NOT NULL,
    tolog_new_chat_photo boolean DEFAULT false NOT NULL,
    tolog_delete_chat_photo boolean DEFAULT false NOT NULL,
    tolog_new_chat_title boolean DEFAULT false NOT NULL,
    tolog_pinned_message boolean DEFAULT false NOT NULL,
    tolog_blockban boolean DEFAULT false NOT NULL,
    tolog_block boolean DEFAULT false NOT NULL,
    tolog_unblock boolean DEFAULT false NOT NULL,
    stats_messages bigint DEFAULT 1 NOT NULL,
    CONSTRAINT chat_lastmsg_ts_check CHECK ((date_part('timezone'::text, lastmsg) = '0'::double precision))
);


ALTER TABLE chat OWNER TO postgres;

--
-- Name: chat_extra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_extra (
    chat_id bigint NOT NULL,
    extra_id text NOT NULL,
    response text NOT NULL,
    kind text DEFAULT 'text'::text NOT NULL
);


ALTER TABLE chat_extra OWNER TO postgres;

--
-- Name: chat_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chat_users (
    chat_id bigint NOT NULL,
    user_id integer NOT NULL,
    ban timestamp with time zone,
    ban_expiration timestamp with time zone,
    warning_media integer DEFAULT 0 NOT NULL,
    warning_spam integer DEFAULT 0 NOT NULL,
    warning_mod integer DEFAULT 0 NOT NULL,
    lastmsg timestamp with time zone DEFAULT now() NOT NULL,
    rank text DEFAULT 'user'::text NOT NULL,
    membership boolean DEFAULT true NOT NULL
);


ALTER TABLE chat_users OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    user_id integer NOT NULL,
    username text NOT NULL,
    blocked boolean DEFAULT false NOT NULL,
    rules_on_join boolean DEFAULT false NOT NULL,
    reports boolean DEFAULT false NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: chat_extra chat_extra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_extra
    ADD CONSTRAINT chat_extra_pkey PRIMARY KEY (chat_id, extra_id);


--
-- Name: chat chat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat
    ADD CONSTRAINT chat_pkey PRIMARY KEY (chat_id);


--
-- Name: chat_users chat_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_users
    ADD CONSTRAINT chat_users_pkey PRIMARY KEY (chat_id, user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: chat_extra chat_extra_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_extra
    ADD CONSTRAINT chat_extra_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES chat(chat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chat_users chat_users_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_users
    ADD CONSTRAINT chat_users_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES chat(chat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chat_users chat_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chat_users
    ADD CONSTRAINT chat_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

