# Tomcat
#
# VERSION 1

FROM       java:1
MAINTAINER djluo <dj.luo@baoyugame.com>

ENV TomcatVer 7.0.55

RUN wget --quiet -O /apache-tomcat-${TomcatVer}.tar.gz     \
            http://mirrors.cnnic.cn/apache/tomcat/tomcat-7/v${TomcatVer}/bin/apache-tomcat-${TomcatVer}.tar.gz
RUN wget --quiet -O /apache-tomcat-${TomcatVer}.tar.gz.md5 \
            https://www.apache.org/dist/tomcat/tomcat-7/v${TomcatVer}/bin/apache-tomcat-${TomcatVer}.tar.gz.md5
RUN wget --quiet -O /apache-tomcat-${TomcatVer}.tar.gz.asc \
            https://www.apache.org/dist/tomcat/tomcat-7/v${TomcatVer}/bin/apache-tomcat-${TomcatVer}.tar.gz.asc

RUN wget --quiet -O /apache-tomcat-${TomcatVer}.tar.gz \
            http://192.168.1.96/apache-tomcat-${TomcatVer}.tar.gz

ADD ./KEYS       /KEYS
RUN gpg --import /KEYS
WORKDIR          /
RUN md5sum -c    /apache-tomcat-${TomcatVer}.tar.gz.md5
RUN gpg --verify /apache-tomcat-${TomcatVer}.tar.gz.asc

RUN tar xf    /apache-tomcat-${TomcatVer}.tar.gz -C / \
    && rm -f  /apache-tomcat-${TomcatVer}.tar.gz      \
    && mv -v  /apache-tomcat-${TomcatVer} /tomcat

RUN rm -f     /tomcat/{LICENSE,NOTICE,RELEASE-NOTES,RUNNING.txt}

WORKDIR       /tomcat/

VOLUME [ "/tomcat/log", "/tomcat/logs/", "/tomcat/temp/", "/tomcat/work/" , "/tomcat/webapps" ]

ADD ./run.sh /tomcat/run.sh
RUN chmod +x /tomcat/run.sh

CMD ["/tomcat/run.sh","run"]
