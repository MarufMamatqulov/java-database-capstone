# Multi-stage build Dockerfile for Spring Boot app

FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /workspace
COPY pom.xml mvnw* ./
COPY .mvn .mvn
COPY src src
RUN ./mvnw -B -e -DskipTests package

FROM openjdk:17-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY --from=build /workspace/target/back-end-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
