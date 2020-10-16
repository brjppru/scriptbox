#!/bin/sh -

root, swap, etc, home, tmp, usrlocal, var

mkdir ${mount_point}/freebsd

etc=`cat /tmp/input.tmp.$$`
t_etc=`expr $etc \* 2 \* 1024`
rm /tmp/input.tmp.$$

    dd if=/dev/zero of=${mount_point}/freebsd/etc.flp bs=512 count=$t_etc
    cd /dev
    ./MAKEDEV vn4
    vnconfig -s labels -c vn4 ${mount_point}/freebsd/etc.flp
    disklabel -r -w vn4c auto
    newfs /dev/vn4c
    mount /dev/vn4c /mnt/tmp
    cd /mnt/tmp
    cp -Rp /etc/* .
    touch /mnt/tmp/XYZ123_
    cd /
    sleep 5
    umount /mnt/tmp
    vnconfig -u vn4

}

