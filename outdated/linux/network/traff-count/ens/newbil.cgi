#!/usr/bin/perl
# cgi тулзина для отображения статистики за день,балланса денег etc.

use DBI;
use HTML::Template;

use constant TMPL_FILE => "$ENV{DOCUMENT_ROOT}/loginsql.tmpl";
$tmpl = new HTML::Template( filename => TMPL_FILE );
$dsn = "DBI:mysql:traf:localhost";
$user_name = "xxx";
$password = "xxx";
$remote=$ENV{REMOTE_USER};
$dbh = DBI->connect ($dsn, $user_name, $password, { RaiseError => 1 } );
$sth = $dbh->prepare ("SELECT tarif,login,abonetka,cenameg,prev,dogovor,mb,mail,money FROM billl WHERE login='$remote' ");
$sth->execute();

   while (@ary = $sth->fetchrow_array())
{
$cenameg=join ("\t", $ary[3]), "\n";
$login=join ("\t", $ary[1]), "\n";
$tarif=join ("\t", $ary[0]), "\n";
$abone=join ("\t", $ary[2]), "\n";
$prev=join ("\t", $ary[4]), "\n";
$dog=join ("\t", $ary[5]), "\n";
$mb=join ("\t",$ary[6]), "\n";
$mail=join ("\t",$ary[7]), "\n";
$money=join ("\t",$ary[8]), "\n";
}

$sth1 = $dbh->prepare ("SELECT traf FROM test WHERE login='$remote' ");
$sth1->execute();
$tr = $sth1->fetchrow_array;
$day=sprintf("%.2f",$tr/1024) ;

$tmpl->param( previ_data => $prev );
$tmpl->param( megi_data => $cenameg );
$tmpl->param( login_data => $login );
$tmpl->param( abone_data => $abone );
$tmpl->param( tarif_data => $tarif );
$tmpl->param( ballans_data => $money );
$tmpl->param( traf_data => $day );
$tmpl->param( dogovor_data => $dog );
$tmpl->param( mail_data => $mail );
$tmpl->param( mb_data => $mb );

print "Content-type: text/html\n\n",
$tmpl->output;

