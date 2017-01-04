<?php
function myslash($prtitle)
{
    if (get_magic_quotes_gpc()) $prtitle=stripslashes($prtitle);
    $prtitle=str_replace("<", "&lt;", $prtitle);
    $prtitle=str_replace("'", "&#39;", $prtitle);
    $prtitle=addslashes($prtitle);
    return $prtitle;
}
$errmess="";
// возврат
if (in_array ("retnow", array_keys ($HTTP_POST_VARS)))
{
    //foreach ($HTTP_POST_VARS as $k=>$v) echo "$k => $v <BR>";
    $retid=$HTTP_POST_VARS["retid"]+0;
    $debret=$HTTP_POST_VARS["retnow"]+0;
    $retrest=$HTTP_POST_VARS["retrest"]+0;
    $hist=date("d.m.Y")." - $debret \n";
    if ($debret<=$retrest)
    {
        $closed="";
        if ($debret==$retrest) $closed=" , debclosed='1' ";
        $sq="UPDATE ".$str_mysql_tbl."_debts SET debret=debret+'$debret',
            debhistory=CONCAT(debhistory, '$hist') $closed
            WHERE debid='$retid' ";
        $result=mysql_query($sq, $mlink);
    }
    else
    {
        $errmess="<DIV class='error'>ERROR: Too much return: $debret vs $retrest </DIV>";
    }
}
// добавление новостей

