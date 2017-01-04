#!/bin/sh

prefix=/home/webcam/bin/
nowpic=/home/webcam/images/`date +%Y.%m.%d`
snapshot=$nowpic/`date +%H%M.jpg`

ln -f -s $snapshot /home/webcam/images/lasted.jpg

mkdir -v $nowpic

${prefix}vid | ${prefix}ppmlabel -colour SeaGreen -y 18 -text "`date`" | ${prefix}ppmtojpeg > $snapshot
