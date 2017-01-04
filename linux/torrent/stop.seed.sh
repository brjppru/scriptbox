#!/bin/sh

transmission-remote -l | grep 100% | grep Done | awk '{print $1}' | xargs -n 1 -I % transmission-remote -t % -r

chmod -R 777 /var/lib/transmission-daemon/downloads
