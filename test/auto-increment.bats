load $BATS_TEST_DIRNAME/common.bash

setup() {
    setup_common
}

teardown() {
    teardown_common
}

@test "set auto increment sequence number" {
     run pg2mysql.pl <<PGDUMP
SELECT pg_catalog.setval('public.my_table_id_seq', 33, true);
select * from t;
PGDUMP

     echo $output
     [ $status -eq 0 ] 
     [[ "$output" =~ "ALTER TABLE my_table AUTO_INCREMENT = 33;" ]] || false
     ! [[ "$output" =~ "select * from t" ]] || false
}
