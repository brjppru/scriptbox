#!/bin/sh
# Shortish script to take webcam pics.
if (ps -aef | grep xawtv | grep -v grep > /dev/null 2>&1); then
  htmldump=/tmp/dynamicbit.php
  date=`date +%Y-%m-%d-%H-%M-%S`
  echo \<A HREF\=\"./images/webcam-$date.jpeg\"\> > $htmldump
  echo \<IMG SRC\=\"./images/webcam-$date.jpeg\" ALT\=\"Chunky Webcam $date\"\ BORDER\=\"0\"\> >> $htmldump
  echo \<\/A\> >> $htmldump
  echo \<P\>Date: $date\<\/P\> >> $htmldump
  echo \<P\>Uploaded using: \<A HREF\=\"./`basename $0`\"\>`basename $0`\<\/A\>\<\/P\> >> $htmldump
  xawtv-remote -d:0 snap jpeg 384x288 /tmp/webcam-$date.jpeg
  scp -q /tmp/webcam-$date.jpeg chunky@icculus.org:/home/chunky/web/webcam/images
  scp -q $htmldump $0 chunky@icculus.org:/home/chunky/web/webcam
  rm $htmldump /tmp/webcam-$date.jpeg
fi
