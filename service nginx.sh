#!/bin/bash
# chkconfig: 2345 10 90
. /etc/rc.d/init.d/functions 

nginx="/usr/local/nginx/sbin/nginx "
nginx1="/usr/local/nginx/sbin/nginx -s stop"

case "$1" in start)
$nginx
;;
stop)
$nginx1
;;
restart)
$nginx1
sleep 1 #‘›Õ£“ª√Î
$nginx
;;
*)
echo "Usage: \$0 {start|stop|status|restart}"
esac

exit 0