FROM maven:3.9.9-eclipse-temurin-21-jammy AS BUILD_IMAGE
RUN git clone https://github.com/ajaiji/terralogic_project.git
RUN cd terralogic_project && RUN git checkout main && RUN mvn install 


FROM tomcat:10-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE terralogic_project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
