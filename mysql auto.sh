#!/bin/bash
#欢迎使用mysql安装脚本
#没有配置wget下载包，所以需要手动把安装包上传到统一文件夹内
#执行脚本输入包名前缀即可
#yum默认为本地源 如需使用网络源 下面去掉注释即可
#-------------------------------------------------------

read -p  "请输入mysql安装包名称(不要输入后缀)：" ma
read -p  "请输入mysql安装路径：" mb
read -p  "请输入mysql数据目录：" mc
read -p  "请输入mysqlsock文件路径（以mysqlXX.scok结尾）：" md
read -p  "请输入端口号：" me

groupadd mysql  #创建mysql的组
useradd -s /sbin/nologin -g mysql -M mysql  #将mysql添加到mysql的组并且设置脚本参数不允许登录
tail -1 /etc/passwd
echo " "
echo " "
echo " "
echo " "
sleep 1

mount /dev/sr0 /mnt/  > /dev/null  #测试环境使用

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

{
#环境部署安装各种依赖包
yum clean all
yum makecache
yum -y install gcc  openssl-devel zlib-devel ncurses-devel cmake libcurl-devel gcc-c++ libjpeg-devel  libpng libpng-devel freetype-devel libxml2-devel net-tools wget git bison expat-devel
}

#mysql脚本
cmak() {
cmake . \
-DCMAKE_INSTALL_PREFIX=$mb \
-DMYSQL_DATADIR=$mc \
-DSYSCONFDIR=/etc \
-DMYSQL_TCP_PORT=$me \
-DMYSQL_UNIX_ADDR=$md \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci
-DWITH_SSL=bundled
}

mkdir /Packup -p

#mysql 源码安装和编译
   tar -xf `find / -name $ma.*` -C /Packup/
   cd `find / -name $ma`
cmak
make && make install
   cd $mb
   chown mysql. -R $mb
   scripts/mysql_install_db --user=mysql #初始化数据库

{  #添加数据库的环境变量
echo 'PATH='$ma'/bin:$PATH' >> /etc/profile
echo 'export PATH' >> /etc/profile
source /etc/profile
}
   cp support-files/mysql.server /etc/init.d/mysqld #server启动服务
   cp $ma/my.cnf /etc/my.cnf
./bin/mysql_secure_installation  #配置初始化 

service mysqld restart  

echo 请手动配置mysql my.cnf文件
echo 请配置mysql的密码
echo ""
echo ""
echo ""
echo ""
sleep 2

mysql -S $md -uroot -p123456

# delete from mysql.user where User=‘’;
# updata mysql.user set Password = password('123456');
# flush privileges;


