#!/bin/bash

a=1 #заглушка для  бесконечного цикла
test_trigger=`cat cache_test_trig.txt` #исходное значение триггера при старте программы

while [ $a == 1  ] #начало бесконечного цикла
do
if ping -c1 ya.ru &> /dev/null
then


test_trigger_now=$(wget http://site.ru/trigger.txt --quiet -O -) # получаем значение триггера

    if [ $test_trigger_now -eq $test_trigger ]; then  #совпадает ли текущий триггер с новым?
              echo "Nothing new :("  			#если совпадает, уход в сон до след цикла
              
###############################
######### Mobile extention
###############################
aa=1 #переменная для поддержания цикла
#count=1 #счетчик для выбора смс из памяти по 1


while [ $aa == 1  ] # получение смсок из памяти по 1
do


sms_test=$(gnokii --getsms IN 1 1) #считали 1 сообщение в цикле (1 1,2 2 и т.д.)
echo $sms_test>mobile_temp.txt #поместили ответ системы в файл
answer_test=$(grep -c Date/time: mobile_temp.txt) #ищем в ответе ключевое слово, присущее сообщению(Date/time:)

if [ "$answer_test" != "1" ]; then #если ключевое слово не найдено, память закончилась, вышла ошибка

aa=2 # прерываем цикл
echo "messages over! Stop"

elif [ "$answer_test" == "1" ]; then #если ключевое слово найдено, 

echo "Here is 1 message"
#let count=$count+1 #работа со счетчиком выборки из памяти
#Теперь в переменной sms_test находится сообщение вида '1. Inbox Message (Unread) Date/time: 07/02/2013 15:33:16 +0400 Sender: +7904xxxxxx Msg Center: Text: 51235 Мое сообщение.'

server_send=$(wget http://site.ru/serv_mobile.php?text="$sms_test" -O /dev/null) #передаем сообщение на сервер для записи/незаписи в бд

sleep 1
gnokii --deletesms IN 1 1 #очищает память телефона 1 сообщение
fi

sleep 3
done




###############################
######### Mobile extention
###############################
              
              
              sleep 500
                
                else 							#если не совпадает, запуск программы смс-отправки
                echo "i need to do something!"
                let different=$test_trigger_now-$test_trigger #(стало-было), сколько нового
                #echo $different #разницу выдает правильно
                get_sender=$(wget http://site.ru/trigger.php?diff=$different --quiet -O -) # в скрипт на реме передается количество новых записей (сколько папок создавать)
                #echo $get_sender # скрипт на реме воспринимает переменную different нормально
                echo $get_sender #возвращает ОК от рема
                sleep 3 #дадим рему время очухаться
                
                #Start SMS-sending
                n=0
                while [ $n -lt $different ]    # пока n < different
                do
                    let n=$n+1
#!!!!!!!!!!!SENDING!!!!!!!!!!!!!!
            
                    echo "send files from send$n folder" #место для запуска gnokii					
                    mess_for_gnok=$(wget http://site.ru/send$n/message.txt --quiet -O -) #скачиваем сообщение
                    numb_for_gnok=$(wget http://site.ru/send$n/numbers.txt) #скачиваем номера
                    cat numbers.txt | while read line
                    do
                    inp=$line
                    echo "$mess_for_gnok" | gnokii --sendsms $inp
                    echo $line
                    echo $mess_for_gnok
                    sleep 2
                    done
                    rm numbers.txt #delete temporary files
                    sleep 1
#!!!!!!!!!!!SENDING!!!!!!!!!!!!!!					
                done
                terminator=$(wget http://site.ru/terminate.php?kill=$different --quiet -O -) # delete all temperal folders in root
                #echo "i kill all files"
                
                test_trigger=$test_trigger_now #задание выполнено, поднимаемся и ждем новых изменений в trigger.txt
                echo $test_trigger>cache_test_trig.txt
                
                
                sleep 10 #засыпает после всех действий
              
    fi

else
echo "Here is no Internet. Find it!"
sleep 500
fi

done


