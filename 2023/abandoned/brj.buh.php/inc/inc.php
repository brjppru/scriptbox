<?
$path="http://$url_domen_path";
$serverpath="http://$url_domen_path";
//$curpath="E:\Documents and Settings\Sense\My Documents\My Docs\myWWW\brj";

function tire($str)
{
    $str=str_replace("\r\n", "<BR>", $str);
    $str=str_replace("\n", "<BR>", $str);
    $str=eregi_replace("([^- ]{1,}) - ", "<nobr>\\1 &#151;</nobr> ", $str);
    $str=eregi_replace("([\.]{3})", "&#133;", $str);
    $str=eregi_replace(' "', " &laquo;", $str);
    $str=eregi_replace('"(\.|,| )', "&raquo;\\1", $str);
    $str=eregi_replace('"$', "&raquo;", $str);
    $str=eregi_replace('^"', "&laquo;", $str);
    $str=str_replace('"<', "&raquo;<", $str);
    $str=str_replace('>"', ">&laquo;", $str);
    return $str;
}

function reptext($text)
{
    global $path;
    global $url_domen_path;

    $text=str_replace("HTTP:", "http:", $text);
    while (ereg("http:([-:\?&=%0-9a-zA-Z\./]{1,})",$text, $ip))
    {
        $url="HTTP".substr($ip[0],4);
        $text=str_replace($ip[0],"<A href='".$url."' >".$url."</A>",$text);

    }

    //$text=str_replace("\n", "</DIV>\n<DIV class='text'>", $text);
    $text=str_replace("[B]", "<SPAN class='paragraf'>", $text);
    $text=str_replace("[/B]", "</SPAN>", $text);
    $text=str_replace("[/b]", "</SPAN>", $text);
    $text=str_replace("[b]", "<SPAN class='paragraf'>", $text);
        $mess=$text;
        $mess=str_replace("[red]", "<FONT color=red>", $mess);
        $mess=str_replace("[/red]", "</FONT>", $mess);
        $mess=str_replace("[blue]", "<FONT color=blue>", $mess);
        $mess=str_replace("[/blue]", "</FONT>", $mess);
        $mess=str_replace("[green]", "<FONT color=green>", $mess);
        $mess=str_replace("[/green]", "</FONT>", $mess);
        $text=$mess;
    $text=eregi_replace("\[IR=([-_a-z0-9A-Z\.]{1,255})\]", "<IMG src='$path/pic/\\1' border='0' align='right' class='textimgright'>", $text);
    $text=eregi_replace("\[IL=([-_a-z0-9A-Z\.]{1,255})\]", "<IMG src='$path/pic/\\1' border='0' align='left' class='textimgleft'>", $text);
    $text=eregi_replace("\[IC=([-_a-z0-9A-Z\.]{1,255})\]", "<CENTER><IMG src='$path/pic/\\1' border='0' class='textimg'></CENTER>", $text);
    $text=eregi_replace("\[A=([a-z0-9]{1,25})\]", "<A href='http://$url_domen_path/doc/\\1.html' class='paragraf'>", $text);
    $text=eregi_replace("\[FILE=([-_a-z0-9A-Z\./]{1,255})\]", "<A href='\\1'>", $text);
    $text=str_replace("[/A]", "</A>", $text);
    $text=str_replace("[/FILE]", "</A>", $text);


    return tire($text);
}

function date_to_rus($str)
{
    if (ereg("^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$", $str))
    {
        $str_rus=substr($str,8,2)."-".substr($str,5,2)."-".substr($str,0,4)." ".substr($str,11);
        return $str_rus;
    }
    else return $str;
} // end function date_to_rus
function int_to_date($dint, $format="j.n.Y")
{
    $day=mktime(0,0,0,1, $dint%1000+1, round($dint/1000 ,0)) ;
    return date($format, $day);
} // end function int_to_date

function date_to_int($day=0)
{
    if ($day==0) return date("y")*1000+date("z");
    elseif ($day<0)
    {
       $day=mktime (0,0,0, date("m"), date("d")+$day, date("Y"));
       return date("y", $day)*1000+date("z", $day);
    }
    else  return date("y", $day)*1000+date("z", $day);
} // end function int_to_date


?>
