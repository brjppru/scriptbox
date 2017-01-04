#print "Set Alt + NumLock\033[?1035h\n";

# k0..k9
CL::addkey("\033O" . chr($_ + ord('p')), "k" . chr($_ + ord('0'))) for 0..9;
#CL::addkey("\033[" . chr($_ + ord('p')), "k" . chr($_ + ord('0'))) for 0..9;

# mod-Fx
my @metaname = ("S", "M", "S-M", "C", "S-C", "C-M", "S-M-C");

for my $mod (2..8) {
    CL::addkey("\033O${mod}".  chr($_ + ord('P') - 1), ${metaname}[$mod - 2] ."-f". $_ ) for 1..4;
    CL::addkey("\033[". scalar $_+10 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 5;
    CL::addkey("\033[". scalar $_+11 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 6..10;
    CL::addkey("\033[". scalar $_+12 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 11..12;
}

1;
