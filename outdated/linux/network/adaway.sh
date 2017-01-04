#!/bin/sh

rm *.ad

wget https://adaway.org/hosts.txt -O 1.ad
wget http://winhelp2002.mvps.org/hosts.txt -O 2.ad
wget http://hosts-file.net/ad_servers.asp -O 3.ad
wget "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" -O 4.ad

cat *.ad | sed 's/\r//' | grep -v "#" | sort | uniq | sed 's/^\(.*\).$/\1/' > final.host

rm *.ad


