#!/bin/sh
# Runs all six Spring Boot apps inside ONE container (the "all-in-one" Docker stage).
#
# Only the API gateway is exposed on Render's $PORT. The five backend services bind
# to fixed internal ports (8081-8085) and talk to each other over localhost.
#
# CRITICAL: we pass --server.port explicitly. Otherwise every service reads Render's
# $PORT and they all try to bind the same port -> only one survives, the rest crash.

# Tight JVM flags so six JVMs fit in as little RAM as possible.
JAVA_OPTS="-XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xss512k -Xmx96m -Xms32m"

echo "Starting backend microservices..."
java $JAVA_OPTS -jar auth-service.jar     --server.port=8081 &
java $JAVA_OPTS -jar product-service.jar  --server.port=8082 &
java $JAVA_OPTS -jar cart-service.jar     --server.port=8083 &
java $JAVA_OPTS -jar order-service.jar    --server.port=8084 &
java $JAVA_OPTS -jar payment-service.jar  --server.port=8085 &

echo "Waiting ~35s for backend services (and the DB connection) to come up..."
sleep 35

echo "Starting API gateway on port ${PORT:-8089}..."
# exec -> gateway becomes the container's main process and receives stop signals.
exec java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xss512k -Xmx128m -Xms48m \
  -jar api-gateway.jar --server.port=${PORT:-8089}