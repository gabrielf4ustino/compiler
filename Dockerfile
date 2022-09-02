FROM maven:3.8.6-eclipse-temurin-18
WORKDIR /usr/app
COPY ./ ./
CMD mvn install && mvn exec:java
