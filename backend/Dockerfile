FROM eclipse-temurin:17-jdk-alpine AS build

# Install necessary build tools
RUN apk add --no-cache bash

WORKDIR /workspace/app

# Copy gradle configuration
COPY gradle gradle
COPY gradlew .
COPY settings.gradle .
COPY build.gradle .

# Ensure the script is executable
RUN chmod +x ./gradlew

# Download dependencies - separate step to leverage Docker layer caching
RUN ./gradlew dependencies --no-daemon

# Copy the source code
COPY src src

# Build the application with more verbose output
RUN ./gradlew bootJar --no-daemon --info

# Use a lightweight runtime image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /workspace/app/build/libs/*.jar app.jar

# Environment variables
ENV PORT=8080

# Expose the port
EXPOSE ${PORT}

# Run the application with environment variables support
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]
