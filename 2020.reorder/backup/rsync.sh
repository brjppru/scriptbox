#!/bin/bash

LANG=en_US.UTF-8

date=`date "+%Y-%m-%dT%H_%M_%S"`

HOME=/mnt/warez/it
BACKDIR=/var/backup/storage
LOGDIR=/var/backup/log

mv ${LOGDIR}/news.txt ${LOGDIR}/vchera.txt

ls -1R /mnt/warez/it > ${LOGDIR}/news.txt

rsync -azP \
  --delete \
  $HOME /var/backup/today

cd ${LOGDIR}/

diff -u ${LOGDIR}/vchera.txt ${LOGDIR}/news.txt > ${LOGDIR}/diff.txt

if [ `ls -la ${LOGDIR}/diff.txt | awk '{print $5}'` -ne 0 ]; then

  cd /var/backup/
  tar -zcf /var/backup/data/today-$date.tar.gz /var/backup/today
  tar -zcf /var/backup/data/wiki-$date.tar.gz /var/www/it

  sendEmail -f 123@mail.ru -u "disk changelog $date" -s server.ru -o message-file=${LOGDIR}/diff.txt -o message-content-type=text -o message-charset=UTF-8 -t 123@mail.ru
