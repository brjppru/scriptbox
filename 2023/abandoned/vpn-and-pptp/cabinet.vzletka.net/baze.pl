#!/usr/bin/perl -w

use strict;
use vars qw($mac);

#@ARGV=qw(razukov 172.16.0.2 tun52 36508);
#        USER    HISADDR      IFACE PID

die "not enough parameters\n" if $#ARGV<3;
my $rc=checkTipVip();

if (defined $rc) {
  unless ($rc) {
    print "@ARGV coming from $mac\n";
  }
} else {
  print "ip is not in database. arguments: @ARGV\n";
  kill(9,$ARGV[3]-1);
}

sub checkTipVip {
#undef = do not exist
#0  = does not equal
#1  = ok
  my $tipvip=ReadTipVipTable("/etc/ppp/ppp-security");
  my ($rtip,$rpid)=@ARGV[1,3];
  my $ctrlpid=$rpid-1;
  my $raw=`/bin/ps ax| grep -v grep| grep $ctrlpid`;
  my ($vip)= ($raw =~/\[([^\[]+)\]/);
  if (exists $tipvip->{$vip}) {
    if ($rtip eq $tipvip->{$vip}{tip}) {
      return 1;
    } else {
      ($mac)= (`/usr/sbin/arp -a | grep $rtip` =~ /at (\S+) on/);
      return 0;
    }
  } else {
    return undef;
  }
}

sub ReadTipVipTable {
  my $path=shift; my $tv;

#  my @tipvip=("10.10.10.37 172.16.0.2 0:20:e0:e0:73:9d\n",
#            "10.11.138.7 172.16.0.3 0:50:4:4b:f1:d1\n",
#            "10.11.138.3 172.16.0.5 0:30:84:76:f4:bf\n");
  my @tipvip=`/bin/cat $path`;
  foreach (@tipvip) {
    chomp; next unless /\w/;
    my ($tip,$vip,$mac)=split/\s+/;
    $tv->{$vip}{"tip"}=$tip;
    $tv->{$vip}{"mac"}=$mac;
  }
  return $tv||undef;  
}
