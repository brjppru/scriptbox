#!/bin/sh

#
# brj@mpd IP-linkup script
#

case "$1" in

    ng0)
	    
	    # Internet connection is up.
	    # restart named and postfix
	    
#	sh /etc/rc.d/named reload
#	sh /etc/crond/brj-routed.sh start
# 	route -q add -net 89.105.128.134/32 -iface ng0

	    /sbin/pfctl -f /etc/brjpf.conf
	    
#	    sh /etc/rc.d/named stop
#	    sh /etc/rc.d/named start

	    ;;
	    
    *)
	    # nothing
	    
	    ;;
	    
esac
