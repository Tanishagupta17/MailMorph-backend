# Use a Maven image to build the app
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy everything to the container
COPY . .

# Build the project and skip tests
RUN mvn clean package -DskipTests

# --------------------

# Use a smaller JDK base image to run the app
FROM eclipse-temurin:17-jdk-jammy

# Set working directory inside container
WORKDIR /app

# Copy the built jar file from the previous build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render sets PORT env variable instead, so this is optional)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
