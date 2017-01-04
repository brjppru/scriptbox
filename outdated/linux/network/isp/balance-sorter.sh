#!/bin/sh

# read first string
oldvalue=`head -n 1 dated.txt | awk '{print $1}'`

cat dated.txt | \
    while read LINE;
    do
    value=`echo $LINE|awk '{print $1}'`;

	if [ "$oldvalue" = "$value" ]
	then 
		echo $LINE;
	else 
		echo " ";
		echo $LINE;
	fi; 
    oldvalue=$value
    done