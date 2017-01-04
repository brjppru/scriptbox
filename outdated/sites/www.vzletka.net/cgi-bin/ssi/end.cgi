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


         </TD>

         <TD width="100%">&nbsp;</TD>

       </TR>
       </TBODY>
       </TABLE>
       <!-- end contenttable -->

    </TR>
</TABLE>
<!-- menu & content -->

<br>

<!-- start footer -->
      <TABLE cellSpacing=0 cellPadding=0 width=100% bgColor=#ffffff border=0>
        <TBODY>
        <TR>
          <TD width="5%">&nbsp;</TD>
	  <TD>
          &copy 2002 <A href="http://www.vzletka.net/">vzletka.net</A> | 
          <A href="/about/contact/">Наши координаты</A>
          </TD>
        </TR>
	</TBODY>
	</TABLE>

<!-- end footer -->
</BODY>
</HTML>

EOF
