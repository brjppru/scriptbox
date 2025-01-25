#!/usr/bin/perl

my $s = `tail -10 /var/log/napster/server.log`;

my ($libsize, $libmeter, $files, $users) = ($1, $2, $3, $4) if $s =~ /^update\_stats\:\slibrary\sis\s(\d{1,})\s(\w{1,})\,\s(\d{1,})\sfiles\,\s(\d{1,})\susers$/gm;

print "Content-type: text/html\n\n";

print <<EOF;
Даун сервер сейчас в эфире! Даун клиентов конкретно: $users человек.
Доступно целых дown-песен: $files, всего $libsize гигабайт.
EOF
