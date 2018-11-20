#!/bin/bash
yum install mailx sendmail  -y  

cat >> /etc/mail.rc <<EOF
set bsdcompat
set from=1245546154@qq.com                
set smtp=smtp.qq.com                      
set smtp-auth-user=1245546154@qq.com      
set smtp-auth-password=vupmkkqgqrxegcfc   
set smtp-auth=login                      
EOF



while true 
do 

netstat -lnpt | grep 80 > /dev/null
if [ $? -eq 1 ] ;then
echo "nginx服务器dowm掉了`date +%F-%T`" >> /rom.log
echo "nginx服务down掉了`date +%F-%T`" | mail -s '负载均衡1'  1245546154@qq.com
fi

netstat -lnpt | grep 9000 > /dev/null
if [ $? -eq 1 ] ; then
echo "php服务器dowm掉了`date +%F-%T`" >> /rom.log

echo "php服务down掉了`date +%F-%T`" | mail -s '负载均衡1'  1245546154@qq.com
fi

netstat -lnpt | grep 3309 > /dev/null
if [ $? -eq 1 ] ; then
echo "mysql服务器dowm掉了`date +%F-%T`" >> /rom.log
echo "mysql服务down掉了`date +%F-%T`" | mail -s '负载均衡1' 1245546154@qq.com
fi

sleep 1800

done 


