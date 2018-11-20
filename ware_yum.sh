#!/bin/bash
[ -f /etc/rc.d/init.d/functions ] && . /etc/rc.d/init.d/functions
#下面是脚本中用到的变量
yum_dir="/etc/yum.repos.d"
local_yum_file="my_local_yum.repo"
local_dir="/media/local_yum"
iso_dir="/dev/cdrom"
share_yum_file="my_share_yum.repo"
share_dir="/var/www/html/my_share_yum"
back_dir="/etc/backup_yum"
ali_yum_file="ali.repo"
dir_name="${back_dir}/`date +%Y_%m_%d_%H_%M`_backup"
fstab_cdrom=`grep -w "cdrom" /etc/fstab`
#fstab_cdrom=`cat /etc/fstab | grep -w "cdrom" | sed -nr 's/(^.*cdrom.*0$)//gp'`
#httpd_proc=`ps -ef|grep "httpd"|grep -v "grep"|wc -l`
#address="http://`ifconfig|sed -nr 's#^.*dr:(.*)  B.*$#\1#gp'`/my_share_yum"
#address="http://192.168.235.131/my_share_yum"

#输出菜单的函数
function menu(){
	echo "操作菜单:"
	echo -e "1.配置本地yum源\n2.配置共享yum源\n3.配置阿里云yum源\n"
	read -p "请选择你要进行的操作:" option
	
}

#制作本地yum仓库的函数
function create_local_yum(){
	#echo -e "${RED_COLOR}请确保您的设备已正常放入光盘!${RES}"
	
	if [ -d "${local_dir}" ];then
		echo "需挂载iso镜像文件的目录已存在,即将挂载!"
		mount_cd
	else
		echo "正在创建iso镜像文件挂载目录..."
		mkdir ${local_dir}
		echo "挂载中..."
		mount_cd
		action "挂载完成!" /bin/true
	fi
	echo "进行仓库配置..."
	
	write_local_yum_file
	find ${yum_dir}/ -type f ! -name "${local_yum_file}" | xargs rm -f

	echo "本地yum仓库配置完成!"
	cache_clean
}

function mount_cd(){
	mount ${iso_dir} ${local_dir} &> /dev/null
	if [ $? -ne 0 ];then
		action "挂载错误,请检查!" /bin/false
		exit 1
       else
           if [ -z "$fstab_cdrom" ];then
		    	echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab 
           else
            	sed -i '/^.*cdrom.*0$/d' /etc/fstab
		    	echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab
           fi
		action "挂载完成!" /bin/true
	fi
}

#服务端制作共享yum仓库的函数
function create_share_yum(){
	/etc/init.d/iptables stop &> /dev/null
	umount ${iso_dir} &>/dev/null

	if [ -f "/var/run/httpd/httpd.pid" ];then
		action "Apache 正在运行!" /bin/true
	else
		action "Apache 服务未启动!" /bin/false
		if [ -f /etc/init.d/httpd ];then
		    chkconfig --level 235 httpd on &>/dev/null	
		    /etc/init.d/httpd start &>/dev/null
		    [ $? -eq 0 ] && action "Apache 服务已启动!" /bin/true || {
			echo "Apache 启动失败,请手动启动!"
			exit 8
		    }
		else
		    echo "Apache 服务不存在,请先安装!"
		    exit 3
		fi
	fi
	if [ -d "${share_dir}" ];then
		echo "需挂载iso镜像文件的目录已存在,即将挂载!"	
		mount ${iso_dir} ${share_dir} &> /dev/null	
		if [ $? -ne 0 ];then
			action "挂载错误,请检查!" /bin/false
			exit 4
        else
			#echo "${iso_dir} ${share_dir} ext4 defaults 0 0" >> /etc/fstab
            if [ -z "$fstab_cdrom" ];then
    	        echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab 
            else
                sed -i 's/\(^.*cdrom.*0$\)//g' /etc/fstab
		        echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab
            fi
			action "挂载完成!" /bin/true
		fi
		
	else	
		echo "正在创建iso镜像文件挂载目录..."
		mkdir $share_dir
		echo "挂载中..."
		mount ${iso_dir} ${share_dir} &> /dev/null
		#echo "${iso_dir} ${share_dir} ext4 defaults 0 0" >> /etc/fstab
        if [ -z "$fstab_cdrom" ];then
    	    echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab 
        else
            sed -i 's/\(^.*cdrom.*0$\)//g' /etc/fstab
		    echo "${iso_dir} ${local_dir} ext4 defaults 0 0" >> /etc/fstab
        fi
		action "挂载完成!" /bin/true
	fi
	#write_share_yum_file
	#creat_share_yum_client
	creat_share_yum_server
	#find ${yum_dir}/ -type f ! -name "${share_yum_file}" | xargs rm -f
	#/etc/init.d/httpd restart &>/dev/null

	#echo "共享yum仓库配置完成!"
	
	cache_clean
}

