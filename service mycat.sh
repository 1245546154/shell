#!/bin/bash
# chkconfig: 2345 10 90
. /etc/rc.d/init.d/functions 

mycat="/usr/local/mycat/bin/mycat start"
mycat1="/usr/local/mycat/bin/mycat stop"

case "$1" in start)
$mycat
;;
stop)
$mycat1
;;
restart)
$mycat
sleep 1 #‘›Õ£“ª√Î
$mycat
;;
*)
echo "Usage: \$0 {start|stop|status|restart}"
esac

exit 0