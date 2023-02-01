#!/bin/sh
HOSTNAME=`hostname`
DATE=`date +'%a, %d %b %Y %T %Z'`
SENDHOST=""
SENDER=""
RCPT=""
MAILFILE=./mailfile
MSGID=$$-`date +'%Y%m%d%H%M'`

echo "220 $HOSTNAME SMTP smtpd.sh ready at $DATE"
while :;
do
	read X
	X=`echo $X | /usr/bin/tr 'A-Z' 'a-z'`
	CMD=`echo $X | sed 's/ .*//'`
	PAR=`echo $X | sed "s/^$CMD //"`
	if [ "$X" = "$CMD" ] ; then
		PAR=""
	fi

	case "$CMD" in
	quit)	echo "221 $HOSTNAME closing connection"
			exit;;
	helo)	if [ -z "$PAR" ] ; then
				echo "501 helo requires domain address"
			else
				SENDHOST=`echo $PAR | sed 's/\..*//'`
				echo "250 $HOSTNAME Hello $SENDHOST, pleased to meet you"
			fi;;
	expn)	echo "502 Error: command not implemented";;
	vrfy)	echo "252 <$PAR>";;
	mail)	case "$PAR" in
			from:\ *)
				SENDER=`echo "$PAR" | sed 's/from: //'`
				SENDER=`echo "$SENDER" | sed 's/ .*//'`
				echo "250 $SENDER... Sender ok";;
			*)
				echo "501 Syntax: MAIL FROM: <address>";;
			esac
			;;
	rcpt)	case "$PAR" in
			to:\ *)
				RCPT=`echo "$PAR" | sed 's/to: //'`
				RCPT=`echo "$RCPT" | sed 's/ .*//'`
				echo "250 $RCPT... Recipient ok";;
			*)
				echo "501 Syntax: RCPT TO: <address>";;
			esac
			;;
	data)	echo "354 Enter mail, end with \".\" on a line by itself"
			FIN="n"
			DATA=""
			while [ "$FIN" != "y" ] ; do
				read DATALINE
				if [ "$DATALINE" = "." ] ; then
					FIN="y"
				fi
				DATALINE=`echo $DATALINE | sed 's/^\.//'`
				DATALINE=`echo $DATALINE | sed 's/^From />From /'`
				DATA="$DATA
$DATALINE"
			done
			LEN=`echo $DATA | wc -c | sed 's/^ *//'`
			/bin/cat >> $MAILFILE <<__eof__
From $SENDER $DATE
From: $SENDER
Date: $DATE
Message-Id: <$MSGID>
Received: from $SENDHOST by $HOSTNAME; $DATE
Content-Length: $LEN
$DATA

__eof__
			echo "250 $MSGID Message accepted for delivery"
			;;
	*)		echo "500 Command unrecognised: \"$X\"";;
	esac
done
