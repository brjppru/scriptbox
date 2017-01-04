#!/bin/sh

echo "This script count trafic for one IP adress, in this mounth"

case $1 in

generate)

	#cd /var/backups/ipacct/

	cd /tmp/123
	
        echo "ok. let's go parse stat";

	for i in `ls -1`

	    do
	    echo "now, script parsing $i file, for $2 IP adress.";
	    /root/cabinet/full-stat/traf-count.pl $i $2 >> /root/cabinet/full-stat/$2.traf.txt
	    done

	echo "All done! User stat u can found in file $2.traf.txt"
	;;

*)
	echo "Usage: `basename $0` generate IP" >&2
	exit 64
	;;
esac

exit 0
