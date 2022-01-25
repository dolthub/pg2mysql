# pg2mysql

pg2mysql transforms a pgdump file on STDIN into a MySQL dump file on
STDOUT. Dump format must be `INSERT` statements, not binary or `COPY`
statements (ie. `pg_dump --insert <dbname>`).

Usage:

```
./pg2mysql.pl < file.pgdump > mysql.sql
./pg2mysql.pl --skip table1 --skip table2 --insert_ignore < file.pgdump > mysql.sql 2>warnings.txt
```

It handles:

* `CREATE TABLE` statements, types converted to MySQL equivalents
* `INSERT INTO` statements, some values (like timestamp strings)
  massaged to work with MySQL
* `CREATE INDEX` statements
* `ALTER TABLE` statements (for foreign keys, other constraints)
* Sequence `nextval` column defaults translated to `auto_increment`
* With --insert_ignore, uses `INSERT IGNORE` statements to be more
  lenient with non-confirming values (at the cost of import accuracy)
  
All other statement types other than the ones above are ignored, and
echoed as SQL comments to STDERR. If you want them in your final
script, redirect STDERR to STDOUT with `2 >&1` when running the
script.

# Known issues

The script has a lot of limitations and there are surely bugs. If you
find some, file an issue to tell us. But these are the things we know
about:

* Only tables supported. Other schema entities like triggers, views,
  stored procedures are not created
* Some types badly / not supported
* Will convert a character varying type to longtext if no length is
  specified, which means MySQL won't be able to make it a key

# Requirements

You must have Perl installed at `/usr/bin/perl` to run the script directly.

# Credits

pg2mysql is heavily inspired and informed by this project of the same
name: https://github.com/ChrisLundquist/pg2mysql

Which in turn was adapated from this web form:
http://www.lightbox.ca/pg2mysql.php
