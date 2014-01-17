#/bin/bash

mkdir -p /root/kuali/main/dev
svnexport=/svnexport/ks-deployment-resources-$BUILD_NUMBER
path=src/main/resources/org/kuali/student/ks-deployment-resources/deploy/config
cp -p $svnexport/$path/ks-with-rice-bundled-config.xml \
    /root/kuali/main/dev/ks-with-rice-bundled-config.xml

# do some substitutions
sed -i.bak \
    -e 's#${public.url}#http://localhost:8080#g' \
    -e "s#\${jdbc.url}#${ORACLE_DBA_URL}#g" \
    -e 's#${jdbc.username}#KSBUNDLED#g' \
    -e 's#${jdbc.password}#KSBUNDLED#g' \
    -e 's#${jdbc.pool.size.max}#20#g' \
    -e 's#${keystore.file.default}#/rice.keystore#g' \
    /root/kuali/main/dev/ks-with-rice-bundled-config.xml

# skip the database reset if SKIP_DB_RESET is true (default: false)
if [ ! ${SKIP_DB_RESET} ]
then
    cd /svnexport/ks-impex-bundled-db-build-$BUILD_NUMBER && \
        mvn initialize -Pdb,oracle \
            -Doracle.dba.url=$ORACLE_DBA_URL \
            -Doracle.dba.password=$ORACLE_DB_PASSWORD
fi

# copy war to ROOT.war in tomcat's webapp directory
path=/root/.m2/repository/org/kuali/student/web/ks-with-rice-bundled/2.1.1-FR2-M1-build-$BUILD_NUMBER
cp -p $path/ks-with-rice-bundled-2.1.1-FR2-M1-build-$BUILD_NUMBER.war \
    /usr/share/tomcat/webapps/ROOT.war

/usr/share/tomcat/bin/startup.sh && tail -F /usr/share/tomcat/logs/catalina.out
