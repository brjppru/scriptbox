<p>See <b><a href="#eng">English</a></b> version above.

<h2>Files | �����</h2>
    <ul>
	<li><a href="dot.Xdefaults">.Xdefaults</a>
	<li><a href="xterm.pm">xterm.pm</a>
    </ul>


<h2> Russian version | ������� ������</h2>


<p>��������� ������, ��� ����������� mmc �� *nix-��������, ����������� � ���������� ���������� ��� ������������� ��������� � X-Window, � ������ ����������� ������ � �������������� ������������ ��������� ������ ���� Ctrl+Alt+F5. � ����� ��� �������� ��� ���� � ���� ���������� ����� ������.
<p>� ��������� FreeBSD-4.7 � xterm �� �������� XFree86-4.2, ������� ��� ������ ������ ����� ������������� ���������.
<p>��-������, �����. MMC ����������� � ������� ������, ���� ���������� ���������� ��������� COLOR_TERM ��� ������� �������� ���������� "xterm-color". ��� ��� � ��������� xterm, �� �������������� ������ �������� - �� ���� ������ ������ ��������� "���������" ��������, ��� �� ����� ������������ �����. �������� � ���� ~/.Xdefaults ������ ���������� ����:

<p class=msg> XTerm*TermName: xterm-color</p>
   
<p>�����, ����������. ��� ����, ����� ��������� ������� keypad (������� k0..k9, k*, k/, k+. k-) ���������� � ~/.Xdefaults �������� ������:
   
<pre class=msg>
XTerm*VT100*translations:   #override \
@Num_Lock <Key>KP_Multiply: string("\033Oj")\n \
@Num_Lock <Key>KP_Add: string("\033Ok")\n \
@Num_Lock <Key>KP_Decimal: string("\033Ol")\n \
@Num_Lock <Key>KP_Subtract: string("\033Om")\n \
@Num_Lock <Key>KP_Divide: string("\033Oo")\n
@Num_Lock <Key>KP_0: string("\033Op")\n \
@Num_Lock <Key>KP_1: string("\033Oq")\n \
@Num_Lock <Key>KP_2: string("\033Or")\n \
@Num_Lock <Key>KP_3: string("\033Os")\n \
@Num_Lock <Key>KP_4: string("\033Ot")\n \
@Num_Lock <Key>KP_5: string("\033Ou")\n \
@Num_Lock <Key>KP_6: string("\033Ov")\n \
@Num_Lock <Key>KP_7: string("\033Ow")\n \
@Num_Lock <Key>KP_8: string("\033Ox")\n \
@Num_Lock <Key>KP_9: string("\033Oy")\n
</pre>							        

<p>������ ��� ������� ������� NumLock ����� ������������ ������ ������������������. ������ ������, ��� � ������������ X-Window �� ������ ���� ���������� ����� ServerNumLock!
<p>������, ����� ������� MMC ������� ������� ����������� �� ������������ ������������������. ��������� � ~/.mmc4rc �������:

<p class=msg>
CL::addkey("\033O" . chr($_ + ord('p')), "k" . chr($_ + ord('0'))) for 0..9;
</p>

��� � ����������� MMC ��������

<p class=mmc>
<span style="color:green">mmc&gt;</span>/perl {CL::addkey("\033O" . chr($_ + ord('p')), "k" . chr($_ + ord('0'))) for 0..9}
</p>

<p>������ ������ MMC ��������� ����������� �� �������������� ������� � ��������� � ���������� ��������������:


<pre class=msg>
my @metaname = ("S", "M", "S-M", "C", "S-C", "C-M", "S-M-C");
for my $mod (2..8) {
   CL::addkey("\033O${mod}".  chr($_ + ord('P') - 1), ${metaname}[$mod - 2] ."-f". $_ ) for 1..4;
   CL::addkey("\033[". scalar $_+10 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 5;
   CL::addkey("\033[". scalar $_+11 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 6..10;
   CL::addkey("\033[". scalar $_+12 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 11..12;
}
</pre>

<p>������ ������� ��� ������� MMC � ��������� ������ � ���������� ��� �� ~/.mmc4rc. � ���� �� ���������� xterm.pm, ������������ (� ~/.mmc4rc) ��������

<p class=msg>
use xterm;
</p>	 
																		 
<h3>��������� �� ��̣���_���� aka PoLaZ:</h3>
<p>� slackware/debian`� ������� ����� ������������ rxvt - ��� ����� ���������� �������, � ������� ����� ������� �� ���.
� ������ � ���� ��� � �� ���������� ��������� �������� �������� ����-����������� ��������
</p>

<a name="eng">
<h2> English version | ���������� ������</h2>

<p>Sorry, English version not ready now... If inetrest in it - let me know via e-mail.

<br>
<br>

<p>Andrew [dikiy] Baznikin<br>
dikiy _@_ scn.ru</a><br>
<a href="http://d.scn.ru">http://d.scn.ru</a><br>