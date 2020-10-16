#!/bin/bash

# Определяем отношение ширины картинки к высоте
# Если оно меньше 1 - это портрет, равно - квадрат, больше - пейзаж

RATIO=`identify -format %[fx:w/h] $1`

if [ $RATIO == "1" ]; then
    echo "square"
else
    RAT_NUM=`echo $RATIO | sed -e 's/\(.\).*/\1/'`
    if [ $RAT_NUM -eq 0 ]; then
        echo "portrait"
    else
        echo "landscape"
    fi
fi

