# Use a base image with JDK and Maven installed
FROM maven:3.8.4-openjdk-11-slim AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the Maven project files
COPY pom.xml .

# Download dependencies specified in pom.xml
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the application
RUN mvn package

# Use a lightweight Java runtime image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the compiled application JAR file from the builder stage
COPY --from=builder /usr/src/app/target/*.jar ./app.jar

# Command to run the application
CMD ["java", "-jar", "app.jar"]# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the application code into the container
COPY . .

# Command to run the application
CMD ["node", "index.js"]