#!/bin/sh

outscan="scan-`date +"%Y-%m-%d-%H%M%S"`"

echo start scan at ${outscan}

scanimage --progress --mode Color --format=tiff --resolution 300 > /tmp/image.tiff

convert /tmp/image.tiff /root/Dropbox/${outscan}.jpg

chmod 777 /root/Dropbox/${outscan}.jpg

rm /tmp/image.tiff

echo "all done. see dropbox/${outscan}.jpg"
