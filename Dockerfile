FROM openjdk:17-oracle
EXPOSE 88
COPY build/libs/shortnerurl-0.0.1.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]