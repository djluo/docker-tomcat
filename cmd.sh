#!/bin/bash
# vim:set et ts=2 sw=2:

# 切换到当前目录
current_dir=`dirname $0`
current_dir=`readlink -f $current_dir`
cd ${current_dir} && export current_dir

# 常量
CATALINA_HOME="/apache-tomcat-${TomcatVer}"
CATALINA_BASE="${current_dir}"
CONFIG="${current_dir}/conf/server.xml"
JDK_OPT="${current_dir}/conf/java-options.conf"
CATALINA_OUT="${current_dir}/logs/catalina.out"
CATALINA_TMPDIR="${current_dir}/work/temp/"
LOGGING_CONFIG="-Djava.util.logging.config.file=${current_dir}/conf/logging.properties"

export CATALINA_HOME CONFIG CATALINA_OUT LOGGING_CONFIG

# java参数等配置
[ -f  "${JDK_OPT}" ] && source "${JDK_OPT}"

exec $CATALINA_HOME/bin/catalina.sh run -config $CONFIG \
  1> >(exec /usr/bin/cronolog ${current_dir}/logs/stdout.txt-%Y%m%d >/dev/null 2>&1) \
  2> >(exec /usr/bin/cronolog ${current_dir}/logs/stderr.txt-%Y%m%d >/dev/null 2>&1)