FROM sameersbn/postgresql
MAINTAINER machiel.van.ampting@trivento.nl

#ENV PG_APP_HOME="/etc/docker-postgresql"\
#    PG_VERSION=9.5 \
#    PG_USER=postgres \
#    PG_HOME=/var/lib/postgresql \
#    PG_RUNDIR=/run/postgresql \
#    PG_LOGDIR=/var/log/postgresql \
#    PG_CERTDIR=/etc/postgresql/certs

#ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin \
#    PG_DATADIR=${PG_HOME}/${PG_VERSION}/main


ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV LD_LIBRARY_PATH=/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server/libjvm.so
ENV MAVEN_HOME /opt/maven

#Install g++
#Install Java.
#Install maven
#Install git
RUN apt-get clean && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --fix-missing -y --force-yes --no-install-recommends install software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get clean && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --fix-missing -y --force-yes --no-install-recommends install \
                                                      build-essential \
                                                      oracle-java8-installer \
                                                      git \
                                                      postgresql-server-dev-${PG_VERSION} \
                                                      libssl-dev \
                                                      libkrb5-dev && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    wget --no-verbose -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz && \
    tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-3.2.2 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin && \
    rm -f /tmp/apache-maven-3.2.2.tar.gz && \
    cd /tmp && \
    git clone https://github.com/tada/pljava.git && \
    cd /tmp/pljava && \
    mvn -Pwnosign  clean install && \
    java -jar /tmp/pljava/pljava-packaging/target/pljava-pg9.5-amd64-Linux-gpp.jar && \
    apt-get -y remove --purge --auto-remove git \
                                            build-essential \
                                            software-properties-common \
                                            postgresql-server-dev-${PG_VERSION} \
                                            libssl-dev \
                                            libkrb5-dev && \
    apt-get -y clean autoclean autoremove && \
    rm -rf ~/.m2 && rm -rf /opt/apache-maven-3.2.2/ /opt/maven /usr/local/bin/mvn /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
     ln -s /usr/lib/jvm/java-8-oracle/ /opt/jdk && \
     rm -rf /opt/jdk/*src.zip \
            /opt/jdk/lib/missioncontrol \
            /opt/jdk/lib/visualvm \
            /opt/jdk/lib/*javafx* \
            /opt/jdk/jre/lib/plugin.jar \
            /opt/jdk/jre/lib/ext/jfxrt.jar \
            /opt/jdk/jre/bin/javaws \
            /opt/jdk/jre/lib/javaws.jar \
            /opt/jdk/jre/lib/desktop \
            /opt/jdk/jre/plugin \
            /opt/jdk/jre/lib/deploy* \
            /opt/jdk/jre/lib/*javafx* \
            /opt/jdk/jre/lib/*jfx* \
            /opt/jdk/jre/lib/amd64/libdecora_sse.so \
            /opt/jdk/jre/lib/amd64/libprism_*.so \
            /opt/jdk/jre/lib/amd64/libfxplugins.so \
            /opt/jdk/jre/lib/amd64/libglass.so \
            /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
            /opt/jdk/jre/lib/amd64/libjavafx*.so \
            /opt/jdk/jre/lib/amd64/libjfx*.so


ENV DB_EXTENSION pljava

WORKDIR ${PG_HOME}

# use updated runtime and entrypoint.sh scritps to execute init scripts after the database is started.:wq
ADD /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY runtime/ ${PG_APP_HOME}/
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
