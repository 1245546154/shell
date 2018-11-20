#!/bin/bash
#欢迎使用环境安装脚本
#centos6-7 lnmp和lamp,各种工具依赖包
#-------------------------------------------------------

install1 (){
yum -y install gcc  openssl-devel zlib-devel ncurses-devel cmake libcurl-devel gcc-c++ libjpeg-devel  libpng libpng-devel freetype-devel libxml2-devel screen net-tools wget git bison
 
glibc glibc-common gd gd-devel  net-snmp unzip openssl-devel lrzsz libevent libevent-devel elinks
}

yum6 (){
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo > /dev/null 2>&1 
yum clean all > /dev/null
yum makecache > /dev/null
}

yum7 (){
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo > /dev/null 2>&1
yum clean all > /dev/null
yum makecache > /dev/null

}

net6 (){
ping -c 1 www.baidu.com > /dev/null 2>&1
if [ $? -eq 0 ] ; then
yum6
else  echo “请检查网络” 
fi
}

net7 (){
ping -c 1 www.baidu.com > /dev/null 2>&1
if [ $? -eq 0 ] ; then
yum7 
else echo “请检查网络” 
fi
}

a=`cat /etc/redhat-release` 

echo 当前系统参数：$a
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

exit 0
