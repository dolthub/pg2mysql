setup () {
    if [ -z "$BATS_TMPDIR" ]; then
	export BATS_TMPDIR=$HOME/batstmp/
	mkdir $BATS_TMPDIR
    fi

    # Assume pg2mysql.pl exists in the directory above this one
    export PATH=$PATH:~/go/bin:$PWD/../
    cd $BATS_TMPDIR

    # remove directory if exists
    # reruns recycle pids
    rm -rf "dolt-repo-$$"

    # Append the directory name with the pid of the calling process so
    # multiple tests can be run in parallel on the same machine
    mkdir "dolt-repo-$$"
    cd "dolt-repo-$$"
}

teardown() {
    rm -rf "$BATS_TMPDIR/dolt-repo-$$"
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

    skip "Dolt does not accept alters on tables like <db>.<table>"
    dolt sql < out.sql

}
