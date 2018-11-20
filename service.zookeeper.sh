#!/bin/bash
# chkconfig: 2345 10 90
. /etc/rc.d/init.d/functions


case "$1" in start)
/usr/local/zookeeper/bin/zkServer.sh start
;;
stop)
/usr/local/zookeeper/bin/zkServer.sh stop
;;
restart)
/usr/local/zookeeper/bin/zkServer.sh stop
sleep 1 #‘›Õ£“ª√Î
/usr/local/zookeeper/bin/zkServer.sh start
;;
*)
echo "Usage: \$0 {start|stop|status|restart}"
esac
exit 0