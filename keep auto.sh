#!/bin/bash

stop=¡¯systemctl stop keepalived >/dev/null¡¯
start=¡¯systemctl start keepalived >/dev/null¡¯
keep=¡¯ps -C keepalived --no-header | wc -l¡¯
nginx=¡¯netstat -lnpt | grep 80 > /dev/null¡¯

while true 
do 
if [ $nginx -eq 1 ] ;then
$stop
    else 
        ping -c 1 192.168.23.200 > /dev/null
        if [ $? -eq 1 ] ; then
        $stop
            else 
    	        $start
      fi
   fi
fi
sleep 2
done 