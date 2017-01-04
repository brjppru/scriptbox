#!/bin/sh

# grab date

outdir="`date +"%Y/%m"`"
outflz="`date +"%d-%H%M%S"`-"

# echo $outdir/$outflz

cd /baza

for file in *.torrent
do
echo "om nom nom $file"
/usr/bin/transmission-remote localhost:9091 -a "$file"
mkdir -p /var/lib/transmission-daemon/downloads/$outdir
mv "$file" /var/lib/transmission-daemon/downloads/$outdir/${outflz}"$file".added
sleep 1
logger -t torrent "$file" added to queue
done

chmod -R 777 /var/lib/transmission-daemon/downloads/

