#!/bin/bash
# File Name: xtrabackup.sh
# Author: Songzeshan 
# Desc: Backup the MySQL 每周1、3、5全备，2、4、6、7增备,binlog每天备份
# Path: /root/xtrabackup.sh
# Created Time: Sun 05 Aug 2018 02:59:50 PM CST
# Crontab书写方法：
# 10 1 * * 1,3,5 /scripts/xtrabackup.sh full  
# 10 1 * * 2,4,6 /scripts/xtrabackup.sh first_incre
# 10 1 * * 7 /scripts/xtrabackup.sh second_incre
# 10 1 * * * /scripts/xtrabackup.sh binlog 

mode=$1
full=/xtrabackup_full
first=/incremental/first
second=/incremental/second
log_bin=/binlog

xtra_full_dir=$full/`date "+%F"`_full
xtra_first_incr_dir=$first/`date "+%F"`_first
xtra_second_incr_dir=$second/`date "+%F"`_second

xtra_first_base_dir=$full/`date -d "-1 day" "+%F"`_full
xtra_second_base_dir=$first/`date -d "-1 day" "+%F"`_first

db_user="backup"
db_pass="123456"
datadir=/date/mysql25/data 
binlog_name=bin_log

function prepare_env(){
    #mkdir /{xtrabackup,incremental,binlog}
    #mkdir /incremental/{first,second}
    mkdir $xtra_full_dir
    mkdir $xtra_first_incre
    mkdir $xtra_second_incr
    mkdir $log_bin/`date "+%F"`
}

function xtra_full(){
    /usr/local/bin/innobackupex -u$db_user -p$db_pass --no-timestamp $xtra_full_dir 
    [ $? -eq 0 ] && echo "$xtra_full_dir  备份成功" || {
    echo "$xtra_full_dir  备份失败" 
    exit 4
    }
}

function xtra_first_incre(){
    /usr/local/bin/innobackupex -u$db_user -p$db_pass --incremental --no-timestamp $xtra_first_incr_dir --incremental-basedir=$xtra_first_base_dir
    [ $? -eq 0 ] && echo "$xtra_first_incr_dir  备份成功" || {
    echo "$xtra_first_incr_dir  备份失败" 
    exit 5
    }
}

function xtra_second_incre(){
	/usr/local/bin/innobackupex -u$db_user -p$db_pass --incremental --no-timestamp $xtra_second_incr_dir --incremental-basedir=$xtra_second_base_dir
	[ $? -eq 0 ] && echo "$xtra_second_incr_dir  备份成功" || {
    echo "$xtra_second_incr_dir  备份失败" 
    exit 6
    }
}

function binlog_bak(){
    cp -a $datadir/${binlog_name}.* $log_bin/`date "+%F"`
}

function clean_bak(){
    find $full -type d -mtime +7 | xargs rm -rf 
    #[ $? -eq 0 ] && echo "`date` 清理全备成功!" || {
    #echo "`date` 清理全备失败!"
    #}
    find $first -type d -mtime +7 | xargs rm -rf
    find $second -type d -mtime +7 | xargs rm -rf 
    find $log_bin -type d -mtime +7 | xargs rm -rf 
} 

function main(){
    case $mode in 
        full)
            xtra_full
            ;;
        first_incre)
            xtra_first_incre
            ;;
        second_incre)
            xtra_second_incre
            ;;
        binlog)
            binlog_bak
            ;;
    esac
    clean_bak
}
main 
