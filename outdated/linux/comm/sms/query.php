<?php
$prev_page = $_SERVER['HTTP_REFERER'];

$who_is_you = substr_count("$prev_page", "http://site.ru/index.php/"); //защита от многократных запросов и запросов извне

        if ($who_is_you == 1)
        
            {

$message=$_POST['message'];
$message=htmlspecialchars(stripslashes($message)); // обработка от спецсимволов

$course=$_POST['Course'];
$course=htmlspecialchars(stripslashes($course));   // обработка от спецсимволов

$groups=$_POST['Group'];
$groups=htmlspecialchars(stripslashes($groups));   // обработка от спецсимволов

$facult=$_POST['Facult'];
$facult=htmlspecialchars(stripslashes($facult));   // обработка от спецсимволов




//validation-----------------------------
 if (empty($message))
  {
    
    echo "
<body style='background-image: url(body_bg.gif); background-repeat: repeat-x'> 

<div align='center' style='margin-top: 14%'>
<p style='color: #666666; font-family: Verdana,Helvetica,sans-serif; font-size: 18px; line-height: 1.8em;'><i>Ваше сообщение НЕ отправлено!</i> <br>Текст уведомления не указан. <a href = '$prev_page'>Вернитесь назад и заполните поле.</a> </p>
</div>

</body>
    ";
    
  }
//validation-----------------------------
  
 else
  {

//connect_to_BD-------------------------- 
include(db_connect.php);
//connect_to_BD--------------------------
mysql_query("SET NAMES 'utf8'");
$r = mysql_query("SELECT id_this_trans FROM on_demand ORDER BY id_this_trans DESC LIMIT 0, 1"); // выводит номер последней трансакции

while($row = mysql_fetch_array($r))
    {
        
        $last_tranzaktion = $row['id_this_trans'];
        
    }

$last_tranzaktion++; // подготовили id новой транзакции
$heutige_datum = date("Y-m-d H:i:s");
mysql_query ("INSERT INTO on_demand VALUES('$message','$groups','$course','$last_tranzaktion', '$heutige_datum')"); // новое указание для отправки

file_put_contents("trigger.txt", $last_tranzaktion);

    echo "
<body style='background-image: url(body_bg.gif); background-repeat: repeat-x'> 

<div align='center' style='margin-top: 14%'>
<p style='color: #666666; font-family: Verdana,Helvetica,sans-serif; font-size: 18px; line-height: 1.8em;'><i>Ваше сообщение принято  к отправке!</i> <br> Вы можете завершить работу с сервисом, или <a href = 'http://site.ru/'>вернуться в Главное меню системы</a> </p>
</div>

</body>
    ";
    
  }
  
            }
        
        
        else


            {
                
    echo "
<html>
<head><title> 404 Not Found
</title></head>
<body><h1> 404 Not Found
</h1>
The resource requested could not be found on this server!<hr />
Powered By <a href='http://www.litespeedtech.com'>LiteSpeed Web Server</a><br />
<font face='Verdana, Arial, Helvetica' size=-1>LiteSpeed Technologies is not responsible for administration and contents of this web site!</font></body></html>
    ";  		
            }
?>
