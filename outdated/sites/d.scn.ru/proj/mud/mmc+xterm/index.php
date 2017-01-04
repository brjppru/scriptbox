<p>See <b><a href="#eng">English</a></b> version above.

<h2>Files | Файлы</h2>
    <ul>
	<li><a href="dot.Xdefaults">.Xdefaults</a>
	<li><a href="xterm.pm">xterm.pm</a>
    </ul>


<h2> Russian version | Русская версия</h2>


<p>Наверняка многие, кто использовал mmc на *nix-системах, столкнулись с некоторыми проблемами при использовании совместно с X-Window, а именно отсутствием цветов и невозможностью использовать сочетания клавиш типа Ctrl+Alt+F5. Я решил эти проблемы для себя и хочу поделиться своим опытом.
<p>Я использую FreeBSD-4.7 и xterm из поставки XFree86-4.2, поэтому для других систем могут потребоваться переделки.
<p>Во-первых, цвета. MMC запускается в цветном режиме, если определена переменная окружения COLOR_TERM или текущий терминал называется "xterm-color". Так как я использую xterm, то воспользовался вторым способом - за одно многие другие программы "научились" узнавать, что им можно использовать цвета. Добавьте в файл ~/.Xdefaults строку следующего вида:

<p class=msg> XTerm*TermName: xterm-color</p>
   
<p>Далее, клавиатура. Для того, чтобы корректно работал keypad (клавиши k0..k9, k*, k/, k+. k-) необходимо в ~/.Xdefaults добавить строки:
   
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

<p>Теперь при нажатой клавише NumLock будут возвращаться нужные последовательности. Учтите только, что в конфигурации X-Window не должна быть выставлена опция ServerNumLock!
<p>Теперь, нужно научить MMC должным образом реагировать на возвращаемые последовательности. Пропишите в ~/.mmc4rc команду:

<p class=msg>
CL::addkey("\033O" . chr($_ + ord('p')), "k" . chr($_ + ord('0'))) for 0..9;
</p>

или в приглашении MMC напишите

<p class=mmc>
<span style="color:green">mmc&gt;</span>/perl {CL::addkey("\033O" . chr($_ + ord('p')), "k" . chr($_ + ord('0'))) for 0..9}
</p>

<p>Теперь научим MMC правильно реагировать на функциональные клавиши в сочетании с различными модификаторами:


<pre class=msg>
my @metaname = ("S", "M", "S-M", "C", "S-C", "C-M", "S-M-C");
for my $mod (2..8) {
   CL::addkey("\033O${mod}".  chr($_ + ord('P') - 1), ${metaname}[$mod - 2] ."-f". $_ ) for 1..4;
   CL::addkey("\033[". scalar $_+10 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 5;
   CL::addkey("\033[". scalar $_+11 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 6..10;
   CL::addkey("\033[". scalar $_+12 .";${mod}~" , ${metaname}[$mod - 2] ."-f". $_ ) for 11..12;
}
</pre>

<p>Удобно вынести все команды MMC в отдельный модуль и подключать его из ~/.mmc4rc. У меня он называется xterm.pm, подключается (в ~/.mmc4rc) командой

<p class=msg>
use xterm;
</p>	 
																		 
<h3>Замечание от Зелёный_Змий aka PoLaZ:</h3>
<p>В slackware/debian`е намного проще использовать rxvt - там более правильный термкап, и намного проще довести до ума.
В хтерме у меня так и не получилось заставить корректо работать мета-модификатор например
</p>

<a name="eng">
<h2> English version | Английская версия</h2>

<p>Sorry, English version not ready now... If inetrest in it - let me know via e-mail.

<br>
<br>

<p>Andrew [dikiy] Baznikin<br>
dikiy _@_ scn.ru</a><br>
<a href="http://d.scn.ru">http://d.scn.ru</a><br>