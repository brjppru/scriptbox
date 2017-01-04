#!/usr/bin/perl

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$mon++;
$year += 1900;

my @monname = ('','января','февраля','марта','апреля','мая','июня',
	'июля','августа','сентября','октября','ноября','декабря');
my @wekname = ('воскресенье','понедельник','вторник','среда','четверг','пятница','суббота');

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

# ==== здесь реальное начало скрипта! ====

&parse_form;               

$title = $FORM{'title'};     

# Сейчас за окном $mday $monname[$mon] $year г., $wekname[$wday]

print "Content-type: text/html\n\n";

print <<EOF;

<HTML>
  <HEAD>
    <TITLE>www.vzletka.net - $title</TITLE>
    <META http-equiv=content-type content="text/html; ">
  </HEAD>

<BODY bgColor="#FFFFFF" link="#0055CC" alink="#FF0000" vlink="#990099" text="#000000" leftMargin="0" topMargin="0" marginheight="0" marginwidth="0">

<style>
a.menu		{color: #000000;}
a.menu:hover	{color: #CC0000;}
</style>

<br>

<TABLE cellSpacing="0" cellPadding="0" width="100%" bgColor="#ffffff" border="0">
  <TBODY>                                                                       
    <TR>                                                                          
        <TD><IMG SRC="/images/logo.gif" border="0"></TD>                            
    </TR>                                                                         
</TBODY>                                                                        
</TABLE>                                                                        

<br>

<!-- start navigation -->
<TABLE cellSpacing="0" cellPadding="0" width="100%" bgColor="#eeeeee" border="0">
  <TBODY>
  
  <TR bgColor="#506DBF">
     <TD>&nbsp;</TD> <TD>&nbsp;</TD> <TD>&nbsp;</TD> <TD>&nbsp;</TD> <TD>&nbsp;</TD>
  </TR>

  <TR valign="top">
    <TD width="24%">&nbsp;</TD>
    <TD width="19%" align="left"><A href="/about/" class="menu">О компании</A></TD>
    <TD width="19%" align="left"><A href="/net/" class="menu">Сеть</A></TD>
    <TD width="19%" align="left"><A href="/service/" class="menu">Услуги</A></TD>
    <TD width="19%" align="left"><A href="/client/" class="menu">Пользователю</A></TD>
  </TR>

  <TR>
     <TD>&nbsp;</TD> <TD>&nbsp;</TD> <TD>&nbsp;</TD> <TD>&nbsp;</TD> <TD>&nbsp;</TD>
  </TR>

</TABLE>

<!-- menu & content -->

<br>

<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
  <TBODY>
  <TR>
    <TD vAlign=top width="24%">

      <!-- start menu -->
      <CENTER>
      <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
       <TBODY>
        <TR>
          <TD>&nbsp;</TD>
          <TD>

EOF

