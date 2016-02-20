#!/bin/sh
# vim:set et ts=2 sw=2:

## 切换到当前目录
#current_dir=`dirname $0`
#current_dir=`readlink -f $current_dir`
#cd ${current_dir} && export current_dir

# change by /entrypoint.pl
current_dir=/tomcat
# change by /entrypoint.pl

find ${current_dir}/log  -name "*log.2*[^z]"   -mtime +7 -exec gzip {} \;
find ${current_dir}/logs -name "std*[^z]"      -mtime +1 -exec gzip {} \;
find ${current_dir}/logs -name "catalina*[^z]" -mtime +1 -exec gzip {} \;
