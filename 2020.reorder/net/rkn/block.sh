#!/bin/sh

url="https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv"
list="russianbl"
downfile="/tmp/rr/templist.txt"
infile="/tmp/rr/craplist.txt"
outfile="/tmp/rr/crapregistry.rsc"
wget $url -O $downfile --no-check-certificate

grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $downfile | sort | uniq >> $infile

echo /ip firewall address-list remove [find list=$list] >> $outfile

for line in $(cat $infile)
do
echo /ip firewall address-list add address="$line" list="$list" >> $outfile
done

