<?php
include_once "config.inc.php";
include_once "lang.inc.php";

function vdir() { $d = dirname ($_SERVER['PHP_SELF']); return ($d== "/" ? "" : $d);}
function realdir() { return dirname ($_SERVER['SCRIPT_FILENAME']); }
function isIgnore ($path) { return ( file_exists("$path/.htignore") ? 1:0); }

function get_htinfo_field ($field, $path="./") {
	$msg = get_dir_htinfo($path);
	if ( ! $msg) return;
	set_add_strings ($msg);
	return str($field);
}

function print_subdirs () {
	$vdir = vdir ();
	$realdir = realdir ();

	if (($dir = @opendir($realdir)) == false) {
		echo "opendir()";
		return;
	}

	$files = Array();
	while (false !== ($file = readdir($dir))) {
		if ($file != "." && $file != "..") {
		$files[] = $file;
		}
	}
	closedir($dir);
	sort($files);
	reset($files);

	while (list($key, $file) = each($files)) {
		if ( ! is_dir($file)) continue;

		if ( isIgnore($file)) continue;

		if ( file_exists("$file/.htinfo")) {
			set_add_strings( get_dir_htinfo($file) );
			echo "<li><a href='$vdir/$file'>", str('ht_name'), "</a>";
#			echo " - ", str('ht_title');
			echo " <font size=-1>", str('ht_desc'), "</font><br>";
		} else {
			echo "<li><a href='$vdir/$file'>$file</a><br>";
		}
	}
}

function print_top_menu () {
	global $site_root;
	global $site_real_root;

	$rp = "!^". realpath($site_real_root) ."!";
	$rel_path = preg_replace( $rp, "", realdir());
	$p = "$site_root";
	$rp = "$site_real_root";
	foreach ( split("/", $rel_path) as $d) {
		$p .= "$d/"; $rp .= "$d/";
		$name =  get_htinfo_field('ht_name', $rp);
		$dscr =  get_htinfo_field('ht_desc', $rp);
		$alt = ($name ? " title=\"$dscr\"" : "");

		echo " / <a href='$p' $alt>";
		echo ($name ? $name : $d);
		echo "</a>  ";
	}
}

function print_lang_select () {
	$lang = get_lang();
	switch ($lang) {
		case "ru":
			echo "<b>RU</b>&nbsp;|&nbsp;";
			echo "<a href='?lang=en'>EN</a>";
			break;
		case "en":
			echo "<a href='?lang=ru'>RU</a>&nbsp;|&nbsp;";
			echo "<b>EN</b>";
			break;
	}
}

function get_dir_htinfo( $path ) {
	if ( ! file_exists("$path/.htinfo") ) return;

	$msg = array();
	$fp = fopen ( "$path/.htinfo", "rb") or print "fopen()";
	while ( $fp && !feof($fp) ) {
		while ( $str = trim(fgets($fp)) ) {
			list($k, $v) = preg_split ("/ : */", $str);
			list($l, $k) = preg_split ("/\./", $k);
			$msg["ht_$k"][$l] = $v;
		}
	}
	return $msg;
}

function fileInsert($file, &$str, $lockfile = null) {
	// ceate a lock file - if not possible someone else is active so wait (a while)
	$lock = ($lockfile)? $lockfile : $file.'.lock';
	$lf = @fopen ($lock, 'x');
	$i = 0;
	while ($lf === FALSE && $i++ < 20) {
		clearstatcache();
		usleep(rand(10,300));
		$lf = @fopen ($lf, 'x');
	}
	// if lockfile (finally) has been created, file is ours, else give up ...
	if ($lf !== False) {
		umask("007");
		if ( ! $fp = fopen( $file, 'a'))
			echo str('cant_write'), " ", $file;

		fputs( $fp, $str);
		fclose( $fp);

		// and unlock
		fclose($lf);
		unlink($lock);
	} else {
		echo str('cant_write'), " ", $lock;
	}
}

function do_log ($log, $text) {
	$logline = "$text\t".
		"$_SERVER[REMOTE_ADDR]\t".
		date("Y.m.d H:i:s"). "\t".
		(isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER']."\t" : "-\t") .
		$_SERVER['HTTP_USER_AGENT']."\n";
	fileInsert($log, $logline);
}

?>
