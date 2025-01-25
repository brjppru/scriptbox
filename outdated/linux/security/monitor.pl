#!/usr/bin/perl

## 
## Пинговалка, версия 0.0.1 бета. (ц) Рома Ю. Богданов
##

## для запуска с отладкой пользовать ключ --verbose

# @mail_list = ('admin1@vzletka.net', 'admin2@vzletka.net');
#@mail_list = ('brj@vzletka.net');

@mail_list = ('smsadmins@vzletka.net');


# Заигнорировать роутер, для пинга. Разуммется, если он не сможет 
# отпинговать, остальная фигня работать не будет

# @ignore = ('this machine's router's or gateway's ip');

@ignore = ();

# %routers = ('ip.to.check', 'имя машины',
#             '192.168.1.13, 'роутер боба марли',
#             '10.1.228.75', 'voice.ip.bogus.GW1.foo.bar');

%routers = ('80.255.136.37',	'internet-uplink-from-sibch',
	    );


%oops = ('127.0.0.1',	'oops web cache on core.vzletka.net');

%ts =   ('10.10.10.10',	'cabinet.vzletka.net');

%dns =  ('10.10.10.1',	'ns.vzletka.net');

%http = ('10.10.10.10',	'cabinet.vzletka.net',
	 '10.11.7.77', 'store.vzletka.net',
	 '10.11.7.80', 'mozg.vzletka.net'
	 );

%mail = ('10.10.10.2',	'mail.vzletka.net');

$lynx = '/usr/local/bin/lynx';
$telnet = '/usr/bin/telnet';
$sleep = '/bin/sleep';
$ping = '/sbin/ping';
$nslookup = '/usr/sbin/nslookup';
$sendmail = '/usr/sbin/sendmail -t';

## тело

if ($ARGV[0] eq '--verbose') { $verbose = '1'; }

if (! &check_ignore) {
  $all_problems = '';

  $all_problems .= &check_routers;
  $all_problems .= &check_terminal_servers;
  $all_problems .= &check_dns;
  $all_problems .= &check_http;
  $all_problems .= &check_mail;
  $all_problems .= &check_oops;

  if ($all_problems) { &mail_problem; }
}
exit;

sub check_ignore {

  foreach $ip (@ignore) {
    if ($verbose) { print "checking $ip\n"; }
    $result = `$ping -c 1 $ip 2>&1`;
    if ($result =~ /0 packets received/) {
      if ($verbose) { print "problem $ip\n"; }
      return 1;
    }
  }
  return 0;
}

sub check_routers {

  my $problem;
  foreach $ip (keys %routers) {
    if ($verbose) { print "ROUTER: $ip (@routers{$ip})\n"; }
    $result = `$ping -c 1 $ip 2>&1`;
    if ($result =~ /0 packets received/) {

	$result = `$ping -c 10 $ip 2>&1`;
        if ($result =~ /0 packets received/) {

	      $problem .= "ROUTER: $ip (@routers{$ip}) appears to have a problem.\n";
	      if ($verbose) { print "problem $ip\n"; }
	}
    }
  }
  return $problem;
}

sub check_terminal_servers {
  my $problem;
  foreach $ip (keys %ts) {
    if ($verbose) { print "TS: $ip (@ts{$ip})\n"; }
    $result = `$ping -c 1 $ip 2>&1`;
    if ($result =~ /0 packets received/) {
      $problem .= "TERMINAL SERVER: $ip (@ts{$ip}) appears to have a problem.\n";
      if ($verbose) { print "problem $ip\n"; }
    }
  }
  return $problem;
}

sub check_dns {
  my $problem;
  foreach $ip (keys %dns) {
    if ($verbose) { print "DNS: $ip (@dns{$ip})\n"; }
    $result = `$nslookup $ip $ip 2>&1`;
    if ($result =~ /Can\'t find server name/) {
      $problem .= "DNS: $ip (@dns{$ip}) timed out (can\'t find server name).\n";
    }
    elsif ($result =~ /can\'t find $ip: Non-existent host/) {
      $problem .= "DNS: $ip (@dns{$ip}) appears to have a problem.\n";
      if ($verbose) { print "problem $ip\n"; }
    }
  }
  return $problem;
}

sub check_http {
  my $problem;
  foreach $ip (keys %http) {
    if ($verbose) { print "HTTP: $ip (@http{$ip})\n"; }
    $results = `$lynx '$ip' -source -term=vt100 2>&1`;
    if (($results =~ /404 Not Found/) ||
      ($results =~ /Can\'t access startfile/)) {
      $problem .= "HTTP: $ip (@http{$ip}) appears to have a problem.\n";
      if ($verbose) { print "problem $ip\n"; }
    }
  } 
  return $problem;
}

sub check_mail {
  my $problem;
  foreach $ip (keys %mail) {
    if ($verbose) { print "MAIL: $ip (@mail{$ip})\n"; }
    $results =
          `(echo quit ; $sleep 3) | $telnet $ip 25 2>&1`;
    if (($results =~ /Connection refused/) ||
        ($results =~ /Unknown host/) ||
        ($results =~ /Unable to connect/) ||
        ($results =~ /Connection timed out/)) {
      $problem .= "MAIL: $ip (@mail{$ip}) appears to have a problem.\n";
      if ($verbose) { print "problem $ip\n"; }
    }
  }
  return $problem;
}

sub check_oops {
  my $problem;
  foreach $ip (keys %oops) {
    if ($verbose) { print "OOPS: $ip (@mail{$ip})\n"; }
    $results =
          `(echo quit ; $sleep 3) | $telnet $ip 3128 2>&1`;
    if (($results =~ /Connection refused/) ||
        ($results =~ /Unknown host/) ||
        ($results =~ /Unable to connect/) ||
        ($results =~ /Connection timed out/)) {
      $problem .= "OOPS: $ip (@oops{$ip}) appears to have a problem.\n";
      if ($verbose) { print "problem $ip\n"; }
    }
  }
  return $problem;
}

sub mail_problem {

  foreach $email_address (@mail_list) {

    if ($verbose) { print "mailing to $email_address\n"; }

    open (SENDMAIL, "| $sendmail");
    print SENDMAIL <<end_of_header;
To: $email_address
Subject: Network/Server Problem Report

end_of_header
    print SENDMAIL "$all_problems";
    close (SENDMAIL);
  }
}
