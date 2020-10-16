# ssd secure #

# cat /etc/sysconfig/iptables|grep 22
-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name DEFAULT --rsource
-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --update --seconds 300 --hitcount 4 --name DEFAULT --rsource -j DROP
-A INPUT -i eth0 -p tcp -m tcp --dport 22 -j ACCEPT
