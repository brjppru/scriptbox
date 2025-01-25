#!/bin/sh -

#                                                              
# запуск сервера DHCPD и зачитка ARP адресов
#                                                              
                                                               
case "$1" in

        start)
		arp -a -d
                /usr/local/sbin/dhcpd -cf /usr/local/etc/dhcpd.conf -lf /var/db/dhcpd.leases fxp0
                echo -n ' dhcpd'
                ;;
        stop)
                kill `cat /var/run/dhcpd.pid`
                echo -n ' dhcpd'
                ;;
        restart)
                $0 stop
                sleep 1
                $0 start
                ;;
        *)
                echo "usage: $0 {start|stop|restart}" >&2
                ;;
esac
