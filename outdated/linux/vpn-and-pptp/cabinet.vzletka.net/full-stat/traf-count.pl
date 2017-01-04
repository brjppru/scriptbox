#!/usr/bin/perl

# $req_addr = "172.16.0.3";

$req_addr = $ARGV[1];

open FILE, $ARGV[0];

$totalin = 0;
$totalout= 0;

while (<FILE>) {
  tr/ / /s;
  ($add1, $FP, $add2, $TP, $proto, $totsize, $packets, $utime) = split(/	/,$_);

  if ($add1 =~ $req_addr) {
        
       #print "$totsize - it\n"; 

       $totalin += $totsize;
       $dh{$add2} += $totsize;
  }

  if ($add2 eq $req_addr) {

       #print "$totsize - out\n"; 

       $totalout += $totsize;
       $dh{$add1} += $totsize;
  }
}
close FILE;

# result print

# print "$totalout\n";

print "Inernet statistic for $ARGV[1] at time $ARGV[0] \n \n";

print "$req_addr Incoming IP trafic: ", $totalin, "\n";
print "$req_addr Outgoing IP trafic: ", $totalout,"\n";
print "\n";
print "Summary by IP:\n";
foreach $key (sort keys(%dh)) {
    foreach (split("\0", $dh{$key})) {
      ($out = $_);
format STDOUT =
@<<<<<<<<<<<<<<<<<<<<<<<<  == @>>>>>>>>>>>>>>>> bytes
$key,                              $out
.
write();
  }
}

print "\n";