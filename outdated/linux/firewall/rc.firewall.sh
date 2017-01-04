#!/bin/bash
# License: GPL3
# Author: Dmitri Gribenko <gribozavr@gmail.com>

LAN_IF="eth0"
INET_IF="eth1"
INET_IP="192.0.2.123"
INET6_IF="he-ipv6"

# for dynamic IPs:
# INET_IP=$(get_ip_ipv4 $INET_IF)

LOOPBACK_IF="lo"

IPTABLES="/sbin/iptables"
IP6TABLES="/sbin/ip6tables"
#IPTABLES="echo 4"
#IP6TABLES="echo 6"
IP="/sbin/ip"

# IPs that need to be NAT'ed to our $INET_IP.
NAT_IPV4='
192.168.1.3  pc1
192.168.1.4  pc2
192.168.1.5
'

# Set to 0 to disable updating IPv4 or IPv6 firewall.
DO_IPV4="1"
DO_IPV6="1"

function get_ip_ipv4
{
  $IP addr show dev $1 primary | sed -n -e '/^\s*inet / s/^\s*inet \(.*\)\/.\{1,2\} .*$/\1/ p'
}

ipt4()
{
  [ "$DO_IPV4" = "1" ] && $IPTABLES "$@"
}

ipt6()
{
  [ "$DO_IPV6" = "1" ] && $IP6TABLES "$@"
}

ipt46()
{
  ipt4 "$@"
  ipt6 "$@"
}

##############################################################################
################################ filter table ################################
##############################################################################

ipt46 -t filter -P INPUT   ACCEPT
ipt46 -t filter -P OUTPUT  ACCEPT
ipt46 -t filter -P FORWARD ACCEPT

ipt46 -t filter -F
ipt46 -t filter -X

FILTER_CHAINS46="bad_tcp inet_input inet_output inet_banned_input inet_banned_output inet_tcp_input inet_tcp_output inet_udp_input inet_udp_output"
for i in $FILTER_CHAINS46; do
  ipt46 -t filter -N $i
  ipt46 -t filter -F $i
done

FILTER_CHAINS4="inet_icmp_input inet_icmp_output"
for i in $FILTER_CHAINS4; do
  ipt4  -t filter -N $i
  ipt4  -t filter -F $i
done

FILTER_CHAINS6="inet_icmpv6_input inet_icmpv6_output inet_icmpv6_forward"
for i in $FILTER_CHAINS6; do
  ipt6  -t filter -N $i
  ipt6  -t filter -F $i
done

#################################
## filter -- INPUT
##

# allow ipv6 in ipv4
ipt4  -t filter -A INPUT -p ipv6 -j ACCEPT

ipt46 -t filter -A INPUT -i $LOOPBACK_IF -j ACCEPT
ipt46 -t filter -A INPUT -i $LAN_IF      -j ACCEPT
ipt4  -t filter -A INPUT -i $INET_IF     -j inet_input
ipt6  -t filter -A INPUT -i $INET6_IF    -j inet_input

#ipt46 -t filter -A INPUT -m limit --limit 3/minute --limit-burst 3 -j LOG --log-level INFO --log-prefix "IPT INPUT packet died: "
#ipt46 -t filter -A INPUT -j LOG --log-level INFO --log-prefix "IPT INPUT packet died: "
ipt46 -t filter -A INPUT -j DROP

#################################
## filter -- OUTPUT
##

ipt46 -t filter -A OUTPUT -o $LOOPBACK_IF -j ACCEPT
ipt46 -t filter -A OUTPUT -o $LAN_IF      -j ACCEPT
ipt4  -t filter -A OUTPUT -o $INET_IF     -j inet_output
ipt6  -t filter -A OUTPUT -o $INET6_IF    -j inet_output

#ipt46 -t filter -A OUTPUT -j LOG --log-level INFO --log-prefix "IPT OUTPUT: "
ipt46 -t filter -A OUTPUT -j ACCEPT

