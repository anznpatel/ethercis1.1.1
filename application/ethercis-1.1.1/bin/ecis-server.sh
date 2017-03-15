#!/bin/bash
#
# SCRIPT created July 2016, Christian Chevalley
# description: Controls Ethercis Server
# processname: ecis-server
#
# usage:
# ./ecis-server start|stop|restart
# ./ecis-server clean -> purge the temp log file
#
# This script assumes "uber" jars as defined in each respective module pom.xml
# specific libraries are posted at:
# ethercis/libraries
#
# For deployment in production, the following should be done:
#
# - remove the stdout/stderr redirection
# - remove java remote debugging (unsafe)
# - set authentication on JMX
#-----------------------------------------------------------------------------------
UNAME=`uname`
HOSTNAME=`hostname`
export ECIS_DEPLOY_BASE=/opt/ecis
export SYSLIB=${ECIS_DEPLOY_BASE}/lib/system
export COMMONLIB=${ECIS_DEPLOY_BASE}/lib/common
export APPLIB=${ECIS_DEPLOY_BASE}/lib/application
export LIB=${ECIS_DEPLOY_BASE}/lib/deploy

# Mailer configuration
ECIS_MAILER=echo

# use the right jvm library depending on the OS
# NB: EtherCIS requires java 8
#if [ :${UNAME}: = :Linux: ];
#then
#  JAVA_HOME=/opt/jdk1.8.0_60/jre
#fi
#if [ :${UNAME}: = :SunOS: ];
#then
#  JAVA_HOME=/jdk1.8.0_60/jre
#fi

#force to use IPv4 so Jetty can bind to it instead of IPv6...
export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"

# runtime parameters
export JVM=${JAVA_HOME}/bin/java
export RUNTIME_HOME=/opt/ecis
export RUNTIME_ETC=/etc/opt/ecis
export RUNTIME_LOG=/var/opt/ecis
export RUNTIME_DIALECT=EHRSCAPE  #specifies the query dialect used in HTTP requests (REST)
export SERVER_PORT=8080 # the port address to bind to
export SERVER_HOST=`hostname` # the network address to bind to

export MAILER_CONF=${RUNTIME_ETC}/xcmail.cf

export JOOQ_DIALECT=POSTGRES
JOOQ_DB_PORT=5432
JOOQ_DB_HOST=postgres
JOOQ_DB_SCHEMA=ethercis
export JOOQ_URL=jdbc:postgresql://${JOOQ_DB_HOST}:${JOOQ_DB_PORT}/${JOOQ_DB_SCHEMA}
export JOOQ_DB_LOGIN=postgres
export JOOQ_DB_PASSWORD=postgres

CLASSPATH=./:\
${JAVA_HOME}/lib:\
${LIB}/ecis-core-1.1.1-SNAPSHOT.jar:\
${LIB}/ecis-knowledge-cache-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-ehrdao-1.1.0-SNAPSHOT.jar:\
${LIB}/jooq-pg-1.1.0-SNAPSHOT.jar:\
${LIB}/aql-processor-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-validation-1.0-SNAPSHOT.jar:\
${LIB}/ecis-transform-1.0-SNAPSHOT.jar:\
${LIB}/ecis-servicemanager-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-authenticate-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-knowledge-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-logon-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-resource-access-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-composition-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-partyidentified-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-system-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-ehr-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-vehr-service-1.1.0-SNAPSHOT.jar:\
${LIB}/ecis-query-service-1.0.0-SNAPSHOT.jar:\
${APPLIB}/ehrxml.jar:\
${APPLIB}/oet-parser.jar:\
${APPLIB}/ecis-openehr.jar:\
${APPLIB}/types.jar:\
${APPLIB}/adl-parser-1.0.9.jar

# launch server
# ecis server is run as user ethercis
su - ethercis << _ECIS
case "$1" in
  start)
    echo "ethercis startup"
     ( ${ECIS_MAILER} ${MAILER_CONF} "EtherCIS Startup" "Manual invocation of server startup" > /dev/null )&
    (
	${JVM} \
	-Xmx256M \
	-Xms256M \
	-server \
	-XX:-EliminateLocks \
	-XX:-UseVMInterruptibleIO \
	-cp ${CLASSPATH} \
	-Xdebug \
	-Xrunjdwp:transport=dt_socket,address=8000,suspend=n,server=y \
        -Djava.rmi.server.hostname=${SERVER_HOST} \
	-Dcom.sun.management.jmxremote.port=8999 \
        -Dcom.sun.management.jmxremote.local.only=false \
	-Dcom.sun.management.jmxremote.ssl=false \
	-Dcom.sun.management.jmxremote.authenticate=false \
	-Djava.util.logging.config.file=${RUNTIME_ETC}/logging.properties \
	-Dlog4j.configurationFile=file:${RUNTIME_ETC}/log4j.xml \
	-Djava.net.preferIPv4Stack=true \
	-Djava.awt.headless=true \
	-Djdbc.drivers=org.postgresql.Driver \
    	-Dserver.node.name=vm01.ethercis.org \
    	-Dfile.encoding=UTF-8 \
    	-Djava.rmi.server.hostname=${SERVER_HOST} \
	-Djooq.dialect=${JOOQ_DIALECT} \
	-Djooq.url=${JOOQ_URL} \
	-Djooq.login=${JOOQ_DB_LOGIN} \
	-Djooq.password=${JOOQ_DB_PASSWORD} \
	-Druntime.etc=${RUNTIME_ETC} \
	 com.ethercis.vehr.Launcher \
	-propertyFile /etc/opt/ecis/services.properties \
    	-server_host ${SERVER_HOST} \
    	-server_port 8080 \
 2>> ${RUNTIME_LOG}/ethercis_test.log >> ${RUNTIME_LOG}/ethercis_test.log &    )&
    ;;
  stop)
    ( ${ECIS_MAILER} ${MAILER_CONF} "Ethercis Stop" "Manual invocation of server STOP" > /dev/null )&
    echo "ethercis shutdown"
    pkill java
    ;;
  restart)
    ( ${ECIS_MAILER} ${MAILER_CONF} "Ethercis Restart" "Manual invocation of server RESTART" )&
    echo "ethercis restarting"
    $0 stop
    $0 start
    ;;
  clean)
    (${ECIS_MAILER} ${MAILER_CONF} "Ethercis CLEAR" "Manual invocation of server Clear logs" > dev/null )&
    echo "ethercis clear"
    $0 stop
	rm -rf {RUNTIME_LOG}/ethercis_test.log
    ;;
  *)
    echo "Usage: ecis-server {start|stop|restart|clean}"
    exit 1
esac
_ECIS
exit 0
# end of file
