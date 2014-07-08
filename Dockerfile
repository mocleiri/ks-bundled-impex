FROM hrafique/openjdk-quantal

MAINTAINER Haroon Rafique https://github.com/hrafique

# maven settings file
ADD files/settings.xml /root/.m2/settings.xml
ENV OJDBC_VERSION 11.2.0.2

# default to what we get with wnameless/oracle-xe-11g
ENV ORACLE_DBA_PASSWORD oracle

# oracle driver
ADD files/ojdbc6_g-$OJDBC_VERSION.jar /tmp/ojdbc6_g-$OJDBC_VERSION.jar

# install maven

RUN apt-get update
RUN apt-get -y install wget
RUN wget --no-verbose -O /tmp/apache-maven-3.0.5.tar.gz \
    http://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
# stop building if md5sum does not match
RUN echo "94c51f0dd139b4b8549204d0605a5859  /tmp/apache-maven-3.0.5.tar.gz" | \
    md5sum -c

# install in /opt/maven
RUN mkdir -p /opt/maven
RUN tar xzf /tmp/apache-maven-3.0.5.tar.gz --strip-components=1 \
    -C /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.0.5.tar.gz

ENV MAVEN_OPTS -XX:MaxPermSize=350m -Xmx2g

# install oracle driver in local maven repo
RUN mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc6_g \
    -Dversion=$OJDBC_VERSION -Dpackaging=jar \
    -Dfile=/tmp/ojdbc6_g-$OJDBC_VERSION.jar


# install subversion 

RUN apt-get -y install subversion

ENV BUILD_NUMBER 799

# install maven dependency plugin

RUN mkdir /svn-export

RUN cd /svn-export && svn co https://svn.kuali.org/repos/student/enrollment/ks-deployments/tags/builds/ks-deployments-2.1/2.1.1-FR2-M1/build-${BUILD_NUMBER}/ks-dbs/ks-impex/ks-impex-bundled-db/

# download the dependencies for impex
RUN cd /svn-export/ks-impex-bundled-db && mvn -Pdb,oracle org.apache.maven.plugins:maven-dependency-plugin:2.8:resolve

ADD files/impex-db.sh /impex-db.sh

RUN chmod +x /impex-db.sh

CMD /impex-db.sh
