#!/bin/sh
DATE=`date +%y%m%d`
TMP="/tmp/agents.$DATE.tmp"
FILE="/dump/misc/agents.txt"
cat /var/www/logs/agent_log > $TMP
sort -u $TMP -o $TMP
cat $TMP >> $FILE
sort -u $FILE -o $FILE
rm $TMP
