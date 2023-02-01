#!/usr/bin/env bash

PHONE_NUMBER="+7904xxxxxx"
BUFFER=$(gnokii --getsms IN 1 end)

function do_send_message () {
    # do_send_message $phone_number $message
    echo $2 | gnokii --sendsms $1;
}

if [[ "$BUFFER" == *"Люба"* ]]; then
    do_send_message $PHONE_NUMBER "бла бла бла"
elif [[ "$BUFFER" == *"Любовь"* ]]; then
    do_send_message $PHONE_NUMBER "другой ответ"
fi

#!/bin/sh
#
# Created by ZigFisher
# 2011.09.11 v.0.1
#

CONFIG=/etc/gnokiirc
MEMTYPE=SM  # use ME, SM, IN, OU
INCOMING=$(gnokii --config $CONFIG --getsms $MEMTYPE 0 && gnokii --config $CONFIG --deletesms $MEMTYPE 0)
ABONENT=$(echo $INCOMING | awk '{print $10}' | grep '+')
REQUEST=$(echo $INCOMING | awk '{print $15}' | tr 'A-Z' 'a-z')
LOGFILE='/home/zig/gnokii.log'

echo "$ABONENT => $REQUEST" >>$LOGFILE

reply() {
    echo $2 | gnokii --config $CONFIG --sendsms $1
    echo "I send       => $2" >>$LOGFILE
}

if [ "$REQUEST" = "balance" ]; then
    reply $ABONENT "Ваш баланс..."
elif [ "$REQUEST" = "news" ]; then
    reply $ABONENT "Новости и акции..."
fi

#!/bin/bash

inp=$(gnokii --getsms IN 1 end) # считывает смску из памяти

echo $inp>/home/light204/Desktop/inp.txt #записывает ее в буферный файл

counter_love=$(grep -c люблю /home/light204/Desktop/inp.txt)      #ищет ключевое слово в сообщении
counter_luba=$(grep -c Любу /home/light204/Desktop/inp.txt)        #ищет ключевое слово в сообщении
counter_hello=$(grep -c привет /home/light204/Desktop/inp.txt)    #ищет ключевое слово в сообщении
counter_good=$(grep -c хорошо /home/light204/Desktop/inp.txt)  #ищет ключевое слово в сообщении
counter_name=$(grep -c зовут /home/light204/Desktop/inp.txt)    #ищет ключевое слово в сообщении


killall gnokii  #прерывает gnokii, чтобы дать ему запуститься для новой задачи

# в зависимости от того, какое слово встретилось в сообщении, отправляет тот или иной ответ.
if [ "$counter_love" == "1" ]; then

echo "Любить нужно людей, а я ПРОСТО КОМПЬЮТЕР!!! (надоело повторять)" | gnokii --sendsms '+7904xxxxxx'

elif [ "$counter_luba" == "1" ]; then

echo "Ладно, думаю, она не обидится :)" | gnokii --sendsms '+7904xxxxxx'

elif [ "$counter_hello" == "1" ]; then

echo "И тебе привет! Как дела твои?" | gnokii --sendsms '+7904xxxxxx'

elif [ "$counter_good" == "1" ]; then

echo "Что же, я очень рад за тебя! А я, вот, уже устал тут работать :(" | gnokii --sendsms '+7904xxxxxx'

elif [ "$counter_name" == "1" ]; then

echo "Меня Light204_comp зовут. Типа приятно познакомиться, хозяин ;)" | gnokii --sendsms '+7904xxxxxx'

fi


sleep 3

killall gnokii #прерывает gnokii, чтобы дать ему запуститься для новой задачи


gnokii --deletesms IN 1 end #очищает память телефона

#Все. Телефон готов к принятию следующего сообщения
