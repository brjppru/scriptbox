<?php
  if (!isset($_SERVER['PHP_AUTH_USER'])) {
    header('WWW-Authenticate: Basic realm="Пароль знаешь?"');
    header('HTTP/1.0 401 Unauthorized');
    echo "<CENTER><A href='/'>Click here</A></CENTER>";
    exit;
  } else {
    if ($_SERVER['PHP_AUTH_USER']!="tango" or $_SERVER['PHP_AUTH_PW']!="zj53Rty")
    {
    header('Location: /');
    exit;
    }
  }

include ("txt/config.php");
include ("txt/const.php");
include ("inc/inc.php");
//$path="/brj";

// Send headers
header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT");    // Date in the past
header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
                                                      // always modified
header ("Cache-Control: no-cache, must-revalidate");  // HTTP/1.1
header ("Pragma: no-cache");                          // HTTP/1.0

$mlink = mysql_connect ($url_mysql_host, $str_mysql_user, $str_mysql_pass)
        or die ("Can't connect");
mysql_select_db($str_mysql_base,$mlink);


// Страницы по умолчанию для разных посетителей
// гость:
$page="outcome";

// Разбор прихода
if ( in_array ("p", array_keys ($HTTP_GET_VARS)) ) $page=$HTTP_GET_VARS["p"];
if ( in_array ("p", array_keys ($HTTP_POST_VARS)) ) $page=$HTTP_POST_VARS["p"];

$arg2="";
if ( in_array ("arg2", array_keys ($HTTP_GET_VARS)) ) $arg2=$HTTP_GET_VARS["arg2"];
if ( in_array ("arg2", array_keys ($HTTP_POST_VARS)) ) $arg2=$HTTP_POST_VARS["arg2"];
$arg2=strtolower(eregi_replace("(\.htm[l]{0,1}|[^/a-zA-Z0-9\.-])", "", $arg2));

$arg="";
if ( in_array ("arg", array_keys ($HTTP_GET_VARS)) ) $arg=$HTTP_GET_VARS["arg"];
if ( in_array ("arg", array_keys ($HTTP_POST_VARS)) ) $arg=$HTTP_POST_VARS["arg"];
$arg=strtolower(eregi_replace("(\.htm[l]{0,1}|[^/a-zA-Z0-9\.-])", "", $arg));
if (strstr($arg, "/")) list($arg, $arg2)=explode("/", $arg);


ob_start("ob_gzhandler");
//ob_start();
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1251">
<LINK href="<?=$path?>/css/brjbsd.css" rel='stylesheet'>
</HEAD>
<BODY>
<!-- Начало Шшапки -->
<?php
$_menu="
      <TABLE class=navmenu>
        <TBODY>
        <TR>
          <TD class=navcell><A href='$path/outcome/' id='bot'>$__expenses</A></TD>
          <TD class=navcell><A href='$path/income/'>$__income</A></TD>
          <TD class=navcell><A href='$path/credits/'>$__credits</A></TD>
          <TD class=navcell><A href='$path/debits/'>$__debits</A></TD>
          <TD class=navcell><A href='$path/stat/'>$__reports</A></TD></TR></TBODY></TABLE>";
?>
<TABLE class=header>
  <TBODY>
  <TR>
    <TD class=menu>
    <?php
        echo str_replace("id='bot'", "", $_menu);
    ?>
        </TD>
    <TD class=logo><IMG alt=milkMoney src="<?=$path?>/img/logo.png"></TD></TR></TBODY></TABLE>
<!-- Конец Шапки -->
<!-- Начало основного контента -->
    <DIV class=pagetext>
    <?php
    include ("inc/".$page.".php");
    ?>
    </DIV>
<!-- Конец основного контента -->
<!--BR><CENTER>$page="<?=$page?>" $arg="<?=$arg?>" $arg2="<?=$arg2?>"</CENTER><BR-->
</BODY></HTML>
<?php
ob_end_flush();

mysql_close($mlink);
?>
