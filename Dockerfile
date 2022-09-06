FROM maven:3.8.6-eclipse-temurin-18 as build
RUN useradd -m myuser
WORKDIR /usr/src/app/
RUN chown myuser:myuser /usr/src/app/
USER myuser
COPY --chown=myuser pom.xml ./
RUN mvn dependency:go-offline
COPY --chown=myuser:myuser src src
RUN mvn install

FROM openjdk:18
COPY --from=build /usr/src/app/target/*.jar /usr/app/app.jar
RUN useradd -m myuser
USER myuser
CMD java -jar /usr/app/app.jar
