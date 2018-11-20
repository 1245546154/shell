#!/bin/bash
#File Name: mysql_install.sh
#Author: Songzeshan 
#Desc: MySQL(5.6.x) Install - Source Code
#Path: /shell/0816/mysql_install.sh
#Created Time: Thu 16 Aug 2018 03:40:04 PM CST

[ -f /etc/rc.d/init.d/functions ] && . /etc/rc.d/init.d/functions 

package=/usr/local/src/package
ext_package=/usr/local/src/ext_package
basedir=/data/mysql 
datadir=/data/mysql/data
port=3306
password=123456
sql_ver=mysql-5.6.31.tar.gz

function prepare_env(){
    [ -d /usr/local/src/package/ ] || {
    mkdir /usr/local/src/{ext_,}package
    }
    rpm -e mysql-libs --nodeps &>/dev/null
    [ -d $basedir ] || mkdir -p $basedir
    [ -d $datadir ] || mkdir -p $datadir
    id mysql &>/dev/null 
    [ $? -eq 0 ] || useradd -r -M -s /sbin/nologin mysql &>/dev/null 
    yum install -y cmake gcc ncurses-devel openssl-devel 
}

function chk_package(){
    if [ -f $package/$sql_ver ];then
        tar xf $package/$sql_ver -C $ext_package
    else
        wget -O $package/$sql_ver https://downloads.mysql.com/archives/get/file/$sql_ver
        tar xf $package/$sql_ver -C $ext_package
    fi
}

function mysql_install(){
    chk_package
    cd $ext_package/${sql_ver:0:12} 
    cmake . \
        -DCMAKE_INSTALL_PREFIX=$basedir \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_general_ci \
        -DENABLED_LOCAL_INFILE=1 \
        -DMYSQL_DATADIR=$datadir \
        -DMYSQL_TCP_PORT=$port \
        -DSYSCONFDIR=$basedir \
        -DMYSQL_UNIX_ADDR=$basedir/mysql.sock \
        -DWITH_EXTRA_CHARSETS=all \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_MEMORY_STORAGE_ENGINE=1 \
        -DWITH_MYISAM_STORAGE_ENGINE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
    wait 
    make && make install 
}

function mysql_init(){
    chown -R mysql.mysql $basedir
    $basedir/scripts/mysql_install_db --user=mysql --basedir=$basedir --datadir=$datadir
    #sed -i "s#^\(basedir=\).*#\1$basedir#g" $basedir/support-files/mysql.server
    #sed -i "s#^\(datadir=\).*#\1$datadir#g" $basedir/support-files/mysql.server
    cp $basedir/support-files/mysql.server /etc/init.d/mysql 
    /etc/init.d/mysql start
    echo "export PATH=\$PATH:$basedir/bin" >> /etc/profile 
    source /etc/profile
    mysqladmin -uroot password "$password" 
    if [ $? -eq 0 ];then
    	action "MySQL启动成功" /bin/true 
    	echo -e "默认端口为:$port,安装目录为:$basedir,数据目录为:$datadir,root密码为:$password"
    else
    	action "MySQL启动失败" /bin/false
    	exit 3
    fi
}

function main(){
    prepare_env
    mysql_install
    mysql_init
}

main

