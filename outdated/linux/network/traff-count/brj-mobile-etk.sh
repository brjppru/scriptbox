#!/usr/bin/perl

$req_addr = "brj.mobile";

open FILE, "/usr/tmp/1.log";

$totalin = 0;
$totalout= 0;

while (<FILE>) {
  tr/ / /s;
  ($add1,$FP,$add2,$TP,$proto,$totdata,$totsize) = split(/ /,$_);

  if ($add1 =~ $req_addr) {
   $totalin += $totsize;
   $dh{$add2} += $totsize;
  }

  if ($add2 eq $req_addr) {
   $totalout += $totsize;
   $dh{$add1} += $totsize;
  }
}
close FILE;

# result print

print "brj\@\mobile statistic \n \n";
print "Incoming IP trafic: ", $totalin, "\n";
print "Outgoing IP trafic: ", $totalout,"\n";
print "\n";
print "Summary bu hosts:\n";
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

