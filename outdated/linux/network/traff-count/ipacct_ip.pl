#!/usr/bin/perl -w --
# $Id: ipacct_ip.pl,v 1.8 2003/03/09 13:03:19 raven66 Exp $
use strict;
use DBI;

sub our_addr($);

our $debug_info = 0;

our %sql_options = (
 'driver' => 'mysql',
 'base'   => 'traffic',
 'table'  => 'clients',
 'host'   => '127.001',
 'port'   => '3306',
 'user'   => 'name',
 'pass'   => 'pass'
);

# адреса сервера
our $main_server_addr = '80.237.91.26';
our @server_addrs = qw(80.237.91.26 80.237.91.25 192.168.1.222 192.168.2.222);
our $ip_addr_mask = '\d+\.\d+\.\d+\.\d+';

# адреса, которые считать:
our %addrs_recv = ();
our %addrs_xmit = ();

# модем и броадкасты не считаем
$addrs_recv{"80.237.91.25"} = -1; $addrs_xmit{"80.237.91.25"} = -1;
$addrs_recv{"192.168.1.255"} = -1; $addrs_xmit{"192.168.1.255"} = -1;
$addrs_recv{"192.168.2.255"} = -1; $addrs_xmit{"192.168.2.255"} = -1;
$addrs_recv{"255.255.255.255"} = -1; $addrs_xmit{"255.255.255.255"}= -1;

# статистика сервера
open(F, '/bin/cat /tmp/ipacct/ipacct.10000|');
while(<F>) {
 if (/^\s($ip_addr_mask)\t($ip_addr_mask)\t(\d+)\t(\d+)$/i) {
  my($src_addr, $dst_addr, $bytes, $our_packet) = ($1, $2, $4, 0);
  if (($src_addr eq $main_server_addr) && (!our_addr($dst_addr))) {
   $addrs_recv{"$src_addr"} = 0 unless (exists($addrs_recv{"$src_addr"}));
   $addrs_xmit{"$src_addr"} = 0 unless (exists($addrs_xmit{"$src_addr"}));
   $addrs_xmit{"$src_addr"} += $bytes if ($addrs_xmit{"$src_addr"} >= 0);
   $our_packet = 1;
  }
  if (($dst_addr eq $main_server_addr) && (!our_addr($src_addr))) {
   $addrs_recv{"$dst_addr"} = 0 unless (exists($addrs_recv{"$dst_addr"}));
   $addrs_xmit{"$dst_addr"} = 0 unless (exists($addrs_xmit{"$dst_addr"}));
   $addrs_recv{"$dst_addr"} += $bytes if ($addrs_recv{"$dst_addr"} >= 0);
   $our_packet = 1;
  }
  if ($our_packet) {
   print("$src_addr\t->\t$dst_addr\t=\t$bytes\n") if ($debug_info);
  }
 }
}
close(F);
print("-----------------------------------------------------\n") if ($debug_info);
$addrs_xmit{"$main_server_addr"} = 0 unless (exists($addrs_xmit{"$main_server_addr"}));
$addrs_recv{"$main_server_addr"} = 0 unless (exists($addrs_recv{"$main_server_addr"}));

# статистика наших подсетей
open(F, '/bin/cat /tmp/ipacct/ipacct.10001 /tmp/ipacct/ipacct.10002|');
while(<F>) {
 if (/^\s($ip_addr_mask)\t(\d+)\t($ip_addr_mask)\t(\d+)\t\w+\t\d+\t(\d+)$/i) {
  my($src_addr, $src_port, $dst_addr, $dst_port, $bytes, $our_packet) = ($1, $2, $3, $4, $5, 0);
  if ((our_addr($src_addr)) && (!our_addr($dst_addr))) {
   $addrs_recv{"$src_addr"} = 0 unless (exists($addrs_recv{"$src_addr"}));
   $addrs_xmit{"$src_addr"} = 0 unless (exists($addrs_xmit{"$src_addr"}));
   if ($addrs_xmit{"$src_addr"} >= 0) {
    $addrs_xmit{"$src_addr"} += $bytes;
    # вычитать только, если был запрос через прозрачный squid
    $addrs_xmit{"$main_server_addr"} -= $bytes if ($dst_port == 80);
   }
   $our_packet = 1;
  }
  if ((our_addr($dst_addr)) && (!our_addr($src_addr))) {
   $addrs_recv{"$dst_addr"} = 0 unless (exists($addrs_recv{"$dst_addr"}));
   $addrs_xmit{"$dst_addr"} = 0 unless (exists($addrs_xmit{"$dst_addr"}));
   if ($addrs_recv{"$dst_addr"} >= 0) {
    $addrs_recv{"$dst_addr"} += $bytes;
    # вычитать всегда, т.к. считаются не успевшие natd пакеты, в локалку
    $addrs_recv{"$main_server_addr"} -= $bytes;
   }
   $our_packet = 1;
  }
  if ($our_packet) {
   print("$src_addr:$src_port\t->\t$dst_addr:$dst_port\t=\t$bytes\n") if ($debug_info);
  }
 }
}
close(F);
print("-----------------------------------------------------\n") if ($debug_info);

# сохраняем в бд
our $dbh;
do {
 $dbh = DBI->connect(
  "DBI:$sql_options{driver}:$sql_options{base};host=$sql_options{host};port=$sql_options{port}",
  $sql_options{'user'},
  $sql_options{'pass'}
 );
 unless (defined($dbh)) {
  print("cannot connect to mysql\n") if ($debug_info);
  sleep(1)
 }
} while (!defined($dbh));

foreach (sort(sort_ip keys(%addrs_recv))) {
 if (($addrs_recv{"$_"} > 0) || ($addrs_xmit{"$_"} > 0)) {
  my($addr, $recv, $xmit) = ($_, $addrs_recv{"$_"}, $addrs_xmit{"$_"});
  my $query = "insert into per_ip (dump_datetime, ip_addr, bytes_recv, bytes_xmit) values(now(), '$addr', '$recv', '$xmit')";
  my $rv = $dbh->do($query) || die("cannot insert traffic data: ".$dbh->errstr());
  print("$addr:\t>$recv<\t<$xmit>\n$rv: $query\n") if ($debug_info);
 }
}

$dbh->disconnect();



sub sort_ip {
 my($y,$z);
 if ($a =~ /^192\.168\.([12]+)\.(\d+)$/) {
  $y = sprintf("%03d%03d", $1, $2);
 } else {
  $y = "999999";
 }
 if ($b =~ /^192\.168\.([12]+)\.(\d+)$/) {
  $z = sprintf("%03d%03d", $1, $2);
 } else {
  $z = "999999";
 }
 return($y cmp $z);
}

sub our_addr($) {
 my $test_addr = shift();
 return(1) if ($test_addr eq '255.255.255.255');
 return(1) if ($test_addr =~ /^192\.168\.[12]\.\d+$/);
 foreach(@server_addrs) {
  return(1) if ($_ eq $test_addr);
 }
 return(0);
}
