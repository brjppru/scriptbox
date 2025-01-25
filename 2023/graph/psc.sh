#!/bin/sh
if (ps -aef | grep xawtv | grep -v grep > /dev/null 2>&1); then
  xawtv-remote -d:0 snap jpeg 384x288 /tmp/psc.jpeg 2>/dev/null
  echo `date` > /tmp/timetaken
  scp -q /tmp/psc.jpeg /tmp/timetaken \
         chunky@icculus.org:/home/chunky/web/playstationcam/ 2>/dev/null

  # 2>/dev/null so that if I'm not connected to the internet,
  #  it'll fail silently, and you'll just have to miss this
  #  particular screenshot.
  #
  #   Shame.

  rm -f /tmp/timetaken /tmp/psc.jpeg 2>/dev/null
fi