function creat_share_yum_server(){
	address="http://`ifconfig|sed -nr 's#^.*dr:(.*)  B.*$#\1#gp'`/my_share_yum"
	write_share_yum_file
	find ${yum_dir}/ -type f ! -name "${share_yum_file}" | xargs rm -f
	/etc/init.d/iptables stop &>/dev/null
	echo "共享yum仓库配置完成!"
	
	cache_clean
}

#共享yum仓库客户端的配置
function creat_share_yum_client(){
	read -p "请输入服务端源地址(默认为http://192.168.235.131/my_share_yum):" address
	if [ -z "${address}" ];then
		address="http://192.168.235.131/my_share_yum"
	fi
	write_share_yum_file
	find ${yum_dir}/ -type f ! -name "${share_yum_file}" | xargs rm -f
	/etc/init.d/iptables stop &>/dev/null
	echo "共享yum仓库配置完成!"
	
	cache_clean
}

function create_ali_yum(){
	if [ -f $yum_dir/$ali_yum_file ];then
		echo "文件已存在,请检查..." 
		exit 7
	else
		echo "写入阿里云源..."
		sleep 1
		write_ali_yum
		cache_clean
	fi
}

#yum源配置好后清理缓存
function cache_clean(){	
	echo "清空缓存中..."
	yum clean all
	[ $? -eq 0 ] && action "清理完成!" /bin/true;{
		echo "刷新yum源仓库..."
		yum repolist
		exit 0
	} || action "清理失败,请检查!" /bin/false;exit 2
	
}

#写入本地yum仓库的配置文件
function write_local_yum_file(){
cat > ${yum_dir}/${local_yum_file} <<EOF
[my_local_yum]
name=my_local_yum
baseurl=file://${local_dir}
enabled=1
gpgcheck=0
EOF
}

#写入共享yum仓库的配置文件
function write_share_yum_file(){
cat > ${yum_dir}/${share_yum_file} <<EOF
[my_share_yum]
name=my_share_yum
baseurl=$address
enabled=1
gpgcheck=0
EOF
}

#写入阿里云源
function write_ali_yum(){
cat > ${yum_dir}/${ali_yum_file} <<EOF
name=ali_yum
baseurl=https://mirrors.aliyun.com/centos/6/os/x86_64/
enabled=1
gpgcheck=0
EOF
}

#备份${yum_dir}/下的源文件，备份文件夹格式为"年_月_日_时_分_backup"即"dir_name"变量
function backup_yum(){
	if [ -d "${back_dir}" ];then
		echo "备份中..."
		mkdir $dir_name
		cp ${yum_dir}/* ${dir_name}
		echo -e "备份完成!\n备份所在路径为:$dir_name"
	else	
		echo "备份中..."
		mkdir -p $dir_name
		cp ${yum_dir}/* ${dir_name}
		echo -e "备份完成!\n备份所在路径为:$dir_name"
	fi
	echo "写入定时删除7天前的备份文件"
	
}

#主函数
function main(){
	menu
	case $option in
		1)
			backup_yum
			create_local_yum	
		;;
		2)
			echo "当前机器是服务端or客户端:"
			echo -e "1.服务端\n2.客户端\n"
			read -p "请选择:" option2
			case ${option2} in 
			1)
				backup_yum
				create_share_yum
			;;
			2)
				backup_yum
				creat_share_yum_client
			;;
			*)
				echo "无效参数!"
				exit 5
			;;
			esac
		;;
		3)
			create_ali_yum
		;;
		*)
			echo "无效参数!"
			exit 6
		;;
	esac
}
main
