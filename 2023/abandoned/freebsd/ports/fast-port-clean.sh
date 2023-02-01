#!/bin/sh

#
# fast "make clean" for all port's tree. http://brj.pp.ru/
#

# remove "work" directory

for i in `find /usr/ports -name "work" -print`
do

  echo "deleting $i"
  rm -rf $i

done

# remove readme files

for i in `find /usr/ports -name "README.html" -print`
do

  echo "deleting $i"
  rm -rf $i

done


