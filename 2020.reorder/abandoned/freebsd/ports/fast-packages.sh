#!/bin/sh

#
# fast package creator for all port's tree in system. http://brj.pp.ru/
#

cd /usr/ports/packages

for i in `ls -1 /var/db/pkg`
do

  pkg_create -jb $i

done

