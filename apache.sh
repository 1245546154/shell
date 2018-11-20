#!/bin/bash
#File Name: apache.sh
#Author: Songzeshan 
#Desc: 
#Path: /shell/0726/apache.sh
#Created Time: Thu 26 Jul 2018 06:22:42 PM CST
[ -f /etc/init.d/functions ] && . /etc/init.d/functions 
RED_COLOR='\E[1;31m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

package=/usr/local/src/package
ext_package=/usr/local/src/ext_package

function menu(){
    echo -e "   ${RED_COLOR}欢迎使用LAMP网站管理系统${RES}"
    echo -e "-----------------------------"
    echo -e "${BLUE_COLOR}1.${RES}安装LAMP"
    echo -e "${BLUE_COLOR}2.${RES}添加网站"
    echo -e "${BLUE_COLOR}3.${RES}修改网站目录(未写)"
    echo -e "${BLUE_COLOR}4.${RES}删除网站(未写)"
    echo -e "${BLUE_COLOR}5.${RES}未完待续..."
    echo -e "-----------------------------"
}

function prepare_env(){
    echo "环境准备中..."
    sleep 1
    mkdir -p $package 
    mkdir -p $ext_package
    #rpm -q pcre-devel &>/dev/null 
    #[ $? -ne 0 ] && 
    yum install -y make gd-devel libcurl-devel cmake gcc ncurses-devel 
    yum install -y openssl-devel pcre-devel expat-devel libtool-ltdl-devel libxml2-devel 
    rpm -q httpd &>/dev/null 
    [ $? -eq 0 ] && rpm -e httpd --nodeps &>/dev/null 
    install_apr_and_util
    [ $? -eq 0 ] && action "环境准备完成!" /bin/true || { action "其他错误!" /bin/false; exit 4; }
}

function install_apr_and_util(){
    apr
    apr_util
    echo "/usr/local/apr/lib/" > /etc/ld.so.conf.d/lamp.conf
    /sbin/ldconfig 
}

function apr(){ 
    echo "准备安装apr..."
    sleep 1
    if [ -f $package/apr-1.5.2.tar.gz ];then
        /bin/tar xf $package/apr-1.5.2.tar.gz -C $ext_package
    else
        wget http://archive.apache.org/dist/apr/apr-1.5.2.tar.gz -qP $package
        wait
        /bin/tar xf $package/apr-1.5.2.tar.gz -C $ext_package 
    fi 

    cd $ext_package/apr-1.5.2/ 
    ./configure --prefix=/usr/local/apr 
    make && make install 
    echo 
    action "apr 安装成功!" /bin/true 
}

function apr_util(){ 
    echo "准备安装apr-util..."
    sleep 1
    if [ -f $package/apr-util-1.5.4.tar.gz ];then
        /bin/tar xf $package/apr-util-1.5.4.tar.gz -C $ext_package
    else
        wget http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz -qP $package
        wait
        /bin/tar xf $package/apr-util-1.5.4.tar.gz -C $ext_package 
    fi 

    cd $ext_package/apr-util-1.5.4/ 
    ./configure --with-apr=/usr/local/apr/bin/apr-1-config 
    make && make install 
    echo 
    action "apr-util 安装成功!" /bin/true 
}

function install_apache(){
    echo "准备安装Apache..."
    sleep 1
    if [ -f $package/httpd-2.4.34.tar.gz ];then
        tar xf $package/httpd-2.4.34.tar.gz -C $ext_package
    else
        wget http://mirror.bit.edu.cn/apache/httpd/httpd-2.4.34.tar.gz -qP $package
        wait
        /bin/tar xf $package/httpd-2.4.34.tar.gz -C $ext_package
    fi 
    cd $ext_package/httpd-2.4.34/ 
    ./configure \
        --enable-modules=all \
        --enable-mods-shared=all \
        --enable-so \
        --enable-rewrite \
        --with-mpm=prefork \
        --with-apr=/usr/local/apr/bin/apr-1-config \
        --with-apr-util=/usr/local/apr/bin/apu-1-config &>/dev/null 
    echo "Apache 安装中..."
    make && make install &>/dev/null 
    sleep 1
    clear
    action "Apache安装成功!" /bin/true 
    sed -i "s/^#\(ServerName .*\)/\1/g" /usr/local/apache2/conf/httpd.conf 
    /usr/local/apache2/bin/apachectl
    [ $? -eq 0 ] && action "服务启动成功!" /bin/true 
}

