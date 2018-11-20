#!/bin/bash
#File Name: zuoye5.sh
#Author: Songzeshan 
#Desc: NFS Instann and Configure
#Path: /shell/zuoye5.sh
#Created Time: Mon 23 Jul 2018 08:45:02 PM CST
[ -f /etc/init.d/functions ] && . /etc/init.d/functions 

function install_nfs(){
    echo "准备安装 NFS..."
    yum install -y nfs-utils &>/dev/null 
    [ $? -eq 0  ] && action "NFS 安装完成" /bin/true 
    choose_conf
}

function choose_conf(){
    read -p "是否配置共享目录(y/n):" choose
    case $choose in 
        y|Y|YES|Yes)
            config_nfs
            ;;
        n|N|NO|No)
            exit 1
            ;;
        *)
            action "无效参数!" /bin/false 
            exit 2
            ;;
    esac
}

function config_nfs(){
    read -p "请输入要共享的目录:" share_dir
    read -p "请输入允许挂载的主机网段或IP(ex:10.1.1.1 or 10.1.1.0/24):" ipaddr 
    echo "$share_dir ${ipaddr}(rw,sync,all_squash)" >>/etc/exports 
    action "配置文件写入完成!" /bin/true 
    /etc/init.d/rpcbind restart &>/dev/null 
    /etc/init.d/nfs restart &>/dev/null 
    [ $? -eq 0 ] && action "服务重启完成!" /bin/true || { action "其他错误!" /bin/false ; exit 3 }
}

function verify(){
    showmount -e localhost &>/dev/null 
    [ $? -eq 0 ] && action "服务搭建成功!" /bin/true || { action "其他错误!" /bin/false ; exit 4 }
}

function main(){
    echo "检查NFS是否已安装..."
    rpm -qa nfs-utils &> /dev/null 
    if [ $? -eq 0  ];then 
        action "NFS 已安装" /bin/true 
        choose_conf 
        verify
    else
        install_nfs
        verify
    fi 
}

main
