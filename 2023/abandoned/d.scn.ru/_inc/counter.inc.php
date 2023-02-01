<?php

function show_counter () {

	// log external referers
	global $log_referer_name;
	$ref = ( isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : "" );
	$srv = $_SERVER['SERVER_NAME'];
	if ( $ref and ! preg_match("/^(http:\/\/)?$srv/i", $ref)) {
		$logline = "$_SERVER[REQUEST_URI]\t".
		"$_SERVER[REMOTE_ADDR]\t".
		date("Y.m.d H:i:s"). "\t".
		(isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER']."\t" : "-\t") .
		$_SERVER['HTTP_USER_AGENT']."\n";
		fileInsert($log_referer_name, $logline);
	}
}

?>

