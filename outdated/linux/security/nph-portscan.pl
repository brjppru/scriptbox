#!/usr/bin/perl
# Installing:
#   Rename file to "nph-portscan.pl" (without the quotes :)
# Usage:
#   nph-portscan.pl?host=(hostname)&port=(start port)-(end port)&opt=display:(open, close or all)-banner:(yes or no)-timeout:(connection timeout(10 recumended))-sleep:(time to sleep betwen close and open(recumended is 0)-os:(yes or no)


$| = 1;
print "$ENV{'SERVER_PROTOCOL'} 200 OK\n";
print "Server: $ENV{'SERVER_SOFTWARE'}\n";
print "Content-type: text/plain\r\n\r\n";

use CGI qw(:standard);
use Socket;

my $port = param('port');
my $host = param('host');
my $opt  = param('opt');

$display = "open";
$banner  = "no";
$timeout = 10;
$sleep   = 0;
$os      = "no";

if($opt ne "") {
 @options = split(/-/,$opt);
 foreach $option (@options) {
  ($name,$value) = split(/:/,$option); 
  $value =~ tr/+/ /;
  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $value =~ s/~!/ ~!/g;
  $value =~ s/<([^>]|\n)*>//g;
  $value =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"\n])/\\$1/g;
  $FORM{$name} = $value;
 }
 if($FORM{'display'} ne "") {
  $display   = $FORM{'display'}; }
 if($FORM{'banner'} ne "") {
  $banner    = $FORM{'banner'}; }
 if($FORM{'timeout'} ne "") {
  $timeout   = $FORM{'timeout'}; }
 if($FORM{'sleep'} ne "") {
  $sleep     = $FORM{'sleep'}; }
 if($FORM{'os'} ne "") {
  $os      = $FORM{'os'}; }
}

($sport,$eport) = split(/-/,$port);

if($os eq "yes") {
 print "Scanning $host";
 osscan();
 print " from $sport to $eport\n"; }

else {
 print "     Scanning $host($port)\n"; }

print "\n------------------------------------";
if($banner eq "yes") {
 print "-------------------------------"; }
print "\n";

if($sport > $eport) {
 print "Error in ports";
 die; }

if($eport > 1024) {
 print "You may only scan to 1024";
 die; }
 
if($port eq "") {
 print "No ports defined";
 die; }

if($host eq "") {
 print "No host defined";
 die; }

print "  Addr";
@letter = split(//,$host);
foreach $let (@letter) {
 print " "; }
print "Port     Status";
if($banner eq "yes") {
 print "       Banner"; }
print "\n------------------------------------";
if($banner eq "yes") {
 print "-------------------------------"; }
print "\n";

($name,$aliases,$type,$len,$addr) = gethostbyname($host);
$sockaddr = "S n a4 x8";
while($sport < $eport+1) {
 $them = pack($sockaddr, &AF_INET, $sport, $addr);
 socket(SOCK, &AF_INET, &SOCK_STREAM, $proto) || die print("Can't open socket.");
 if(connect(SOCK, $them)) {
  local $SIG{ALRM} = sub { close(SOCK); } ;
  alarm $timeout;
  $reply = "";
  if($banner eq "yes" && ($display eq "open" || $display eq "all")) {
    recv(SOCK, $reply, 90, $timeout);
    chomp($reply);
    $reply =~ s/\n//g;
   }
  alarm 0;
  if($display eq "open" || $display eq "all") {
   print " $host     ";
   space($sport);
   print "open"; 
   if($banner eq "yes") {
    print "         $reply"; }
   print "\n";
  }
 }
 else {
  if($display eq "all" || $display eq "close") {
   print " $host     ";
   space($sport);
   print "close\n"; }
 }
 $sport++;
 close(SOCK);
 if($sleep ne 0) {
 sleep($sleep); }
}

sub space {
 $sport = shift(@_);
 print "$sport";
 if($sport < 10) {
  print "        "; }
 if($sport < 100 && $sport >= 10) {
  print "       "; }
 if($sport < 1000 && $sport >= 100) {
  print "      "; }
 if($sport < 1024 && $sport >= 1000) {
  print "     "; }
}

sub osscan {
 $answer = "?";
 $| = 1;
 ($name,$aliases,$type,$len,$addr) = gethostbyname($host);
 $sockaddr = "S n a4 x8";
 $them = pack($sockaddr, &AF_INET, 80, $addr);
 socket(SOCK, &AF_INET, &SOCK_STREAM, $proto);
 connect(SOCK, $them);
 alarm 10;
 local $SIG{ALRM} = sub { close(SOCK); } ;
 select(SOCK);
 $| = 1;
 select(STDOUT);
 print SOCK "HEAD /index.html HTTP/1.0\r\n";
 print SOCK "\r\n";
 @reply = <SOCK>;
 close(SOCK);
 foreach $line (@reply) {
  if($line =~ m/nix/ig ||
     $line =~ m/nux/ig) { $answer ="Unix"; }
  if($line =~ m/IIS/ig ||
     $line =~ m/Microsoft/ig) { $answer ="Windows"; }
  if($line =~ m/BSD/ig) { $answer ="Berkeley Unix"; }
  if($line =~ m/Red-Hat/ig ||
     $line =~ m/RedHat/ig) { $answer ="Redhat"; }
  if($line =~ m/Debian/ig) { $answer ="Debian"; }
  if($line =~ m/SuSE/ig) { $answer ="SuSE"; }
  if($line =~ m/Mandrake/ig) { $answer ="Linux Mandrake"; }
 }

 $them = pack($sockaddr, &AF_INET, 21, $addr);
 socket(SOCK, &AF_INET, &SOCK_STREAM, $proto);
 connect(SOCK, $them);
 alarm 10;
 local $SIG{ALRM} = sub { close(SOCK); } ;
 select(SOCK);
 $| = 1;
 select(STDOUT);
 print SOCK "SYST\r\n";
 @reply = <SOCK>;
 foreach $line (@reply) {
  if($line =~ m/Sun/ig ||
     $line =~ m/SUNOS/ig ||
     $line =~ m/SunOS/ig) { $answer = "Solaris"; }
  if($line =~ m/Red-Hat/ig ||
          $line =~ m/RedHat/ig) { $answer ="Redhat"; }
  if($line =~ m/Debian/ig) { $answer ="Debian"; }
  if($line =~ m/SuSE/ig) { $answer ="SuSE"; }
  if($line =~ m/Mandrake/ig) { $answer ="Linux Mandrake"; }
  if($line =~ m/BSD/ig) { $answer ="Berkeley Unix"; }
 }
 print "($answer)";
}

print "\n------------------------------------";
if($banner eq "yes") {
 print "-------------------------------"; }
print "\n";
print "          Scanning ready.\n";
die

