load $BATS_TEST_DIRNAME/common.bash

setup() {
    setup_common
}

teardown() {
    teardown_common
}

@test "Simple database and keyed table creation with integer types" {
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
-- Name: basic_test; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.basic_test (
    pk integer NOT NULL,
    c1 integer
);
ALTER TABLE public.basic_test OWNER TO timsehn;

--
-- Data for Name: basic_test; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: basic_test basic_test_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.basic_test
    ADD CONSTRAINT basic_test_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

     dolt sql < out.sql

     [ -d "public" ]

     run dolt sql -q "use public; show tables;"
     [ $status -eq 0 ]
     [[ "$output" =~ "basic_test" ]] || false

     run dolt sql -q "use public; describe basic_test;"
     [ $status -eq 0 ]
     [[ "$output" =~ "pk" ]] || false
     [[ "$output" =~ "c1" ]] || false
}

@test "Two column table with integer types now with rows inserted" {
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
-- Name: basic_test; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.basic_test (
    pk integer NOT NULL,
    c1 integer
);


ALTER TABLE public.basic_test OWNER TO timsehn;

--
-- Data for Name: basic_test; Type: TABLE DATA; Schema: public; Owner: timsehn
--

INSERT INTO public.basic_test VALUES (0, 0);
INSERT INTO public.basic_test VALUES (1, 1);
INSERT INTO public.basic_test VALUES (2, 2);


--
-- Name: basic_test basic_test_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.basic_test
    ADD CONSTRAINT basic_test_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

     dolt sql < out.sql

     run dolt sql -q "use public; select * from basic_test;"
     [ $status -eq 0 ]
     [[ "$output" =~ "0" ]] || false
     [[ "$output" =~ "1" ]] || false
     [[ "$output" =~ "2" ]] || false
}

@test "Numeric types: int, bigint, float8, numeric(1,1), real, smallint" {
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
-- Name: numeric_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.numeric_types (
    pk integer NOT NULL,
    c1 bigint,
    c2 double precision,
    c3 numeric(1,1),
    c4 real,
    c5 smallint
);


ALTER TABLE public.numeric_types OWNER TO timsehn;

--
-- Data for Name: numeric_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: numeric_types numeric_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.numeric_types
    ADD CONSTRAINT numeric_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--

PGDUMP

      dolt sql < out.sql

      run dolt sql -q "use public; show tables;"
      [ $status -eq 0 ]
      [[ "$output" =~ "numeric_types" ]] || false

      run dolt sql -q "use public; show create table numeric_types;"
      [ $status -eq 0 ]
      [[ "$output" =~ "int" ]] || false
      [[ "$output" =~ "bigint" ]] || false
      [[ "$output" =~ "double" ]] || false
      [[ "$output" =~ "decimal(1,1)" ]] || false
      [[ "$output" =~ "smallint" ]] || false
}

@test "Text types: text, char(1), varchar(1)" {
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
-- Name: text_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.text_types (
    pk integer NOT NULL,
    c1 text,
    c2 character(1),
    c3 character varying(1)
);


ALTER TABLE public.text_types OWNER TO timsehn;

--
-- Data for Name: text_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: text_types text_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.text_types
    ADD CONSTRAINT text_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    dolt sql < out.sql

    run dolt sql -q "use public; show create table text_types;"
    [ $status -eq 0 ]
    [[ "$output" =~ "longtext" ]] || false
    [[ "$output" =~ "char(1)" ]] || false
    [[ "$output" =~ "varchar(1)" ]] || false
}

