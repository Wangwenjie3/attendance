FROM tomcat:9.0-jdk11-corretto

# 限制 JVM 内存，适配 128MB 小机器
ENV JAVA_OPTS="-Xms64m -Xmx120m -XX:+UseSerialGC -XX:MaxMetaspaceSize=96m"
ENV CATALINA_OPTS="-Xms64m -Xmx120m"

# 删除默认 Tomcat 示例应用，省内存
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps/manager

# 关闭 AJP Connector（不需要，省内存和启动时间）
RUN sed -i '/<Connector port="8009"/,/\/>/d' /usr/local/tomcat/conf/server.xml

# 复制 war 并在构建时解压为 ROOT（这样根路径直接访问，健康检查不会 404）
# 同时避免运行时解压 war 的启动延迟
COPY attendance.war /tmp/attendance.war
WORKDIR /usr/local/tomcat/webapps
RUN jar -xf /tmp/attendance.war && rm /tmp/attendance.war

# 复制 entrypoint
COPY entrypoint.sh /usr/local/tomcat/bin/entrypoint.sh
RUN chmod +x /usr/local/tomcat/bin/entrypoint.sh

EXPOSE 3000
CMD ["/usr/local/tomcat/bin/entrypoint.sh"]