function verify(){
    echo "验证服务..."
    echo "test" > /usr/local/apache2/htdocs/index.html
    curl -I http://localhost &>/dev/null 
    [ $? -eq 0 ] && action "服务正常!" /bin/true 
}

function add_website(){
    ip_addr=""
    domain=""
    root_dir=""
#    while [ -z "$ip_addr" -o -z "$domain" -o -z "$root_dir" ]
#    do 
#        read -p "1.请输入IP地址：" ip_addr
#        read -p "2.请输入域名：" domain
#        read -p "3.请输入数据目录：" root_dir
#    done
    while [ -z "$ip_addr" ]
    do 
        read -p "1.请输入IP地址：" ip_addr
    done
    while [ -z "$domain" ]
    do 
        read -p "2.请输入域名：" domain
    done 
    while [ -z "$root_dir" ]
    do 
        read -p "3.请输入数据目录：" root_dir
    done 
#    read -p "请输入IP地址：" ip_addr
#    read -p "请输入域名：" domain
#    read -p "请输入数据目录：" root_dir
#    if [ -z "$ip_addr" -o -z "$domain" -o -z "$root_dir" ];then
#        add_website
#    else
#        add_vhost
#    fi 
    if [ -d $root_dir ];then 
        add_vhost
    else
        mkdir -p $root_dir
        add_vhost
    fi
    /usr/local/apache2/bin/apachectl restart 
    [ $? -eq 0 ] && action "网站添加成功!" /bin/true || {
    action "网站添加失败!" /bin/false 
    exit 3
    }
}

function add_vhost(){
cat >> /usr/local/apache2/conf/extra/httpd-vhosts.conf <<-EOF
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot $root_dir
    ServerName $domain
    ErrorLog logs/$domain-error_log
    CustomLog logs/$domain-access_log common
</VirtualHost>
EOF
cat >> /usr/local/apache2/conf/httpd.conf <<-EOF 
DocumentRoot "$root_dir"
<Directory "$root_dir">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory> 
EOF

echo "this is test page">$root_dir/index.html
echo "$ip_addr $domain" >> /etc/hosts 
}

function set_service(){
echo "将Apache添加到系统服务..."
sleep 1
cat > /etc/init.d/apache <<-EOF
#!/bin/bash 
# chkconfig: 2345 77 30
# description: Apache Web Server 
[ -f /etc/init.d/functions ] && . /etc/init.d/functions 
option=\$1
counts=\$#
pid_num=\`cat /usr/local/apache2/logs/httpd.pid 2>/dev/null \`
function usage(){
    echo "Usage:/etc/init.d/\$0 [start|stop|reload|restart|status]"
}

function start(){
    if [ ! -f /usr/local/apache2/logs/httpd.pid ];then 
        /usr/local/apache2/bin/apachectl start 
        action "Apache 启动成功!" /bin/true 
    else
        action "Apache 正在运行!" /bin/false
        exit 1
    fi
}

function stop(){
    if [ -f /usr/local/apache2/logs/httpd.pid ];then 
        /usr/local/apache2/bin/apachectl stop 
        action "Apache 停止成功!" /bin/true 
    else 
        action "Apache 没有运行!" /bin/false
        exit 2
    fi
}

function restart(){
    stop 
    sleep 1
    start
}

function reload(){
    /usr/local/apache2/bin/apachectl graceful
    [ \$? -eq 0 ] && action "Apache 重载配置成功!" /bin/true || {
    action "Apache 重载配置失败!" /bin/false 
    }
}

function status(){
    if [ -f /usr/local/apache2/logs/httpd.pid ];then
        echo "Apache is running[pid:\$pid_num]..."
    else
        echo "Apache is stopped..."
    fi 
}

function main(){
    if [ \$counts -eq 1 ];then 
        case \$option in 
            start)
                start 
                ;;
            stop)
                stop 
                ;;
            restart)
                restart
                ;;
            reload)
                reload
                ;;
            status)
                status
                ;;
            *)
                usage
                ;;
        esac
    else
        usage
    fi
}

main
EOF

chmod +x /etc/init.d/apache 
chkconfig --add apache 
action "添加成功!" /bin/true 

}

#function main(){
#    prepare_env
#    install_apache
#    verify
#    add_website
#    set_service
#}

function main(){
#while true 
#do 
    menu 
    read -p "请选择功能:" option 
    case $option in 
        1)
            prepare_env 
            install_apache
            verify
            set_service 
            ;;
        2)
            add_website
            ;;
        3)
            ;;
        4)
            ;;
        5)
            ;;
        *)
            ;;
    esac
#done 
}
main
