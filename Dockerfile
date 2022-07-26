FROM openjdk:11
RUN mkdir /app
WORKDIR /app

ADD ./build/libs/api-gateway-app-0.0.1.jar /app/app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
