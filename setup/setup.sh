#!/bin/bash
# vim:set et ts=2 sw=2:

URL="tomcat/tomcat-7/v${TomcatVer}/bin/apache-tomcat-${TomcatVer}.tar.gz"

## New APP
mkdir -p /tomcat/{conf,log,logs,webapps,temp,work}
mv       /setup/run.sh  /tomcat/
chmod +x /tomcat/run.sh

## Get Tomcat
#wget --quiet -O /apache-tomcat-${TomcatVer}.tar.gz     \
#        http://mirrors.cnnic.cn/apache/${URL}
wget --quiet -O \
    /apache-tomcat-${TomcatVer}.tar.gz \
    http://192.168.1.96/apache-tomcat-${TomcatVer}.tar.gz

wget --quiet -O \
    /apache-tomcat-${TomcatVer}.tar.gz.md5 \
    https://www.apache.org/dist/${URL}.md5
wget --quiet -O \
    /apache-tomcat-${TomcatVer}.tar.gz.asc \
    https://www.apache.org/dist/${URL}.asc

cd /
md5sum -c    /apache-tomcat-${TomcatVer}.tar.gz.md5 || { echo "md5sum error?...";     exit 127; }

gpg --import /setup/KEYS 2> /dev/null
gpg --verify /apache-tomcat-${TomcatVer}.tar.gz.asc || { echo "gpg verify error?..."; exit 127; }

## Build Tomcat
tar xf  /apache-tomcat-${TomcatVer}.tar.gz -C /


## Clean
rm -f  /apache-tomcat-${TomcatVer}/{LICENSE,NOTICE,RELEASE-NOTES,RUNNING.txt} \
       /apache-tomcat-${TomcatVer}.tar.gz      \
       /apache-tomcat-${TomcatVer}.tar.gz.md5  \
       /apache-tomcat-${TomcatVer}.tar.gz.asc
rm -rf /setup
