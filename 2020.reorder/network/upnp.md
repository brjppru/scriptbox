#!/bin/sh

exit 0

# pnp +ssh #

sudo aptitude install -y zenity miniupnpc

http://www.pivpav.com/post/162

#!/bin/bash

# Start port 22222
PORT=22222

# Test for router
upnpc -l > /dev/null
if [[ $? -ne 0 ]]
then
  zenity --warning --title="Ошибка UPnP" --text="Маршрутизатор с поддержкой UPnP не найден."
  exit 2
fi

USER=`whoami`
EXT_IP=`upnpc -l | awk '/ExternalIPAddress/ {print $3}'`
INT_IP=`hostname -I`
PORTS=`upnpc -l | awk '/^\ [0-9]\ TCP/ {print $3}' | sed 's/->.*//g' | tr '\n' ' '`

# Find first free port
while [[ "$PORTS" =~ .*$PORT\ .* ]]
do
  PORT=$(( $PORT + 1 ))
done

# Opening port
upnpc -a $INT_IP 22 $PORT TCP

if [[ $? -ne 0 ]]
then
    zenity --warning --title="Ошибка UPnP" --text="Не удалось открыть порт"
    exit 3
fi

# Informing
zenity --info --title="Проброс SSH" --text="Адресс для подключения:\n ssh $USER@$EXT_IP -p $PORT\n Не закрывайте это окно до завершения сеанса."

# Closing port
upnpc -d $PORT TCP
if [[ $? -ne 0 ]]
then
  exit 4
fi


