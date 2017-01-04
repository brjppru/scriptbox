#!/usr/bin/perl -w
use Net::IPv4Addr qw(ipv4_in_network);
@interfaces=qw(fxp0 fxp1);
$path=`./savetraf.pl`;
#$path="/var/log/trafd";
$rbnet="62.76.138.0/23";
$burnet="212.0.64.0/19";
$bol="212.0.65.58/32";
$oip="212.0.73.106";
$intranet="192.168.0.0/24";
%Overall=();

sub SplitComma {
  my $var=shift; my @tmp=split("",reverse($var)); my $i=1; my $out="";
  foreach (@tmp) {
    $out.=$_; 
    if (($i%3==0) && ($i>=3) && ($i <= $#tmp)) {$out.=",";} 
    $i++;
  }
  $out=reverse($out); return($out);
}

sub ParseString{
  my ($from,$fromport,$to,$toport,$proto,$data,$al,$tmp);
  $tmp=shift;
  ($from,$fromport,$to,$toport,$proto,$data,$all)=split(/\s+/, $tmp);

  if      (ipv4_in_network($intranet, "$from/32")) {
            return("intranet",$to,$all);
  } elsif (($to eq $oip) && ($toport eq "701") 
    && (!ipv4_in_network($burnet, "$from/32"))
      && (!ipv4_in_network($rbnet, "$from/32"))) {
            return("buddyphone",$to,$all);
  } elsif (($to eq $oip) && ($toport eq "6112") 
    && (!ipv4_in_network($burnet, "$from/32"))
      && (!ipv4_in_network($rbnet, "$from/32"))) {
            return("brood",$to,$all);
  } elsif (($to eq $oip) && ($toport =~ /^2796\d$/) 
    && (!ipv4_in_network($burnet, "$from/32"))
      && (!ipv4_in_network($rbnet, "$from/32"))) {
            return("quake3",$to,$all);
  } elsif (($to eq $oip) && ($toport =~ /^2750\d$/) 
    && (!ipv4_in_network($burnet, "$from/32"))
      && (!ipv4_in_network($rbnet, "$from/32"))) {
            return("quake1",$to,$all);
  } elsif (ipv4_in_network($rbnet, "$from/32")) {
              return("rbnet",$to,$all);
  } elsif (ipv4_in_network($bol, "$from/32")) {
              return("bol",$to,$all);
  } elsif (ipv4_in_network($burnet, "$from/32")) {
              return("burnet",$to,$all);
  } else {
              return("other", $to, $all);
  }
}


foreach (@interfaces) {
open (STDOUT, ">$path/day.${_}.stats") || die "can't open stdout";
open (STDERR, "<$path/day.${_}.stats.err") || die "can't open stderr\n";
  my ($log,@tmp,$null,$stats,$summary,$type,@rv);
  $log=$path."/day.".$_;
  open (LOG, $log)||die"can't open $log: $!\n";@tmp=<LOG>;chomp(@tmp);close(LOG);
  $null=shift(@tmp); $stats=shift(@tmp); $summary=shift(@tmp); $null=shift(@tmp);
  foreach $i (0..$#tmp) {
    @rv=ParseString($tmp[$i]);
    if ($#rv<2) {warn "invalid return value \@rv\n"; next;}
    $type=shift(@rv);
    if ($type eq "other") {
      $Overall{$rv[0]}+=$rv[1];
    } elsif ($type =~ /^(rbnet|bol|burnet|buddyphone|brood|quake1|quake3)$/) {
      $Overall{$type}+=$rv[1];
    } elsif ($type eq "intranet") {
      #nafiga intranetovskii traffic schitat'?
    }
  }  
foreach (sort(keys %Overall)) {
  $ALL+=$Overall{$_};
  if ($Overall{$_}<1024) {
    print("$_ ",$Overall{$_}, " bytes\n");
  } elsif ($Overall{$_}<1024*1024) {
    print("$_ ",sprintf("%.2f",$Overall{$_}/1024), "Kb ",&SplitComma($Overall{$_}),"\n");
  } elsif ($Overall{$_}<1024*1024*1024) {
    print("$_ ",sprintf("%.2f",$Overall{$_}/1024/1024), "Mb ",&SplitComma($Overall{$_}),"\n");
  } else {
    print("$_ ",sprintf("%.2f",$Overall{$_}/1024/1024/1024), "Gb ",&SplitComma($Overall{$_}),"\n");
  }
}
print "\nCommerce traffic: ", $ALL-$Overall{bol}-$Overall{burnet}-$Overall{rbnet}," bytes\n";
$Overall{buddyphone}=0 unless $Overall{buddyphone};
$Overall{brood}=0 unless $Overall{brood};
print "\n\t--==Special ports==--
 BuddyPhone: $Overall{buddyphone} bytes
   Broodwar: $Overall{brood} bytes\n
     Quake1: $Overall{quake1} bytes\n
     Quake3: $Overall{quake3} bytes\n";

print "\nOverall traffic: ", &SplitComma($ALL), " bytes\n";
undef(%Overall);
undef($ALL);
close STDOUT;
close STDERR;
}