if (in_array ("debsum", array_keys ($HTTP_POST_VARS)))
{
    //foreach ($HTTP_POST_VARS as $k=>$v) echo "$k => $v <BR>";
    //exit;
    //
    $dto=$HTTP_POST_VARS["debdate"];
    @list($dod, $dom, $doy)=@explode(".", $dto);
    $day=@mktime (0,0,0, $dom, $dod, $doy);
    if (@date("j.n.Y", $day)===$dto)
    {
        $debdate=date("y", $day)*1000+date("z", $day);
        $insertdate=$debdate;
    }
    else
    {
        $errmess="<DIV class='error'>ERROR: Invalid date</DIV>";
    }
    //
    $debsum=$HTTP_POST_VARS["debsum"]+0;
    if (!$debsum)
    {
        $errmess="<DIV class='error'>ERROR: Zero sum</DIV>";
    }
    //
    $debtxt=myslash($HTTP_POST_VARS["debtxt"]);
    $debname=myslash($HTTP_POST_VARS["debname"]);
    if (trim($debname)=="")
    {
        $errmess="<DIV class='error'>ERROR: Empty name</DIV>";
    }

    if ($errmess=="")
    {
        $sq="INSERT INTO ".$str_mysql_tbl."_debts SET  debdate='$debdate', debname='$debname',
            debsum='$debsum', debtxt='$debtxt', debret='0', debhistory='' ";
        $result=mysql_query($sq, $mlink);
        //echo $sq."<BR>".mysql_error();
    }
}
if (in_array ("del", array_keys ($HTTP_GET_VARS)))
{
    $delid=$HTTP_GET_VARS["del"]+0;
    $sq="DELETE FROM ".$str_mysql_tbl."_debts WHERE debid='$delid' ";
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
    $where=" WHERE debdate>='$datefirst' AND debdate<='$datelast' ";
    // фильтр по дате
    if ($arg=="all")
    {
        $where=" ";
        $filtr="<SPAN class='filtr'>($__all)</SPAN>";
    }
    if ($arg=="month")
    {
        $datefirst=date_to_int(mktime (0,0,0, date("m"), 1, date("Y")));
        $where=" WHERE debdate>='$datefirst' AND debdate<='$datelast' ";
        $filtr="<SPAN class='filtr'>($__month)</SPAN>";
    }
    if ($arg=="lastmonth")
    {
        $datefirst=date_to_int(mktime (0,0,0, date("m")-1, 1, date("Y")));
        $datelast=date_to_int(mktime (0,0,0, date("m"), 0, date("Y")));
        $where=" WHERE debdate>='$datefirst' AND debdate<='$datelast' ";
        $filtr="<SPAN class='filtr'>($__month)</SPAN>";
    }
    if ($arg=="year")
    {
        $datefirst=date_to_int(mktime (0,0,0, 1, 1, date("Y")));
        $where=" WHERE debdate>='$datefirst' AND debdate<='$datelast' ";
        $filtr="<SPAN class='filtr'>($__year)</SPAN>";
    }
    if (substr($arg,0,4)=="date")
    {
        $ok=0;
        $arg=substr($arg,4);
        @list($dto1, $dto2)=@explode("-", $arg);
        @list($dod, $dom, $doy)=@explode(".", $dto1);
        $day=@mktime (0,0,0, $dom, $dod, $doy);
        if (@date("j.n.Y", $day)===$dto1)
        {
            $datefirst=date_to_int($day);
            $ok++;
        }
        @list($dod, $dom, $doy)=@explode(".", $dto2);
        $day=@mktime (0,0,0, $dom, $dod, $doy);
        if (@date("j.n.Y", $day)===$dto2)
        {
            $datelast=date_to_int($day);
            $ok++;
        }
        if ($ok==2)
        {
            $where=" WHERE debdate>='$datefirst' AND debdate<='$datelast' ";
            $filtr="<SPAN class='filtr'>($__from $dto1 $__to $dto2)</SPAN>";
        }
    }

    
    // Сортировка по умолчанию
    $order=" ORDER BY debdate  ";
?>
<H1 class='pagehead'><?=$__debts?> <?=$filtr?></H1>
<TABLE  width='*' cellpadding='5'>
<TR><TD valign='top' width='90%'>
    <TABLE width='100%'>
        <TR class='color0'>
        <TD><?=$__date?></TD>
        <TD><?=$__creditor?></TD>
        <TD><?=$__sum?></TD>
        <TD><?=$__note?></TD>
        <TD><?=$__retsum?></TD>
        <TD><?=$__retnow?></TD>
        <TD width='40'></TD>
        </TR>
<?php

    $sq="SELECT * FROM ".$str_mysql_tbl."_debts  $where $order ";
    $result=mysql_query($sq, $mlink);
    // echo $sq."<BR>".mysql_error();
    $color=1;
    $total="";
    $totalret="";
    $diff="";
    if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
    {
        $total+=$row["debsum"];
        $totalret+=$row["debret"];
        $retrest=$row["debsum"]-$row["debret"];
        ?>
            <FORM action='' name='ret<?=$row["debid"]?>' method='post'>
            <INPUT type='hidden' name='retid' value='<?=$row["debid"]?>'>
            <INPUT type='hidden' name='retrest' value='<?=$retrest?>'>
            <TR class='color<?=$color?>'  title='<? echo trim($row["debhistory"]); ?>'>
            <TD><?php echo int_to_date($row["debdate"]);?></TD>
            <TD><?=$row["debname"]?></TD>
            <TD><?=$row["debsum"]?> <?=$__rub?></TD>
            <TD width='210'><nobr><DIV style='width:200px; overflow: hidden;' title='<?=$row["debtxt"]?>'><?=$row["debtxt"]?></DIV></nobr></TD>
            <TD><?=$row["debret"]?></TD>
            <TD>
            <?php
            if ($retrest>0)
            {
                $retimg="<INPUT type='image' src='$path/img/return.png' border='0'>";
                ?>
            <INPUT class='line' style='color:#bbbbbb;' onchange='this.style.color="#000000";' type='text' size='6' name='retnow' value='<?=$retrest?>'>
                <?php
            }
            else
            {
                $retimg="<IMG src='$path/img/ok.png' border='0'>";
                ?>
            <?=$__closed?>
                <?php
            }
            ?>
            </TD>
            <TD><?=$retimg?><A href='?del=<?=$row["debid"]?>' onclick='return confirm("<?=$__ausure?>"); '><IMG src='<?=$path?>/img/del.png'
            border='0'></A></TD>
            </TR>
            </FORM>
            <?php
        $color=3-$color;
    }
    ?>
    <?php
    if (1)
    {
        ?>
        <FORM action='' name='frm' method='post'>
        <TR class='color<?=$color?>'>
        <TD><INPUT class='line' type='text' size='8' value='<?php echo int_to_date($insertdate); ?>' name='debdate'></TD>
        <TD><INPUT class='line' type='text' size='8' maxlength='250' value='' name='debname'></TD>
        <TD><INPUT class='line' type='text' size='6' value='' name='debsum'></TD>
        <TD colspan='3'><INPUT class='line' type='text' size='50' maxlength='250' value='' name='debtxt'></TD>
        <TD><INPUT type='image' src='<?=$path?>/img/save.png' name='save'></TD>
        </TR>
        </FORM>
        <?php
    }
    ?>
    </TABLE>
</TD><TD valign='bottom' width='10%'><DIV class='news'>
    <B><?=$__summary?></B><BR>
    <?php
    $loans="";
    $debt="";

    $sq="SELECT SUM(ce"."dsum-ce"."dret) AS expen FROM ".$str_mysql_tbl."_ce"."dts  WHERE ce"."dclosed='0' ";
    $result=mysql_query($sq, $mlink);
    if ($result and $row=mysql_fetch_array ($result, MYSQL_ASSOC)) $loans=$row["expen"];

    $sq="SELECT SUM(de"."bsum-de"."bret) AS gain FROM ".$str_mysql_tbl."_de"."bts  WHERE de"."bclosed='0'";
    $result=mysql_query($sq, $mlink);
    if ($result and $row=mysql_fetch_array ($result, MYSQL_ASSOC)) $debt=$row["gain"];

    $dolg=$total-$totalret.$__rub;
    if ($total!="") $total.=$__rub;
    if ($totalret!="") $totalret.=$__rub;
    if ($loans!="") $loans.=$__rub;
    if ($debt!="") $debt.=$__rub;
    ?>
    <nobr><?=$__total?> <?=$total?></nobr><BR>
    <nobr><?=$__totalret?> <?=$totalret?></nobr><BR>
    <nobr><?=$__dolg?> <?=$dolg?></nobr><BR><BR>
    <nobr><?=$__loans?> <?=$loans?></nobr><BR>
    <nobr><?=$__tome?> <?=$debt?></nobr><BR>
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
document.all["bot"].focus();
document.frm.debdate.focus();
</SCRIPT>

