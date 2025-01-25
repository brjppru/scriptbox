#!/bin/sh
# site monotoring script, 
# by entity [at] cryptobeacon.net
# license: BSD
# no warranty
# you must keep above header on the script

# add page to monitor here.
PAGE="<site to monitor here>"

# enter emailadress here
EMAIL="<your emailadress>"

HASH=`lynx -dump $PAGE | md5`
FILE="$HOME/.sitemonitor.hash"
OLD=`cat $FILE`

if [ $OLD == $HASH ]; then
exit 0
else
lynx -dump $PAGE | mail -s "sitenews for $PAGE" $EMAIL
echo $HASH > $FILE
fi
