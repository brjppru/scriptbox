#!/bin/sh

for j in "" 1 2 3 4 5 6 7 8 9 10 11 12; do
  for i in 0 1 2 3 4 5 6 7 8 9; do
    echo $j$i
    ngctl shutdown ng$j$i:
    ngctl shutdown mpd$1-pptp$j$i:
  done
done
