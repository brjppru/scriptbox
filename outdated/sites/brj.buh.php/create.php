<?
include ("txt/config.php");

    $mlink = mysql_connect ($url_mysql_host, $str_mysql_user, $str_mysql_pass)
        or die ("Could not connect");
    mysql_select_db($str_mysql_base, $mlink);


$sq="CREATE TABLE ".$str_mysql_tbl."_incat (
  catid int DEFAULT '0' NOT NULL auto_increment,
  cattitle varchar(250),
  PRIMARY KEY (catid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

$sq="CREATE TABLE ".$str_mysql_tbl."_income (
  inid int DEFAULT '0' NOT NULL auto_increment,
  indate int,
  incatid int,
  intxt varchar(250),
  insum int,
  inq int,
  PRIMARY KEY (inid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

$sq="CREATE TABLE ".$str_mysql_tbl."_outcat (
  catid int(11) DEFAULT '0' NOT NULL auto_increment,
  cattitle varchar(250),
  PRIMARY KEY (catid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

$sq="CREATE TABLE ".$str_mysql_tbl."_outsub (
  subid int DEFAULT '0' NOT NULL auto_increment,
  subcatid int,
  subtitle varchar(250),
  PRIMARY KEY (subid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

$sq="CREATE TABLE ".$str_mysql_tbl."_outcome (
  outid int DEFAULT '0' NOT NULL auto_increment,
  outdate int,
  outsubid int,
  outtxt varchar(250),
  outsum int,
  outq int,
  PRIMARY KEY (outid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

$sq="CREATE TABLE ".$str_mysql_tbl."_debts (
  debid int DEFAULT '0' NOT NULL auto_increment,
  debdate int,
  debname varchar(250),
  debtxt varchar(250),
  debsum int,
  debret int DEFAULT '0',
  debclosed  int DEFAULT '0',
  debhistory TEXT,
  PRIMARY KEY (debid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

$sq="CREATE TABLE ".$str_mysql_tbl."_cedts (
  cedid int DEFAULT '0' NOT NULL auto_increment,
  ceddate int,
  cedname varchar(250),
  cedtxt varchar(250),
  cedsum int,
  cedret int DEFAULT '0',
  cedclosed  int DEFAULT '0',
  cedhistory TEXT,
  PRIMARY KEY (cedid)
)";
$resupd = mysql_query($sq, $mlink);
    echo $sq . "<BR>";
    if ($resupd)
    {
        echo "<B>Created</B><br><BR>";
    }
    else
    {
        echo "<B>" . mysql_error ($mlink)."</B><BR><BR>";
    }

?>
