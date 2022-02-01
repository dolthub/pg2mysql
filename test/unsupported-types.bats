load $BATS_TEST_DIRNAME/common.bash

setup() {
    setup_common
}

teardown() {
    teardown_common
}

@test "network types" {
     pg2mysql.pl <<PGDUMP > out.sql
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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
-- Name: network_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.network_types (
    pk integer NOT NULL,
    c1 cidr,
    c2 inet,
    c3 macaddr
);


ALTER TABLE public.network_types OWNER TO timsehn;

--
-- Data for Name: network_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--

INSERT INTO public.network_types VALUES (1, '192.168.100.128/25', '192.168.100.128/25', '08:00:2b:01:02:03');

--
-- Name: network_types network_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.network_types
    ADD CONSTRAINT network_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

     dolt sql < out.sql

     run dolt sql -q "use public; show create table network_types;"
     [ $status -eq 0 ]
     [[ "$output" =~ "varchar(32)" ]] || false
     [[ ! "$output" =~ "cidr" ]] || false
     [[ ! "$output" =~ "inet" ]] || false
     [[ ! "$output" =~ "macaddr" ]] || false

     run dolt sql -q "use public; select * from network_types;"
     [ $status -eq 0 ]
     [[ "$output" =~ "192.168.100.128/25" ]] || false
     [[ "$output" =~ "08:00:2b:01:02:03" ]] || false
}

@test "enum types" {
    run pg2mysql.pl --strict <<PGDUMP
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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

--
-- Name: mood; Type: TYPE; Schema: public; Owner: timsehn
--

CREATE TYPE public.mood AS ENUM (
    'sad',
    'ok',
    'happy'
);


ALTER TYPE public.mood OWNER TO timsehn;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: enum_type; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.enum_type (
    pk integer NOT NULL,
    c1 public.mood
);


ALTER TABLE public.enum_type OWNER TO timsehn;

--
-- Data for Name: enum_type; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: enum_type enum_type_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.enum_type
    ADD CONSTRAINT enum_type_pkey PRIMARY KEY (pk);

--
-- PostgreSQL database dump complete
--
PGDUMP

    [ $status -ne 0 ]
    [[ "$output" =~ "CREATE TYPE statements not supported" ]] || false
}    

@test "money type" {
    pg2mysql.pl <<PGDUMP > out.sql
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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
-- Name: money_type; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.money_type (
    pk integer NOT NULL,
    c1 money
);


ALTER TABLE public.money_type OWNER TO timsehn;

--
-- Data for Name: money_type; Type: TABLE DATA; Schema: public; Owner: timsehn
--

INSERT INTO public.money_type VALUES (0, '$100.00');
INSERT INTO public.money_type VALUES (1, '$10.00');
INSERT INTO public.money_type VALUES (2, '$1.00');


--
-- Name: money_type money_type_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.money_type
    ADD CONSTRAINT money_type_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    dolt sql < out.sql

     run dolt sql -q "use public; show create table money_type;"
     [ $status -eq 0 ]
     [[ "$output" =~ "varchar(32)" ]] || false
     [[ ! "$output" =~ "c1 money" ]] || false

     run dolt sql -q "use public; select * from money_type;"
     [ $status -eq 0 ]
     [[ "$output" =~ "$100.00" ]] || false
     [[ "$output" =~ "$10.00" ]] || false
     [[ "$output" =~ "$1.00" ]] || false
}

@test "Serial types: smallserial, serial, bigserial" {
    pg2mysql.pl <<PGDUMP > out.sql
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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
-- Name: serial_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.serial_types (
    pk integer NOT NULL,
    c1 smallint NOT NULL,
    c2 integer NOT NULL,
    c3 bigint NOT NULL
);
ALTER TABLE public.serial_types OWNER TO timsehn;

--
-- Name: serial_types_c1_seq; Type: SEQUENCE; Schema: public; Owner: timsehn
--

CREATE SEQUENCE public.serial_types_c1_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serial_types_c1_seq OWNER TO timsehn;

--
-- Name: serial_types_c1_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: timsehn
--

ALTER SEQUENCE public.serial_types_c1_seq OWNED BY public.serial_types.c1;


--
-- Name: serial_types_c2_seq; Type: SEQUENCE; Schema: public; Owner: timsehn
--

CREATE SEQUENCE public.serial_types_c2_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
erial_types_c2_seq'::regclass);


--
-- Name: serial_types c3; Type: DEFAULT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.serial_types ALTER COLUMN c3 SET DEFAULT nextval('public.serial_types_c3_seq'::regclass);


--
-- Data for Name: serial_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: serial_types_c1_seq; Type: SEQUENCE SET; Schema: public; Owner: timsehn
--

SELECT pg_catalog.setval('public.serial_types_c1_seq', 1, false);


--
-- Name: serial_types_c2_seq; Type: SEQUENCE SET; Schema: public; Owner: timsehn
--

SELECT pg_catalog.setval('public.serial_types_c2_seq', 1, false);


--
-- Name: serial_types_c3_seq; Type: SEQUENCE SET; Schema: public; Owner: timsehn
--

SELECT pg_catalog.setval('public.serial_types_c3_seq', 1, false);


--
-- Name: serial_types serial_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.serial_types
    ADD CONSTRAINT serial_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    skip "Dolt only allows auto increments on keys. MySQL only allows auto increment on keys or indexed columns."
    dolt sql < out.sql   
    
}
