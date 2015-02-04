Build for Kuali Student Bundled Impex
======================================================

This will load the database content required to run the ks-bundled-app for
a specific build tag.

If you are running oracle in a docker container it can be committed after
impex runs and this step may only be needed once per build.


Run wnameless/oracle-xe-11g Container
-------------------------------------

Startup an oracle container:
```
$ docker run --name oracle -d -t wnameless/oracle-xe-11g
```

Run impex against oracle Container
----------------------------------

```
$ docker run -i -t --link oracle:db mocleiri/bundled-impex:build-799
```

Run impex against oracle db running on the host
-----------------------------------------------

```
$ docker run -i -t -e ORACLE_DBA_PASSWORD=<password> -e ORACLE_DBA_URL="jdbc:oracle:thin:@<lan ip of host computer>:1521:XE" mocleiri/bundled-impex:build-799
```
Following environment variables are supported:

Environment Variable | Default Value | Comment
--- | --- | ---
`ORACLE_DBA_URL` | jdbc:oracle:thin:@localhost:1521:XE | URL to Oracle Database
`ORACLE_DBA_PASSWORD` | manager | Oracle DBA Password
`SKIP_DB_RESET` | false | If `true`, the database reset is skipped

If linked to a container with the db alias the *ORACLE_DBA_URL* will be automatically constructed.

Once the impex process has completed the container will stop.

The oracle container could be committed at this point in time as a way to quickely restore back to the post impex situation.  Note that the image saved at this point is in the 5 GB region and not very portable.  But it can be useful within the same docker instance.
