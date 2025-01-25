#!/bin/bash

# antizaebator, http://brj.pp.ru/

ADMIN="root@mega.admin.ru"
ALERT=80
#

function main_prog ()
{

while read output;
do
echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep -ge $ALERT ] ; then
     echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date)" | mail -s "Alert: Almost out of disk space $usep%" $ADMIN
  fi
done
}

# and here we begin

df -H | grep da0 | awk '{print $5 " " $6}' | main_prog
