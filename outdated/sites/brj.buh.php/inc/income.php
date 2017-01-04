<?php
function editline($insertdate, $catid=0, $insum="", $inq=1, $inid=0)
{
        global $color;
        global $str_mysql_tbl;
        global $mlink;
        global $path;
        ?>
        <FORM action='' name='frm' method='post'>
        <TR class='color<?=$color?>'>
        <TD><INPUT class='line' type='text' size='10' value='<?php echo int_to_date($insertdate); ?>' name='indate'></TD>
        <TD><SELECT  class='line' style='width: 8em;'  name='catid'><?php
        $sq="SELECT * FROM ".$str_mysql_tbl."_incat ORDER BY cattitle ";
        $result=mysql_query($sq, $mlink);
        if ($result) while ($row=mysql_fetch_array ($result))
        {
            if (!isset($firstcatid)) $firstcatid=$row["catid"];
            ?><OPTION value='<?=$row["catid"]?>' <?php if ($row["catid"]==$catid) echo "selected"; ?>><?=$row["cattitle"]?></OPTION><?php
        }
        ?></SELECT>&nbsp;&nbsp;<A href='javascript:addCat();'>+</A></TD>
        <TD><INPUT class='line' type='text' size='6' value='<?=$insum?>' name='insum'></TD>
        <TD><INPUT class='line' type='text' size='2' value='<?=$inq?>' name='inq'></TD>
        <TD><INPUT type='image' src='<?=$path?>/img/save.png' name='save'></TD>
        <INPUT type='hidden' value='0' name='newcat'>
        <INPUT type='hidden' value='0' name='newsub'>
        <INPUT type='hidden' value='<?=$inid?>' name='saveid'>
        </TR>
        </FORM>
        <?php
        return $firstcatid;
}
function myslash($prtitle)
{
    if (get_magic_quotes_gpc()) $prtitle=stripslashes($prtitle);
    $prtitle=str_replace("<", "&lt;", $prtitle);
    $prtitle=str_replace("'", "&#39;", $prtitle);
    $prtitle=addslashes($prtitle);
    return $prtitle;
}
// добавление новостей
$errmess="";
if (in_array ("inq", array_keys ($HTTP_POST_VARS)))
{
    //foreach ($HTTP_POST_VARS as $k=>$v) echo "$k => $v <BR>";
    //exit;
    $saveid=$HTTP_POST_VARS["saveid"]+0;
    //
    $dto=$HTTP_POST_VARS["indate"];
    @list($dod, $dom, $doy)=@explode(".", $dto);
    $day=@mktime (0,0,0, $dom, $dod, $doy);
    if (@date("j.n.Y", $day)===$dto or @date("d.m.Y", $day)===$dto)
    {
        $indate=date("y", $day)*1000+date("z", $day);
        $insertdate=$indate;
    }
    else
    {
        $errmess="<DIV class='error'>ERROR: Invalid date</DIV>";
    }
    //
    $insum=$HTTP_POST_VARS["insum"]+0;
    if (!$insum)
    {
        $errmess="<DIV class='error'>ERROR: Zero sum</DIV>";
    }
    //
    $inq=$HTTP_POST_VARS["inq"]+0;
    //if (!$inq) $inq=1;
    //
    $catid=$HTTP_POST_VARS["catid"]+0;
    if (!$catid)
    {
        // Insert new cat
        $cattite=myslash($HTTP_POST_VARS["newcat"]);
        $sq="INSERT INTO ".$str_mysql_tbl."_incat SET cattitle='$cattite' ";
        $result=mysql_query($sq, $mlink);
        $catid=mysql_insert_id($mlink);
    }

    if ($errmess=="")
    {
        if ($saveid)
        {
            $comand="UPDATE ";
            $cond=" WHERE inid='$saveid' ";
        }
        else
        {
            $comand="INSERT INTO ";
            $cond="";
        }
        $sq="$comand ".$str_mysql_tbl."_income SET  indate='$indate', incatid='$catid',
            insum='$insum', inq='$inq' $cond ";
        if (!$inq and $cond!="") $sq="DELETE FROM ".$str_mysql_tbl."_income $cond ";
        $result=mysql_query($sq, $mlink);
        //echo $sq."<BR>".mysql_error();
    }
    $HTTP_GET_VARS["edit"]=0;
}
if (in_array ("del", array_keys ($HTTP_GET_VARS)))
{
    $delid=$HTTP_GET_VARS["del"]+0;
    $sq="DELETE FROM ".$str_mysql_tbl."_income WHERE inid='$delid' ";
    $result=mysql_query($sq, $mlink);
}

