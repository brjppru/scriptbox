#!/bin/bash

set -euo pipefail

mkdir -p /tmp/scan
cp /root/ico/favicon.ico /tmp/scan

mpg321 /root/golos/preload.mp3 &

# see bottom for script, youpta

#echo "--- ✄ -----------------------"
#lsusb | grep Samsung
#echo "--- ✄ -----------------------"

# bus 001 Device 003: ID 04e8:341b Samsung Electronics Co., Ltd SCX-4200 series
# Bus 001 Device 004: ID 055f:021b Mustek Systems, Inc. BearPaw 1200 CU Plus

#VENDOR=04e8
#PRODUCT=341b

#dev=$(lsusb -t | grep Printer | grep 'If 1' | cut -d' ' -f13|cut -d"," -f1)
#VENDOR=$(lsusb -s $dev | cut -d' ' -f6 | cut -d: -f1)
#PRODUCT=$(lsusb -s $dev | cut -d' ' -f6 | cut -d: -f2)
#echo $VENDOR:$PRODUCT - found

#for DIR in $(find /sys/bus/usb/devices/ -maxdepth 1 -type l); do
#  if [[ -f $DIR/idVendor && -f $DIR/idProduct &&
#        $(cat $DIR/idVendor) == $VENDOR && $(cat $DIR/idProduct) == $PRODUCT ]]; then
    #sudo bash -c 'echo 0 > $DIR/authorized'
    #sleep 0.5
    #sudo bash -c 'echo 1 > $DIR/authorized'
#    echo "ololo ;-)"
#  fi
#done

#uptime

echo "--- ✄ -----------------------"
echo "begin scan"
echo "--- ✄ -----------------------"

outscan="scan-`date +"%Y-%m-%d-%H%M%S"`"
#
echo start scan at ${outscan}
#
#scanimage -v --progress --mode Color --format=tiff --resolution 300 > /tmp/image.tiff
#
## A4 - is 210x297
## fucking letter size is 215.9 x 279.4
#
#    --mode Color \
#
scanimage -B --verbose --progress \
    --mode Color \
    --format=tiff \
    --resolution 300 \
    -x 210 -y 297 > /tmp/scan/image.tiff
#

mpg321 /root/golos/upload.mp3 &

echo "--- ✄ -----------------------"
convert -verbose /tmp/scan/image.tiff /tmp/scan/${outscan}.jpg
#
echo "--- ✄ -----------------------"
echo "upload"
#
#curl -T /tmp/scan/${outscan}.jpg -k "scp://192.168.0.10:2022/" --user "user:pass"
pscp -P 2022 -sftp -pw pass "/tmp/scan/${outscan}.jpg"  user@192.168.0.10:/
echo "get it from http://scan.home.lan/"${outscan}.jpg
#
echo "--- ✄ -----------------------"
rm /tmp/scan/image.tiff
mpg321 /root/golos/finish.mp3

echo "all done. see MEGA/${outscan}.jpg"

