#!/bin/sh

#
# ������� �������, ��� �� �� �������� ���������� �� ������ (-;
#

killall -hup ipacctd

#
# ���������, ���� �� ��������� �������
#

	    if [  -e /root/cabinet/admin.lock ]; then
	        echo "[CABINET] Locked by admin. Exit"
		logger -t cabinet "Admin locked the sync. Exit."
		exit 0
	    
	    fi

#
# ���������, ���� �� ����� �������� � ������, ���� ���� �����.
#

	    zavis=`/usr/bin/find /root/cabinet/sync.lock -cmin +15`

	    if [ "${#zavis}" -eq  23 ]
	        then
	    	    echo "[CABINET] Lock file old 15 minutes, remove!"
		    logger -t cabinet "�� ���. �������� ���������� �� ���������� �� ������� 15 �����."
		    echo "����������� ������ � �������� �� ���������� �� ������ cabinet ��������� 15 �����. ������ LOCK ���� ������, ������� ���������� ������������ (-;" | mail info@vzletka.net
		    rm /root/cabinet/sync.lock
	    fi

	    if [  -e /root/cabinet/sync.lock ]; then
	        echo "[CABINET] Already run. Exit"
		logger -t cabinet "Found lock file. Stop sync."
		exit 0
	    fi

#
# ���� �������� ���, �� �� ��� ��������� � ������� ���� ������������
#

touch /root/cabinet/sync.lock
logger -t cabinet "sync is started"

# ====================================================================

#
# ��������� ����������� ������� �������. 1 ���, ���� ��� �� �����, ��
# ��������� �ݣ 10 ���, � ���� ����� ������ �� ���������� ���� ������
# � ������� ���� ��������� ��������.
#

sip="10.10.10.10"

/sbin/ping -n -c1 -q ${sip} > /dev/null 2>&1

if [ $? -ne  0 ]
then
   /sbin/ping -n -c10 -q ${sip} > /dev/null 2>&1
   if [ $? -ne  0 ]
    then
     echo "[SERVER] CABINET is down"
     logger -t cabinet "Cabinet host is down. Stop sync."
     rm /root/cabinet/sync.lock
     exit 0
   fi
fi

# ====================================================================

#
# �������������� �����, � �������� ��������� ����� � ������� �����,
# ���������� �� ��������� ������. ����� ��� �� ����� ��������:
#
# /arp/arp.hold 
# /dhcpd/addr.dhcp
# /ppp/ppp.secrets
#

cd /root/cabinet

ftp ftp://${sip} << EOF
bin
passive off
cd /arp
get core.arp.hold
del "core.arp.hold"
cd /dhcp
get addr.dhcp
del "addr.dhcp"
cd /ppp
get ppp.secret
del ppp.secret
quit
EOF

#
# �������������� ����� DNS, � �������� ���������, ����� � ������� �����,
# ���������� �� ��������� ������. ����� ��� �� ����� ��������:
#
# /bind/named-reverse
# /bind/internal.part
# /bind/rev/*.rev
#

cd /root/cabinet/bind

ftp -i ftp://${sip} << EOF
bin
passive off
cd /bind
get "named-reverse"
del "named-reverse"
get internal.part
del "internal.part"
cd /bind/rev
mget *.rev
mdel *.rev
quit
EOF

#
# �������������� ����� VPN DNS, � �������� ���������, ����� � ������� 
# �����, ���������� �� ��������� ������. ����� ��� �� ����� ��������:
#
# /bind/vpn/vpn-reverse
# /bind/vpn/vzletka.vpn-client
# /bind/vpn/rev/*.rev
#

cd /root/cabinet/bind/vpn

ftp -i ftp://${sip} << EOF
bin
passive off
cd /bind/vpn
get "vpn-reverse"
del "vpn-reverse"
get "vzletka.vpn-client"
del "vzletka.vpn-client"
cd /bind/vpn/rev
mget *.rev
mdel *.rev
quit
EOF

# ====================================================================
# �������� ������ ������� ���������� ������ ��� (-;
# ====================================================================


