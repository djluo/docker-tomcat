#!/usr/bin/perl
# vim:set et ts=2 sw=2:

# Author : djluo
# version: 3.0(20150625)
#
# 初衷: 每个容器用不同用户运行程序,已方便在宿主中直观的查看.
# 需求: 1. 动态添加用户,不能将添加用户的动作写死到images中.
#       2. 容器内尽量不留无用进程,保持进程树干净.
# 问题: 如用shell的su命令切换,会遗留一个su本身的进程.
# 最终: 使用perl脚本进行添加和切换操作. 从环境变量User_Id获取用户信息.

use Cwd;
use strict;
#use English '-no_match_vars';

my $uid = 1000;
my $gid = 1000;
my $pwd = cwd();

$uid = $gid = $ENV{'User_Id'} if $ENV{'User_Id'} =~ /\d+/;

system("rm", "-f", "/run/crond.pid") if ( -f "/run/crond.pid" );
system("/usr/sbin/cron");

unless (getpwuid("$uid")){
  system("/usr/sbin/useradd", "-U", "-u $uid", "-m", "docker");
  system("mkdir -p /tomcat/work/appbase");
  system("mkdir -p /tomcat/work/xmlbase");
  system("mkdir -p /tomcat/work/workdir");
  system("mkdir -p /tomcat/work/temp");
  system("chown docker.docker -R /tomcat/work");
}

my @log_dirs = ( "/tomcat/log", "/tomcat/logs", "$pwd/log", "$pwd/logs" );
foreach my $dir ( @log_dirs ){
  system("mkdir", "-p", "$dir")               unless ( -d "$dir" );
  system("chown", "docker.docker", "-R", "$dir")  if ( -d "$dir" );
}

system("sed", "-i", "s%^current_dir=/tomcat%current_dir=$pwd%", "/tomcat/cmd.sh");
system("sed", "-i", "s%^current_dir=/tomcat%current_dir=$pwd%", "/tomcat/gzip.sh");
system("sed", "-i", "s%= /tomcat%= $pwd%", "/tomcat/conf/logging.properties");

my @links = ( "cmd.sh", "gzip.sh", "webapps", "conf" );
foreach my $link ( @links ){
  system("ln", "-sv", "/tomcat/$link");
}

system("/init.sh") if ( -x "/init.sh" );

# 切换当前运行用户,先切GID.
#$GID = $EGID = $gid;
#$UID = $EUID = $uid;
$( = $) = $gid; die "switch gid error\n" if $gid != $(;
$< = $> = $uid; die "switch uid error\n" if $uid != $<;

$ENV{'HOME'} = "/home/docker";

my $min = int(rand(60));
open(CRON,"|/usr/bin/crontab") or die "crontab error?";
print CRON ("$min 02 * * * (/tomcat/gzip.sh >/dev/null 2>&1)\n");
close(CRON);

exec(@ARGV);
