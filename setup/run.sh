#!/bin/bash
# vim:set et ts=2 sw=2:

# 切换到当前目录
current_dir=`dirname $0`
current_dir=`readlink -f $current_dir`
cd ${current_dir} && export current_dir

# 常量
JAVA_HOME="/home/jdk"
CATALINA_HOME="/apache-tomcat-${TomcatVer}"
export JAVA_HOME CATALINA_HOME

if [ -f "${current_dir}/conf/server.xml" ] ;then
  CONFIG="${current_dir}/conf/server.xml"
  CATALINA_OUT="${current_dir}/logs/catalina.out"
  LOGGING_CONFIG="-Djava.util.logging.config.file=${current_dir}/conf/logging.properties"
  export CONFIG CATALINA_OUT LOGGING_CONFIG
fi

# java参数等配置
APP_NAME_C="Tomcat"
if [ -f "${current_dir}/conf/java-options.conf" ];then
  . "${current_dir}/conf/java-options.conf"
fi

# 启动参数：支持后台运行(start),以及前台运行(run)
action () {
  local action=$1
  $CATALINA_HOME/bin/catalina.sh $action -config $CONFIG
}

# 入口
case "$1" in
  run|start|stop)
    action $1
    ;;
  *)
    echo $"Usage: ${current_dir}/run.sh {run|start|stop}"
    exit 1
esac

exit $?
