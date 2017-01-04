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

# ==== здесь реальное начало скрипта! ====

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

print"<b><A HREF=\"/about/\" class=\"menu\">О компании</a></b><br>\n";

if ( $about_open eq 1 ) { 
    print <<EOF;

    &nbsp;&nbsp;&nbsp;<A href="/about/news/" class="menu">Новости</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/license/" class="menu">Лицензии</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/pr/" class="menu">Пресс-релиз</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/jobs/" class="menu">Вакансии</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/about/contact/" class="menu">Наши координаты</A><BR>
EOF
} 

print"<b><A HREF=\"/net/\" class=\"menu\">Сеть</a></b><br>\n";

if ( $net_open eq 1 ) { 
    print <<EOF;

	&nbsp;&nbsp;&nbsp;<A href="/net/" class="menu">Наш узел ПД</A><BR>               
	&nbsp;&nbsp;&nbsp;<A href="/net/ap/" class="menu">География подключений</A><BR>
	&nbsp;&nbsp;&nbsp;<A href="/net/join/" class="menu">Заявка на подключение</A><BR>        
	&nbsp;&nbsp;&nbsp;<A href="/net/serv/" class="menu">Как настроить</A><BR>        
	&nbsp;&nbsp;&nbsp;<A href="/net/card/" class="menu">Сетевые карты</A><BR>        

EOF
} 

print"<b><A HREF=\"/service/\" class=\"menu\">Услуги</a></b><br>\n";

if ( $service_open eq 1 ) { 
    print <<EOF;

    &nbsp;&nbsp;&nbsp;<A href="/service/internet/" class="menu">Доступ в Интернет</A><BR>
    &nbsp;&nbsp;&nbsp;<A href="/service/vpn/" class="menu">IP VPN</A><BR>                
    &nbsp;&nbsp;&nbsp;<A href="/service/price/voip/" class="menu">IP телефония</A><BR>                
    &nbsp;&nbsp;&nbsp;<A href="/service/price/" class="menu">Цены</A><BR>          
    &nbsp;&nbsp;&nbsp;<A href="/service/pay/" class="menu">Как оплатить</A><BR>          

EOF
} 


print"<b><A HREF=\"/client/\" class=\"menu\">Пользователю</a></b><br>\n";

if ( $client_open eq 1 ) { 
    print <<EOF;

      &nbsp;&nbsp;&nbsp;<A href="http://cabinet.vzletka.net/" class="menu">Личный Кабинет</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="http://fs.vzletka.net/" class="menu">FTP поиск</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="http://forum.vzletka.net/" class="menu">Форум сети</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="/client/chat/" class="menu">Сетевой ЧАТ</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="/client/faq/" class="menu">Вопросы и Ответы</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="/client/links/" class="menu">Полезные ссылки</A><BR>
      &nbsp;&nbsp;&nbsp;<A href="http://games.vzletka.net/" class="menu">Игры</A><BR>
EOF
}
