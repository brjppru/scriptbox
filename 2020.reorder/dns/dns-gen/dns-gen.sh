#!/bin/sh

echo "/ip dns static" > dns.gen

cat 37.local | while read lin 
do

 echo "add address=`echo $lin|awk '{print $1}'` name=`echo $lin|awk '{print $2}'`" >> dns.gen

done

