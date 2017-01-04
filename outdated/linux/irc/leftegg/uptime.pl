# Copyright (c) Eugen J. Sobchenko // ejs@paco.net

BEGIN {
    push (@publ_exp, 'get_up::^\s*.?uptime\s*$');
}
sub get_up {
    my ($text, $channel, $r_nick, $r_mask) = @_;
    my $uptime = `/usr/bin/uptime`;
    chop($uptime);
    chomp($uptime);
    irc_msg($channel, "$r_nick, $uptime");
}
1;
