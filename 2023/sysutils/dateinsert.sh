#!/bin/sh

exit 0

find . -print | while read i
do
  echo $i
  sed -i '1 i--- ✄ -----------------------' $i
  sed -i '1 i'$i $i

done

