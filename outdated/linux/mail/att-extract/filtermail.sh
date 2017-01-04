#!/bin/sh

export LC_ALL=C

ATTACHDIR=/root/att
TMPFILE=`/bin/mktemp /tmp/filtermail.XXXXXX`
DATEDIR=`/bin/date +%Y/%m/%d`

export SENDER=`tee $TMPFILE | formail -zxFrom: -zxReply-To:|cut -f2- -d'<' | cut -f1 -d'>'`
SUBJECT=`/bin/cat $TMPFILE  | formail -zxSubject:`

/bin/mkdir -p $ATTACHDIR/$DATEDIR/$SENDER >/dev/null
munpack -t -C $ATTACHDIR/$DATEDIR/$SENDER $TMPFILE |

while read decodedfile;do
        /bin/echo $SENDER~$DATEDIR~$SUBJECT~$ATTACHDIR/$SENDER/$DATEDIR/$decodedfile >>$ATTACHDIR/mails
done

/bin/cat $TMPFILE
/bin/rm $TMPFILE
