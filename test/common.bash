setup_common() {
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

teardown_common() {
    rm -rf "$BATS_TMPDIR/dolt-repo-$$"
}
