#!/bin/sh

cat abv |

while read mac ip comm
do

 echo add address=$ip always-broadcast=yes comment=\"$comm\" mac-address=$mac

done

