# Use Maven to build the app and Eclipse Temurin as the base image
FROM eclipse-temurin:17-jdk-focal AS build

# Set the working directory inside the container
WORKDIR /app

# Copy pom.xml and run mvn to fetch dependencies (so it can run offline)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn clean install

# Now use a lighter image to run the app
FROM eclipse-temurin:17-jdk-focal

# Set the working directory inside the container
WORKDIR /app

# Copy the built .jar file from the build stage
COPY --from=build /app/target/nosql-injection-vulnapp-mongodb-java-*.jar /app/niva.jar

# Expose the port that your app will run on
EXPOSE 8080

# Set the entry point for running the app
ENTRYPOINT [ "java", "-jar", "niva.jar" ]
