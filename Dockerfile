# Tomcat
#
# VERSION 4

FROM       docker.xlands-inc.com/baoyu/by-java
MAINTAINER djluo <dj.luo@baoyugame.com>

ADD ./entrypoint.pl        /entrypoint.pl
ADD ./cmd.sh               /tomcat/cmd.sh

ENV TomcatVer 7.0.57
ADD ./apache-tomcat-7.0.57 /apache-tomcat-7.0.57

VOLUME [ "/tomcat/log", "/tomcat/logs/", "/tomcat/conf/", "/tomcat/webapps" ]

ENTRYPOINT ["/entrypoint.pl"]
CMD        ["/tomcat/cmd.sh"]
