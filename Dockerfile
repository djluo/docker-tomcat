# Tomcat
#
# VERSION 2

FROM       java:1
MAINTAINER djluo <dj.luo@baoyugame.com>

ENV TomcatVer 7.0.55

ADD ./setup/   /setup/
RUN /bin/bash  /setup/setup.sh

WORKDIR        /tomcat/

EXPOSE 8080
VOLUME [ "/tomcat/log", "/tomcat/logs/", "/tomcat/conf/", "/tomcat/webapps" ]

CMD ["/tomcat/run.sh","run"]
