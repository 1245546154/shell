#!/bin/bash
#File Name: nginx_php.sh
#Author: Songzeshan 
#Desc: 
#Path: /root/nginx_php.sh
#Created Time: Tue 14 Aug 2018 01:38:46 PM CST

[ -f /etc/rc.d/init.d/functions ] && . /etc/rc.d/init.d/functions 

package=/usr/local/src/package
ext_package=/usr/local/src/ext_package
ngx_ver=nginx-1.12.2
ngx_suffix=.tar.gz
php_ver=php-5.6.23
php_suffix=.tar.xz
icon_ver=libiconv-1.14

mysql_host="192.168.235.163"
mysql_port="8066"
mysql_user="web"

function prepare_env(){
    if [ $UID -eq 0 ];then
        yum install -y pcre pcre-devel openssl openssl-devel epel-release
        yum install -y zlib-devel libxml2-devel libjpeg-turbo-devel
        yum install -y freetype-devel libpng-devel gd-devel libcurl-devel
        yum install -y mhash mhash-devel mcrypt libmcrypt-devel libxslt-devel
        id nginx &>/dev/null 
        [ $? -eq 0 ] || useradd -r -M nginx
        [ -d /usr/local/package ] || mkdir /usr/local/src/{ext_,}package
    else
        echo "此脚本只能用root用户运行"
        exit 1
    fi
}

function nginx_install(){
    chk_soft $ngx_ver $ngx_suffix "http://nginx.org/download/$ngx_ver$ngx_suffix"
    cd $ext_package/$ngx_ver 
    ./configure \
        --prefix=/usr/local/$ngx_ver \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_stub_status_module 
    make && make install 
    [ -L /usr/local/nginx ] || {
    ln -s /usr/local/$ngx_ver /usr/local/nginx 
    }
    #add_ngx_sys
}

function chk_soft(){
    if [ -f $package/$1$2 ];then
        tar xf $package/$1$2 -C $ext_package
    else
        wget -O $package/$1$2 $3 
        tar xf $package/$1$2 -C $ext_package
    fi
}

function add_ngx_sys(){
cat > /etc/init.d/nginx <<-EOF
#!/bin/bash
#chkconfig: 35 20 80
#description: Nginx service manage

[ -f /etc/init.d/functions ] && . /etc/init.d/functions

option=\$1
nginx=/usr/local/nginx/sbin/nginx
pidFile=/usr/local/nginx/logs/nginx.pid
function usage(){
    echo "Usage: /etc/init.d/nginx {start|stop|restart|reload|graceful|check}"
    exit 1
}

function start(){
    if [ -f \$pidFile ];then
        echo "Nginx is Running[pid:\`cat \$pidFile\`]..."
        exit 1
    else
        \$nginx &>/dev/null
        [ \$? -eq 0 ] && action "Nginx Start Success" /bin/true || {
        action "Nginx Start Failed" /bin/false
        exit 6
        }
    fi
}

function stop(){
    if [ -f \$pidFile ];then
        \$nginx -s stop &>/dev/null
        [ \$? -eq 0 ] && action "Nginx Stop Success" /bin/true || {
        action "Nginx Stop Failed" /bin/false
        exit 7
        }
    else
        echo "Nginx is not Running..."
        exit 2
    fi
}

function reload(){
    if [ -f \$pidFile ];then
        \$nginx -s reload &>/dev/null
        [ \$? -eq 0 ] && action "Nginx Reload Success" /bin/true || {
        action "Nginx Reload Failed" /bin/false
        exit 7
        }
    else
        echo "Nginx is not Running..."
        exit 3
    fi
}

function restart(){
    stop
    sleep 1
    start
}

function graceful(){
    if [ -f \$pidFile ];then
        \$nginx -s quit &>/dev/null
        action "Nginx Stop Gracefully" /bin/true
    else
        echo "Nginx is not Running..."
        exit 4
    fi
}

function status(){
    if [ -f \$pidFile ];then
        echo "Nginx is Running[pid:\`cat \$pidFile\`]..."
    else
        echo "Nginx is not Running..."
    fi
}

function check(){
    if [ -f \$pidFile ];then
        \$nginx -t &>/dev/null
        [ \$? -eq 0 ] && action "Correct grammar" /bin/true || {
        \$nginx -t
        exit 5
        }
    else
        echo "Nginx is not Running..."
        exit 6
    fi
}

function manage(){
    case "\$option" in 
        start)
            start
            ;;
        stop)
            stop
            ;;
        restart)
            reload
            ;;
        reload)
            reload
            ;;
        graceful)
            graceful
            ;;
        status)
            status
            ;;
        check)
            check
            ;;
        *)
            usage
            ;;
    esac
}
manage $option
EOF

