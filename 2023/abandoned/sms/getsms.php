<?php
if ($_REQUEST["sender"] == "+7921*******" AND $_REQUEST["pass"] == "****") {
// You're free to do any actions - post to twitter, send another SMS or just write to file
// As I do for displaying this on my homepage
	$fp = fopen("/home/kolo/****/****.txt","w");
	fwrite($fp, stripslashes($_REQUEST["text"]));
	fclose($fp);
	mail("kolo@****", "SMS Alarm @ +7926****", var_export($_REQUEST, true)); // Good for debugging
}
?>