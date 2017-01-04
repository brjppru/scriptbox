#!/usr/bin/perl -w

use strict;

my $url;
my $host;

while(<>)
{
	if(/GET\s+(\S+)/) { $url=$1; }
	if(/Host:\s+(\S+)/) { $host=$1; }
	last if /^\s*$/;
}

print<<EOF;
HTTP-1.1 503 Service Unavailable
Content-type: text/html
Retry-After: 3600

<html>
<head>
  <title>Temporarily unavailable</title>
</head>
<body>
  <h1>Temporarily unavailable</h1>
  <p>The Website <b>$host</b> is currently unaccessible due to maintainance. Please try again in 60 minutes.</p>
</body>
</html>
EOF

exit 0;
