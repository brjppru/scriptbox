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

# ==== ����� �������� ������ �������! ====

&parse_form;               

$menu = $FORM{'menu'};     

$about_open = 0;
$net_open = 0;
$service_open = 0;
$client_open = 0;

if ( $menu eq "about"   )   { $about_open=1;   }
if ( $menu eq "net"     )   { $net_open=1;     }
if ( $menu eq "service"   ) { $service_open=1; }
if ( $menu eq "client"   )  { $client_open=1;  }

print "Content-type: text/html\n\n";

############################ DRAW MENU ############################

# Menu about

print"<b><A HREF=\"/about/\" class=\"menu\">� ��������</a></b><br>\n";

if ( $about_open eq 1 ) { 
    print <<EOF;

    &nbsp;&nbsp;&nbsp;<A href="/about/news/" class="menu">�������</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/license/" class="menu">��������</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/pr/" class="menu">�����-�����</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/jobs/" class="menu">��������</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/contact/" class="menu">���� ����������</A><BR>
EOF
} 

print"<b><A HREF=\"/net/\" class=\"menu\">����</a></b><br>\n";

if ( $net_open eq 1 ) { 
    print <<EOF;

	&nbsp;&nbsp;&nbsp;<A href="/net/" class="menu">��� ���� ��</A><BR>               
	&nbsp;&nbsp;&nbsp;<A href="/net/ap/" class="menu">��������� �����������</A><BR>
	&nbsp;&nbsp;&nbsp;<A href="/net/join/" class="menu">������ �� �����������</A><BR>        
	&nbsp;&nbsp;&nbsp;<A href="/net/serv/" class="menu">��� ���������</A><BR>        
	&nbsp;&nbsp;&nbsp;<A href="/net/card/" class="menu">������� �����</A><BR>        

EOF
} 

print"<b><A HREF=\"/service/\" class=\"menu\">������</a></b><br>\n";

if ( $service_open eq 1 ) { 
    print <<EOF;

    &nbsp;&nbsp;&nbsp;<A href="/service/internet/" class="menu">������ � ��������</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/service/vpn/" class="menu">IP VPN</A><BR>                
    &nbsp;&nbsp;&nbsp;<A href="/service/price/voip/" class="menu">IP ���������</A><BR>                
    &nbsp;&nbsp;&nbsp;<A href="/service/price/" class="menu">����</A><BR>          
    &nbsp;&nbsp;&nbsp;<A href="/service/pay/" class="menu">��� ��������</A><BR>          

EOF
} 


print"<b><A HREF=\"/client/\" class=\"menu\">������������</a></b><br>\n";

if ( $client_open eq 1 ) { 
    print <<EOF;

      &nbsp;&nbsp;&nbsp;<A href="http://cabinet.vzletka.net/" class="menu">������ �������</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="http://fs.vzletka.net/" class="menu">FTP �����</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="http://forum.vzletka.net/" class="menu">����� ����</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="/client/chat/" class="menu">������� ���</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="/client/faq/" class="menu">������� � ������</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="/client/links/" class="menu">�������� ������</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="http://games.vzletka.net/" class="menu">����</A><BR>
EOF
}
