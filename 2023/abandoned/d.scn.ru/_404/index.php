<?

require_once "../_inc/config.inc.php";
require_once "../_inc/counter.inc.php";
include_once "../_inc/lang.inc.php";
include_once "../_inc/func.inc.php";

$MOVED = array (
	'/index.html'		=> '/',
	'/proj.html'		=> '/proj/',
	'/news.html'		=> '/news/',
	'/news_arc.html'	=> '/news/old/',
	'/whoami.html'		=> '/whoami/',
	'/mud'			=> '/proj/mud/',
	'/mud/'			=> '/proj/mud/',
	'/mud/ge'		=> '/proj/mud/ge/',
	'/mud/ge/'		=> '/proj/mud/ge/',
	'/mud/ge/ge'		=> '/proj/mud/ge/',
	'/mud/ge/ge/'		=> '/proj/mud/ge/',
	'/mud/ge/ge2'		=> '/proj/mud/ge/ge2/',
	'/mud/ge/ge2/'		=> '/proj/mud/ge/ge2/',
	'/mud/log-colorizer'	=> '/proj/mud/log-colorizer/',
	'/mud/log-colorizer/'	=> '/proj/mud/log-colorizer/',
	'/mud/log-colorizer/index.html'	=> '/proj/mud/log-colorizer/',
	'/mud/mmc/xterm'	=> '/proj/mud/mmc+xterm',
	'/mud/mmc/xterm/'	=> '/proj/mud/mmc+xterm',
	'/mud/mmc/xterm/index.html'	=> '/proj/mud/mmc+xterm',
	'/proj/mud/ge/ge'	=> '/proj/mud/ge/',
	'/proj/mud/ge/ge/'	=> '/proj/mud/ge/',
	'/proj/mud/mmc/xterm'	=> '/proj/mud/mmc+xterm',
	'/proj/mud/mmc/xterm/'	=> '/proj/mud/mmc+xterm',

	'/article/mu-re/index.shtml' => '/article/mu-re/',
	'/article/mu-re/MU.index.php' => '/article/mu-re/',
	'/article/mu-re/MU.msg.php' => '/article/mu-re/msg/',
	
	'/article/slon.txt'	=> '/article/Slon/',

	'/txt/volkonius.html'	=> '/article/volkonius/',
);

$IGNORE = array (
	'/new/1.5/ignoreme' => 1,
);


$url = $_SERVER['REDIRECT_URL'];


if (isset($MOVED[$url])) {
	header($HTTP_SERVER_VARS['SERVER_PROTOCOL'] . ' 301');
	echo "<div align=left style='font-size: 120px; float: left'><b>301</b></div>";
	echo "<center><h1>Document moved</h1><br>";
	echo "Document adress changed! Please, update your bookmarks. New location:<br>";
	echo "<h2><a href='$MOVED[$url]'>http://". $_SERVER['SERVER_NAME'] ."$MOVED[$url]</a></h2>";
} elseif (isset($IGNORE[$url])) {
} else {
	do_log($log_404_name, $url);

	echo "<div align=left style='font-size: 120px; float: left'><b>404</b></div>";
	echo "<center><h1>Document not found</h1><br>";
	echo "Your request logged, I'll try to fix this issue<br>";
	echo "Try <a href='$site_root/'>start page</a> first.";
}

show_counter();
?>