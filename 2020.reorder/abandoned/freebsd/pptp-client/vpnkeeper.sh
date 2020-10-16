#!/bin/sh

if [ -z $1 ]; then
    echo "This script keep VPN channel, don't run it!"
    exit 1
fi

 while true ; do
    /usr/local/sbin/pptp 10.10.10.1 VPN
 done
