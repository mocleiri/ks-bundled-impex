Docker - Trusted Build for Kuali Student Bundled
================================================

You can test it out by issuing:
```
docker run -p 8080:8080 -t hrafique/kuali-student-bundled
```
Note: this will expose port `8080` from the container to port `8080` on the docker host.

Following environment variables are supported:

Environment Variable | Default Value | Comment
--- | --- | ---
`ORACLE_DBA_URL` | jdbc:oracle:thin:@localhost:1521:XE | URL to Oracle Database
`ORACLE_DBA_PASSWORD` | manager | Oracle DBA Password
`SKIP_DB_RESET` | false | If `true`, the database reset is skipped

A full command invocation might look like:
```
docker run -e ORACLE_DBA_URL=jdbc:oracle:thin:@128.x.x.x:1521:XE \
    -e SKIP_DB_RESET=true -p 8080:8080 -t hrafique/kuali-student-bundled
```
