#!/bin/sh

while true ; do

for i in `cat /home/netstat/data/all-network`; do

  if [ ! -f /home/netstat/host/$i.txt ]; then

    echo $i not in base
    /usr/local/sbin/arping -c 2 ${i}

    if [ $? -eq 0 ]
	then
	echo $i - is up, scan em now! :D
	#ipfw add 137 pass all from me to $i
	#xprobe2 -m 1 $i > /home/netstat/host/$i.txt
	#nmap rulcom.vzletka.net -v -p 21 > /home/netstat/host/$i.txt
	su - napster -c "nmap $i -q -p 21" > /home/netstat/host/$i.txt
	#ipfw delete 137
    fi
  fi
  
done

done