@test "Date/Time types: timestamp, time, date" {
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
-- Name: time_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.time_types (
    pk integer NOT NULL,
    c1 timestamp without time zone,
    c2 timestamp(1) without time zone,
    c3 time without time zone,
    c4 time(1) without time zone,
    c5 date,
    c6 timestamp with time zone
);


ALTER TABLE public.time_types OWNER TO timsehn;

--
-- Data for Name: time_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: time_types time_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.time_types
    ADD CONSTRAINT time_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    skip "Dolt does not support the length of time yet. But this is valid MySQL"
    dolt sql < out.sql

    run dolt sql -q "use public; show create table text_types;"
    [ $status -eq 0 ]
    [[ "$output" =~ "timestamp" ]] || false
    [[ "$output" =~ "timestamp(1)" ]] || false
    [[ "$output" =~ "time" ]] || false
    [[ "$output" =~ "time(1)" ]] || false
    [[ "$output" =~ "date" ]] || false
}

@test "JSON types: json, jsonb" {
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
-- Name: json_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.json_types (
    pk integer NOT NULL,
    c1 json,
    c2 jsonb
);
ALTER TABLE public.json_types OWNER TO timsehn;

--
-- Data for Name: json_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: json_types json_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.json_types
    ADD CONSTRAINT json_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    dolt sql < out.sql

    run dolt sql -q "use public; show create table json_types;"
    [ $status -eq 0 ]
    [[ "$output" =~ "json" ]] || false
    [[ ! "$output" =~ "jsonb" ]] || false
}

@test "Binary types: bytea" {
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
-- Name: binary_types; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.binary_types (
    pk integer NOT NULL,
    c1 bytea
);


ALTER TABLE public.binary_types OWNER TO timsehn;

--
-- Data for Name: binary_types; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: binary_types binary_types_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.binary_types
    ADD CONSTRAINT binary_types_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    dolt sql < out.sql

    run dolt sql -q "use public; show create table binary_types;"
    [ $status -eq 0 ]
    [[ "$output" =~ "blob" ]] || false
    [[ ! "$output" =~ "bytea" ]] || false
}

@test "Boolean type" {
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
-- Name: boolean_type; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.boolean_type (
    pk integer NOT NULL,
    c1 boolean
);


ALTER TABLE public.boolean_type OWNER TO timsehn;

--
-- Data for Name: boolean_type; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: boolean_type boolean_type_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.boolean_type
    ADD CONSTRAINT boolean_type_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    dolt sql < out.sql

    run dolt sql -q "use public; show create table boolean_type;"
    [ $status -eq 0 ]
    [[ "$output" =~ "tinyint" ]] || false
}

@test "Serial primary key translated to autoincrement" {
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
-- Name: serial_pk; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.serial_pk (
    pk integer NOT NULL,
    c1 integer,
    c2 integer
);


ALTER TABLE public.serial_pk OWNER TO timsehn;

--
-- Name: serial_pk_pk_seq; Type: SEQUENCE; Schema: public; Owner: timsehn
--

CREATE SEQUENCE public.serial_pk_pk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serial_pk_pk_seq OWNER TO timsehn;

--
-- Name: serial_pk_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: timsehn
--

ALTER SEQUENCE public.serial_pk_pk_seq OWNED BY public.serial_pk.pk;


--
-- Name: serial_pk pk; Type: DEFAULT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.serial_pk ALTER COLUMN pk SET DEFAULT nextval('public.serial_pk_pk_seq'::regclass);


--
-- Data for Name: serial_pk; Type: TABLE DATA; Schema: public; Owner: timsehn
--

INSERT INTO public.serial_pk VALUES (1, 0, 0);
INSERT INTO public.serial_pk VALUES (2, 1, 1);


--
-- Name: serial_pk_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: timsehn
--

SELECT pg_catalog.setval('public.serial_pk_pk_seq', 2, true);


--
-- Name: serial_pk serial_pk_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.serial_pk
    ADD CONSTRAINT serial_pk_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP
    dolt sql < out.sql

    skip "Dolt alters on non-used databases in jacked"
    run dolt sql -q "use public; show create table serial_pk;"
    [ $status -eq 0 ]
    [[ "$output" =~ "autoincrement" ]] || false
}
