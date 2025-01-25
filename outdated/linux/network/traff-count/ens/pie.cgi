#!/usr/bin/perl -w

#use strict;
use CGI;
use GD::Graph::pie3d;
use DBI;

####$remote =param( "user_name" );
use constant TITLE => "traf stat for user ";

$dsn = "DBI:mysql:traf:localhost";
$user_name = "xxx";
$password = "xxx";
$dbh = DBI->connect ($dsn, $user_name, $password, { RaiseError => 1 } );
$sth = $dbh->prepare ("SELECT mb FROM billl WHERE login='$remote' ");
$sth->execute();
$trs = $sth->fetchrow_array;

$sth1 = $dbh->prepare ("SELECT traf FROM test WHERE login='$remote' ");
$sth1->execute();
$tr = $sth1->fetchrow_array;
$trr=$tr/1024;
$ch=int($trr/1024);

$sth->finish();
$sth1->finish();

$sum=$trs-ch;;
$q = new CGI;
$graph = new GD::Graph::pie3d( 200, 200 );
 @data = (
[     qw( na chetu  potracheno  ) ],
[               $sum ,          $ch          ],
);

$graph->set(
title   => TITLE,
'3d'    => 1
);

$gd_image = $graph->plot( \@data );
print $q->header( -type => "image/png", -expires => "-1d" );

binmode STDOUT;
print $gd_image->png;
