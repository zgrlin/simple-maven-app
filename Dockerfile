FROM debian
MAINTAINER Ozgur Kara <o@zgur.org>
ENV TOMCAT_DOWNLOAD_URL http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz
ENV TOMCAT_SHA512 408d30bf56d59941149b397e5e725a5f9baf225807397a4b7a3be79f7d211e6d878d34bf00776746a54cc7d067f168db24c367e5c7390bb7329b3bca428726cc
RUN apt-get update \
    && apt-get upgrade -y \
	&& apt-get dist-upgrade -y \
	&& apt-get install -y \
	dnsutils \
	net-tools \
	tzdata \
	sudo \
	locate \
	curl \
	wget \
	&& updatedb \
	&& ldconfig \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir /opt/tomcat \
	&& mkdir /opt/jdk
RUN cd /opt \
    && curl -O "$TOMCAT_DOWNLOAD_URL" \
	&& echo "$TOMCAT_SHA512 /opt/apache-tomcat-9.0.27.tar.gz" | sha512sum -c - \
    && tar -zxvf /opt/apache-tomcat-9.0.27.tar.gz -C /opt/tomcat \
    && rm -rf /opt/apache-tomcat-9.0.27.tar.gz
COPY jdk-13.0.1_linux-x64_bin.tar.gz /opt/
RUN tar -zxvf /opt/jdk-13.0.1_linux-x64_bin.tar.gz -C /opt/jdk \
    && rm -rf /opt/jdk-13.0.1_linux-x64_bin.tar.gz \
	&& sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk-13.0.1/bin/java 100 \
	&& sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-13.0.1/bin/javac 100 \
	&& rm -rf /opt/tomcat/apache-tomcat-9.0.27/conf/tomcat-users.xml \
	&& rm -rf /opt/tomcat/apache-tomcat-9.0.27/webapps/manager/META-INF/context.xml \
	&& rm -rf /opt/tomcat/apache-tomcat-9.0.27/webapps/host-manager/META-INF/context.xml
COPY conf/tomcat-users.xml /opt/tomcat/apache-tomcat-9.0.27/conf/
COPY manager/context.xml /opt/tomcat/apache-tomcat-9.0.27/webapps/manager/META-INF/context.xml
COPY host-manager/context.xml /opt/tomcat/apache-tomcat-9.0.27/webapps/host-manager/META-INF/context.xml
EXPOSE 8080
CMD ["/opt/tomcat/apache-tomcat-9.0.27/bin/catalina.sh", "run"]