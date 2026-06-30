#!/bin/sh
# Start all microservices in the background with memory optimization flags
java -XX:TieredStopAtLevel=1 -Xmx64m -Xms32m -jar auth-service.jar &
java -XX:TieredStopAtLevel=1 -Xmx64m -Xms32m -jar product-service.jar &
java -XX:TieredStopAtLevel=1 -Xmx64m -Xms32m -jar cart-service.jar &
java -XX:TieredStopAtLevel=1 -Xmx64m -Xms32m -jar order-service.jar &
java -XX:TieredStopAtLevel=1 -Xmx64m -Xms32m -jar payment-service.jar &

# Wait 10 seconds for services to initialize
sleep 10

# Start api-gateway in the foreground
java -XX:TieredStopAtLevel=1 -Xmx96m -Xms48m -jar api-gateway.jar
