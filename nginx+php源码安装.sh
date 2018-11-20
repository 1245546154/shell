#!/bin/bash
#欢迎使用nginx php安装脚本
#没有配置wget下载包，所以需要手动把安装包上传到统一文件夹内
#执行脚本输入包名前缀即可
#yum默认为本地源 如需使用网络源 下面去掉注释即可
#-------------------------------------------------------

#read -p  "请输入ngx第三方软件包名称(不要输入后缀)：" f
read -p  "请输入nginx安装包名称(不要输入后缀)：" na
read -p  "请输入pcre安装包名称(不要输入后缀)：" ea
read -p  "请输入php安装包名称(不要输入后缀)：" pa
echo " "

sleep 1

mount /dev/sr0 /mnt/ > /dev/null  #测试环境使用

# echo "自动检测配置yum中.."
# {
# mv /etc/yum.repo.d/Cen* /etc/yum.repo.d/back
# ping -c 1 www.baidu.com > /dev/null  
# if [ $? -eq 0 ]
# cat > /etc/yum.repos.d/server.repo << EOF
# [base]
# name=CentOS-$releasever - Base - mirrors.aliyun.com
# failovermethod=priority
# baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
#        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
#        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
# enabled=1
# gpgcheck=1
# gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
# EOF
# else exit 
# echo 请检查源
# fi
# }

mkdir /Packup -p > /dev/null

yum clean all > /dev/null
yum makecache > /dev/null
yum -y install gcc  openssl-devel zlib-devel ncurses-devel cmake libcurl-devel gcc-c++ libjpeg-devel  libpng libpng-devel freetype-devel libxml2-devel net-tools wget git bison expat-devel  pcre-devel

yum install -y `find /packup -name libmcrypt-*`

{ #安装pcre包
echo 安装pcre包
    tar -xf `find / -name $ea.*` -C /Packup/ 
    cd `find / -name $ea` 
./configure --prefix=/usr/local/pcre  
make && make install 
}i

{ #安装nginx
echo 安装nginx
   tar -xf `find / -name $na.*` -C /Packup/ 
   cd `find / -name $na`
 ./configure --prefix=/usr/local/$na --with-http_ssl_module --add-module=../$f
make && make install
}

#{ #安装ngx第三方软件
#echo 安装ngx第三方软件
#   tar -xf `find / -name $f.*` -C /Packup/
#   cd `find / -name $f`
#./configure --prefix=/usr/local/$na --with-http_ssl_module
#make && make install
#}

cat > /etc/init.d/nginx << EOF
#!/bin/bash
#添加第四行的 1前面加上刀勒符
#添加第十六行 \ 0 中间加上刀勒符
. /etc/rc.d/init.d/functions 
case 1 in start)
/usr/local/nginx/sbin/nginx
;;
stop)
/usr/local/nginx/sbin/nginx -s stop
;;
restart)
/usr/local/nginx/sbin/nginx -s stop 
sleep 1 
/usr/local/nginx/sbin/nginx
;; 
*)
echo "Usage: \ 0 {start|stop|status|restart}"
esac
exit 0

EOF

php(){
 ./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-mbstring \
--with-mcrypt \
--enable-ftp \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--without-pear \
--with-gettext \
--disable-fileinfo \
--enable-maintainer-zts 
}

cd /packup
yum install libmcrypt-2.5.8-4.3.x86_64.rpm -y
yum install libmcrypt-devel-2.5.8-4.3.x86_64.rpm -y

{ #安装php
echo 安装php
    tar -xf `find / -name $pa.*` -C /Packup/ 
    cd `find / -name $pa`
php 
make && make install
}

cd /usr/local/php
ls /usr/local/$na
echo "-----------------------------------"
ls /usr/local/php/
echo "-----------------------------------"
php -v
echo "-----------------------------------"
sleep 1

#复制配置文件
echo 复制配置文件
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
#cp /root/soft/$na/php.ini-production /usr/local/php/etc/php.ini
   
#添加php-fpm运行用户   
groupadd www
useradd -s /sbin/nologin -g www -M www

#添加php启动服务
cd /Packup/php*
cp sapi/fpm/init.d.php-fpm /etc/init.d/php
chmod +x /etc/init.d/php

#开机启动
chkconfig --add php
chkconfig php on

#添加php环境变量
echo 'PATH=/usr/local/php/bin:$PATH' >> /etc/profile
echo 'export PATH' >> /etc/profile
source /etc/profile

echo 安装完成

sleep 1

service php start

#创建软连接方便启动
ln -s /usr/local/$na/ /usr/local/nginx
chmod +x /etc/init.d/nginx  
#/usr/local/nginx/sbin/nginx

#调用server启动服务
service nginx start
vim /etc/init.d/nginx

#设置开机自启
chkconfig --add nginx
chkconfig nginx on

ps -aux | grep nginx
ps -aux | grep php

echo "服务启动完成"


