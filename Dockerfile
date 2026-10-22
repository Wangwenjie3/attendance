FROM tomcat:9.0-jdk11-corretto

# 限制 JVM 内存，适配 128MB 小机器
ENV JAVA_OPTS="-Xms64m -Xmx120m -XX:+UseSerialGC -XX:MaxMetaspaceSize=96m"
ENV CATALINA_OPTS="-Xms64m -Xmx120m"

# 默认 PORT=3000（Deplexo 期望的端口）
ENV PORT=3000

# 删除默认 Tomcat 示例应用，省内存
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps/manager

# 直接在构建时把 HTTP 端口从 8080 改成 3000
RUN sed -i 's/port="8080"/port="3000"/' /usr/local/tomcat/conf/server.xml

# 关闭 AJP Connector
RUN sed -i '/<Connector port="8009"/,/\/>/d' /usr/local/tomcat/conf/server.xml

# 复制 war 并解压到 ROOT 目录（根路径直接访问）
COPY attendance.war /tmp/attendance.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT
WORKDIR /usr/local/tomcat/webapps/ROOT
RUN jar -xf /tmp/attendance.war && rm /tmp/attendance.war

EXPOSE 3000
CMD ["catalina.sh", "run"]
