#!/bin/bash

if test -n $DB_PORT_1521_TCP_ADDR
then

		ORACLE_DBA_URL="jdbc:oracle:thin:@${DB_PORT_1521_TCP_ADDR}:${DB_PORT_1521_TCP_PORT}:XE"

fi


# skip the database reset if SKIP_DB_RESET is true (default: false)
if test -z $SKIP_DB_RESET || test $SKIP_DB_RESET=="false"
then
    cd /svn-export/ks-impex-bundled-db &&
        mvn initialize -Pdb,oracle \
            -Doracle.dba.url=$ORACLE_DBA_URL \
            -Doracle.dba.password=$ORACLE_DBA_PASSWORD

else
	echo "Skipping DB Reset"
fi
