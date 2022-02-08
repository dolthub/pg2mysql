load $BATS_TEST_DIRNAME/common.bash

setup () {
    setup_common
}

teardown() {
    teardown_common
}

@test "Check constraints" {
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
-- Name: constraint_test; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.constraint_test (
    pk integer NOT NULL,
    c1 integer,
    CONSTRAINT constraint_test_pk_check CHECK ((pk > 0))
);


ALTER TABLE public.constraint_test OWNER TO timsehn;

--
-- Data for Name: constraint_test; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: constraint_test constraint_test_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.constraint_test
    ADD CONSTRAINT constraint_test_pkey PRIMARY KEY (pk);


--
-- PostgreSQL database dump complete
--
PGDUMP

      dolt sql < out.sql

      run dolt sql -q "show create table public.constraint_test";
      [ $status -eq 0 ]
      [[ $output =~ CHECK ]] || false
}

@test "Secondary indexes" {
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
-- Name: index_test; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.index_test (
    pk integer NOT NULL,
    c1 integer
);


ALTER TABLE public.index_test OWNER TO timsehn;

--
-- Data for Name: index_test; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: index_test index_test_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.index_test
    ADD CONSTRAINT index_test_pkey PRIMARY KEY (pk);


--
-- Name: index_test_c1_idx; Type: INDEX; Schema: public; Owner: timsehn
--

CREATE INDEX index_test_c1_idx ON public.index_test USING btree (c1);


--
-- PostgreSQL database dump complete
--
PGDUMP

    dolt sql < out.sql

    skip "Dolt does not apply indexes correctly"
    run dolt sql -q "show create table public.index_test";
    [ $status -eq 0 ]
    [[ $output =~ INDEX ]] || false
}

@test "Foreign keys" {
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
-- Name: cities; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.cities (
    pk integer NOT NULL,
    city character varying(255),
    state character varying(2)
);


ALTER TABLE public.cities OWNER TO timsehn;

--
-- Name: states; Type: TABLE; Schema: public; Owner: timsehn
--

CREATE TABLE public.states (
    state_id integer NOT NULL,
    state character varying(2)
);


ALTER TABLE public.states OWNER TO timsehn;

--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: timsehn
--



--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (pk);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (state_id);


--
-- Name: states_state_idx; Type: INDEX; Schema: public; Owner: timsehn
--

CREATE UNIQUE INDEX states_state_idx ON public.states USING btree (state);

--
-- Name: cities foreign_key1; Type: FK CONSTRAINT; Schema: public; Owner: timsehn
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT foreign_key1 FOREIGN KEY (state) REFERENCES public.states(state);

--
-- PostgreSQL database dump complete
--
PGDUMP

    skip "Another example of chained schema failing"
    skip "pg2mysql misses the CREATE UNIQUE INDEX line"
   
    dolt sql < out.sql

    run dolt sql -q "show create table public.cities";
    [ $status -eq 0 ]
    [[ $output =~ "FOREIGN KEY" ]] || false
}
