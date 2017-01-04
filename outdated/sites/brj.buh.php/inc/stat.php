<H1 class='pagehead'><?=$__stat?></H1>
<?php
if (in_array ("report", array_keys ($HTTP_POST_VARS)))
{
    $report=$HTTP_POST_VARS["report"];
    if (in_array ("fromdate", array_keys ($HTTP_POST_VARS)))
    {
        $dto1=$HTTP_POST_VARS["fromdate"];
        @list($dod, $dom, $doy)=@explode(".", $dto1);
        $day=@mktime (0,0,0, $dom, $dod, $doy);
        if (@date("j.n.Y", $day)===$dto1 or @date("d.m.Y", $day)===$dto1)
        {
            $datefirst=date_to_int($day);
        }
        else
        {
            $datefirst=date_to_int(mktime (0,0,0, 1, 1, date("Y")));
        }
    }
    if (in_array ("todate", array_keys ($HTTP_POST_VARS)))
    {
        $dto2=$HTTP_POST_VARS["todate"];
        @list($dod, $dom, $doy)=@explode(".", $dto2);
        $day=@mktime (0,0,0, $dom, $dod, $doy);
        if (@date("j.n.Y", $day)===$dto2 or @date("d.m.Y", $day)===$dto2)
        {
            $datelast=date_to_int($day);
        }
        else
        {
            $datelast=date_to_int();
        }
    }

    switch ($report)
    {
    case 1:
        $sq="SELECT catid, cattitle, subtitle, SUM(outsum) AS outsum FROM ".$str_mysql_tbl."_outcome
            LEFT JOIN ".$str_mysql_tbl."_outsub ON outsubid=subid
            LEFT JOIN ".$str_mysql_tbl."_outcat ON subcatid=catid  WHERE outdate>='$datefirst' AND outdate<='$datelast' GROUP BY subid ORDER BY catid ";
        $result=mysql_query($sq, $mlink);
        //echo $sq.mysql_error();
        $color=2;
        $catid=0;
        $total=0;
        ?>
        <CENTER>
        <H1 class='pagehead'><SPAN class='filtr'>(<?=$__rep1_2?> <?php echo int_to_date($datefirst);?> <?=$__rep1_3?> <?php echo int_to_date($datelast);?>)</SPAN></H1>
        <TABLE width='80%'>
        <?php
        if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
        {
            if ($catid!=$row["catid"])
            {
                if ($catid)
                {
                ?>
                <TR class='color0' >
                <TD colspan='2'><?=$__cattotal?> <?=$cattitle?></TD>
                <TD><?=$cattotal?> <?=$__rub?></TD>
                </TR>
                <TR></TR>
                <?php
                }
                $catid=$row["catid"];
                $cattitle=$row["cattitle"];
                $cattotal=0;
            }
            $total+=$row["outsum"];
            $cattotal+=$row["outsum"];
            ?>
            <TR class='color<?=$color?>'>
            <TD><?=$row["cattitle"]?></TD>
            <TD><?=$row["subtitle"]?></TD>
            <TD><?=$row["outsum"]?> <?=$__rub?></TD>
            </TR>
            <?php
            //$color=3-$color;
        }
        if (isset($cattitle))
        {
            ?>
            <TR class='color0' >
            <TD colspan='2'><?=$__cattotal?> <?=$cattitle?></TD>
            <TD><?=$cattotal?> <?=$__rub?></TD>
            </TR>
            <TR></TR>
            <TR class='color0' >
            <TD colspan='2'><B><?=$__total?></B></TD>
            <TD><B><?=$total?> <?=$__rub?></B></TD>
            </TR>
            <TR></TR>
            <?php
        }
        ?>
        </TABLE>
        </CENTER>
        <?php
    break;
    case 2:
        $sq="SELECT cattitle, SUM(outsum) AS outsum FROM ".$str_mysql_tbl."_outcome
            LEFT JOIN ".$str_mysql_tbl."_outsub ON outsubid=subid
            LEFT JOIN ".$str_mysql_tbl."_outcat ON subcatid=catid  WHERE outdate>='$datefirst' AND outdate<='$datelast' GROUP BY catid ORDER BY outsum DESC";
        $result=mysql_query($sq, $mlink);
        $total=0;
        if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
        {
            $cat[$row["cattitle"]]=$row["outsum"];
            $total+=$row["outsum"];
        }
        $picwidth=600;
        $picheight=30;
        if ($total==0) $total=1;
        ?>
        <CENTER>
        <H1 class='pagehead'><SPAN class='filtr'>(<?=$__rep1_2?> <?php echo int_to_date($datefirst);?> <?=$__rep1_3?> <?php echo int_to_date($datelast);?>)</SPAN></H1>
        <DIV>
        <?php
        $color=0;
        $text="";
        if (isset($cat)) foreach ($cat as $cattitle => $outsum)
        {
            $proc=$outsum/$total;
            $imgwidth=round($proc*$picwidth, 0);
            $proc=round($proc*100, 0);
            echo "<IMG src='$path/img/color$color.png' height='$picheight' width='$imgwidth' alt='$cattitle: $outsum $__rub ($proc %)'>";
            $text.="<TR><TD><IMG src='$path/img/color$color.png' height='15' width='15'></TD><TD>$cattitle</TD><TD>$outsum&nbsp;$__rub</TD><TD>($proc&nbsp;%)</TD></TR>";
            $color=($color+1)%10;
        }
        ?>
        </DIV>
        <TABLE cellpadding='2'>
        <?=$text?>
        </TABLE>
        </CENTER>
        <?php
    break;
    case 3:
        $sq="SELECT outdate, SUM(outsum) AS outsum FROM ".$str_mysql_tbl."_outcome
            WHERE outdate>='$datefirst' AND outdate<='$datelast' GROUP BY outdate ORDER BY outdate ";
        $result=mysql_query($sq, $mlink);
        $maxmonth=0;
        if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
        {
            $k=int_to_date($row["outdate"], "F Y");
            if (!isset($month[$k])) $month[$k]=0;
            $month[$k]+=$row["outsum"];
            if ($month[$k]>$maxmonth) $maxmonth=$month[$k];
        }
        $sq="SELECT indate, SUM(insum) AS insum FROM ".$str_mysql_tbl."_income
            WHERE indate>='$datefirst' AND indate<='$datelast' GROUP BY indate ORDER BY indate ";
        $result=mysql_query($sq, $mlink);
        if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
        {
            $k=int_to_date($row["indate"], "F Y");
            if (!isset($inmonth[$k])) $inmonth[$k]=0;
            if (!isset($month[$k])) $month[$k]=0;
            $inmonth[$k]+=$row["insum"];
            if ($inmonth[$k]>$maxmonth) $maxmonth=$inmonth[$k];
        }
        $picwidth=600;
        $picheight=200;
        if ($maxmonth==0) $maxmonth=1;
        $count=count($month);
        if ($count==0) $count=1;
        $imgwidth=round($picwidth/3/$count, 0);
        if ($imgwidth>20) $imgwidth=20;
        if ($imgwidth<5) $imgwidth=5;
        ?>
        <CENTER>
        <H1 class='pagehead'><SPAN class='filtr'>(<?=$__rep1_2?> <?php echo int_to_date($datefirst);?> <?=$__rep1_3?> <?php echo int_to_date($datelast);?>)</SPAN></H1>
        <TABLE cellpadding='2'>
        <TR>
        <?php
        $color=0;
        $text="";
        if (isset($month)) foreach ($month as $mn => $outsum)
        {
            if (!isset($inmonth[$mn])) $inmonth[$mn]=0;
            $proc=$outsum/$maxmonth;
            $imgheight=round($proc*$picheight, 0);
            $proc=$inmonth[$mn]/$maxmonth;
            $inimgheight=round($proc*$picheight, 0);
            echo "<TD valign='bottom' align='center'><IMG src='$path/img/color2.png' height='$inimgheight' width='$imgwidth' alt='".$inmonth[$mn]." $__rub'>
                <IMG src='$path/img/color3.png' height='$imgheight' width='$imgwidth' alt='$outsum $__rub'></TD>";
            $text.="<TD align='center'>&nbsp;$mn&nbsp;<BR>&nbsp;".$inmonth[$mn]." $__rub / $outsum $__rub&nbsp;</TD>";
            $color=($color+1)%10;
        }
        ?>
        </TR>
        <TR>
        <?=$text?>
        </TR>
        </TABLE>
        </CENTER>
        <?php
    break;
    case 4:
        $sq="SELECT outdate, SUM(outsum) AS outsum FROM ".$str_mysql_tbl."_outcome
            GROUP BY outdate ORDER BY outdate ";
        $result=mysql_query($sq, $mlink);
        if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
        {
            $k=int_to_date($row["outdate"], "F Y");
            if (!isset($month[$k])) $month[$k]=0;
            $month[$k]+=$row["outsum"];
        }
        $sq="SELECT indate, SUM(insum) AS insum FROM ".$str_mysql_tbl."_income
            GROUP BY indate ORDER BY indate ";
        $result=mysql_query($sq, $mlink);
        if ($result) while ($row=mysql_fetch_array ($result, MYSQL_ASSOC))
        {
            $k=int_to_date($row["indate"], "F Y");
            if (!isset($inmonth[$k])) $inmonth[$k]=0;
            if (!isset($month[$k])) $month[$k]=0;
            $inmonth[$k]+=$row["insum"];
        }
        $picwidth=600;
        $picheight=200;
        $count=count($month);
        if ($count==0) $count=1;
        $imgwidth=round($picwidth/3/$count, 0);
        if ($imgwidth>20) $imgwidth=20;
        if ($imgwidth<5) $imgwidth=5;
        ?>
        <CENTER>
        <H1 class='pagehead'><SPAN class='filtr'>(<?=$__rep4_1?>)</SPAN></H1>
        <TABLE cellpadding='2'>
        <TR>
        <?php
        $text="";
        $sum=0;
        $maxmonth=0;
        if (isset($month)) foreach ($month as $mn => $outsum)
        {
            if (!isset($inmonth[$mn])) $inmonth[$mn]=0;
            $sum+=$inmonth[$mn]-$month[$mn];
            $month[$mn]=$sum;
            if ($month[$mn]>$maxmonth) $maxmonth=$month[$mn];
            if (-$month[$mn]>$maxmonth) $maxmonth=-$month[$mn];
        }
        if ($maxmonth==0) $maxmonth=1;
        if (isset($month)) foreach ($month as $mn => $outsum)
        {
            $color=2;
            if ($month[$mn]<0)
            {
                $month[$mn]=-$month[$mn];
                $color=3;
            }
            $proc=$month[$mn]/$maxmonth;
            $imgheight=round($proc*$picheight, 0);
            echo "<TD valign='bottom' align='center'><IMG src='$path/img/color$color.png' height='$imgheight' width='$imgwidth' alt='".$month[$mn]." $__rub'></TD>";
            $text.="<TD align='center'>&nbsp;$mn&nbsp;<BR>&nbsp;$outsum $__rub&nbsp;</TD>";
        }
        ?>
        </TR>
        <TR>
        <?=$text?>
        </TR>
        </TABLE>
        </CENTER>
        <?php
    break;
    }
}
else
{
    $datefirst=date("j.n.Y", mktime (0,0,0, 1, 1, date("Y")));
    $datelast=date("j.n.Y");
    ?>
    <TABLE>
    <!-- Отчёт начало -->
    <FORM name='fltr' method='post'><TR class='color2'><TD>
    <INPUT type='hidden' value='1' name='report'>
    <?=$__rep1_1?>
    <?=$__rep1_2?> <INPUT type='text' size='8' class='line' name='fromdate' value='<?=$datefirst?>'>
    <?=$__rep1_3?> <INPUT type='text' size='8' class='line' name='todate' value='<?=$datelast?>'>
    </TD><TD>
    <INPUT type='image' src='<?=$path?>/img/report.png' name='save'>
    </TD></TR></FORM>
    <!-- Отчёт конец -->

    <!-- Отчёт начало -->
    <FORM name='fltr' method='post'><TR class='color2'><TD>
    <INPUT type='hidden' value='2' name='report'>
    <?=$__rep2_1?>
    <?=$__rep2_2?> <INPUT type='text' size='8' class='line' name='fromdate' value='<?=$datefirst?>'>
    <?=$__rep2_3?> <INPUT type='text' size='8' class='line' name='todate' value='<?=$datelast?>'>
    </TD><TD>
    <INPUT type='image' src='<?=$path?>/img/report.png' name='save'>
    </TD></TR></FORM>
    <!-- Отчёт конец -->

    <!-- Отчёт начало -->
    <FORM name='fltr' method='post'><TR class='color2'><TD>
    <INPUT type='hidden' value='3' name='report'>
    <?=$__rep3_1?>
    <?=$__rep3_2?> <INPUT type='text' size='8' class='line' name='fromdate' value='<?=$datefirst?>'>
    <?=$__rep3_3?> <INPUT type='text' size='8' class='line' name='todate' value='<?=$datelast?>'>
    </TD><TD>
    <INPUT type='image' src='<?=$path?>/img/report.png' name='save'>
    </TD></TR></FORM>
    <!-- Отчёт конец -->

    <!-- Отчёт начало -->
    <FORM name='fltr' method='post'><TR class='color2'><TD>
    <INPUT type='hidden' value='4' name='report'>
    <?=$__rep4_1?>
    </TD><TD>
    <INPUT type='image' src='<?=$path?>/img/report.png' name='save'>
    </TD></TR></FORM>
    <!-- Отчёт конец -->
    </TABLE>
<?php
}
?>





