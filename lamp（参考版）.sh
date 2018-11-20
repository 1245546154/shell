#!/bin/bash
#lamp环境一键部署 （仅用于新装系统）
#yum配置  mysql31 apr php http
echo “————————★————————”
echo “————————★————————”
echo “————————★————————”
read -p  "欢迎使用lamp一键搭建脚本，按任意键继续"
read -p  "请输入mysql安装包名称(不要输入后缀):" ma
read -p  "请输入mysql sever id ：" id
read -p  "请输入php安装包名称(不要输入后缀):" pf
read -p  "请输入apr安装包名称(不要输入后缀):" af
read -p  "请输入apr-util安装包名称(不要输入后缀):" uf
read -p  "请输入http安装包名称(不要输入后缀):" hf

mount /dev/sr0 /mnt/  > /dev/null 2&>1 #测试环境使用
echo "自动检测配置yum中.."
ping -c 1  1.0.0.1 > /dev/null  #测试环境使用127.0.0.1
if [ $? -eq 0 ] ; then 

cat > /etc/yum.repos.d/server.repo << EOF
[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
EOF

else 
cat > /etc/yum.repos.d/local.repo << EOF
[c7-media]
name=CentOS-$releasever - Media
baseurl=file:///mnt/
gpgcheck=0
enabled=1
EOF
fi

#环境部署安装各种依赖包
{
yum clean all 
yum makecache 
yum -y install gcc pcre-devel openssl-devel zlib-devel ncurses-devel cmake libcurl-devel gcc-c++ libjpeg-devel  libpng libpng-devel freetype-devel libxml2-devel 
yum groupinstall "Development tools" -y
yum groupinstall "Desktop Platform Development" -y
} 

#mysql脚本
cmak() {
cmake . \
-DCMAKE_INSTALL_PREFIX=/mydb/mysql31 \
-DMYSQL_DATADIR=/mydb/mysql31/data \
-DSYSCONFDIR=/etc \
-DMYSQL_TCP_PORT=3308 \
-DMYSQL_UNIX_ADDR=/mydb/mysql31 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci
}

#mysql 源码安装和编译
{
   mkdir /Packup
   tar -xf `find / -name $ma.*` -C /Packup/
   cd `find / -name $ma` 
cmak 
make 
make install
   cd /mydb/mysql31
   chown mysql. -R /mydb/mysql31/ 
   scripts/mysql_install_db --user=mysql 
   cp support-files/mysql.server /etc/init.d/mysql31
}
#配置mysql my.cnf文件
sed -i '19s/#socket = .../socket = \/mydb\/mysql31\/mysql31.sock/' /mydb/mysql31/my.cnf
sed -i '18s/#server_id = .../server_id = '$id'/' /mydb/mysql31/my.cnf

service mysql31 restart

#mysql_secure_installation  #需要更改密码之后进行初始化（源码安装无效）
{
service mysql35 stop 
service mysql31 stop 
service mysql25 stop
service mysqld  stop
service mysql

    tar -xf `find / -name $af.*` -C /Packup/
    cd `find / -name $af`
    ./configure
make 
make install

} 

{
    tar -xf `find / -name $uf.*` -C /Packup/
    cd `find / -name $uf`
    ./configure --with-apr=/usr/local/apr/bin/apr-1-config
make
make install
echo /usr/local/apr/lib/ > /etc/ld.so.conf.d/lamp.conf
ldconfig 
} 
http(){
#!/bin/bash
./configure \
--enable-modules=all \
--enable-mods-shared=all \
--enable-so \
--enable-rewrite \
--with-mpm=prefork \
--with-apr=/usr/local/apr/bin/apr-1-config \
--with-apr-util=/usr/local/apr/bin/apu-1-config
}

{
    tar -xf `find / -name $hf.*` -C /Packup/
    cd `find / -name $hf`
http
make
make install
} 
php() {
./configure \
--with-apxs2=/usr/local/apache2/bin/apxs \
--with-mysql=/mydb/mysql31/ \
--with-mysqli=/mydb/mysql31/bin/mysql_config \
--with-pdo-mysql=/mydb/mysql31/ \
--with-zlib \
--with-zlib-dir=/mydb/mysql31/zlib \
--with-curl \
--enable-zip \
--with-gd \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--enable-sockets \
--with-xmlrpc \
--enable-soap \
--enable-opcache \
--enable-mbstring \
--enable-mbregex \
--enable-pcntl \
--enable-shmop \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-calendar \
--enable-bcmath
}

{
    tar -xf `find / -name $pf.*` -C /Packup/
    cd `find / -name $pf`

php
make
make install
} 

#输出apache文件和php文件 确认安装成功
echo 安装完毕输出安装目录文件..
ls /usr/local/apache2/
ls /usr/local/apache2/modules/libphp5.so	
echo 准备后续配置..

#后续配置 A. 配置apache和php的联系
#配置语言支持
echo "LoadModule negotiation_module" >> /usr/local/apache2/conf/httpd.conf
echo "modules/mod_negotiation.so" >> /usr/local/apache2/conf/httpd.conf
echo "Include conf/extra/httpd-languages.conf	" >> /usr/local/apache2/conf/httpd.conf

#开机虚拟主机的支持
sed -i '/httpd-languages.conf/s/^#//' /usr/local/apache2/conf/httpd.conf

#以.php结尾的文件都认为是php程序文件
sed -i '/LoadModule php5_module/a\\AddHandler php5-script   .php' /usr/local/apache2/conf/httpd.conf
sed -i '/AddHandler php5-script   .php/a\\AddType text/html  .php' /usr/local/apache2/conf/httpd.conf

#默认主页加上index.php,并放在index.html前,支持php的首页文件
sed -i  's/index.html/ index.php&/' /usr/local/apache2/conf/httpd.conf

#修改apache子配置文件 优先支持中文
echo DefaultLanguage zh-CN >> /usr/local/apache2/conf/extra/httpd-languages.conf

#打开注释，默认语言集改为中文
sed -i '19s/# DefaultLanguage nl/DefaultLanguage zh-CN/' /usr/local/apache2/conf/extra/httpd-languages.conf   

#语言集优先集，把zh-CN 写到前面
sed -i  's/en ca cs da/ zh-CN &/' /usr/local/apache2/conf/extra/httpd-languages.conf

#后续配置 B.让php支持连接本地的数据库
#拷贝关联文件
yes|cp  `find / -name $pf`/php.ini-production /usr/local/lib/php.ini

#告诉php从哪里读取socket文件以及数据库的端口号
#[修改mysql]
sed -i '1151s/mysql.default_port =/mysql.default_port = 3308/' /usr/local/lib/php.ini    
sed -i '1156s/mysql.default_socket =/mysql.default_socket = \/mydb\/mysql31\/mysql31.sock/' /usr/local/lib/php.ini
#[修改mysqli]
sed -i '1215s/mysqli.default_socket =/ mysqli.default_socket = \/mydb\/mysql31\/mysql31.sock/' /usr/local/lib/php.ini
sed -i '1210s/mysqli.default_port = 3306/mysqli.default_port = 3308/' /usr/local/lib/php.ini


#网站加目录里写php测试页
ppp(){ << CAT
<?php
        phpinfo();
?>
CAT
}

ppp >> /usr/local/apache2/htdocs/index.php

#虚拟主机选项再次加上注释
sed -i '/httpd-languages.conf/s/^/#&/' /usr/local/apache2/conf/httpd.conf

#将apache启动命令做成脚本
yes|cp /usr/local/apache2/bin/apachectl /etc/init.d/apache


service apache restart
service mysql31 restart
lsof -i :80
sleep 1
lsof -i :3308


#sed -i '3s/关键字/替换/' file    替换指定行
#sed -i 's[关键字]/[替换]' file   替换关键字
#sed -i '/关键字/a\\插入' file    关键行下面插入
#sed -i '/关键字\\插入' file      关键行上面插入
#sed -i 's/关键字/插入&/' file    在关键字前面插入语句 （&）  
#sed -i 's/关键字/&插入/' file    在关键字后面插入语句 （&）
#sed -i '/关键字/s/^#//' file     再关建行前面删除注释
#sed -i '/关键字/s/^/#&/' file    在关键行前面添加注释