$editid=0;
if (in_array ("edit", array_keys ($HTTP_GET_VARS)))
{
    $editid=$HTTP_GET_VARS["edit"]+0;
}

    // даты по умолчанию
    $datelast=date_to_int();
    $today=$datelast;
    $filtr="<SPAN class='filtr'>($__usual)</SPAN>";
    if (!isset($insertdate)) $insertdate=$today;
    $datefirst=date_to_int(0-$int_day_to_show);
    $where=" WHERE indate>='$datefirst' AND indate<='$datelast' ";
    // фильтр по дате
    if ($arg=="all")
    {
        $where=" ";
        $filtr="<SPAN class='filtr'>($__all)</SPAN>";
    }
    if ($arg=="month")
    {
        $datefirst=date_to_int(mktime (0,0,0, date("m"), 1, date("Y")));
        $where=" WHERE indate>='$datefirst' AND indate<='$datelast' ";
        $filtr="<SPAN class='filtr'>($__month)</SPAN>";
    }
    if ($arg=="lastmonth")
    {
        $datefirst=date_to_int(mktime (0,0,0, date("m")-1, 1, date("Y")));
        $datelast=date_to_int(mktime (0,0,0, date("m"), 0, date("Y")));
        $where=" WHERE indate>='$datefirst' AND indate<='$datelast' ";
        $filtr="<SPAN class='filtr'>($__month)</SPAN>";
    }
    if ($arg=="year")
    {
        $datefirst=date_to_int(mktime (0,0,0, 1, 1, date("Y")));
        $where=" WHERE indate>='$datefirst' AND indate<='$datelast' ";
        $filtr="<SPAN class='filtr'>($__year)</SPAN>";
    }
    if (substr($arg,0,4)=="date")
    {
        $ok=0;
        $arg=substr($arg,4);
        @list($dto1, $dto2)=@explode("-", $arg);
        @list($dod, $dom, $doy)=@explode(".", $dto1);
        $day=@mktime (0,0,0, $dom, $dod, $doy);
        if (@date("j.n.Y", $day)===$dto1 or @date("d.m.Y", $day)===$dto1)
        {
            $datefirst=date_to_int($day);
            $ok++;
        }
        @list($dod, $dom, $doy)=@explode(".", $dto2);
        $day=@mktime (0,0,0, $dom, $dod, $doy);
        if (@date("j.n.Y", $day)===$dto2 or @date("d.m.Y", $day)===$dto2)
        {
            $datelast=date_to_int($day);
            $ok++;
        }
        if ($ok==2)
        {
            $where=" WHERE indate>='$datefirst' AND indate<='$datelast' ";
            $filtr="<SPAN class='filtr'>($__from $dto1 $__to $dto2)</SPAN>";
        }
    }

    
    // Сортировка по умолчанию
    $order=" ORDER BY indate  ";
?>
<H1 class='pagehead'><?=$__gain?> <?=$filtr?></H1>
<TABLE  width='*' cellpadding='5'>
<TR><TD valign='top' width='90%'>
    <TABLE width='100%'>
        <TR class='color0'>
        <TD><?=$__date?></TD>
        <TD><?=$__incat?></TD>
        <TD><?=$__sum?></TD>
        <TD><?=$__qqq?></TD>
        <TD width='40'></TD>
        </TR>
<?php

    $sq="SELECT * FROM ".$str_mysql_tbl."_income
        LEFT JOIN ".$str_mysql_tbl."_incat ON incatid=catid  $where $order ";
    $result=mysql_query($sq, $mlink);
    // echo $sq."<BR>".mysql_error();
    $color=1;
    $total="";
    $totaltoday="";
    if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
    {
        $total+=$row["insum"];
        if ($today==$row["indate"]) $totaltoday+=$row["insum"];
        if ($editid==$row["inid"])
        {
            $firstcatid=$row["catid"];
            editline($row["indate"], $row["catid"], $row["insum"], $row["inq"], $row["inid"]);
        }
        else
        {
        ?>
            <TR class='color<?=$color?>'  title='<?=$row["intxt"]?>'>
            <TD><?php echo int_to_date($row["indate"]);?></TD>
            <TD><?=$row["cattitle"]?></TD>
            <TD><?=$row["insum"]?> <?=$__rub?></TD>
            <TD><?=$row["inq"]?></TD>
            <TD><A href='?edit=<?=$row["inid"]?>'><IMG src='<?=$path?>/img/edit.png'
            border='0'></A><A href='?del=<?=$row["inid"]?>' onclick='return confirm("<?=$__ausure?>"); '><IMG src='<?=$path?>/img/del.png'
            border='0'></A></TD>
            </TR>
            <?php
        }
        $color=3-$color;
    }
    ?>
    <?php
    if ($editid==0)
    {
        $firstcatid=editline($insertdate);
    }
    ?>
    </TABLE>
