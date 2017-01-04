#!/bin/sh

dhcpd_pid="/var/run/dhcpd.pid";
dhcp_primary="10.11.9.9";
dhcp_secondary="10.11.9.7";
dhcp_sec_mac="00:50:8b:01:14:3d";
/usr/local/bin/dhcping -q -c $dhcp_secondary -s $dhcp_primary -h $dhcp_sec_mac
RESULT=$?
if [ ${RESULT} -eq "1" ]; then
    if [ ! -f $dhcpd_pid ]; then
	echo "Light Server : Start dhcpd !";
	/usr/local/sbin/dhcpd -cf /etc/dhcpd.conf
    fi
fi

if [ ${RESULT} -eq "0" ]; then
    if [ -f $dhcpd_pid ]; then
	echo "Light Server : Stop dhcpd !";
	kill `cat $dhcpd_pid`;
        if [ -f $dhcpd_pid ]; then
	    rm -f $dhcpd_pid;
	fi
    fi
fi
