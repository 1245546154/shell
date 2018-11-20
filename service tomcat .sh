#!/bin/bash
# chkconfig: 2345 10 90
export JAVA_HOME=/usr/local/java/jdk/jdk-10.0.1
. #需要指定java文件目录的变量/etc/rc.d/init.d/functions

start="/usr/local/tomcat/bin/startup.sh"
stop="/usr/local/tomcat/bin/shutdown.sh"
net="netstat -lntp | grep 8080"

STOP() {
$net > /dev/null
if [ $? -eq 0 ] ; then
$stop #>/dev/null 2&>1
action "tomcat" /bin/true
else action "tomcat" /bin/false
echo "tomcat服务没有开启"
fi
}

START(){
$net >/dev/null
if [ "$?" -eq "0" ] ; then
$start #>/dev/null 2&>1
action "tomcat" /bin/true
else action "tomcat" /bin/false
echo "tomcat服务正在后台运行"
fi
}

case "$1" in start)
START
;;

stop)
STOP
;;

restart)
STOP
START
;;
*)
esac

exit 0

