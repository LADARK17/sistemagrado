FROM tomcat:9.0-jdk17-temurin

# Remove default Tomcat demo applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Working directory for ROOT application
WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy project files
COPY . .

# Ensure WEB-INF/classes exists
RUN mkdir -p WEB-INF/classes

# Compile Java source files
RUN javac -encoding UTF-8 \
    -cp "WEB-INF/lib/*:/usr/local/tomcat/lib/*" \
    -d WEB-INF/classes \
    $(find src/java -name "*.java")

# Copy configuration files to classes
RUN cp src/java/database.properties WEB-INF/classes/ 2>/dev/null || true

# Mirror ROOT to /Sistema-proyectos context path
RUN cp -r /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/Sistema-proyectos

# Entrypoint to dynamically bind Tomcat to Render's $PORT
RUN printf '#!/bin/sh\nif [ -n "$PORT" ]; then\n  sed -i "s/port=\\\"8080\\\"/port=\\\"$PORT\\\"/g" /usr/local/tomcat/conf/server.xml\nfi\nexec catalina.sh run\n' > /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

CMD ["/usr/local/bin/entrypoint.sh"]
