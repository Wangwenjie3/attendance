#!/bin/bash
# Deplexo injects the PORT environment variable (default 3000).
# Tomcat listens on 8080 by default, so patch server.xml before startup.
if [ -n "$PORT" ]; then
  sed -i "s/port=\"8080\"/port=\"$PORT\"/" "$CATALINA_HOME/conf/server.xml"
fi
exec "$CATALINA_HOME/bin/catalina.sh" run
