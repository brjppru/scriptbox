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

$title = $FORM{'title'};     

# ������ �� ����� $mday $monname[$mon] $year �., $wekname[$wday]

print "Content-type: text/html\n\n";

print <<EOF;
	  
	  </TD>
	</TR>
       </TBODY>
      </TABLE>
      </CENTER>
      <!-- end menu -->

    </TD>

    <TD vAlign="top" width="76%">

      <!-- start contenttable -->

      <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
        <TBODY>
        <TR>
 
    <!-- start content -->
         <TD width="3%">&nbsp;</TD>

         <TD vAlign="top" width="94%">


EOF
