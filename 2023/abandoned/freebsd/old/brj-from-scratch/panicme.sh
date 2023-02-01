#!/bin/sh

# brj@fast panicbox

PANICBOX=/home/chroot

# run the lib'rs
chroot ${PANICBOX} /sbin/ldconfig -m /usr/lib/compat
chroot ${PANICBOX} /sbin/ldconfig -m /usr/lib
chroot ${PANICBOX} /sbin/ldconfig -m /lib

# plug devfs
#mount -t devfs foo ${PANICBOX}/dev

# enter the chroot
chroot ${PANICBOX} /bin/csh
