#!/usr/bin/perl -wT
#

use strict;
$ENV{PATH} = "/usr/bin";

# де сындмыл?
my( $sendmail ) = "/usr/sbin/sendmail";

# Де живем?
my( $homedir ) = "/etc/mail/lmmm";
my( $userlist ) = $homedir . "/users";

# Кто админ?
my( $listadmin ) = "r.bogdanov\@sibttk.ru";

# от кого будут сыпаться мессаги? alcha
my( $from_mail ) = 'r.bogdanov\@sibttk.ru';

# Это поставить больше нуля, если подписчик сам подписан
my( $approved ) = 0;

# хуета всякая
my( $sender, $errormsg, $message, $data );
my( @real_recipients );

# послать в жопу тех. кто не подписан.
my( $denymsg ) = "
Вы не фига не админ этого списка рассылки.
Поэтому больше не присылайте сюда писем. Ибо нефик.

И помните, сообщение, что вы пытались отослать письмо не имея на это прав, 
уже отправленно администратору.

Рассылатель почты. Версия 0.1. by Roman Y. Bogdanov
"; 

if( ! -x $sendmail ) {
  die "Sendmail is not executable or does not exist\n";
}

open( USERS, $userlist ) || ( $errormsg .= "o Could not open $userlist\n"
);
while( <USERS> ) {
  s/(\r|\n|\s)+$//;
  s/(\r|\n|\s)//gs;
  s/^#.*$//;
  next if( /^$/ );
  $data = $_;
  if( $data =~ /^([-a-zA-Z0-9_.@]+)$/ ) {
#  if( $data =~ /^([\w.@-]+)$/ ) {
    $data = $1; #зачем ваще эта строка???
    push( @real_recipients, $1 );
  } else {
    $errormsg .= "o Address $data in $userlist is broken\n";
  }
}
close( USERS );

my $body="";
while( <> ) {
#  if( /^From ([-_a-zA-Z0-9\.]+@[-_a-zA-Z0-9\.]+) .+$/  && ! $sender ) {
  if( /^From ([\w\.-]+@[\w\.-]+)\s+.+$/  && ! $sender ) {
    $sender = $1;
    next;
  }
  $body++ if /^$/;
  s/^\.$/. /;
  s/\/r//;
  $message .= $_ if $body;
}

if( $sender ) {
#  my( $recipient );
  foreach my $recipient( @real_recipients ) {
    if( $recipient eq $sender ) {
      $approved++;
    } 
  }
} else {
  $errormsg .= "o Unable to find the sender or\n";
  $errormsg .= "  sender address did not match regexp\n";
}

if( $approved && ! $errormsg ) {
  open( MAIL, "|$sendmail -t" );
  print MAIL "From: $from_mail\n";
  print MAIL "To: ${\(shift @real_recipients)}\n";
  print MAIL "Bcc: ${\(join ',', @real_recipients)}\n\n";
  print MAIL $message;
  close( MAIL );
} else {
  $errormsg .= "o Denied $sender from sending to the list\n";
  open( DENY, "|$sendmail -t" );
  print DENY "From: $from_mail\n";
  print DENY "To: $sender\n\n";
  print DENY $denymsg;
  close( DENY );
}

if( $errormsg ) {
  open( MAILADMIN, "|$sendmail -t" );
  print MAILADMIN "From: $from_mail\n";
  print MAILADMIN "To: $listadmin\n\n";
  print MAILADMIN "The following errors have occured:\n\n$errormsg";
  close( MAILADMIN );
}
