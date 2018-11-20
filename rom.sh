#!/bin/bash
#循环检测服务是否down掉，自动启动服务，并记录状态到对应文件
while true 
do 
netstat -lnpt | grep 80 > /dev/null
if [ $? -eq 1 ] ;then
    echo "nginx is dowm" >> /rom.log
    service nginx start
else 
    echo nginx is up  >> /rom.log
fi


netstat -lnpt | grep 9000 > /dev/null
if [ $? -eq 1 ] ; then
    echo "php is dowm" >> /rom.log
    service php start
else
    echo php is up  >> /rom.log
fi


netstat -lnpt | grep 3309 > /dev/null
if [ $? -eq 1 ] ; then
    echo "mysql is dowm" >> /rom.log
    service mysql33 start
else
    echo mysql is up  >> /rom.log
fi


netstat -lnpt | grep 22 > /dev/null
if [ $? -eq 1 ] ; then
    echo "sshd is dowm" >> /rom.log
    service sshd start
else
    echo ssh is up  >> /rom.log
fi

#netstat -lnpt | grep ?? > /dev/null
#if [ $? -eq 1 ] ; then
#    echo "?? is dowm" >> /rom.log
#    service ?? start
#else
#    echo ?? is up  >> /rom.log
#fi

echo "--------------`date +%F-%T`----------------" >> /rom.log

sleep 3 #设置成了三秒一次

done 



