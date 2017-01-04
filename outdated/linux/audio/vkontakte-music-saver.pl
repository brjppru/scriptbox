#!/usr/bin/perl -w
use Text::Iconv;

$Email='login@mail.ru'; # логин
$Password="mypassword"; # пароль
$Id="1"; # id человека плейлист которого скачиваем

$User_agent="\"Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.8.131 Version/11.10\""; # узерагет
$Curl="/usr/bin/curl"; # курл
$Cookie="cookie.txt"; # куда пишем куки
$Vk_domain="http://vk.com/";

$converter=Text::Ico
nv->new("windows-1251", "utf8");
$Curl_cmd="$Curl --referer $Vk_domain -A $User_agent";
$_=`$Curl_cmd $Vk_domain`;
m/(<form.+?\/form>)/s; $Form=$1;
$Form=~m/action="(\S+?)"/s; $Action=$1;
while ($Form=~m/<input.+?name="(\S+?)".+?value="(\S*?)"\s\/>/gs){$Post_data="$Post_data$1=$2&"}
$Post_data="\"${Post_data}email=$Email&pass=$Password\"";
$_=`$Curl_cmd -i -c $Cookie -d $Post_data $Action`;
m/Location:\s([^\s]+?)\s/s; $Location="\"$1\"";
`$Curl_cmd -b $Cookie -c $Cookie $Location`;
$Post_data="\"act=load_audios_silent&al=1&id=$Id\""; $Action="$Vk_domain\\audio";
$_=`$Curl_cmd -b $Cookie -d $Post_data $Action`; s/&[^&]+;//g;
while (m/\[\S+?,\S+?,'\s*?(http\S+?)\s*?',\S+?,\S+?,'\s*?(\S.+?\S)\s*?','\s*?(\S.+?\S)\s*?',.+?\]/g){$Name=$converter->convert("\"$2-$3.mp3\""); `wget -O $Name $1`;}
