<?php
ini_set ('session.use_only_cookies', '1');
session_start();

include_once "config.inc.php";
include_once "lang.inc.php";
include_once "func.inc.php";
include_once "counter.inc.php";

if (isset($_GET['lang'])) {
	set_lang($_GET['lang']);
}

include "head.inc.php";

if ( ! isIgnore(realdir()) )
	print_subdirs();

;
if ($l = get_lang() and file_exists("index.$l.php")) {
	include("index.$l.php");
}