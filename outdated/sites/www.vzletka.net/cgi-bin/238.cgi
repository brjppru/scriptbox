#!/usr/bin/perl

use strict;

print "Content-type: text/html\n\n"; 

my @arr = (); 

$arr[0] = 'podarok.gif'; 
$arr[1] = '500r.gif'; 

print "<img src=/238/$arr[int(rand(2))] border=1>";




