yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp unzip openssl-devel
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagios,nagcmd apache
tar xvf nagios-4.4.2.tar.gz
tar xvf nagios-plugins-2.2.1.tar.gz
cd nagios-4.4.2/
./configure --with-command-group=nagcmd --prefix=/usr/local/nagios
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
#外部插件所在目录
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers/
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
service nagios start
service httpd start
#设置web界面密码
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
#编译插件
cd ../nagios-plugins-2.2.1/
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make && make install