FROM tomcat:9.0-jdk8-temurin

COPY DPS_project/code_implementation/DataAnonymizer/target/DataAnonymizer.war /usr/local/tomcat/webapps/DataAnonymizer.war

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
