#!/bin/bash
set -e

PORT=${PORT:-8080}

if [ "$PORT" != "8080" ]; then
  sed -i "s/port=\"8080\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml
fi

export JAVA_OPTS="-Djava.awt.headless=true -Xms256m -Xmx512m"

exec catalina.sh run
