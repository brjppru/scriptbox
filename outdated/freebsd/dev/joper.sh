#!/bin/sh

cd /dev

i=0

while [ $i -lt 80 ]; do sh MAKEDEV vn$i; i=$(($i+1)); echo $i;done




