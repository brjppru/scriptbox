#!/bin/sh

mount /dev/ad4s1a /sata
mount /dev/ad4s1f /sata/var
mount /dev/ad4s1d /sata/usr
mount /dev/ad4s1e /sata/usr/home
mount -t devfs foo /sata/dev

chroot /sata /sbin/ldconfig -m /usr/lib/compat
chroot /sata /sbin/ldconfig -m /usr/lib
chroot /sata /sbin/ldconfig -m /lib
