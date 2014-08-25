# 介绍
基于Oracle jdk7的Tomcat容器。

## 目录结构约定：
约定目的: 与docker无关,自用.

|  目录                         |             用途                                                |
|-------------------------------|-----------------------------------------------------------------|
|/home/coop/appname/conf/    |Tomcat的主配置包含server.xml/logging.properties/java-options.conf等 |
|/home/coop/appname/log/     |当前应用产生产生的统计类业务日志                                    |
|/home/coop/appname/logs/    |Tomcat自身的日志,如:catalina.out/catalina.2014-08-22.log等          |
|/home/coop/appname/webapps/ |当前应用的主代码:jsp/jar等文件                                      |

## 创建镜像：
1. 获取：
<pre>
cd ~
git clone https://github.com/djluo/docker-tomcat.git
</pre>
2. 构建镜像（依赖网络,会从Tomcat官网下载Dockerfile中指定的版本）：
<pre>
cd ~/docker-tomcat
sudo docker build -t tomcat   .
sudo docker build -t tomcat:1 .
</pre>
3. 启动容器：
<pre>
sudo docker run -it -p 8080:8080 --rm tomcat
</pre>
4. 测试：
<pre>
curl http://127.0.0.1:8080/
</pre>

## 使用
1. 目录结构
<pre>
sudo mkdir -p /home/coop/appname/{conf,log,logs,webapps}
</pre>
2. 复制配置文件
<pre>
sudo cp -av ~/docker-tomcat/conf /home/coop/appname/
</pre>
3. 如部署的应用是支持自动发布的:
<pre>
sudo mv -v /home/coop/appname/server.xml{.example1,}
</pre>
4. 如不支持自动发布:
<pre>
sudo mv -v /home/coop/appname/server.xml{.example2,}
</pre>
5. 部署应用的代码至 `/home/coop/appname/webapps`
6. 启动
<pre>
cd /home/coop/appname/
sudo docker run -ti -p 8080:8080       \
    -v `pwd`/conf:/tomcat/conf/:ro     \
    -v `pwd`/log/:/tomcat/log/         \
    -v `pwd`/logs/:/tomcat/logs/       \
    -v `pwd`/webapps/:/tomcat/webapps/ \
    --name appname tomcat $@
</pre>
