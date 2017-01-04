#!/bin/bash

/usr/bin/kvm -monitor stdio -smp 2 -cpu core2duo -soundhw ac97 -vga std -enable-kvm -m 1024 -full-screen -no-fd-bootchk -localtime -drive file="/home/lahwaacz/Virtual.Machines/winxp.raw" -boot once=c,menu=off -net nic,vlan=0,model=virtio -net user,vlan=0 -usb -no-frame -name "Windows XP" -usbdevice tablet
