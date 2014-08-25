#!/bin/bash

# 切换到当前目录
current_dir=`dirname $0`
current_dir=`readlink -f $current_dir`
cd ${current_dir} && export current_dir

# 常量
JAVA_HOME="/home/jdk"
CATALINA_HOME="/tomcat"
export JAVA_HOME CATALINA_HOME

# java参数等配置
APP_NAME_C="Tomcat"
if [ -f "${current_dir}/conf/java-options.conf" ];then
  . "${current_dir}/conf/java-options.conf"
fi

# 启动参数：支持后台运行(start),以及前台运行(run)
start () {
  local action=$1
  $CATALINA_HOME/bin/catalina.sh $action >/dev/null
}
stop () {
  $CATALINA_HOME/bin/catalina.sh stop >/dev/null
}

# 入口
case "$1" in
  start|run)
    start $1
    ;;
  stop)
    stop
    ;;
  *)
    echo $"Usage: ${current_dir}/run.sh {run|start|stop}"
    exit 1
esac

exit $?
# vim:set et ts=2 sw=2:
