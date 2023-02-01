# Creating CSV file for imapsync
#

#!//usr/bin/perl

use strict;
use DBI;

my $dsn="DBI:mysql:exim_db:localhost";
my $db_user="exim";
my $db_password="exim_password";

my $dbh=DBI->connect($dsn, $db_user, $db_password) or die "Cannt connect to DB";

my $f_csv="imap_users.csv";

open(CSV, ">".$f_csv);

my $sql="select login, password from accounts";
my $result=$dbh->prepare($sql);

$result->execute;

while ((my $login, my $password)=$result->fetchrow_array) {
    print CSV $login.";".$password.";".$login.";".$password."\n";
}

print "File $f_csv is created\n";
close(CSV);

$result->finish;
