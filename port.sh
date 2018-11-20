#!/bin/bash 

while  true
do  b=`netstat -lntp | grep -v ^$|wc -l`
  for ((i=3;i<=$b;i++))
     do
       rom=`netstat -lntp | sed -n $i'p' | awk '{print $4}'`
       rom1=`netstat -lntp | sed -n $i'p' | awk '{print $7}'`
       echo 当前系统中开启的端口号：${rom##*:}
       echo 端口号对应的PID及服务名：$rom1
       echo " "
     done 
sleep 3
echo -------------------------------
done
