#!/bin/sh

cat /etc/arp.hold | awk '{print $1}' | sort > /home/netstat/data/all-network




