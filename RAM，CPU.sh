#!/bin/bash
while  true
  do 
     top -n 1 -b > /top.sh  
echo --------------------------------------------------------
{
men1=`free -m | sed -n "2p" | awk '{print $2}'` #内存总额
men2=`free -m | sed -n "2p" | awk '{print $3}'` #内存使用
men3=`free -m | sed -n "2p" | awk '{print $4}'` #内存剩余
zong=`echo "scale=2;$men2/$men1" \* 100  | bc | awk -F. '{print $1}'`
if [ $zong -ge "90" ] ; then echo "内存hight了，就剩下$men3,M了" |mail -s "内存爆了"  1245546154@qq.com
fi
echo 内存总额$men1'm'  内存使用$men2'm'  内存剩余$men3'm'
}


{
swap1=`free -m | sed -n "3p" | awk '{print $2}'` #交换内存总额 
swap2=`free -m | sed -n "3p" | awk '{print $3}'` #交换内存使用
swap3=`free -m | sed -n "3p" | awk '{print $4}'` #交换内存剩余
shu=`echo "scale=2;$swap2/$swap1" \* 100  | bc | awk -F. '{print $1}'`
if [ $shu -ge 90 ] ; then echo "交换内存hight了，就剩下$men3,M了" |mail -s "交换内存爆了"  1245546154@qq.com
fi
echo 交换内存总额$swap1'm'  交换内存使用$swap2'm'  交换内存剩余$swap3'm'
}

{
echo --------------------------------------------------------
time1=`cat /top.sh | sed -n "1p" | awk '{print $3}'` &&  echo 当前系统时间 $time1
time3=`cat /top.sh | sed -n "1p" | awk '{print $5}'` &&  echo 当前系统运行时间 $time3
time4=`cat /top.sh | sed -n "1p" | awk '{print $6}'` &&  echo 当前登录的用户数量 $time4
echo --------------------------------------------------------
echo CPU已使用$time2"%"
echo 系统1分钟负载情况$time5"%"
echo 系统5分钟负载情况$time6"%"
echo 系统15分钟负载情况$time7"%"
}

{
time5=`cat /top.sh |  sed -n "1p" | awk '{print $12}'`  #系统1分钟负载情况
#ti1=`echo "scale=2;$time5/10"   | bc | awk -F. '{print $2}'`
#if [ $ti1 -ge "500" ] ; then 
#echo "系统负载了" |mail -s "系统负载了"  1245546154@qq.com
#fi
}

{
time6=`cat /top.sh |  sed -n "1p" | awk '{print $11}'`  #系统5分钟负载情况
#ti2=`echo "scale=2;$time6/10"   | bc | awk -F. '{print $2}'`
#if [ $ti2 -ge "500" ] ; then 
#echo "系统负载了" |mail -s "系统负载了"  1245546154@qq.com
#fi
}

{
time7=`cat /top.sh |  sed -n "1p" | awk '{print $10}'`  #系统15分钟负载情况
#ti3=`echo "scale=2;$time7/10"   | bc | awk -F. '{print $2}'`
#if [ $ti3 -ge "500" ] ; 
#then echo "系统负载了" |mail -s "系统负载了"  1245546154@qq.com
#fi
}

{
time2=`cat /top.sh |  sed -n "3p" | awk '{print $2}'`  #CPU使用率
ti2=`echo "scale=2;$time2/100" | bc | awk -F. '{print $2}'` #将小数计算成整数
if [ $ti2 -ge "85" ] ;  
then echo "CPU使用率达到80%" |mail -s "CPU使用率达到80%"  1245546154@qq.com
fi
}

echo  --------------------------------------------------------
echo  --------------------------------------------------------


sleep 2
done
