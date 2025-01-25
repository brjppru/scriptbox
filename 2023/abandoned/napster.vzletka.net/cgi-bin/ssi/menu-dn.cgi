#!/usr/bin/perl

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$mon++;
$year += 1900;

my @monname = ('','������','�������','�����','������','���','����',
	'����','�������','��������','�������','������','�������');
my @wekname = ('�����������','�����������','�������','�����','�������','�������','�������');

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

$root_open = "v";
$server_open = "v";
$faq_open = "v";
$client_open = "v";
$login_open = "v";

if ( $menu eq "root"   ) { $root_open="r";  }
if ( $menu eq "server" ) { $server_open="r"; }
if ( $menu eq "faq"    ) { $faq_open="r"; }
if ( $menu eq "client" ) { $client_open="r"; }
if ( $menu eq "login"  ) { $login_open="r"; }

print "Content-type: text/html\n\n";


############################ DRAW MENU ############################


# Menu DOWN
print <<EOF;

    <table cellspacing=0 cellpadding=0 border=0 width=100%><tr valign=top>
    <td class=b2><img src=/o.gif width=200 height=1><br>
      <table cellspacing=0 cellpadding=0 border=0 width=100%>
      <tr valign=top>
       <form method=get action=/login/>
       <td><img src=/o.gif width=22></td>
       <td class=w><input type=text name=username size=14 class=f><br>
       <input type=password name=password size=14 class=f><br>
       <img src=/o.gif height=1><br>����� ����� / ������<br></td>
       <td align=right width=100% class=w><input type=submit name=login value="ENTER&nbsp;&nbsp;" class=fs><br>
       <input type=submit name=login value="�OWN&nbsp;&nbsp;" class=fn>
       </td></tr></form>
      </table></td>
      <td><img src=/o.gif width=7></td>
      <td width=100%><table cellspacing=0 cellpadding=0 border=0 width=100%><tr class=b0>
      <td colspan=3><img src=/o.gif height=1></td></tr><tr class=s>
      <td><img src=/o.gif width=5 height=30></td>
      <td>��������� &copy; 2004 DOWN�����<sup><font style="font-size:9">TM</font></sup></td>
      <td align=right>��� ����� ��� �������. ����� ����� � �����!</td></tr><tr class=b0>
      <td colspan=3><img src=/o.gif height=1></td></tr><tr class=s>
      <td><img src=/o.gif width=5 height=30></td>
      <td>������ ������������� ��</td>
      <td align=right>��� P4-3.2 c 1 �� ������ � 120Gb HDD</td></tr><tr class=b0>
      <td colspan=3><img src=/o.gif height=1></td></tr><tr class=s>
      <td><img src=/o.gif width=5 height=30></td>
      <td>���� � ���-������ : <a href=http://brj.vzletka.net/>�����</a></td>
      <td align=right>����������� ��������� : <a href=http://brj.vzletka.net/>DOWN�����</a></td></tr><tr class=b0>
      <td colspan=3><img src=/o.gif height=1></td></tr></table></td></tr></table>
      <img src=/o.gif height=7><br>

      <table cellspacing=0 cellpadding=0 border=0 width=100%><tr valign=bottom>
      <td><img src=/o.gif width=200 height=1></td>
      <td><img src=/o.gif width=7 height=70></td>
      <td align=center width=100% class=b1><table cellspacing=0 cellpadding=0 border=0 width=90%><tr>
	<td nowrap><img src=/$root_open.gif width=20 height=15 align=absmiddle><a href=/root/ class=m>����-������</a></td>
	<td nowrap><img src=/$server_open.gif width=20 height=15 align=absmiddle><a href=/server/ class=m>����-������</a></td>
	<td nowrap><img src=/$faq_open.gif width=20 height=15 align=absmiddle><a href=/faq/ class=m>����-�������</a></td>
	<td nowrap><img src=/$client_open.gif width=20 height=15 align=absmiddle><a href=/client/ class=m>����-������</a></td>
	<td nowrap><img src=/$login_open.gif width=20 height=15 align=absmiddle><a href=/login/ class=m>����-����</a></td>
      </tr></table></td></tr></table>

</body>
</html>
EOF
