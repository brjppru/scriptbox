# bind9 #

forward-socks4a .onion  127.0.0.1:9050 .

/etc/bind/named.conf.local:

zone "onion" {
        type forward;
        forwarders { 127.0.0.2; };
        forward only;
};

/etc/tor/torrc:

DNSPort 53
DNSListenAddress 127.0.0.2

Described in RFC2671, it is intended as a set of extensions to DNS that allows passing UDP packets larger than 512 bytes between EDNS-enabled nameservers.

Many public DNS servers do not implement EDNS - excluding root servers, which just increases DNS traffic over the network needlessly. Misconfigured firewalls or cheap routers may have issues with the increased UDP packet length.

https://www.ietf.org/rfc/rfc1035.txt

To disable EDNS, you need to add the following two lines:

server ::/0 { edns no; };        
server 0.0.0.0/0 { edns no; }; 

