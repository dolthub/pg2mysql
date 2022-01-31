load $BATS_TEST_DIRNAME/common.bash

setup() {
    setup_common
}

teardown() {
    teardown_common
}

@test "Skip tables argument" {
      pg2mysql.pl --skip public.table2 <<PGDUMP > out.sql
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
-- Name: table1; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.table1 (
    c1 integer
);


ALTER TABLE public.table1 OWNER TO timsehn;

--
-- Name: table2; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.table2 (
    c1 integer
);


ALTER TABLE public.table2 OWNER TO timsehn;

--
-- Name: table3; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.table3 (
    c1 integer
);


ALTER TABLE public.table3 OWNER TO timsehn;

--
-- Data for Name: table1; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Data for Name: table2; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Data for Name: table3; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- PostgreSQL database dump complete
--
PGDUMP
      dolt sql < out.sql

      run dolt sql -q "use public; show tables;"
      [ $status -eq 0 ]
      [[ ! "$output" =~ "table2" ]] || false
      [[ "$output" =~ "table1" ]] || false
      [[ "$output" =~ "table3" ]] || false

      pg2mysql.pl --skip public.table1 --skip public.table2 --skip public.table3 <<PGDUMP > out.sql
CREATE TABLE public.table1 (
    c1 integer
);
CREATE TABLE public.table2 (
    c1 integer
);
CREATE TABLE public.table3 (
    c1 integer
);                            
PGDUMP
      dolt sql < out.sql

      run dolt sql -q "use public; show tables;"
      [ $status -eq 0 ]
      [[ ! "$output" =~ "table1" ]] || false
      [[ ! "$output" =~ "table2" ]] || false
      [[ ! "$output" =~ "table3" ]] || false

      pg2mysql.pl --skip garbage <<PGDUMP > out.sql
CREATE TABLE public.table1 (
    c1 integer
);
CREATE TABLE public.table2 (
    c1 integer
);
CREATE TABLE public.table3 (
    c1 integer
);                            
PGDUMP
      dolt sql < out.sql

      run dolt sql -q "use public; show tables;"
      [ $status -eq 0 ]
      [[ "$output" =~ "table1" ]] || false
      [[ "$output" =~ "table2" ]] || false
      [[ "$output" =~ "table3" ]] || false
}

@test "Basic --insert_ignore" {
    pg2mysql.pl --insert_ignore <<PGDUMP > out.sql
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
-- Name: insert_ignore; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.insert_ignore (
    pk integer NOT NULL,
    c1 integer,
    c2 integer,
    c3 integer
);


ALTER TABLE public.insert_ignore OWNER TO timsehn;

--
-- Data for Name: insert_ignore; Type: TABLE DATA; Schema: public; Owner: timsehn
--

INSERT INTO public.insert_ignore VALUES (0, 0, 0, 0);
INSERT INTO public.insert_ignore VALUES (1, 1, 1, 1);


--
-- Name: insert_ignore insert_ignore_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.insert_ignore
    ADD CONSTRAINT insert_ignore_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

    run cat out.sql
    [[ "$output" =~ "INSERT IGNORE" ]] || false

    dolt sql < out.sql
}
