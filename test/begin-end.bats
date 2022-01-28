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
