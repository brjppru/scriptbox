#!/bin/sh

# clone cloud image to new VM

qm clone 9009 999 --name test-clone-cloud-init
qm set 999 --ipconfig0 ip=192.168.0.25/24,gw=192.168.0.1
qm start 999
