#!/usr/bin/perl
use Mysql;

$dbhost="DBASE";
$dbname="traffic";
$dbuser="NAME";
$dbpass="XXXX";

($mday,$mon,$year)=(localtime(time))[3,4,5];
$year += 1900;
$mon++;
$dati = sprintf("%04d%02d%02d",$year,$mon,$mday);

$ipacct_path="/usr/local/ipacct/";
$loc_dat=$ipacct_path.$dati;
$RSH_4 = "ipfw show";
$RSH_5 = "ipfw -q zero";
$source="213.24.218.5";
%costs = '';

$trafdb = Mysql->connect($dbhost, $dbname, $dbuser, $dbpass) || die("Can't connect to SQLserver $dbhost.");
open(OUT,">>$loc_dat") || die("Can't open for write file $loc_dat.");

@rs4 = `$RSH_4`;
chomp(@rs4);
`$RSH_5`;
foreach $s (@rs4) {
    $s =~ /\d+\s+(\d+)\s+(\d+)\s+\w+\s+\w+\s+\w+\s+\w+\s+\w+\s+(\d+\.\d+\.\d+\.\d+)/;
    if ($2 > 0) {
      print OUT " $source  $3  $1  $2\n";
      $sth = $trafdb->query("INSERT INTO trafdb ( fromip , toip , dt , bts ) VALUES ( \"$source\" , \"$3\" , \"$dati\" , \"$2\" ) ");
      $sth = $trafdb->query("SELECT klId FROM ips WHERE ip LIKE \"$3\"");
      while($id = $sth->fetchrow){ $costs{$id} += $2 };
    };
};
close(OUT);

foreach $kl (sort (keys %costs)){
  next if ($kl eq '');
  $sth = $trafdb->query("UPDATE klients SET cost = cost+$costs{$kl} WHERE klId = $kl ") if ($costs{$kl}>0);
};

exit(0);
