#!/bin/sh
#
# Download list of blocked IP by RosComNadzor
# - Make list of IP & collapse it
# - Make list of subnets
# - Make list for Mikrotik
#
# Current date
curdate=`date +%F-%H-%M`
# Antizapret URL
url="https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv"
# Main directory
maindir="/home/fireball/rkn/"
# Source file from Antizapret
downfile="dump.csv"
# File with cleaned & formatted ip addresses
infile="rkn-hosts.txt"
# File with subnets
infilesub="rkn-subnets.txt"
# File with cleaned, formatted and collapsed ip addresses
infilecol="rkn-hosts-col.txt"
# File with all subnets
outfilefull="rkn-full.txt"
# Directory for diff's
diffdir="changes"
# Address list name in Mikrotik
list="RKN-blocked"
# Where to put rsc script for Mikrotik
outfile="rkn-full.rsc"
# Temp file
diffile="rkn-full-old.txt"
#---
# Change directory
cd $maindir
# Backup old file
mv $outfilefull $diffile
# Download list of blocked IP
wget $url -O $downfile --no-check-certificate
# Extract all IPs to file
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $downfile | sort -V | uniq > $infile
# Extract list of subnets to file
cat $downfile | cut -d ";" -f1 | tr '|' '\n' | grep '/' | tr -d ' ' | sort -V | uniq > $infilesub
# Collapse all IP to file
cat $infile | perl -MSocket -F'\s|;|\|' -nlae 'BEGIN{$mask = 24 ;for($i=0;$i<$mask;$i++){$bm=($bm<<1)+1}$bm=$bm<<(32-$mask)}for(@F){next if !(/^((25[0-5]?|2[0-4]?\d|[01]?\d\d?)\.){3}(25[0-5]?|2[0-4]?\d?|[01]?\d\d?)$/);$h{unpack("N",inet_aton($_))&$bm}+=1}END{for(keys %h){print inet_ntoa(pack("N",$_))."/$mask"}}' | sort -V | uniq > $infilecol
# Merge 2 lists to one
cat $infilesub $infilecol > $outfilefull
# Create address list for Mikrotik
echo "#" > $outfile
echo "/ip firewall address-list remove [find list=$list]" >> $outfile
echo "#" >> $outfile
# Build rsc file for Mikrotik
for line in $(cat $outfilefull)
do
echo "/ip firewall address-list add address="$line" list="$list"" >> $outfile
done
# Take diff for history changes
diff $diffile $outfilefull > diff-$curdate.diff
# Delete empty diff
if [ -f diff-$curdate.diff ]
then
  if [ ! -s diff-$curdate.diff ]
  then
    rm -f diff-$curdate.diff
  fi
fi
# Clean diff file for human readable
cat diff-$curdate.diff | grep '>' | sort -V | uniq > diff.temp
# Move diff file into directory
mv diff.temp diff-$curdate.diff
mv diff-$curdate.diff $diffdir
