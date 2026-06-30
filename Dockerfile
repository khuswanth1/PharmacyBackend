# Build stage: compile and package all modules
FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /app

# Copy root pom.xml and source code of all modules
# COPY pom.xml .
# COPY common-lib common-lib
# COPY api-gateway api-gateway
# COPY auth-service auth-service
# COPY product-service product-service
# COPY cart-service cart-service
# COPY order-service order-service
# COPY payment-service payment-service
COPY . .
# Package the entire project (builds common-lib first, then all microservices)
RUN mvn clean package -DskipTests

FROM openjdk:21.0.1-jdk-slim

COPY --from=build  /target/backend-0.0.1-SNAPSHOT.jar backend.jar
EXPOSE 8089
ENTRYPOINT ["java","-jar","backend.jar"]
