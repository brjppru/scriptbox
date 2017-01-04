use strict;
use Digest::MD5 qw(md5_hex);
use DBI;

my $dsn='DBI:mysql:exim_db:192.168.2.7';
my $db_user='exim';
my $db_pass='exim_password!';
my $dbh=DBI->connect($dsn, $db_user, $db_pass)
    or die "Cann\'t connect to DB\n";

my $acc_file="c:\\Accounts.csv";
my $alias_file="c:\\Alias.dat";

open(ACFILE, $acc_file);
open(ALIASFILE, $alias_file);
my @line=<ACFILE>;
my @alias=<ALIASFILE>;

my @arr;
my @arr1;

my $login;
my $password;
my $mquota;
my $mdir;

my $sq

sub  sql_query
{
    my ($query)=@_;
    #print $query."\n";

    my $sth=$dbh->prepare($query);
    $sth->execute;
    $sth->finish;
}

print "Adding user accounts\n";

foreach my $s(@line)
{
    @arr=split(/,/, $s);
    if ($arr[0] =~ m/Email/g) {
        next;
    }
    $login=$arr[0];
    $password=$arr[5];
    
    $login =~ s/\"//g;
    $login =~ s/\@domain.ru//;
    
    if($arr[17]>0)
    {
        $mquota=$arr[17]/1000;
    } else { $mquota=0; }
    
    $sql=qq(INSERT INTO accounts(login, password, quota) VALUES("$login", $password, $mquota));
    sql_query($sql);
    print $login." added OK\n";
    
}

print "\nAdding aliases\n";

foreach my $s(@alias)
{
    @arr1=split(/ /, $s);
    $arr1[2] =~ s/\n//;
    
    $arr1[0] =~ s/\@domain.ru//;
    $arr1[2] =~ s/\@domain.ru//;
    
    my $goto=$arr1[2];
    my $address=$arr1[0];
    #print $goto."\n";
    
    $sql=qq(insert into aliases(address, goto) values('$address', '$goto'));
    sql_query($sql);
    print "Alias ".$address." => ".$goto." added OK\n";
}
