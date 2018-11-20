#!/bin/bash
# chkconfig: 2345 10 90
. /etc/rc.d/init.d/functions

#reids="/usr/local/redis/bin/redis-server redis.conf"

redis1="killall redis-server"
net="netstat -lntp | grep redis-server"

STOP() {
$net > /dev/null
if [ $? -eq 0 ] ; then
$redis1 >/dev/null 2&>1
action "redis" /bin/true
else action "redis" /bin/false
echo "reids服务没有开启"
fi
}

START(){
$net >/dev/null
if [ "$?" -eq "1" ] ; then
cd /usr/local/redis/bin
./redis-server redis.conf
action "redis" /bin/true
else action "redis" /bin/false
echo "redis服务正在后台运行"
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
