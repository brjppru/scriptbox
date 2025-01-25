#!/usr/bin/perl

sub parse_form {                                                                
        if ($ENV{'REQUEST_METHOD'} eq "POST") {$mode = 0}                       
        if ($ENV{'REQUEST_METHOD'} eq "GET") {$mode = 1}                        
        if ($mode == 0) {read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'})}          
        if ($mode == 1) {$buffer = $ENV{'QUERY_STRING'}}                        
        @pairs = split(/&/, $buffer);                                           
        foreach $pair ( @pairs ) {                                              
                ( $thisname, $thisvalue ) = split( /=/, $pair );                
                $thisvalue =~ tr/+/ /;                                          
                $thisvalue =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
                $FORM{ $thisname } = $thisvalue;                                
        }                                                                       
}                                                                               

sub sendmessage {
my ( $sendmail, $bounce_mailer, $send_str, $s ) = '';
	$sendmail = "/usr/sbin/sendmail";
	$bounce_mailer = "$sendmail";
	$send_str = "| ".$bounce_mailer." info\@vzletka.net";
	open ( FILE, $send_str );
	print FILE "From: info\@vzletka.net\n";
	print FILE "To: info\@vzletka.net\n";
	print FILE "Reply-To: info\@vzletka.net\n";
	print FILE "Content-Type: text/plain; charset=koi8-r\n\n";
	print FILE "Subject: Join request!\n\n";

	print FILE "$_[0] - www.vzletka.net";

	close (FILE);
}

# ==== ����� �������� ������ ���������! ====

&parse_form;               

print "Content-type: text/html\n\n";

$lastname = $FORM{'lastname'};
$firstname = $FORM{'firstname'};
$midname = $FORM{'midname'};

$street = $FORM{'street'};
$house = $FORM{'house'};
$building = $FORM{'building'};
$blabla = $FORM{'blabla'};
$flat = $FORM{'flat'};

$phone = $FORM{'phone'};
$misccontacts = $FORM{'misccontacts'};
$timetodie = $FORM{'timetodie'};
$addinfo = $FORM{'addinfo'};

#		   &errormessage($text);

$addr = defined $ENV{HTTP_X_FORWARDED_FOR} ? "$ENV{REMOTE_ADDR} / $ENV{HTTP_X_FORWARDED_FOR}" : $ENV{REMOTE_ADDR};
 
$text = "� ������ $addr �� ����� www.vzletka.net ���������� ������ �� �����������.

������� ��� ��������: $firstname $midname $lastname

������ �����: �����: $street ���: $house ��������/������: $building �������: $blabla ��������: $flat 

�������: $phone
������ ���������� ����������: $misccontacts
�����, � ������� ������� ����� � ���������: $timetodie

�������������� ����������: $addinfo

";

# print $text;

&sendmessage($text);

# &sendmessage($addr);

print <<EOF;                              
<html>
<head>
<meta http-equiv="refresh" content="5; url=/net/">
</head>
<body>

<center>���� ������ �������.
<br><br>
<a href=/net/>������� ���, ���� ��� ������� �� ������������ �������������� ���������������</a>

</body>
</html>
EOF