chmod +x /etc/init.d/nginx
chkconfig --add nginx 
chkconfig --level 35 nginx on
}

function install_php(){
    install_icon
    chk_soft $php_ver $php_suffix "http://cn2.php.net/distributions/$php_ver$php_suffix"
    cd $ext_package/$php_ver 
    ./configure \
        --prefix=/usr/local/$php_ver \
        --enable-mysqlnd  \
        --with-pdo-mysql=mysqlnd  \
        --with-mysqli=mysqlnd   \
        --with-iconv-dir=/usr/local/libiconv \
        --with-freetype-dir \
        --with-jpeg-dir \
        --with-png-dir \
        --with-zlib \
        --with-libxml-dir=/usr \
        --enable-xml \
        --disable-rpath \
        --enable-bcmath \
        --enable-shmop \
        --enable-sysvsem \
        --enable-inline-optimization \
        --with-curl \
        --enable-mbregex \
        --enable-fpm \
        --enable-mbstring \
        --with-mcrypt \
        --with-gd \
        --enable-gd-native-ttf \
        --with-openssl \
        --with-mhash \
        --enable-pcntl \
        --enable-sockets \
        --with-xmlrpc \
        --enable-soap \
        --enable-short-tags \
        --enable-static \
        --with-xsl \
        --with-gettext \
        --with-fpm-user=nginx \
        --with-fpm-group=nginx \
        --enable-ftp \
        --enable-opcache=no 
    wait
    make && make install 
    [ -L /usr/local/php ] || {
    ln -s /usr/local/$php_ver /usr/local/php
    }
    cp $ext_package/$php_ver/php.ini-production /usr/local/php/lib/php.ini 
    cp /usr/local/php/etc/{php-fpm.conf.default,php-fpm.conf} 
    config_php
}

function install_icon(){
    chk_soft $icon_ver $ngx_suffix "https://ftp.gnu.org/pub/gnu/libiconv/$icon_ver$ngx_suffix"
    cd $ext_package/$icon_ver 
    ./configure --prefix=/usr/local/libiconv 
    make && make install
}

function config_php(){
    sed -i "s/^\(mysql.default_host =\).*$/\1 $mysql_host/g" /usr/local/php/lib/php.ini 
    sed -i "s/^\(mysql.default_port =\).*$/\1 $mysql_port/g" /usr/local/php/lib/php.ini 
    sed -i "s/^\(mysql.default_user =\).*$/\1 $mysql_user/g" /usr/local/php/lib/php.ini 
    
    sed -i "s/^\(mysqli.default_host =\).*$/\1 $mysql_host/g" /usr/local/php/lib/php.ini 
    sed -i "s/^\(mysqli.default_port =\).*$/\1 $mysql_port/g" /usr/local/php/lib/php.ini 
    sed -i "s/^\(mysqli.default_user =\).*$/\1 $mysql_user/g" /usr/local/php/lib/php.ini 
    /usr/local/php/sbin/php-fpm 
    echo "/usr/local/php/sbin/php-fpm" >>/etc/rc.local
}

function main(){
    prepare_env
    nginx_install 
}

main
