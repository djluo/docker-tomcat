#!/bin/bash
# vim:set et ts=2 sw=2:

## 切换到当前目录
#current_dir=`dirname $0`
#current_dir=`readlink -f $current_dir`
#cd ${current_dir} && export current_dir

# change by /entrypoint.pl
current_dir=/tomcat
# change by /entrypoint.pl

# 常量
CATALINA_HOME="/apache-tomcat-${TomcatVer}"
CONFIG="/tomcat/conf/server.xml"
JDK_OPT="/tomcat/conf/java-options.conf"
CATALINA_OUT="${current_dir}/logs/catalina.out"
CATALINA_TMPDIR="/tomcat/work/temp/"
LOGGING_CONFIG="-Djava.util.logging.config.file=/tomcat/conf/logging.properties"
LOG_DIR="${current_dir}/log/"

export CATALINA_HOME CONFIG CATALINA_OUT LOGGING_CONFIG LOG_DIR CATALINA_TMPDIR

# java参数等配置
if [ -f  "${JDK_OPT}" ];then
  source "${JDK_OPT}"
elif [ -n "$JAVA_OPTS" ] ;then
  # 使用环境变量中的设置
  :
else
  JAVA_OPTS="-Xms1G -Xmx1G"
fi

DEF_OPTS="-Dnet.sf.ehcache.skipUpdateCheck=true    \
          -Dcom.sun.management.jmxremote           \
          -Dcom.sun.management.jmxremote.ssl=false \
          -Dcom.sun.management.jmxremote.local.only=false \
          -Dcom.sun.management.jmxremote.authenticate=false"

export JAVA_OPTS="$JAVA_OPTS $DEF_OPTS"

exec $CATALINA_HOME/bin/catalina.sh run -config $CONFIG \
  1> >(exec /usr/bin/cronolog ${current_dir}/logs/stdout.txt-%Y%m%d >/dev/null 2>&1) \
  2> >(exec /usr/bin/cronolog ${current_dir}/logs/stderr.txt-%Y%m%d >/dev/null 2>&1)
