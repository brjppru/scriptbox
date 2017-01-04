#!/bin/sh

for i in `find /home/mail/sam -size +3M`
do
  echo $i
  mv "$i" /home/mail/sam/.archive2016/cur
done
