load $BATS_TEST_DIRNAME/common.bash

setup () {
    setup_common
}

teardown() {
    teardown_common
}

@test "Test for begin/end keyword handling" {
     run pg2mysql.pl <<PGDUMP 
insert into foo values('begin', 'end');
insert into foo values('begin');
create table end(c1 int);
begin
this is garbage
end bla;
BEGIN
garbage again
END
PGDUMP

     [ $status -eq 0 ]
     [[ "$output" =~ "insert" ]] || false
     [[ "$output" =~ "create" ]] || false
     [[ ! "$output" =~ "garbage" ]] || false
}
