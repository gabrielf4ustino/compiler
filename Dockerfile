FROM maven:3.8.6-eclipse-temurin-18 as build
COPY ./ ./
RUN mvn install

FROM openjdk:18
WORKDIR /compiler
COPY --from=build ./ ./
CMD java -jar /compiler/target/compiler-v1.2.3-shaded.jar
