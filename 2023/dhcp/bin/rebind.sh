#!/bin/sh

systemctl stop dnsmasq
systemctl start dnsmasq
systemctl status dnsmasq
lnav
