#!/bin/sh

exit 0

while true; do
    sudo ddrescue /dev/sda diskimage.img mapfile.log
    if [ -a /dev/sdc ]; then
        sudo ddrescue /dev/sda diskimage.img mapfile.log -M
    else
        curl -X POST https://maker.ifttt.com/trigger/switch_off/with/key/REDACTED
        sleep 10
        curl -X POST https://maker.ifttt.com/trigger/switch_on/with/key/REDACTED
        sleep 10
    fi
done