#################################
## filter -- bad_tcp
##

ipt46 -t filter -A bad_tcp -p tcp -m state --state NEW ! --syn -j DROP
ipt46 -t filter -A bad_tcp        -m state --state INVALID -j DROP

ipt46 -t filter -A bad_tcp -j RETURN

################################
## filter -- inet_input
##

# filter out bad packets so they don't even reach other checks
ipt46 -t filter -A inet_input        -j inet_banned_input
ipt46 -t filter -A inet_input -p tcp -j bad_tcp

ipt46 -t filter -A inet_input -m state --state ESTABLISHED,RELATED -j ACCEPT

ipt46 -t filter -A inet_input -p tcp    -j inet_tcp_input
ipt46 -t filter -A inet_input -p udp    -j inet_udp_input
ipt4  -t filter -A inet_input -p icmp   -j inet_icmp_input
ipt6  -t filter -A inet_input -p icmpv6 -j inet_icmpv6_input
ipt4  -t filter -A inet_input -p igmp   -j ACCEPT

ipt46 -t filter -A inet_input -j RETURN

################################
## filter -- inet_output
##

ipt46 -t filter -A inet_output -j inet_banned_output

# allow established -- fast path
ipt46 -t filter -A inet_output -m state --state ESTABLISHED,RELATED -j ACCEPT

ipt46 -t filter -A inet_output -p tcp    -j inet_tcp_output
ipt46 -t filter -A inet_output -p udp    -j inet_udp_output
ipt4  -t filter -A inet_output -p icmp   -j inet_icmp_output
ipt6  -t filter -A inet_output -p icmpv6 -j inet_icmpv6_output
ipt4  -t filter -A inet_output -p igmp   -j ACCEPT

ipt46 -t filter -A inet_output -j RETURN

#################################
## filter -- inet_banned_input, inet_banned_output
##

# Drop packets from private, local and reserved addresses.
# You can add 10.0.0.0/8 if your ISP doesn't use it.
# You can also add 224.0.0.0/4 if you don't use multicast.
for ip in 172.16.0.0/12 192.168.0.0/16 127.0.0.0/8 240.0.0.0/5; do
  ipt4  -t filter -A inet_banned_input   -s $ip -j DROP
  ipt4  -t filter -A inet_banned_output  -d $ip -j REJECT --reject-with icmp-admin-prohibited
done

if [ -e /etc/firewall/inet_banned4 ]; then
  while read ext_ip; do
    ipt4  -t filter -A inet_banned_input  -s $ext_ip -j DROP
    ipt4  -t filter -A inet_banned_output -d $ext_ip -j REJECT --reject-with icmp-admin-prohibited
  done < /etc/firewall/inet_banned4
fi

if [ -e /etc/firewall/inet_banned6 ]; then
  while read ext_ip; do
    ipt6  -t filter -A inet_banned_input  -s $ext_ip -j DROP
    ipt6  -t filter -A inet_banned_output -d $ext_ip -j REJECT --reject-with adm-prohibited
  done < /etc/firewall/inet_banned6
fi

ipt46 -t filter -A inet_banned_input  -j RETURN
ipt46 -t filter -A inet_banned_output -j RETURN

#################################
## filter -- inet_tcp_input
##

while read proto port comment; do
  if [ -n "$proto" ]; then
    $proto -t filter -A inet_tcp_input -p tcp --dport $port -j ACCEPT
  fi
done <<__EOF__
ipt46 20          ftp-data
ipt46 21          ftp
ipt46 12500:13000 ftp-data

ipt46 22          ssh
__EOF__

# drop all MS stuff so that it won't clutter logs
ipt46 -t filter -A inet_tcp_input -p tcp -m multiport --ports 137,138,139,445 -j DROP

ipt46 -t filter -A inet_tcp_input -j RETURN

#################################
## filter -- inet_tcp_output
##

