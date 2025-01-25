<h1>MUD-relaited stuff</h1>

<a name="logcolorizer"></a>
<h2><b>log colorizer</b> ANSI to HTML convering perl script</h2>

<p>This Perl script is designed for converting ANSI-colored log-files to HTML format.

<p>See <a href="#logcolorizer-ex">Advantages & disadvantages</a> section for comparison.</p>

<a name="logcolorizer-hist"></a>
<h3>History</h3>
<ul>
 <li>15 Oct 2002 - fix for <i>--optimise</i> options (compiled .exe-version NOT FIXED yet!)
 <li>26 Sep 2002 - Inintial release.
</ul>

<a name="logcolorizer-down"></a>
<h3>Download</h3>

<p>Perl script (require Perl)<br>
<a href="/files/log-colorizer/log_colorizer.pl">log_colorizer.pl</a>, 3,962 bytes
(<a href="/files/log-colorizer/log_colorizer.tar.gz">tar.gz archive</a>, 1,788 bytes)
<p>Stanalone executable (does not require Perl)<br>
<a href="/files/log-colorizer/log_colorizer.exe">log_colorizer.exe</a>, 1,068,039 bytes
(<a href="/files/log-colorizer/log_colorizer.zip">zip archive</a>, 568,160 bytes)


<a name="logcolorizer-use"></a>
<h3>Typical usage</h3>
<pre class=msg>prompt$ ./log_colorizer.pl &lt; infile.log &gt; outfile.html
prompt$ ./log_colorizer.pl --from infile.log --to outfile.html
prompt$ gunzip -c log-file.gz | ./log_colorizer.pl --title "My old logs"\
    --to outfile.html --charset koi8-r</pre>

<a name="logcolorizer-cmdline"></a>
<h3>Command-line options</h3>
<pre class=msg>
prompt$ ./log_colorizer.pl --help
  --help, -h, -?        - this help screen
  --help-style          - show used CSS class names (to write your own one)
  --from, -f  <file>    - input ANSI file  (default: STDIN)
  --to, -t  <file>      - output HTML file (default: STDOUT)
  --optimise, -o        - optimise HTML file
  --title <text>        - HTML page title  (default:"Colorized log")
  --codepage, -c <text> - set codepage for HTML file  (default: windows-1251)
  --style, -s <file>    - file to get CSS (Cascade Style Sheet) from
			                            (default: built-in)</pre>

<a name="logcolorizer-ex"></a>
<h3>Advantages & disadvantages</h3>

<p>There are some known analog scripts:
<ul>
 <li><a href="http://velinor.virtualave.net/a2html.zip"><b>ansi2html</b></a> by Velinor [velinor _@_ mail.com]
 <li><a href="http://search.cpan.org/author/AUTRIJUS/HTML-FromANSI-1.00/">HTML::FromANSI-1.00</a> by autrijus _@_ autrijus.org from <a href="http://cpan.org">CPAN.org</a>
 <li><a href="http://www.a-mud.ru/resurs/files/Amud_Html.exe">Amud_Html.exe</a> by Sitn from <a href="http://www.a-mud.ru/resurs/index.htm">Adamant MUD</a>
</ul>

<table border=1>
<tr align=right style="background-color:#dddddd">
<td>Size, bytes</td>
<td>bylins.log (many colors)</td>
<td>gwse.log (some colors)</td>
  </tr>
<tr align=right>
<td>Original log</dt>
<td>565,408 <a href="/files/log-colorizer/bylins.log">[link]</a></td>
<td>503,143 <a href="/files/log-colorizer/gwse.log">[link]</a></td>
  </tr>
<tr align=right>
<td>log colorizer</dt>
<td>750,010</td>
<td>412,597</td>
  </tr>
<tr align=right style="background-color:#aaffaa">
<td>log colorizer<br>(with --optimise option)</dt>
<td>609,590</td>
<td>405,870</td>
  </tr>
<tr align=right>
<td>ansi2html</td>
<td>652,414</td>
<td>407,268</td>
  </tr>
<tr align=right>
<td>HTML::FromANSI</td>
<td>not tested ;-%</td>
<td>9,823,262 ( !!! )</td>
  </tr>
<tr align=right>
<td>Amud_Html.exe</td>
<td>1,057,685</td>
<td>862,470</td>
</table>
</p>

<p><b>log-colorizer</b> support more command-line options for customising output html-file.</p>

