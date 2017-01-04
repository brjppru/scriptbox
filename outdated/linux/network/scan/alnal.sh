#!/bin/sh

while true ; do
for i in `cat addr`; do

  if [ ! -f /home/scan/log/$i.txt ]; then 

    echo $i not in base
    /sbin/ping -n -c2 -q ${i} > /dev/null 2>&1

    if [ $? -eq 0 ]
	then
	echo $i - is up, nmap em now! :D
	nmap -P0 -O -sS -e sk0 -S 10.10.37.37 $i >> /home/scan/log/$i.txt
    fi
  fi
  
done
done
