#!/bin/sh

rm /etc/monit/conf-enabled/localhome

cat /etc/dnsmasq.d/98-brjdhcpd.conf | grep dhcp-host | sed 's/dhcp-host=//' | \
awk -F ","  '{print "check host home-"$1" with address ",$3" if failed ping then alert"}' > /etc/monit/conf-enabled/localhome

systemctl stop monit
systemctl start monit
systemctl status monit
