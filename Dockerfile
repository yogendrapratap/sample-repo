# Stage 1: Build
FROM openjdk:17-jdk-slim AS build
WORKDIR /app

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

COPY src/ ./src/
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
