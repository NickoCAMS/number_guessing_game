--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE number_guess;
--
-- Name: number_guess; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE number_guess WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE number_guess OWNER TO freecodecamp;

\connect number_guess

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: scores; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.scores (
    id integer NOT NULL,
    username character varying(22) NOT NULL,
    guesses integer,
    number_to_guess integer,
    games_played integer DEFAULT 0,
    best_game integer DEFAULT 0
);


ALTER TABLE public.scores OWNER TO freecodecamp;

--
-- Name: scores_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.scores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scores_id_seq OWNER TO freecodecamp;

--
-- Name: scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.scores_id_seq OWNED BY public.scores.id;


--
-- Name: scores id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.scores ALTER COLUMN id SET DEFAULT nextval('public.scores_id_seq'::regclass);


--
-- Data for Name: scores; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.scores VALUES (2, 'user_1731779157426', NULL, NULL, 2, 610);
INSERT INTO public.scores VALUES (1, 'user_1731779157427', NULL, NULL, 5, 23);
INSERT INTO public.scores VALUES (4, 'user_1731779189040', NULL, NULL, 2, 113);
INSERT INTO public.scores VALUES (3, 'user_1731779189041', NULL, NULL, 5, 29);
INSERT INTO public.scores VALUES (6, 'user_1731779230661', NULL, NULL, 2, 710);
INSERT INTO public.scores VALUES (5, 'user_1731779230662', NULL, NULL, 5, 268);
INSERT INTO public.scores VALUES (7, 'Nicko', NULL, NULL, 1, 10);
INSERT INTO public.scores VALUES (9, 'user_1731779405534', NULL, NULL, 2, 167);
INSERT INTO public.scores VALUES (8, 'user_1731779405535', NULL, NULL, 5, 66);
INSERT INTO public.scores VALUES (11, 'user_1731779412844', NULL, NULL, 2, 45);
INSERT INTO public.scores VALUES (10, 'user_1731779412845', NULL, NULL, 5, 385);
INSERT INTO public.scores VALUES (13, 'user_1731779479629', NULL, NULL, 2, 440);
INSERT INTO public.scores VALUES (12, 'user_1731779479630', NULL, NULL, 5, 241);


--
-- Name: scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.scores_id_seq', 13, true);


--
-- Name: scores scores_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

