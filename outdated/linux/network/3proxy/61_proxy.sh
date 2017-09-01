yum update
yum install gcc
yum install libc.so.6
yum install nano
rpm -i http://dl.fedoraproject.org/pub/epel/6/i386/3proxy-0.6.1-10.el6.i686.rpm
#
cat /dev/null > /etc/3proxy.cfg
#
echo "daemon" >> /etc/3proxy.cfg
echo "internal IP_Адрес_Вашего_Сервера" >> /etc/3proxy.cfg
echo "external IP_Адрес_Вашего_Сервера" >> /etc/3proxy.cfg
echo "nserver 8.8.8.8" >> /etc/3proxy.cfg
echo "nscache 65536" >> /etc/3proxy.cfg
echo "timeouts 1 5 30 60 180 1800 15 60" >> /etc/3proxy.cfg
echo "allow *" >> /etc/3proxy.cfg
echo "proxy -p3128 -a" >> /etc/3proxy.cfg
echo "socks -p3129" >> /etc/3proxy.cfg
echo "admin -p8081" >> /etc/3proxy.cfg
echo "#Панель администратора будет по Адресу_Вашего_Сервера:8081" >> /etc/3proxy.cfg
#
nano /etc/3proxy.cfg
#
service 3proxy restart
#
chkconfig 3proxy on
