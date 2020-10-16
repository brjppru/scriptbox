#!/usr/bin/perl

use strict;
use IO::Handle;
use IO::Socket;

# Program variables.
my (%CFG);
my (@CHANNELS, @SERVERS);
my ($IRC);

$|++; # turn off output buffering

&main;

# parsing configuration file. (default egg.cfg)
sub Parse_Config {
  my $file = shift;
  STATUS("Parsing $file...");
  if (-e $file) {
	open(CONFIG, "<$file") || ERR("can't open config file for reading");
	while (<CONFIG>) {
	  chomp;
	  next if /^\s*\#/;
	  next unless /\S/;
	  my ($key, $value) = split(/\s+/, $_, 2);
	  $value =~ s/(\$(\w+))/$CFG{$2}/g;
	  $CFG{$key} = $value;
	}
	close(CONFIG);
	return %CFG;
  } else {
	ERR("$file not found");
  }
}

# parsing %CFG hash
sub Parse_CFG_HASH {
  # checking if all important variables defined
  ERR("nick value is nod defined") unless defined($CFG{nick});
  ERR("servers value is not defined") unless defined($CFG{servers});
  ERR("channels value is not defined") unless defined($CFG{channels});
  ERR("ircname value is not defined") unless defined($CFG{ircname});
  ERR("username value is not defined") unless defined($CFG{username});
  foreach my $k (sort keys %CFG) { chomp $CFG{$k}; }
  # creating arrays for servers and channels
  push @CHANNELS, split(/\s+/, $CFG{channels});
  push @SERVERS, split(/\s+/, $CFG{servers});
}

# this sub logging events to logdir/event.log

# this if fatal error
sub ERR {
  my $err = shift;
  print STDERR "Error: " . $err . "\n";
  exit(0);
}

# this displays arguments to STDOUT
sub STATUS {
  my $text = shift;
  print STDOUT "$text" . "\n";
}

# this connects to irc server
sub Connect_to_IRCd {
  my $REPLY = undef;
  my ($SERVER, $PORT) = split ":", $SERVERS[0];
  STATUS("Connecting to $SERVER:$PORT...");
  $IRC = IO::Socket::INET->new(PeerAddr  => $SERVER,
							   PeerPort  => $PORT,
							   Proto     => 'tcp');

  STATUS("can't connect to $SERVER:$PORT") unless ($IRC);
  $IRC->autoflush(1);
  # this registering on ircd
  IRCD_RAW_OUT("NICK", "$CFG{nick}");
  IRCD_RAW_OUT("USER", "$CFG{username} foo bar :$CFG{ircname}");

  foreach (@CHANNELS) {
	IRCD_RAW_OUT("JOIN", "$_");
  }
  return 1;
}

sub CHECK_REPLY {
  chomp(my $REPLY=shift);
  my ($A, $SrvMsg, @Args) = split ":", $REPLY;
  my $TEXT = join ":", @Args;
  $TEXT =~ s/[\n\r]//g;
  my ($R_NICK, $R_HOST);
  my @BIT;
  
  # now checking
  if ("PING" eq substr $A, 0, 4) {
	# pings are important!
	IRCD_RAW_OUT("PONG", "$SrvMsg");
  } else {
	# seems like this shit is not ping, parsing...
	@BIT = split(/\s+/, $SrvMsg);
	$R_NICK = (split "!", $SrvMsg)[0];
	($R_HOST = $1) if ($SrvMsg =~ /\S+!(\S+\@\S+)\s+.+\s*$/);
  }
  
  if ($BIT[1] eq "PRIVMSG") {
	my $TO = lc $BIT[2];
	# regular mesg
	if ($TEXT =~ /[!]uptime/i) {
	  my $ppp_status = get_ppp_status();
	  IRC_MSG($TO, $ppp_status);
	}
  }
}

# messager
sub IRC_MSG {
  my ($TO, $TEXT) = @_;
  IRCD_RAW_OUT("PRIVMSG", "$TO :$TEXT");
}

# prints arguments to server
sub IRCD_RAW_OUT {
  my ($WHAT, $ARGS) = @_;
  print $IRC "$WHAT $ARGS" . "\n";
}

sub get_ppp_status {
#  my $PPP = `/sbin/ifconfig | /usr/bin/grep ppp0`;
   my $PPP = `/usr/bin/uptime`;

   return $PPP;

#  if ($PPP =~ m/.*UP.*RUNNING.*/) {
# return "interface ppp0 up and running ;-)";
#  } else {
# return "interface ppp0 is not running ;-(";
#  }
}

# MAIN Energizer!
sub main {
  my $REPLY;
  # this checking arguments of command line. if defined and file
  # exists - running Parse_Config() with argument from command line.
  if (defined($ARGV[0])) {
	Parse_Config($ARGV[0]);
	&Parse_CFG_HASH; # CFG hash reparse
  } else {
	Parse_Config("config");
	&Parse_CFG_HASH; # CFG hash reparse
  }
	Connect_to_IRCd();
	STATUS("Going to background!");
	fork && exit(0);
	while (defined($REPLY = <$IRC>)) {
	  CHECK_REPLY($REPLY);
	}
	close $IRC;
}

# eof
