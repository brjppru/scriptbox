#!/bin/sh

exit 0

mailq | grep  MAILER-DAEMON | tail -n +2 | awk  '{  print $1 }' | tr -d '*!' | postsuper -d -
