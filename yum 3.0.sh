#!/bin/bash
#欢迎使用环境安装脚本
#centos6-7 lnmp和lamp,各种工具依赖包
#-------------------------------------------------------

mount /dev/sr0 /mnt/ > /dev/null 2>&1 #虚拟机使用可注释

install1 (){
yum -y install gcc  openssl-devel zlib-devel ncurses-devel cmake libcurl-devel bc gcc-c++ libjpeg-devel  libpng sendmail libpng-devel freetype-devel libxml2-devel screen net-tools wget git bison
 
glibc glibc-common gd gd-devel  net-snmp unzip openssl-devel lrzsz libevent libevent-devel elinks
}

yum6 (){
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo > /dev/null 2>&1 
#yum clean all > /dev/null
yum makecache > /dev/null
}

yum7 (){
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo > /dev/null 2>&1
#yum clean all > /dev/null
yum makecache > /dev/null

}

net6 (){
ping -c 1 www.baidu.com > /dev/null 2>&1
if [ $? -eq 0 ] ; then
yum6
else  echo “配置失败请检查网络” 
exit 1
fi
}

net7 (){
ping -c 1 www.baidu.com > /dev/null 2>&1
if [ $? -eq 0 ] ; then
yum7 
else echo “配置失败请检查网络” 
exit 1
fi
}


mkdir /usr/bin/bc > /dev/null
if [ $? -eq 1 ] ; then
  aa=`awk '{print $3}'  /etc/redhat-release`
  bb=`echo "scale=2;$aa/10" | bc | awk -F. '{print $2}'`

      if [ "$bb" -ge "60" ] | [ "$bb" -le "69" ] ; then 
      net6 
      fi

      if [ "$bb" -ge "70" ] | [ "$bb" -le "79" ] ; then
      net7
      fi

      install1

else
rm -rf /usr/bin/bc
a=`cat /etc/redhat-release`
echo 当前系统信息为：$a 
echo ------------------------------------------------------
read -p "选择配置的系统版本（6|7）:" c

case "$c" in 6 )
net6
read "Centos6 yum阿里源配置完成"
;;

7 )
net7 
read "Centos7 yum阿里源配置完成"
;;
esac

install1 

fi
exit 0


