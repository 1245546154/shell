#!/bin/bash


mount /dev/sr0 /mnt/  #测试环境使用
echo "自动检测配置yum中。。"
ping -c 1  127.0.0.1 > /dev/null  #测试环境使用127.0.0.1
if [ $? -qe 0 ] ; then

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

yum clean all
yum makecache
yum -y install bind bind-chroot 

read -p "请输入要指定的IP：" a
read -p "请输入要指定域名：" b
c=`echo "$a" | awk -F"." '{print $4"."$3"."$2"."$1}'`
d=`echo "$a" | awk -F"." '{print $4}'`

sed -s '13s/listen-on port 53 { 127.0.0.1; };/listen-on port 53 { any; };/' /etc/named.conf
sed -s 'listen-on-v6 port 53 { ::1; };/listen-on-v6 port 53 { any; };/' /etc/named.conf
sed -s 'allow-query     { localhost; };/allow-query     { any; };/' /etc/named.conf


zone(){
zone "www.$b" IN {
        type master;
        file "www.$b.zone";
        allow-update { none; };
};

zone "$c.in-addr.arpa" IN {
        type master;
        file "$c.rev";
        allow-update { none; };
};
}

zone >> /etc/named.rfc1912.zones

+END+
cat > /var/named/$b.zone <<+END+
\$TTL 1D
@    IN  SOA    $b.       (
                                             0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
     NS   dns.$b.
dns  A    $a
www  A    $a
+END+


+END+
cat > /var/named/$c.rev <<+END+
\$TTL 1D
@    IN  SOA    dns.$b.       (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum     
     NS   dns.$b.com
$d   PTR    dns.'$a'.com.
$d   PTR    www.'$a'.com.
+END+

echo nameserver $a >> /etc/resolv.conf
service named start
