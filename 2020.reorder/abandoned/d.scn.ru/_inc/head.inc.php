<? global $site_root ?>
<? global $site_real_root ?>
<html>
<head>
<title>
dikiy/ <?= ifstr(get_htinfo_field('ht_title'), "домашние миры Дикого")?>
</title>
<!-- (c) 2000-2004 Andrew I Baznikin -->
<meta http-equiv="Content-Type" content="text/html; charset=koi8-r">
<link type="text/css" rel="stylesheet" href="<?= $site_root ?>/_st/adm.css">
</head>
<body bgcolor=#EBEAEA>

<!-- // header -->
<table border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td rowspan=3 class="top-logo">
			<a href="/">
			<img src="<?= $site_root ?>/_images/top-dikiy.gif" width=200 height=135></a></td>
		<td width=100% align=left valign=top class="top-rand">
<!-- TOP: random pic -->
			<img src="<?= $site_root ?>/_images/top-random.gif" width=125 height=105></td>
	</tr>
	<tr>
		<td>
			<img src="<?= $site_root ?>/_images/top-bar.gif" width=100% height=6></td>
	</tr>
	<tr>
		<td colspan=1 align=left valign=bottom class="menu">
<?php print_top_menu() ?>
		</td>
		<td colspan=1 align=right valign=bottom class="menu">
<?php print_lang_select() ?>
		</td>
	</tr>
</table>
<!-- // header -->
<br>
<table border=0 cellpadding=0 cellspacing=0 class="body" width="100%">
	<tr><td colspan=2 width="100%"></td></tr>
	<tr>
		<td align=left valign=top>
<!-- BODY -->

<br>