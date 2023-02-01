#!/bin/sh

for i in `ls -1 *.jpg`
do

 echo $i
 cat $i | jpegtopnm | pnmtops | lp -P 1 -d voip -o PageSize=A5 -o fit-to-page

done
