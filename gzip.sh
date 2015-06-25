#!/bin/sh
# vim:set et ts=2 sw=2:

# 切换到当前目录
current_dir=`dirname $0`
current_dir=`readlink -f $current_dir`
cd ${current_dir} && export current_dir

find ./logs -name "std*[^z]" -mtime +1 -exec gzip {} \;
