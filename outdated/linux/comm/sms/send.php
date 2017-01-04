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



Далее, для того, чтобы удаленный хостинг мог отвечать на запросы shell-скрипта, необходимо, чтобы в его корневой директории были расположены следующие файлы:

файл serv_mobile.php — отвечает за обработку сообщений, принятых мобильным телефоном

<?php
#$sms_text=mysql_real_escape_string($_GET['text']); // получаем очередную смску от хома + защита от инъекций
$sms_text=$_GET['text']; // получаем очередную смску от хома + защита от инъекций

file_put_contents("temp_mobile_mess.txt", $sms_text); //записываем всю смску во временное хранилище
$get_from_file = file_get_contents("temp_mobile_mess.txt"); //записываем всю смску в переменную
 
$number = substr("$get_from_file", 72, 11); //выделяем номер отправителя (не забывать про read/unread)
$pass = substr("$get_from_file", 103, 5); 	//выделяем пароль
$message = substr("$get_from_file", 109); 	//выделяем текст сообщения


//connect_to_BD-------------------------- 
include(db_connect.php);
//connect_to_BD--------------------------
mysql_query("SET NAMES 'utf8'");

//защита от инъекций
$number = mysql_real_escape_string($number);
$pass = mysql_real_escape_string($pass);
$message = mysql_real_escape_string($message);

//защита от инъекций


$r = mysql_query("SELECT COUNT(*) FROM `starosti` WHERE pass='$pass' AND number='$number'"); //проверяет наличие связки пароль/номер в базе
while($row = mysql_fetch_array($r))
    {
        

        if($row[0] == 1) //определил, что такая связка присутствует
            {


//------------определяет заполнение поля id_this_trans---------------
                    $q = mysql_query("SELECT id_this_trans FROM on_demand ORDER BY id_this_trans DESC LIMIT 0, 1"); // выводит номер последней трансакции

                            while($rowq = mysql_fetch_array($q))
                                {
                                    
                                    $last_tranzaktion = $rowq['id_this_trans'];
                                    
                                }

                            $last_tranzaktion++; // подготовили id новой транзакции
//------------определяет заполнение поля id_this_trans---------------
                            
//------------вставляет все полученные данные в таблицу on_demand----	
                    $second_r = mysql_query("SELECT * FROM `starosti` WHERE pass='$pass' AND number='$number'"); //узнаем курс и группу старосты, приславшей смску
                    while($second_row = mysql_fetch_array($second_r))
                        {
                    
                            $groups = $second_row['group'];
                            $course = $second_row['course'];
                            $heutige_datum = date("Y-m-d H:i:s");
                            mysql_query ("INSERT INTO on_demand VALUES('$message','$groups','$course','$last_tranzaktion','$heutige_datum')"); // формирует указание для отправки
                        }
//------------вставляет все полученные данные в таблицу on_demand----	

    #не забыть обновить триггер на новое значение транзакции
    file_put_contents("trigger.txt", $last_tranzaktion);
         			  
            }

        
    }
    
?>



Скрипт trigger.php, тоже лежит в корневой директории, создает папки на хостинге, содержащие файл с сообщением и файл с номерами, которым это сообщение будет рассылаться.

Его листинг:
<?php
$inp_diff = $_GET['diff'];  // принимает различия от хома

//connect_to_BD-------------------------- 
include(db_connect.php);
//connect_to_BD--------------------------
mysql_query("SET NAMES 'utf8'");

//Create files AND Folders---------------
for($i=1; $i<=$inp_diff;$i++)
    {
        mkdir("send$i");
        file_put_contents("send$i/message.txt",'');
        file_put_contents("send$i/numbers.txt",'');
    }
//Create files AND Folders---------------

$counter=1;// счетчик для записи в папки, указывает на номер папки

// Вывод последних дифферент записей-----
$r = mysql_query("SELECT * FROM on_demand ORDER BY id_this_trans DESC LIMIT 0, $inp_diff"); // выводит последние записи

while($row = mysql_fetch_array($r))
    {
        file_put_contents("send$counter/message.txt",$row['message']); //заполняет текстом файл message.txt во всех папках
// заполняем файл numbers.txt во всех папках			
            $help_course = $row['course'];
            $help_group = $row['group'];
            $second_r = mysql_query("SELECT * FROM telephones WHERE course='$help_course' AND groups='$help_group'");
            while($second_row = mysql_fetch_array($second_r))
                {
                    
                    $insert_number = $second_row['number']; // помогает записать в файл 1 номер на 1 итерации
                    $fp=fopen("send$counter/numbers.txt","a");
                    fputs($fp,$insert_number. "\n");
                    fclose($fp);
                    

                }
// заполняем файл numbers.txt во всех папках			
$counter++;
        
    }
// Вывод последних дифферент записей-----

echo "ok";

?>


Последний файл в корневой директории — файл terminate.php. Удаляет созданные ранее папки с сервера, когда сообщения уже разосланы.

Его листинг:
<?php
$inp_diff = $_GET['kill'];  // принимает различия от хома

//Delete files AND Folders---------------
for($i=1; $i<=$inp_diff;$i++)
    {
        unlink("send$i/message.txt");
        unlink("send$i/numbers.txt");
            rmdir("send$i");
    }
//Delete files AND Folders---------------

?>
