#!/bin/sh

echo /ip dhcp-server lease

cat ip.txt |

while read mac ip comm
do

 echo add address=$ip always-broadcast=yes comment=\"$comm\" mac-address=$mac

done

