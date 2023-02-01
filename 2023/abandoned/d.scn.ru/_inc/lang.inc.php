<?php

// LANGUAGE DETECTION
if (isset($_SESSION['lang'])) {
	$LANG = $_SESSION['lang'];
} else {
	$LANG = isset($_SERVER['HTTP_ACCEPT_LANGUAGE']) ? $_SERVER['HTTP_ACCEPT_LANGUAGE'] : 'en';
	if (preg_match("/ru/", $LANG)) {
		$LANG="ru";
	} else {
		$LANG="en";
	}
	$_SESSION['lang'] = $LANG;
}

function str($name, $add_strings='') {
        if (isset($GLOBALS['ADDITIONAL_STRINGS'][$name]))
                return $GLOBALS['ADDITIONAL_STRINGS'][$name][$GLOBALS['LANG']];
        if (isset($GLOBALS['STRINGS_DEFAULT'][$name]))
                return $GLOBALS['STRINGS_DEFAULT'][$name][$GLOBALS['LANG']];
	if (isset($GLOBALS['STRINGS'][$name]))
		return $GLOBALS['STRINGS'][$name][$GLOBALS['LANG']];
	return "UNKNOWN STRING $name!";
}

function set_add_strings ($arr) {
	if (is_array($arr))
		$GLOBALS['ADDITIONAL_STRINGS'] = $arr;
}

function ifstr($str, $alt='') {
	return (isset($str) ? $str : $alt );
}

function set_lang($lang) {
	if ($lang=="ru" or $lang=="en") {
		$GLOBALS['LANG'] = $lang;
		$_SESSION['lang'] = $lang;
	}
}

function get_lang() {
	return $GLOBALS['LANG'];
}

// DEFAULT STRINGS
$STRINGS_DEFAULT = array(
	'lang_name'	=> array( 'ru' => "Russian/Русский", 'en' => "English/Английский"),
	'send_button'	=> array( 'ru' => "ОТПРАВИТЬ СООБЩЕНИЕ", 'en' => "SEND MESSAGE"),
	'date'		=> array( 'ru' => "Дата", 'en' => "Date"),
	'server_time'	=> array( 'ru' => "время сервера", 'en' => "server time"),
	'cant_write'	=> array( 'ru' => "Невозможно записать файл", 'en' => "Cant write file"),
	);

$ADDITIONAL_STRINGS = array();

?>
