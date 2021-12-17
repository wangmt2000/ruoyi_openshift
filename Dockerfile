FROM maven:3.6.3-jdk-8 AS build


RUN useradd -d /home/ruoyi ruoyi
RUN mkdir /usr/src/app/
RUN chmod -R 644 /usr/src/app/



#copy .m2 /root/.m2/
#WORKDIR /usr/src/app
COPY .  /usr/src/app/
#run ls /root/.m2/
#run ls /usr/src/app/
#RUN --mount=type=cache,target=/home/opc/.m2 mvn -f pom.xml mvn clean install

RUN mvn -f /usr/src/app/pom.xml clean install

FROM maven:3.6.3-jdk-8
RUN mkdir /app/
COPY --from=build /usr/src/app/. /app/
RUN useradd -d /home/ruoyi ruoyi
RUN chown -R ruoyi:ruoyi /app/
USER ruoyi
RUN ls /home/ruoyi
#RUN chown -R ruoyi:ruoyi /home/ruoyi/
RUN mkdir /home/ruoyi/logs

#COPY --from=build /usr/src/app/target/*.jar app.jar  


#RUN chown -R ruoyi:ruoyi /app/

#COPY --from=build /usr/src/app/ruoyi-admin/target/* /app/ruoyi-admin/target/
#COPY --from=build /usr/src/app/ruoyi-common/target/* /app/ruoyi-common/target/
#COPY --from=build /usr/src/app/ruoyi-framework/target/* /app/ruoyi-framework/target/
#COPY --from=build /usr/src/app/ruoyi-generator/target/* /app/ruoyi-generator/target/
#COPY --from=build /usr/src/app/ruoyi-quartz/target/* /app/ruoyi-quartz/target/
#COPY --from=build /usr/src/app/ruoyi-ruoyi-system/target/*.jar app5.jar
#若亦有路径问题
#COPY --from=build /usr/src/app/ruoyi-admin/target/*.jar ruoyi-admin.jar
#COPY --from=build /usr/src/app/ruoyi-common/target/*.jar ruoyi-common.jar
#COPY --from=build /usr/src/app/ruoyi-framework/target/*.jar ruoyi-framework.jar
#COPY --from=build /usr/src/app/ruoyi-generator/target/*.jar ruoyi-generator.jar
#COPY --from=build /usr/src/app/ruoyi-quartz/target/*.jar ruoyi-quartz.jar

#RUN mkdir /home/ruoyi
RUN  ls /app/

#WORKDIR /app

ENTRYPOINT ["java", "-XshowSettings:128m", "-XX:NativeMemoryTracking=off", "-jar", "/app/ruoyi-admin/target/ruoyi-admin.jar"]
#ENTRYPOINT ["java", "-XshowSettings:vm", "-XX:NativeMemoryTracking=summary", "-jar", "app.jar"]
EXPOSE 80
