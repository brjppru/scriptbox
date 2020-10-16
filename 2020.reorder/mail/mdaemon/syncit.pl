# imapsync
#!/usr/bin/perl

my $f_csv="imap_users.csv";

my $src="192.168.2.3";
my $dst="127.0.0.1";

open(CSV, $f_csv);

while(<CSV>) {
    chomp;

    my ($u1, $p1, $u2, $p2)=split(";");
    #print $p1."\n";
    print "Sync user $u1\n";
    my $r_sync=system("imapsync --debug --host1 $src --user1 $u1 --password1 $p1 --host2 $dst --user2 $u2 --password2 $p2");
}

close(CSV);

