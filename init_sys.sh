#!/bin/bash
#File Name: init_sys.sh
#Author: Songzeshan 
#Desc: System Initialization - Change Hostname , Config Yum , Shut off iptables and selinux
#Path: /shell/0728/init_sys.sh
#Created Time: Sat 28 Jul 2018 06:36:54 PM CST

[ -f /etc/rc.d/init.d/functions ] && . /etc/rc.d/init.d/functions 
iso_dir=/dev/cdrom
local_dir=/media/iso
#fstab_cdrom=`grep "$local_dir" /etc/fstab &>/dev/null`  #与写入fstab搭配使用
rc_local_cd=`grep "$local_dir" /etc/rc.local &>/dev/null`   #与写入rc.local搭配使用

#修改主机名
function re_hostname(){
    before=`hostname`
    ipaddr=`ifconfig eth0 | sed -n 's/^.*addr:\(.*\)  Bcast.*$/\1/gp'`
    end_ip=`echo $ipaddr|awk -F. '{print $4}'`
    after="server${end_ip}.itxxs.net"
    if [ "$before" = "$after" ];then
        echo "主机名正常,不必修改!"
        continue
    else
        echo "准备修改主机名..."
        sleep 1
        /bin/hostname $after
        sed -i "s/^\(HOSTNAME=\).*/\1$after/g" /etc/sysconfig/network
        #sed -i "s/^\(127.*omain6\).*$/\1 $after/g" /etc/hosts 
        #sed -i "s/^\(:.*omain6\).*$/\1 $after/g" /etc/hosts 
        echo "$ipaddr $after server$end_ip" >>/etc/hosts
        action "主机名修改完成" /bin/true 
    fi
}

#配置本地yum源
function create_local_yum(){
    [ -n "`mount | grep /media/iso`" ] && { 
    action "$local_dir 已挂载!" /bin/false 
    exit 3 
    }
    if [ -d "${local_dir}" ];then
        echo "需挂载iso镜像文件的目录已存在,即将挂载!"
        mount_cd
    else
        echo "正在创建iso镜像文件挂载目录..."
        mkdir ${local_dir}
        echo "挂载中..."
        mount_cd
    fi
    echo "进行仓库配置..."
    if [ -d /etc/yum.repos.d/backup/ ];then
        find /etc/yum.repos.d/ -type f | xargs -i mv {} /etc/yum.repos.d/backup/ 
    else
        mkdir /etc/yum.repos.d/backup/
        find /etc/yum.repos.d/ -type f | xargs -i mv {} /etc/yum.repos.d/backup/
    fi
    write_local_yum_file
    action "Yum仓库配置完成" /bin/true 
    yum repolist
}

#挂载iso
function mount_cd(){
    umount ${local_dir} &>/dev/null 
    mount ${iso_dir} ${local_dir} &> /dev/null
    if [ $? -ne 0 ];then
        action "挂载错误,请检查!" /bin/false
        exit 1
    else
        action "挂载完成!" /bin/true
        echo "设置开机自动挂载...."
        sleep 1
        ##########################写入fstab#############################
        #if [ -z "$fstab_cdrom" ];then
        #echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab 
        #else
        #    sed -i '/^.*cdrom.*0$/d' /etc/fstab
        #    echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab
        #fi

        #######################写入rc.local#############################
        if [ -z "$rc_local_cd" ];then 
            echo "mount ${iso_dir} ${local_dir}">>/etc/rc.local 
        else
            sed -i "/^mount.*cdrom.*$/d" /etc/rc.local
            echo "mount ${iso_dir} ${local_dir}">>/etc/rc.local 
        fi
        action "设置成功" /bin/true 
    fi 
}

#写入配置文件
function write_local_yum_file(){
cat >/etc/yum.repos.d/local_yum.repo <<EOF
[my_local_yum]
name=my_local_yum
baseurl=file://${local_dir}
gpgcheck=0
EOF
}

#关闭Iptables和selinux
function shut_off(){
    echo "关闭iptables和selinux..."
    sleep 1
    /etc/init.d/iptables stop &>/dev/null 
    chkconfig iptables off
    setenforce 0 &>/dev/null 
    sed -i 's/^\(SELINUX=\).*$/\1disabled/g' /etc/selinux/config
    action "iptables和selinux关闭完成" /bin/true 
}


function main(){
    re_hostname
    create_local_yum
    shut_off
}

main
