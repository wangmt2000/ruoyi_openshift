FROM maven:3.6.3-jdk-8 AS build

#copy .m2 /root/.m2/
#WORKDIR /usr/src/app
copy .  /usr/src/app/
#run ls /root/.m2/
run ls /usr/src/app/
#RUN --mount=type=cache,target=/home/opc/.m2 mvn -f pom.xml mvn clean install

RUN mvn -f /usr/src/app/pom.xml clean install
FROM openjdk:8-slim
#COPY --from=build /usr/src/app/target/*.jar app.jar  
COPY --from=build /usr/src/app/ruoyi-admin/target/*.jar app.jar
COPY --from=build /usr/src/app/ruoyi-common/target/*.jar app1.jar
COPY --from=build /usr/src/app/ruoyi-framework/target/*.jar app2.jar
COPY --from=build /usr/src/app/ruoyi-generator/target/*.jar app3.jar
COPY --from=build /usr/src/app/ruoyi-quartz/target/*.jar app4.jar
#COPY --from=build /usr/src/app/ruoyi-ruoyi-system/target/*.jar app5.jar


ENTRYPOINT ["java", "-XshowSettings:128m", "-XX:NativeMemoryTracking=off", "-jar", "app.jar"]
#ENTRYPOINT ["java", "-XshowSettings:vm", "-XX:NativeMemoryTracking=summary", "-jar", "app.jar"]
EXPOSE 8080