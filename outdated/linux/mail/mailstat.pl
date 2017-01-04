#!/usr/bin/perl -w

#/etc/crontab
#run script every day at 8.58 AM
#58     8       *       *       *       root    /usr/local/etc/bin/postfix/mail_traf.pl >/dev/null 2>&1
#/etc/newsyslog.conf:
#backup maillog every day at 9.00 AM
#/var/log/maillog                       644  7     *    $D9   Z

open MLOG, "/var/log/maillog"; @MLOG=<MLOG>; close MLOG;

open PFC, "/usr/local/etc/postfix/main.cf";

while (<PFC>) {
  if (m!^mydestination = (.+)$!) {
    %mydomains=map {$_=>1;} (split ",", $1);
    last;
  };
}
%mydomains=map {$_=~s/\s+//g; $_=>1} keys %mydomains;
close PFC;

foreach $i (0..$#MLOG) {
  if ($MLOG[$i] =~ m! from=<.*?>, size=(\d+)!) {
    $size=$1;
    if ($MLOG[++$i] =~ m!to=<([^>]+)>!) {
      ($user,$host)=split('@', $1);
      warn "$user : $host\n";
      if (defined $host && exists $mydomains{$host}) {
        $MAILTRAF{$user}+=$size;
      } elsif (defined $host) {
        next; # outgoing mail
      } else {
        next; # local mail
      }
    }
  } else {
    next;
  }
}
map {$a.="$_: $MAILTRAF{$_}\n"; $All+=$MAILTRAF{$_}} sort keys %MAILTRAF;
$a.="\nOverall: $All";

@mails=qw(alchie);

SendMail($a, 'postfix@rbcom.ru', 'Mail Traffic for Last Day', @mails);

sub SendMail {
  my ($text_to_send,$from_mail,$subj,$to_mail, @to_mails)=@_;
  open (MAIL, "|sendmail -t");
  print MAIL "To: $to_mail\n";
  print MAIL "Return-Path: \<$from_mail\>\n";
  print MAIL "From: $from_mail\n";
  print MAIL "Bcc: @to_mails\n";
  print MAIL "Subject: $subj\n\n";
  print MAIL $text_to_send;
  print MAIL "";
  close(MAIL);
};
