#!/bin/bash

exit

figlet fetch

fetchmail -v --nodetach --nosyslog -a -f /root/bin/mail/sba/.fetchmango

KUDA=/baza/sb-a.su
DIR=/tmp/sba.su/Maildir

CD $DIR

mkdir -p $KUDA
mkdir -p $DIR/process/landing/

mv $DIR/new/* $DIR/process/landing/

cd $DIR/process/landing/

figlet extract

shopt -s nullglob

for i in *
    do
    mkdir -p $DIR/process/extract/$i
    cp $i $DIR/process/extract/$i/
    mv $i $DIR/process/archive
    munpack -C $DIR/process/extract/$i -q $DIR/process/extract/$i/$i
done

mv $DIR/process/extract/* $DIR/process/store/

shopt -u nullglob

figlet move

for i in `find $DIR -name "*.mp3"`
    do
    mv $i $KUDA
done

chmod -R 777 $KUDA
rm -rf $DIR

figlet done

