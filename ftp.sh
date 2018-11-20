#!/bin/bash
#Ftp搭建脚本
#
[ -f /etc/rc.d/init.d/functions ] && . /etc/rc.d/init.d/functions 

function install_ftp(){
    rpm -q vsftpd &>/dev/null 
    if [ $? -eq 0 ];then
        echo "ftp服务已安装,准备配置..."
        sleep 1
        config_ftp
    else
        yum install -y vsftpd 
        wait
        action "FTP 安装完成!" /bin/true 
        echo "准备配置服务..."
        sleep 1
        config_ftp
    fi
}

function config_ftp(){
    echo "备份原配置文件..."
    sleep 1
    mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak 
    [ $? -eq 0 ] && action "备份完成!" /bin/true || {
    action "备份出错!" /bin/false 
    exit 1
    }
    echo "写入配置..."
    sleep 1
    cat > /etc/vsftpd/vsftpd.conf <<-EOF
    anonymous_enable=YES         #设置为允许匿名
    write_enable=YES             #设定本地用户可以访问，主要是虚拟宿主用户
    listen=YES                   #监听
    dirmessage_enable=YES        #设定开启目录标语功能
    xferlog_std_format=YES       #设定日志使用标准的记录格式
    pam_service_name=vsftpd      #设定pam服务下的vsftpd验证配置文件名
    anon_upload_enable=YES       #匿名用户上传
    anon_mkdir_write_enable=YES  #匿名用户建立目录
    anon_other_write_enable=YES  #允许匿名使用删除或者重命名
    anon_umask=022               #设定上传文件的权限掩码
    anon_max_rate=500000         #限制匿名最大传输速率
EOF
    chmod o+w /var/ftp/pub 
    action "写入配置成功!" /bin/true 
    echo "重启服务..."
    /etc/init.d/vsftpd restart &>/dev/null 
    action "重启成功!" /bin/true 
}

function main(){
    install_ftp
}

main 

