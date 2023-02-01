#!/usr/bin/perl -w

use strict;

print "ppp killer started\n";

my @known_ip=();

open PS, "</etc/ppp/ppp.secret";
while (<PS>) { 
  my $ip=(split /\t/)[2]; chomp $ip;
  push @known_ip, $ip;
}

close PS;

my @ifconfig=`/sbin/ifconfig`;

while (my $ic_string=shift @ifconfig) {
  if ($ic_string =~ /^tun\d+: flags=\d+<UP,/) {
    my $remote_ip=(split/\s+/,shift @ifconfig)[4];
    my $ppp_pid  =(split/\s+/,shift @ifconfig)[4];
    kill(15,$ppp_pid) unless grep {/^$remote_ip$/} @known_ip;
  }
}

print "ppp killer finished\n";