</TD><TD valign='bottom' width='10%'><DIV class='news'>
    <B><?=$__summary?></B><BR>
    <?php
    $rest=0;

    $sq="SELECT SUM(outsum) AS expen FROM ".$str_mysql_tbl."_outcome  ";
    $result=mysql_query($sq, $mlink);
    if ($result and $row=mysql_fetch_array ($result, MYSQL_ASSOC)) $rest-=$row["expen"];

    $sq="SELECT SUM(insum) AS gain FROM ".$str_mysql_tbl."_income  ";
    $result=mysql_query($sq, $mlink);
    if ($result and $row=mysql_fetch_array ($result, MYSQL_ASSOC)) $rest+=$row["gain"];
    $profit=$rest;

    $sq="SELECT SUM(cedsum-cedret) AS expen FROM ".$str_mysql_tbl."_cedts  WHERE cedclosed='0' ";
    $result=mysql_query($sq, $mlink);
    if ($result and $row=mysql_fetch_array ($result, MYSQL_ASSOC)) $rest+=$row["expen"];

    $sq="SELECT SUM(debsum-debret) AS gain FROM ".$str_mysql_tbl."_debts  WHERE debclosed='0'";
    $result=mysql_query($sq, $mlink);
    if ($result and $row=mysql_fetch_array ($result, MYSQL_ASSOC)) $rest-=$row["gain"];

    if ($total!="") $total.=$__rub;
    if ($totaltoday!="") $totaltoday.=$__rub;
    if ($rest!=0) $rest.=$__rub;
    if ($profit!=0) $profit.=$__rub;
    ?>
    <nobr><?=$__total?> <?=$total?></nobr><BR>
    <nobr><?=$__totaltoday?> <?=$totaltoday?></nobr><BR><BR>
    <nobr><?=$__rest?> <?=$rest?></nobr><BR>
    <nobr><?=$__profit?> <?=$profit?></nobr><BR>
    <FORM name='fltr' class='color2'>
    <B><?=$__filtr?></B><BR>
    <A href='<?=$path?>/<?=$page?>/'><?=$__usual?></A><BR>
    <A href='<?=$path?>/<?=$page?>/month/'><?=$__month?></A><BR>
    <A href='<?=$path?>/<?=$page?>/lastmonth/'><?=$__lastmonth?></A><BR>
    <A href='<?=$path?>/<?=$page?>/year/'><?=$__year?></A><BR>
    <A href='<?=$path?>/<?=$page?>/all/'><?=$__all?></A><BR>
    <?=$__from?><BR><INPUT type='text' size='8' class='line' name='fromdate'><BR>
    <?=$__to?><BR><INPUT type='text' size='8' class='line' name='todate'><BR>
    <A href='#' onclick='this.href="<?=$path?>/<?=$page?>/date"+document.fltr.fromdate.value+"-"+document.fltr.todate.value+"/"'><?=$__ok?></A><BR>
    </FORM>
</DIV></TD></TR>
</TABLE>
<?=$errmess?>
<?=$_menu?>
<SCRIPT>
function addCat()
{
   var oNewOption = document.createElement("OPTION");
   document.frm.catid.appendChild(oNewOption);
   oNewOption.value=0;
   var str=prompt("<?=$__prom3?>");
   oNewOption.text=str;
   document.frm.catid.selectedIndex=document.frm.catid.length-1
   doselect(0);
   document.frm.newcat.value=str;
}
function addSub()
{
   var oNewOption = document.createElement("OPTION");
   document.frm.subid.appendChild(oNewOption);
   oNewOption.value=0;
   var str=prompt("<?=$__prom2?>");
   oNewOption.text=str;
   document.frm.subid.selectedIndex=document.frm.subid.length-1
   document.frm.newsub.value=str;
}
function focusSub(subid)
{
    //alert (document.frm.subid.length);
    for (i=0;i<document.frm.subid.length;i++)
    {
        if (document.frm.subid.options[i].value==subid) document.frm.subid.selectedIndex=i;
    }
}
function addOption(value, text)
{
   var oNewOption = document.createElement("OPTION");
   document.frm.subid.appendChild(oNewOption);
   oNewOption.value=value;
   oNewOption.text=text;
}

    optarray = new Array ();
    optarray[0]=new Array ();

    <?php
        $sq="SELECT * FROM ".$str_mysql_tbl."_insub ORDER BY subcatid, subtitle ";
        $result=mysql_query($sq, $mlink);
        $i=0;
        if ($result) while ($row=mysql_fetch_array ($result))
        {
            if ($i!=$row["subcatid"])
            {
                $i=$row["subcatid"];
                ?>optarray[<?=$i?>]=new Array ();
    <?php
            }
            ?>optarray[<?=$i?>][<?=$row["subid"]?>]="<?=$row["subtitle"]?>";
    <?php
        }
    ?>

function doselect(selnum)
{
    return 1;
    document.frm.subid.innerHTML="";
    for (i=1;i<optarray[selnum].length;i++)
    {
        if (optarray[selnum][i]) addOption(i, optarray[selnum][i]);
    }
}
document.all["bot"].focus();
document.frm.indate.focus();
doselect(<?=$firstcatid?>);
</SCRIPT>

