#!/usr/bin/php5

<?php

# define vantala

    $APIKEY='ololoid';
    $DEVID='ololoid2';

require 'PushBullet.class.php';

# get vantala


	$fp = file("vantala.txt");
	$count = count($fp);
	$cur_num = rand(1,$count);
	echo $fp[$cur_num];

# send vantala

	$p = new PushBullet($APIKEY);
	$p->pushNote($DEVID, 'vantala', $fp[$cur_num]);

?>
