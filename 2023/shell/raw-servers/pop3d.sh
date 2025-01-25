#!/bin/sh

MESG="Date: `/bin/date -R`
From: root@localhost
Subject: By the way...

`/usr/games/fortune | /usr/bin/sed 's/^\./../'`

"
LEN=`echo $MESG | /usr/bin/wc -c`

echo "+OK Pop3 4 U .com"
while : ;
do
	read X
	X=`echo $X | /usr/bin/tr 'A-Z' 'a-z'`

	case "$X" in
	quit*)	echo "+OK"
			exit;;
	stat*)	echo "+OK  1 $LEN";;
	list*)	echo "+OK"
			echo "1 $LEN"
			echo ".";;
	retr*|top*)	echo "+OK"
			echo "$MESG"
			echo "."
			;;
	last*|uidl*)		echo "-ERR ";;
	*)		echo "+OK";;
	esac
done