# drop all MS stuff so that it won't clutter logs
ipt46 -t filter -A inet_tcp_output -p tcp -m multiport --ports 137,138,139,445 -j DROP

ipt46 -t filter -A inet_tcp_output -j RETURN

#################################
## filter -- inet_udp_input
##

# iptv
ipt4  -t filter -A inet_udp_input -p udp -d 224.0.0.0/4 -j ACCEPT

# drop all MS stuff so that it won't clutter logs
ipt46 -t filter -A inet_udp_input -p udp -m multiport --ports 137,138,139,445 -j DROP

# some unknown flood on my ISP's net
ipt4  -t filter -A inet_udp_input -p udp --dport 631 -j DROP

ipt46 -t filter -A inet_udp_input -j RETURN

#################################
## filter -- inet_udp_output
##

# drop all MS stuff so that it won't clutter logs
ipt46 -t filter -A inet_udp_output -p udp -m multiport --ports 137,138,139,445 -j DROP

ipt46 -t filter -A inet_udp_output -j RETURN

#################################
## filter -- inet_icmp_input
##

# echo-reply should be handled by conntrack
ipt4  -t filter -A inet_icmp_input -p icmp -m icmp --icmp-type echo-request            -j ACCEPT
ipt4  -t filter -A inet_icmp_input -p icmp -m icmp --icmp-type time-exceeded           -j ACCEPT
ipt4  -t filter -A inet_icmp_input -p icmp -m icmp --icmp-type destination-unreachable -j ACCEPT
ipt4  -t filter -A inet_icmp_input -p icmp -j DROP

ipt4  -t filter -A inet_icmp_input -j RETURN

#################################
## filter -- inet_icmp_output
##

ipt4  -t filter -A inet_icmp_output -j RETURN

#################################
## filter -- inet_icmpv6_input
##

# See RFC 4890.

# echo-reply should be handled by conntrack
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type echo-request            -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type destination-unreachable -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type packet-too-big          -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type time-exceeded           -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type parameter-problem       -j ACCEPT

ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type router-solicitation     -m hl --hl-eq 255 -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type router-advertisement    -m hl --hl-eq 255 -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type neighbour-solicitation  -m hl --hl-eq 255 -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type neighbour-advertisement -m hl --hl-eq 255 -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type redirect                -m hl --hl-eq 255 -j ACCEPT
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type 141                     -m hl --hl-eq 255 -j ACCEPT # Inverse neighbour discovery solicitation
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type 142                     -m hl --hl-eq 255 -j ACCEPT # Inverse neighbour discovery advertisement

ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 130 -j ACCEPT # Listener query
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 131 -j ACCEPT # Listener report
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 132 -j ACCEPT # Listener done
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 143 -j ACCEPT # Listener report v2

ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type 148 -m hl --hl-eq 255 -j ACCEPT # Certificate path solicitation
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -m icmp6 --icmpv6-type 149 -m hl --hl-eq 255 -j ACCEPT # Certificate path advertisement

ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 151 -m hl --hl-eq 1 -j ACCEPT # Multicast router advertisement
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 152 -m hl --hl-eq 1 -j ACCEPT # Multicast router solicitation
ipt6  -t filter -A inet_icmpv6_input -p icmpv6 -s fe80::/10 -m icmp6 --icmpv6-type 153 -m hl --hl-eq 1 -j ACCEPT # Multicast router termination

ipt6  -t filter -A inet_icmpv6_input -j RETURN

#################################
## filter -- inet_icmpv6_output
##

ipt6  -t filter -A inet_icmpv6_output -j RETURN

#################################
## filter -- inet_icmpv6_forward
##

