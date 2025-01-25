

while (<>) {
    if (/\[([^\]]+)\]\s+logged\s+in,\s+come\s+from\s+([^. ]+)([. ].+)$/) {
        my ($user,$host)=($1,$2);
        print "$user from $host$3\n" if (defined $user && defined $host
                                                          && $user ne $host);
    }
}
                                                        