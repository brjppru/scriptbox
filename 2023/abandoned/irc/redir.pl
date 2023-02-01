#!/usr/bin/perl
use IO::Socket;
use IO::Select;
use Lingua::RU::Charset qw(:CONVERT);

if ($#ARGV != 1) {
print "Usage: redirect.pl <remoteip> <remoteport>\n";
exit 0;
}

my $target = $ARGV[0];
my $target_port = $ARGV[1];


my $Msg;

# Create a local socket
$sock1 = new IO::Socket::INET(LocalPort=>25601,
  Proto=>'tcp',Listen=>5,Reuse=>1) || die "$!\n";
  
while (1) {
  
  # Accept a connection
  $IS = $sock1->accept() || die;
  
  # Open a socket to the remote host
  $OS = new IO::Socket::INET(PeerAddr=>$target,
                             PeerPort=>$target_port,
                             Proto=>'tcp') || die;
  $RECODE{$OS}=\&win2koi;
  $RECODE{$IS}=\&koi2win;
 
  # Create a read set for select()
  $rs = new IO::Select();
  $rs->add($IS,$OS);
  
  $finished = 0;
  
  while(! $finished) {
    ($r_ready) = IO::Select->select($rs,undef,undef,undef);
  
    foreach $i (@$r_ready) {
      $o = $OS if $i == $IS;
      $o = $IS if $i == $OS;
  
      recv($i,$Msg,8192,0);
      if (! length $Msg) {
        $finished=1;
        close $IS; close $OS;
#warn "finished\n";
        last;
      }
      ($Msg)=$RECODE{$i}->($Msg);
      send($o,$Msg,0);
    }
  }
}