ipt6  -t filter -A inet_icmpv6_forward -p icmpv6 -m icmp6 --icmpv6-type echo-request            -j ACCEPT
ipt6  -t filter -A inet_icmpv6_forward -p icmpv6 -m icmp6 --icmpv6-type destination-unreachable -j ACCEPT
ipt6  -t filter -A inet_icmpv6_forward -p icmpv6 -m icmp6 --icmpv6-type packet-too-big          -j ACCEPT
ipt6  -t filter -A inet_icmpv6_forward -p icmpv6 -m icmp6 --icmpv6-type time-exceeded           -j ACCEPT
ipt6  -t filter -A inet_icmpv6_forward -p icmpv6 -m icmp6 --icmpv6-type parameter-problem       -j ACCEPT

ipt6  -t filter -A inet_icmpv6_forward -j RETURN

#################################
## filter -- FORWARD
##

ipt46 -t filter -A FORWARD -i $INET_IF -j inet_banned_input
ipt46 -t filter -A FORWARD -o $INET_IF -j inet_banned_output
ipt46 -t filter -A FORWARD -p tcp -j bad_tcp

# don't forward MS stuff
ipt46 -t filter -A FORWARD -p tcp -m multiport --ports 137,138,139,445 -j DROP
ipt46 -t filter -A FORWARD -p udp -m multiport --ports 137,138,139,445 -j DROP

ipt6  -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

ipt6  -t filter -A FORWARD -p icmpv6 -j inet_icmpv6_forward

while read proto port ip comment; do
  if [ -n "$proto" ]; then
    ipt6 -t filter -A FORWARD -d $ip -p $proto --dport $port -j ACCEPT
  fi
done <<__EOF__
tcp 22 ::/0 ssh
tcp 80 2001:db8::1 http
__EOF__

ipt6  -t filter -A FORWARD -i $INET6_IF -p tcp -j REJECT --reject-with tcp-reset
ipt6  -t filter -A FORWARD -i $INET6_IF -j DROP
ipt6  -t filter -A FORWARD -o $INET6_IF -j ACCEPT

echo "$NAT_IPV4" | while read int_ip comment; do
  if [ -n "$int_ip" ]; then
    ipt4  -t filter -A FORWARD -s $int_ip -o $INET_IF -j ACCEPT
    ipt4  -t filter -A FORWARD -d $int_ip -i $INET_IF -j ACCEPT
  fi
done

#ipt46 -t filter -A FORWARD -j LOG --log-level INFO --log-prefix "IPT FORWARD packet died: "
ipt46 -t filter -A FORWARD -j DROP

##############################################################################
################################ mangle table ################################
##############################################################################

ipt46 -t mangle -P INPUT       ACCEPT
ipt46 -t mangle -P OUTPUT      ACCEPT
ipt46 -t mangle -P FORWARD     ACCEPT
ipt46 -t mangle -P PREROUTING  ACCEPT
ipt46 -t mangle -P POSTROUTING ACCEPT

ipt46 -t mangle -F
ipt46 -t mangle -X

##############################################################################
################################## nat table #################################
##############################################################################

ipt4  -t nat -P OUTPUT      ACCEPT
ipt4  -t nat -P PREROUTING  ACCEPT
ipt4  -t nat -P POSTROUTING ACCEPT

ipt4  -t nat -F
ipt4  -t nat -X

####################################
## nat -- PREROUTING
##

# Port forwarding
while read proto port int_ip comment; do
  if [ -n "$proto" ]; then
    ipt4  -t nat -A PREROUTING -i $INET_IF -p $proto --dport $port -j DNAT --to-destination $int_ip:$port
  fi
done <<__EOF__
tcp 1234 192.168.1.3 something
udp 5678 192.168.1.3 something else
__EOF__

####################################
## nat -- POSTROUTING
##

echo "$NAT_IPV4" | while read int_ip comment; do
  if [ -n "$int_ip" ]; then
    ipt4  -t nat -A POSTROUTING -s $int_ip -o $INET_IF -j SNAT --to-source $INET_IP
  fi
done

echo 1 > /proc/sys/net/ipv4/ip_forward

##
## __END__
#################################

