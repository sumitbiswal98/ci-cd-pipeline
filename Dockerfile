# Use an existing Tomcat base image
FROM tomcat:8.5-jre8

# Maintainer information
LABEL maintainer="your_name <your_email>"

# Copy the WAR file to the Tomcat webapps directory
COPY myapp.war /usr/local/tomcat/webapps/

# Expose port 8080 for Tomcat
EXPOSE 8080

# Start Tomcat when the container is run
CMD ["catalina.sh", "run"]
