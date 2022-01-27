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

     run dolt sql < out.sql

     [ -d "public" ]

     run dolt sql -q "use public; show tables;"
     [ $status -eq 0 ]
     [[ "$output" =~ "basic_test" ]] || false

     run dolt sql -q "use public; describe basic_test;"
     [ $status -eq 0 ]
     [[ "$output" =~ "pk" ]] || false
     [[ "$output" =~ "c1" ]] || false
}