#
# DNS �������������.
#
# ��������� ���� �� ���� named-reverse, ���� ���� �������� ������
# ������ ������ �����������, ����� �� ��� ����� �����.
# ������� ����� �������� ���� � ����� �� �� ����� �����.
#

	if [  -e /root/cabinet/bind/named-reverse ]; then
		rm /etc/namedb/vzletka.net/named-reverse
		mv /root/cabinet/bind/named-reverse /etc/namedb/vzletka.net/named-reverse
		rm -f /etc/namedb/vzletka.net/rev/*.rev
		mv /root/cabinet/bind/*.rev /etc/namedb/vzletka.net/rev
		touch /root/cabinet/make.zone
		fi

# ���� ������ ���������� ���������� ����� ������ �������.���
# �� ������ ������ ����
# �������� ��������� + ����� ���� � ���� �������� � ����� � �����.

	if [  -e /root/cabinet/bind/internal.part ]; then
		rm /etc/namedb/vzletka.net/internal.part
		mv /root/cabinet/bind/internal.part /etc/namedb/vzletka.net
		touch /root/cabinet/make.zone
		fi

# ���� ���� ���������� � ������� VPN, �� ������ ������ ����
# �������� ��� �����. ������ ������ ���� �������� ������� � 
# �������� ��� �����. ������ �������� ���� � �������� �� ������.

	if [  -e /root/cabinet/bind/vpn/vzletka.vpn-client ]; then
		rm /etc/namedb/vzletka.net/vpn/vzletka.vpn-client
		mv /root/cabinet/bind/vpn/vzletka.vpn-client /etc/namedb/vzletka.net/vpn/vzletka.vpn-client
		rm /etc/namedb/vzletka.net/vpn/vpn-reverse
		mv /root/cabinet/bind/vpn/vpn-reverse /etc/namedb/vzletka.net/vpn/vpn-reverse
		rm /etc/namedb/vzletka.net/vpn/rev/*.rev
		mv /root/cabinet/bind/vpn/*.rev /etc/namedb/vzletka.net/vpn/rev
		touch /root/cabinet/make.zone
		fi

#
# �������� ���. �� �����, ��� ����������, ��� internal ����, ��� VPN
#

	if [  -e /root/cabinet/make.zone ]; then

		cat /etc/namedb/vzletka.net/internal.header > /etc/namedb/vzletka.net/internal
		
                cat /etc/namedb/vzletka.net/internal.part >> /etc/namedb/vzletka.net/internal
		
		cat /etc/namedb/vzletka.net/vpn/vzletka.vpn-client >> /etc/namedb/vzletka.net/internal
		
		touch /root/cabinet/restart.bind
		rm /root/cabinet/make.zone

		logger -t cabinet "Found new NAMED files, new zone's generated"
		fi

# ====================================================================

# ������������� PPP ������. 
# ���� ����, ��������� ����� ����, ������ ������� � ������� ����, ��� �� 
# ������ �� ��� �� ���.

	if [  -e /root/cabinet/ppp.secret ]; then
		rm /etc/ppp/ppp.secret
		mv /root/cabinet/ppp.secret /etc/ppp
		chmod 600 /etc/ppp/ppp.secret
		logger -t cabinet "Found new ppp.secret file, applying new acces"
		fi

# ====================================================================

# ������� ��������� ��� ��������.
# ���� ���� - ��������� �� �����.

	if [  -e /root/cabinet/core.arp.hold ]; then
		rm /etc/core.arp.hold
		mv /root/cabinet/core.arp.hold /etc
		touch /root/cabinet/restart.dhcp
		logger -t cabinet "Found new ARP hold file, applying new"
		fi

# ====================================================================

# �������� ��� DHCP. 
# ���� ����, �� ���������� ��������� + ��� ���� � ����� ������������.

	if [  -e /root/cabinet/addr.dhcp ]; then
		rm /etc/dhcpd.conf
		cp /etc/dhcp/dhcpd.conf /etc
		cat /root/cabinet/addr.dhcp >> /etc/dhcpd.conf
	        rm /root/cabinet/addr.dhcp
		touch /root/cabinet/restart.dhcp
		logger -t cabinet "Found new dhcpd file, applying new DHCPD configuration"
		fi

# ====================================================================
# ���������� ��������
# ====================================================================


# BIND restart 

	if [ -e /root/cabinet/restart.bind ]; then
	        rm /root/cabinet/restart.bind
		killall -HUP named
		logger -t cabinet "I'am run NAMED restart"
		fi

# DHCP restart 

	if [ -e /root/cabinet/restart.dhcp ]; then
	        rm /root/cabinet/restart.dhcp
		/usr/local/etc/rc.d/dhcpd.sh restart
		logger -t cabinet "I'am run DHCPD restart"
		fi

# ��������� �������������, ���� ���������� ��������.

		/root/cabinet/ppp_kill.pl


# ====================================================================
# �������� ���������� VPN ������������� �� cabinet.vzletka.net
# ====================================================================

cd /var/log/ipacct
                                          
count_total=`ls -1|wc -l`;
counter=0
                                          
for i in `ls -1`
 do
   counter=$(($counter+1))

	if [ $counter != $count_total ]; then

            /usr/local/bin/ftpq add -c cabinet $i

	    /usr/local/bin/ftpq run

		if [ $? -eq  0 ]
		 then
		   mv "$i" /var/backups/ipacct
	        fi
	fi                                    
done                                     

	logger -t cabinet "IP accounting for VPN uploaded"

# ====================================================================
# �������� ���������� VPN ������������� ��� �������� IP �� cabinet.vzletka.net
# ====================================================================

cd /var/log/ipacctr
                                          
count_total=`ls -1|wc -l`;
counter=0
                                          
for i in `ls -1`
 do
   counter=$(($counter+1))

	if [ $counter != $count_total ]; then

            /usr/local/bin/ftpq add -c cabinet $i

	    /usr/local/bin/ftpq run

		if [ $? -eq  0 ]
		 then
		   mv "$i" /var/backups/ipacctr
	        fi
	fi                                    
done                                     

	logger -t cabinet "IP accounting for real IP uploaded"


# ====================================================================
# ������ ����������, ������ ���� ������� � �������.

	logger -t cabinet "sync is finished, all done"

	rm /root/cabinet/sync.lock
	exit 0
